-- PERSONA_AUTORIZADA_NO_EXISTENTE_EXCEPTION EXCEPTION;
-- PERSONA_YA_BORRADA_EXCEPTION EXCEPTION; 
-- EMPRESA_NO_EXISTENTE_EXCEPTION EXCEPTION;
-- SIN_AUTORIZACIONES_EXCEPTION EXCEPTION;

PROCEDURE ELIMINAR_AUTORIZADO(
P_PERSONA_AUTORIZADA_ID         IN AUTORIZACION.PERSONA_AUTORIZADA_ID%TYPE
P_EMPRESA_ID                    IN AUTORIZACION.EMPRESA_ID%TYPE)
IS 
PERSONA_AUTORIZADA_ID_AUX       IN PERSONA_AUTORIZADA.ID%TYPE;
ESTADO_PERSONA                  IN PERSONA_AUTORIZADA.ESTADO%TYPE;
EMPRESA_ID_AUX                      IN AUTORIZACION.EMPRESA_ID%TYPE;
CONT_AUT_EMP                    INTEGER;
CONT_AUT_GEN                    INTEGER;
BEGIN

    -- CHECK DE QUE LA PERSONA AUTORIZADA EXISTE
    SELECT ID INTO PERSONA_AUTORIZADA_ID_AUX FROM PERSONA_AUTORIZADA WHERE ID LIKE P_PERSONA_AUTORIZADA_ID;
    SELECT ESTADO INTO ESTADO_PERSONA FROM PERSONA_AUTORIZADA WHERE ID LIKE PERSONA_AUTORIZADA_ID_AUX;
    IF PERSONA_AUTORIZADA_ID_AUX IS NULL THEN
        RAISE PERSONA_AUTORIZADA_NO_EXISTENTE_EXCEPTION;
    END IF;
    --CHECK DE QUE LA EMPRESA EXISTE
    SELECT ID INTO EMPRESA_ID_AUX FROM CLIENTE WHERE ID LIKE P_EMPRESA_ID;
    IF EMPRESA_ID_AUX IS NULL THEN 
        RAISE EMPRESA_NO_EXISTENTE_EXCEPTION;
    END IF;
    -- CHECK DE QUE EL ESTADO NO SEA YA BORRADO
    IF ESTADO LIKE 'BORRADO' THEN
        RAISE PERSONA_YA_BORRADA_EXCEPTION;
    END IF;
    -- CHECK DE LAS AUTORIZACIONES QUE TIENE LA PERSONA AUTORIZADA CON LA EMPRESA + BORRARLAS SI TIENE
    SELECT COUNT(PERSONA_AUTORIZADA_ID) INTO CONT_AUT_EMP FROM AUTORIZACION WHERE EMPRESA_ID LIKE EMPRESA_ID_AUX AND PERSONA_AUTORIZADA_ID LIKE PERSONA_AUTORIZADA_ID_AUX;
    IF CONT_AUT_EMP > 0 THEN 
        DELETE * FROM AUTORIZACION 
        WHERE   PERSONA_AUTORIZADA_ID LIKE PERSONA_AUTORIZADA_ID_AUX AND
                EMPRESA_ID LIKE EMPRESA_ID_AUX;
    ELSE 
        RAISE SIN_AUTORIZACIONES_EXCEPTION;
    END IF;

    -- CHECK DE LAS AUTORIZACIONES QUE TIENE LA PERSONA EN GENERAL. (SI TIENE 0 SE BORRA LA PERSONA AUTORIZADA)
    SELECT COUNT(PERSONA_AUTORIZADA_ID) INTO CONT_AUT_GEN FROM AUTORIZACION WHERE PERSONA_AUTORIZADA_ID LIKE PERSONA_AUTORIZADA_ID_AUX;
    IF CONT_AUT_GEN <= 0;
        UPDATE PERSONA_AUTORIZADA
        SET
            ESTADO = 'BORRADO',
            FECHA_FIN = SYSDATE
        WHERE
            PERSONA_AUTORIZADA_ID = PERSONA_AUTORIZADA_ID_AUX;
    END IF;
END;