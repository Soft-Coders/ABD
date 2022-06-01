-- Creación del procedimiento P_COBRO

-- Esta función comprueba si una cuenta referencia tiene asociada una segregada o no (entonces será una pooled)
CREATE OR REPLACE FUNCTION f_comprueba_segregada (ref_id in cuenta_referencia.cuenta_cuenta_id%type)
    RETURN BOOLEAN IS
    es_segregada BOOLEAN := false;
    segregada_asociada  segregada.cuenta_fintech_id%type;
    BEGIN
    SELECT seg.cuenta_fintech_id INTO segregada_asociada FROM segregada seg, cuenta_referencia refe
        WHERE seg.cuenta_ref_id = refe.cuenta_cuenta_id  AND
            ref_id = refe.cuenta_cuenta_id;

    IF segregada_asociada IS NOT NULL 
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END f_comprueba_segregada;
/

-- Esta función calcula el saldo que deberá tener la cuenta referencia después del cobro
CREATE OR REPLACE FUNCTION f_saldo_referencia (ref_id in cuenta_referencia.cuenta_cuenta_id%type)
    RETURN cuenta_referencia.saldo%type IS
    saldo_aux        cuenta_referencia.saldo%type;  -- saldo inicial de la cuenta referencia
    cantidad_aux     movimientos.cantidad%type;     -- cantidad a cobrar
    pooled_aux       pooled_account.cuenta_fintech_id%type;  -- cuenta pooled de la que restar el saldo en depositar_en
    saldo_aux_depo   depositar_en.saldo%type;  -- saldo inicial de la pooled en la tabla depositar_en
        BEGIN
            IF f_comprueba_segregada(ref_id) THEN  -- el caso en que la cuenta es segregada
                SELECT m.cantidad, cref.saldo INTO cantidad_aux, saldo_aux 
                FROM cuenta_referencia cref, movimientos m, segregada seg, cuenta_fintech cf, cuenta, tarjetas tar
                    WHERE cref.cuenta_cuenta_id = ref_id  AND
                        seg.cuenta_ref_id = cref.cuenta_cuenta_id AND
                        cf.cuenta_cuenta_id = seg.cuenta_fintech_id AND
                        cuenta.cuenta_id = cf.cuenta_cuenta_id AND
                        tar.cuenta_fintech_id = cf.cuenta_cuenta_id AND
                        m.numero_tarjeta = tar.numero;
                RETURN saldo_aux - cantidad_aux;

            ELSE  -- el caso en que la cuenta es pooled
                SELECT m.cantidad, c.saldo, pc.cuenta_fintech_id, depo.saldo INTO cantidad_aux, saldo_aux, pooled_aux, saldo_aux_depo
                FROM cuenta_referencia c, movimientos movi, depositar_en depo, pooled_account pc, cuenta_fintech cf, cuenta, tarjetas tar
                    WHERE c.cuenta_cuenta_id = ref_id  AND
                        c.cuenta_cuenta_id = depo.cuenta_ref_id AND
                        pc.cuenta_fintech_id = depo.pool_id AND
                        pc.cuenta_fintech_id = cf.cuenta_cuenta_id AND
                        cuenta.cuenta_id = cf.cuenta_cuenta_id AND
                        tar.cuenta_fintech_id = cf.cuenta_cuenta_id AND
                        movi.numero_tarjeta = tar.numero;
                
                UPDATE DEPOSITAR_EN
                    SET 
                        SALDO = saldo_aux_depo - cantidad_aux
                    WHERE
                        pooled_aux = pool_id AND
                        ref_id = cuenta_ref_id;

                RETURN saldo_aux - cantidad_aux;

            END IF;
END f_saldo_referencia;
/

-- Este procedimiento resta las cantidades indicadas en los movimientos pendientes y de débito a sus 
-- respectivas cuentas asociadas.
CREATE OR REPLACE PROCEDURE P_COBRO
IS
BEGIN
    UPDATE CUENTA_REFERENCIA
        SET 
            SALDO = f_saldo_referencia(cuenta_referencia.cuenta_cuenta_id)
        WHERE
            EXISTS (SELECT c FROM CUENTA_REFERENCIA c  --esta parte es por las cuentas pooled
                    JOIN DEPOSITAR_EN depo ON c.cuenta_cuenta_id = depo.cuenta_ref_id
                    JOIN POOLED_ACCOUNT pc ON pc.cuenta_fintech_id = depo.pool_id
                    JOIN CUENTA_FINTECH cf ON pc.cuenta_fintech_id = cf.cuenta_cuenta_id
                    JOIN CUENTA cuenta     ON cuenta.cuenta_id = cf.cuenta_cuenta_id
                    JOIN TARJETAS tar      ON tar.cuenta_fintech_id = cf.cuenta_cuenta_id
                    JOIN MOVIMIENTOS movi   ON movi.numero_tarjeta = tar.numero
                        WHERE movi.estado = 'PENDIENTE' AND movi.modo = 'DEBITO'
                    UNION
                    SELECT c FROM CUENTA_REFERENCIA c  --esta parte es por las cuentas segregadas
                    JOIN SEGREGADA seg     ON seg.cuenta_ref_id = c.cuenta_cuenta_id
                    JOIN CUENTA_FINTECH cf ON cf.cuenta_cuenta_id = seg.cuenta_fintech_id
                    JOIN CUENTA cuenta     ON cuenta.cuenta_id = cf.cuenta_cuenta_id
                    JOIN TARJETAS tar      ON tar.cuenta_fintech_id = cf.cuenta_cuenta_id
                    JOIN MOVIMIENTOS movi   ON movi.numero_tarjeta = tar.numero
                        WHERE movi.estado = 'PENDIENTE' AND movi.modo = 'DEBITO');

    UPDATE MOVIMIENTOS
        SET
            ESTADO = 'COBRADO'
        WHERE
            ESTADO = 'PENDIENTE' AND MODO = 'DEBITO';

    -- COMMIT; 
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
END P_COBRO;
/

END;
/

