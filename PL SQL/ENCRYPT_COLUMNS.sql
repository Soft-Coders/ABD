-- ENCRIPTAR COLUMNAS

ALTER TABLE CLIENTE MODIFY (
IDENTIFICACION ENCRYPT NO SALT,
DIRECCION ENCRYPT,
CIUDAD ENCRYPT,
CODIGO_POSTAL ENCRYPT,
PAIS ENCRYPT
);

ALTER TABLE EMPRESA MODIFY (
RAZON_SOCIAL ENCRYPT
);

ALTER TABLE INDIVIDUAL MODIFY (
NOMBRE ENCRYPT,
APELLIDO ENCRYPT,
FECHA_NACIMIENTO ENCRYPT
);

ALTER TABLE PERSONA_AUTORIZADA MODIFY (
IDENTIFICACION ENCRYPT NO SALT,
DIRECCION ENCRYPT,
NOMBRE ENCRYPT,
APELLIDOS ENCRYPT,
FECHA_NACIMIENTO ENCRYPT
);

ALTER TABLE TRANSACCION MODIFY (
CANTIDAD ENCRYPT,
COMISION ENCRYPT
);

ALTER TABLE TARJETAS MODIFY (
NUMERO ENCRYPT NO SALT,
NOMBRE_TITULAR ENCRYPT,
CVV ENCRYPT,
FECHA_CAD ENCRYPT
);