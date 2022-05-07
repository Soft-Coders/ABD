create or replace PACKAGE PK_GESTION_CLIENTES AS 

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
P_FECHA_NACIMIENTO          IN INDIVIDUAL.FECHA_NACIMIENTO%TYPE);

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
P_APELLIDOS         IN INDIVIDUAL.APELLIDO%TYPE,
P_FECHA_NACIMIENTO          IN INDIVIDUAL.FECHA_NACIMIENTO%TYPE);

PROCEDURE BAJA_CLIENTE(P_ID_CLIENTE IN CLIENTE.ID%TYPE);

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
P_ID_EMPRESA IN AUTORIZACION.EMPRESA_ID%TYPE);

PROCEDURE BAJA_AUTORIZADO(ID               IN PERSONA_AUTORIZADA.ID%TYPE);

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
P_ID_EMPRESA IN AUTORIZACION.EMPRESA_ID%TYPE);

-- Excepciones
PERSONA_AUTORIZADA_NO_EXISTENTE_EXCEPTION EXCEPTION;
PERSONA_YA_BORRADA_EXCEPTION EXCEPTION; 
EMPRESA_NO_EXISTENTE_EXCEPTION EXCEPTION;
SIN_AUTORIZACIONES_EXCEPTION EXCEPTION;
ESTADO_INACTIVO_EXCEPTION EXCEPTION;
CUENTAS_ACTIVAS_EXCEPTION EXCEPTION;
CLIENTE_NO_EXISTENTE_EXCEPTION EXCEPTION;
DATOS_INCORRECTOS_EXCEPTION EXCEPTION;
AUTORIZADO_NO_EXISTENTE_EXCEPTION EXCEPTION;
CLIENTE_EXISTENTE_EXCEPTION EXCEPTION;
CLIENTE_NO_VALIDO_EXCEPTION EXCEPTION;

END PK_GESTION_CLIENTES;