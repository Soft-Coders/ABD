create or replace PACKAGE BODY PK_GESTION_CUENTAS AS
    
    PROCEDURE ABRIR_CUENTA(
    CUENTA_ID         IN CUENTA.CUENTA_ID%TYPE,
    IBAN              IN CUENTA.IBAN%TYPE,
    SWIFT             IN CUENTA.SWIFT%TYPE,      
    CLIENTE_ID        IN CUENTA_FINTECH.CLIENTE_ID%TYPE,
    ESTADO            IN CUENTA_FINTECH.ESTADO%TYPE,
    FECHA_APERTURA    IN CUENTA_FINTECH.FECHA_APERTURA%TYPE,
    FECHA_CIERRE      IN CUENTA_FINTECH.FECHA_CIERRE%TYPE,
    CLASIFICACION     IN CUENTA_FINTECH.CLASIFICACION%TYPE,
    COMISION          IN SEGREGADA.COMISION%TYPE,
    CUENTA_REF_ID     IN SEGREGADA.CUENTA_REF_ID%TYPE)
    IS
    ESTADO_CLIENTE CUENTA_FINTECH.ESTADO%TYPE;
    CUENTA_EXISTE CUENTA_FINTECH.CUENTA_ID%TYPE;
    BEGIN
        SELECT ESTADO INTO ESTADO_CLIENTE FROM CLIENTE WHERE ID LIKE CLIENTE_ID;
        SELECT CUENTA_ID AS CF INTO CUENTA_EXISTE FROM CUENTA_FINTECH WHERE CF.CUENTA_ID = CUENTA_ID;
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
            CUENTA_ID,
            IBAN,
            SWIFT
        );
        
        INSERT INTO cuenta_fintech (
            cuenta_cuenta_id,
            cliente_id,
            estado,
            fecha_apertura,
            fecha_cierre,
            clasificacion
        ) VALUES (
            CUENTA_ID,
            CLIENTE_ID,
            ESTADO,
            FECHA_APERTURA,
            FECHA_CIERRE,
            CLASIFICACION
        );
        
        IF CUENTA_REF_ID IS NULL THEN
            INSERT INTO pooled_account (
                cuenta_fintech_id
            ) VALUES (
                CUENTA_ID
            );
        ELSE
            INSERT INTO segregada (
                cuenta_fintech_id,
                comision,
                cuenta_ref_id
            ) VALUES (
                CUENTA_ID,
                COMISION,
                CUENTA_REF_ID
            );
        END IF;
    END;
    
    
    PROCEDURE CERRAR_CUENTA(
    CUENTA_ID IN CUENTA.CUENTA_ID%TYPE)
    IS
    REF_SEGREGADA CUENTA.CUENTA_ID%TYPE;
    SALDO_MAYOR DEPOSITAR_EN.SALDO%TYPE;
    BEGIN
        SELECT CUENTA_REF_ID INTO REF_SEGREGADA FROM SEGREGADA WHERE CUENTA_FINTECH_ID = CUENTA_ID;
        IF REF_SEGREGADA IS NOT NULL THEN
            SELECT SALDO INTO SALDO_MAYOR FROM CUENTA_REFERENCIA WHERE CUENTA_CUENTA_ID = REF_SEGREGADA;
            IF SALDO_MAYOR <> 0 THEN
                RAISE SALDO_NO_VACIO_EXCEPTION;  
            END IF;
        ELSE
            SELECT MAX(SALDO) INTO SALDO_MAYOR FROM DEPOSITAR_EN WHERE POOL_ID = CUENTA_ID;
            -- En caso de no cumplirse el predicado del WHERE la variables SALDO_MAYOR devería ser nula
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
            CUENTA_CUENTA_ID = CUENTA_ID;
    END;
    
END PK_GESTION_CUENTAS;