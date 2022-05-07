CREATE OR REPLACE
PACKAGE BODY PK_GESTION_CLIENTES AS

  PROCEDURE ALTA_CLIENTE(P_ID_CLIENTE IN CLIENTE.ID%TYPE, 
P_IDENTIFICACION IN CLIENTE.IDENTIFICACION%TYPE,
P_TIPO_CLIENTE   IN CLIENTE.TIPO_CLIENTE%TYPE,
P_ESTADO         IN CLIENTE.ESTADO%TYPE,
P_FECHA_ALTA     IN CLIENTE.FECHA_ALTA%TYPE,
P_FECHA_BAJA              IN CLIENTE.FECHA_BAJA%TYPE,     
P_DIRECCION      IN CLIENTE.DIRECCION%TYPE,
P_CIUDAD         IN CLIENTE.CIUDAD%TYPE,
P_CODIGO_POSTAL  IN CLIENTE.CODIGO_POSTAL%TYPE,
P_PAIS           IN CLIENTE.PAIS%TYPE,
P_RAZON_SOCIAL IN EMPRESA.RAZON_SOCIAL%TYPE,
P_NOMBRE           IN INDIVIDUAL.NOMBRE%TYPE, 
P_APELLIDO         IN INDIVIDUAL.APELLIDO%TYPE,
P_FECHA_NACIMIENTO          IN INDIVIDUAL.FECHA_NACIMIENTO%TYPE) AS
  BEGIN
    --Insertamos el cliente
        INSERT INTO CLIENTE (
            id,
            identificacion,
            tipo_cliente,
            estado,
            fecha_alta,
            fecha_baja,
            direccion,
            ciudad,
            codigo_postal,
            pais
        ) VALUES (
            P_ID_CLIENTE,
            P_IDENTIFICACION,
            P_TIPO_CLIENTE,
            P_ESTADO,
            P_FECHA_ALTA,
            P_FECHA_BAJA,     
            P_DIRECCION,
            P_CIUDAD,
            P_CODIGO_POSTAL,
            P_PAIS
        );
    
    IF P_TIPO_CLIENTE = 'EMPRESA' THEN 
        --Insertar empresa
        INSERT INTO EMPRESA (
            cliente_id,
            razon_social
        ) VALUES (
            P_ID_CLIENTE,
            P_RAZON_SOCIAL
        );
    ELSE
        --Insertar individual
            INSERT INTO individual (
            cliente_id,
            nombre,
            apellido,
            fecha_nacimiento
        ) VALUES (
            P_ID_CLIENTE,
            P_NOMBRE,
            P_APELLIDO,
            P_FECHA_NACIMIENTO
        );
    END IF;    
  END ALTA_CLIENTE;
  
  PROCEDURE MOD_CLIENTE(P_ID_CLIENTE IN CLIENTE.ID%TYPE, 
P_IDENTIFICACION IN CLIENTE.IDENTIFICACION%TYPE,
P_TIPO_CLIENTE   IN CLIENTE.TIPO_CLIENTE%TYPE,
P_ESTADO         IN CLIENTE.ESTADO%TYPE,
P_FECHA_ALTA     IN CLIENTE.FECHA_ALTA%TYPE,
P_FECHA_BAJA              IN CLIENTE.FECHA_BAJA%TYPE,     
P_DIRECCION      IN CLIENTE.DIRECCION%TYPE,
P_CIUDAD         IN CLIENTE.CIUDAD%TYPE,
P_CODIGO_POSTAL  IN CLIENTE.CODIGO_POSTAL%TYPE,
P_PAIS           IN CLIENTE.PAIS%TYPE,
P_RAZON_SOCIAL IN EMPRESA.RAZON_SOCIAL%TYPE,
P_NOMBRE           IN INDIVIDUAL.NOMBRE%TYPE, 
P_APELLIDO         IN INDIVIDUAL.APELLIDO%TYPE,
P_FECHA_NACIMIENTO          IN INDIVIDUAL.FECHA_NACIMIENTO%TYPE) IS
AUX              INTEGER
  BEGIN

    IF P_ID IS NULL THEN
		RAISE CLIENTE_NO_EXISTENTE_EXCEPTION;
	ELSE
		IF P_IDENTIFICACION IS NOT NULL THEN
			SELECT COUNT(CLIENTE.IDENTIFICACION) INTO AUX FROM CLIENTE WHERE CLIENTE_IDENTIFICACION LIKE P_IDENTIFICACION;
			IF AUX > 0 THEN
				RAISE DATOS_INCORRECTOS_EXCEPTION;
			ELSE
				UPDATE CLIENTE
        		SET
            			IDENTIFICACION = P_IDENTIFICACION
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
			END IF;
		END IF;
		IF P_TIPO_CLIENTE IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			TIPO_CLIENTE = P_TIPO_CLIENTE
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_ESTADO IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			ESTADO = P_ESTADO
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_FECHA_ALTA IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			FECHA_ALTA = P_FECHA_ALTA
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_FECHA_BAJA IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			FECHA_BAJA = P_FECHA_BAJA
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_DIRECCION IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			DIRECCION = P_DIRECCION
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_CIUDAD IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			CIUDAD = P_CIUDAD
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_CODIGO_POSTAL IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			CODIGO_POSTAL = P_CODIGO_POSTAL
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_PAIS IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			PAIS = P_PAIS
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_RAZON_SOCIAL IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			RAZON_SOCIAL = P_RAZON_SOCIAL
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_NOMBRE IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			NOMBRE = P_NOMBRE
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_APELLIDOS IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			APELLIDOS = P_APELLIDOS
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
		IF P_FECHA_NACIMIENTO IS NOT NULL THEN
			UPDATE CLIENTE
        		SET
            			FECHA_NACIMIENTO = P_FECHA_NACIMIENTO
        		WHERE
            			CLIENTE_ID = P_ID_CLIENTE;
		END IF;
	END IF;

  END MOD_CLIENTE;

  PROCEDURE BAJA_CLIENTE(P_ID_CLIENTE IN CLIENTE.ID%TYPE) AS
  BEGIN
    -- TAREA: Se necesita implantación para PROCEDURE PK_GESTION_CLIENTES.BAJA_CLIENTE
    NULL;
  END BAJA_CLIENTE;

  PROCEDURE ALTA_AUTORIZADO(P_ID_AUTORIZADO              IN PERSONA_AUTORIZADA.ID%TYPE,
P_IDENTIFICACION   IN PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
P_NOMBRE           IN PERSONA_AUTORIZADA.NOMBRE%TYPE,
P_APELLIDOS        IN PERSONA_AUTORIZADA.APELLIDOS%TYPE, 
P_DIRECCION        IN PERSONA_AUTORIZADA.DIRECCION%TYPE,
P_FECHA_NACIMIENTO          IN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
P_FECHA_INICIO              IN PERSONA_AUTORIZADA.FECHA_INICIO%TYPE,
P_ESTADO                    IN PERSONA_AUTORIZADA.ESTADO%TYPE,
P_FECHA_FIN                 IN PERSONA_AUTORIZADA.FECHA_FIN%TYPE,
P_TIPO   IN AUTORIZACION.TIPO%TYPE,
P_ID_EMPRESA IN AUTORIZACION.EMPRESA_ID%TYPE) AS
  BEGIN
    -- TAREA: Se necesita implantación para PROCEDURE PK_GESTION_CLIENTES.ALTA_AUTORIZADO
    NULL;
  END ALTA_AUTORIZADO;

  PROCEDURE BAJA_AUTORIZADO(ID               IN PERSONA_AUTORIZADA.ID%TYPE) AS
  BEGIN
    -- TAREA: Se necesita implantación para PROCEDURE PK_GESTION_CLIENTES.BAJA_AUTORIZADO
    NULL;
  END BAJA_AUTORIZADO;

  PROCEDURE MOD_AUTORIZADO(P_ID_AUTORIZADO               IN PERSONA_AUTORIZADA.ID%TYPE,
P_IDENTIFICACION   IN PERSONA_AUTORIZADA.IDENTIFICACION%TYPE,
P_NOMBRE           IN PERSONA_AUTORIZADA.NOMBRE%TYPE,
P_APELLIDOS        IN PERSONA_AUTORIZADA.APELLIDOS%TYPE, 
P_DIRECCION        IN PERSONA_AUTORIZADA.DIRECCION%TYPE,
P_FECHA_NACIMIENTO          IN PERSONA_AUTORIZADA.FECHA_NACIMIENTO%TYPE,
P_FECHA_INICIO              IN PERSONA_AUTORIZADA.FECHA_INICIO%TYPE,
P_ESTADO                    IN PERSONA_AUTORIZADA.ESTADO%TYPE,
P_FECHA_FIN                 IN PERSONA_AUTORIZADA.FECHA_FIN%TYPE,
P_TIPO   IN AUTORIZACION.TIPO%TYPE,
P_ID_EMPRESA IN AUTORIZACION.EMPRESA_ID%TYPE) IS
AUX INTEGER;
  BEGIN
  
    IF P_ID_AUTORIZADO IS NULL THEN
		RAISE AUTORIZADO_NO_EXISTENTE_EXCEPTION;
	ELSE
		IF P_IDENTIFICACION IS NOT NULL THEN
			SELECT COUNT(IDENTIFICACION) INTO AUX FROM PERSONA_AUTORIZADA WHERE IDENTIFICACION LIKE P_IDENTIFICACION;
			IF AUX > 0 THEN
				RAISE DATOS_INCORRECTOS_EXCEPTION;
			ELSE
				UPDATE PERSONA_AUTORIZADA
        		SET
            			IDENTIFICACION = P_IDENTIFICACION
        		WHERE
            			ID = P_ID_AUTORIZADO;
			END IF;
		END IF;
		IF P_NOMBRE IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			NOMBRE = P_NOMBRE
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_APELLIDOS IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			APELLIDOS = P_APELLIDOS
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_DIRECCION IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			DIRECCION = P_DIRECCION
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_FECHA_NACIMIENTO IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			FECHA_NACIMIENTO = P_FECHA_NACIMIENTO
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_FECHA_INICIO IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			DIRECCION = P_DIRECCION
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_ESTADO IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			ESTADO = P_ESTADO
        		WHERE
            			ID = P_ID_AUTORIZADO;
		END IF;
		IF P_FECHA_FIN IS NOT NULL THEN
			UPDATE PERSONA_AUTORIZADA
        		SET
            			FECHA_FIN = P_FECHA_FIN
        		WHERE
            			ID = P_ID_AUTORIZADO;
        END IF;
    END IF;

  END MOD_AUTORIZADO;

END PK_GESTION_CLIENTES;