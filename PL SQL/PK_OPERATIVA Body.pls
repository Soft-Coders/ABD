create or replace PACKAGE PK_OPERATIVA AS 
    
    PROCEDURE INSERTAR_TRANSACCIONES(
--  P_ID                    ASIGNADA SQ_TRANSACCION EN RUNTIME
    P_FECHA_INSTRUCCION     IN TRANSACCION.FECHA_INSTRUCCION%TYPE,
    P_CANTIDAD              IN TRANSACCION.CANTIDAD%TYPE,
--  P_FECHA_EJECUCION       ASIGNADA EN RUNTIME
    P_TIPO                  IN TRANSACCION.TIPO%TYPE,
    P_COMISION              IN TRANSACCION.COMISION%TYPE,
    P_INTERNACIONAL         IN TRANSACCION.INTERNACIONAL%TYPE,
    P_DIVISA_ABREVIATURA2   IN DIVISA.ABREVIATURA%TYPE,
    P_DIVISA_ABREVIATURA    IN DIVISA.ABREVIATURA%TYPE,
    P_CUENTA_CUENTA_ID      IN CUENTA.IBAN%TYPE,
    P_CUENTA_CUENTA_ID1     IN CUENTA.IBAN%TYPE
    )
    IS
    -- VARIABLES
    BEGIN
      
    END;
    
    PROCEDURE CAMBIO_DIVISAS(
    P_IBAN              IN CUENTA.IBAN%TYPE,
    P_DIVISA_ORIGEN     IN DIVISA.ABREVIATURA%TYPE,
    P_DIVISA_OBJETIVO   IN DIVISA.ABREVIATURA%TYPE
    )
    IS
    -- VARIABLES
    BEGIN
    
    END;

END PK_OPERATIVA;