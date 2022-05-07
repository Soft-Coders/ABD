create or replace PACKAGE BODY PK_GESTION_CUENTAS AS
    
    PROCEDURE ABRIR_CUENTA(
    P_CUENTA_ID         IN CUENTA.CUENTA_ID%TYPE,
    P_IBAN              IN CUENTA.IBAN%TYPE,
    P_SWIFT             IN CUENTA.SWIFT%TYPE,      
    P_CLIENTE_ID        IN CUENTA_FINTECH.CLIENTE_ID%TYPE,
    P_ESTADO            IN CUENTA_FINTECH.ESTADO%TYPE,
    P_FECHA_APERTURA    IN CUENTA_FINTECH.FECHA_APERTURA%TYPE,
    P_FECHA_CIERRE      IN CUENTA_FINTECH.FECHA_CIERRE%TYPE,
    P_CLASIFICACION     IN CUENTA_FINTECH.CLASIFICACION%TYPE,
    P_COMISION          IN SEGREGADA.COMISION%TYPE,
    P_CUENTA_REF_ID     IN SEGREGADA.CUENTA_REF_ID%TYPE)
    IS
    ESTADO_CLIENTE CUENTA_FINTECH.ESTADO%TYPE;
    CUENTA_EXISTE CUENTA_FINTECH.CUENTA_ID%TYPE;
    BEGIN
        SELECT ESTADO INTO ESTADO_CLIENTE FROM CLIENTE WHERE ID LIKE P_CLIENTE_ID;
        SELECT CUENTA_CUENTA_ID INTO CUENTA_EXISTE FROM CUENTA_FINTECH WHERE CUENTA_CUENTA_ID = P_CUENTA_ID;
        IF ESTADO_CLIENTE NOT LIKE 'ACTIV[OAE]' THEN
            RAISE CLIENTE_DE_BAJA_EXCEPTION;
        END IF;
        IF CUENTA_EXISTE IS NOT NULL THEN
            RAISE CUENTA_YA_EXISTE_EXCEPTION;
        END IF;
        
        INSERT INTO cuenta (
            cuenta_id,
            iban,
            swift
        ) VALUES (
            P_CUENTA_ID,
            P_IBAN,
            p_SWIFT
        );
        
        INSERT INTO cuenta_fintech (
            cuenta_cuenta_id,
            cliente_id,
            estado,
            fecha_apertura,
            fecha_cierre,
            clasificacion
        ) VALUES (
            P_CUENTA_ID,
            P_CLIENTE_ID,
            P_ESTADO,
            P_FECHA_APERTURA,
            P_FECHA_CIERRE,
            P_CLASIFICACION
        );
        
        IF P_CUENTA_REF_ID IS NULL THEN
            INSERT INTO pooled_account (
                cuenta_fintech_id
            ) VALUES (
                P_CUENTA_ID
            );
        ELSE
            INSERT INTO segregada (
                cuenta_fintech_id,
                comision,
                cuenta_ref_id
            ) VALUES (
                P_CUENTA_ID,
                P_COMISION,
                P_CUENTA_REF_ID
            );
        END IF;
    END;
    
    
    PROCEDURE CERRAR_CUENTA(
    P_CUENTA_ID IN CUENTA.CUENTA_ID%TYPE)
    IS
    REF_SEGREGADA CUENTA.CUENTA_ID%TYPE;
    SALDO_MAYOR DEPOSITAR_EN.SALDO%TYPE;
    BEGIN
        SELECT CUENTA_REF_ID INTO REF_SEGREGADA FROM SEGREGADA WHERE CUENTA_FINTECH_ID = P_CUENTA_ID;
        IF REF_SEGREGADA IS NOT NULL THEN
            SELECT SALDO INTO SALDO_MAYOR FROM CUENTA_REFERENCIA WHERE CUENTA_CUENTA_ID = REF_SEGREGADA;
            IF SALDO_MAYOR <> 0 THEN
                RAISE SALDO_NO_VACIO_EXCEPTION;  
            END IF;
        ELSE
            SELECT MAX(SALDO) INTO SALDO_MAYOR FROM DEPOSITAR_EN WHERE POOL_ID = P_CUENTA_ID;
            -- En caso de no cumplirse el predicado del WHERE la variables SALDO_MAYOR dever�a ser nula
            IF SALDO-MAYOR IS NULL THEN
                RAISE CUENTA_NO_EXISTE_EXCEPTION;
            IF SALDO_MAYOR <> 0 THEN
                RAISE SALDO_NO_VACIO_EXCEPTION;
            END IF;
        END IF;
        
        UPDATE CUENTA_FINTECH
        SET
            ESTADO = 'INACTIVA',
            FECHA_CIERRE = SYSDATE
        WHERE
            CUENTA_CUENTA_ID = P_CUENTA_ID;
    END;
    
END PK_GESTION_CUENTAS;