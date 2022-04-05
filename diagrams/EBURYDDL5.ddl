-- Generado por Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   en:        2022-03-24 09:52:22 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE SEQUENCE cuenta_cuenta_id_seq START WITH 1 NOCACHE ORDER;

CREATE TABLE autorizacion (
    tipo                  VARCHAR2(20) NOT NULL,
    persona_autorizada_id VARCHAR2(20) NOT NULL,
    empresa_id            VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE autorizacion ADD CONSTRAINT autorizacion_pk PRIMARY KEY ( persona_autorizada_id );

CREATE TABLE cliente (
    id             VARCHAR2(20) NOT NULL,
    identificacion VARCHAR2(20) NOT NULL,
    tipo_cliente   VARCHAR2(20) NOT NULL,
    estado         VARCHAR2(20) NOT NULL,
    fecha_alta     DATE NOT NULL,
    fecha_baja     DATE,
    direccion      VARCHAR2(20) NOT NULL,
    ciudad         VARCHAR2(20) NOT NULL,
    codigo_postal  VARCHAR2(20) NOT NULL,
    pais           VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id );

ALTER TABLE cliente ADD CONSTRAINT cliente_identificacion_un UNIQUE ( identificacion );

CREATE TABLE cuenta (
    cuenta_id NUMBER NOT NULL,
    iban      VARCHAR2(20) NOT NULL,
    swift     VARCHAR2(20)
)
LOGGING;

ALTER TABLE cuenta ADD CONSTRAINT cuenta_pk PRIMARY KEY ( cuenta_id );

CREATE TABLE cuenta_fintech (
    cuenta_cuenta_id NUMBER NOT NULL,
    cliente_id       VARCHAR2(20) NOT NULL,
    estado           VARCHAR2(20) NOT NULL,
    fecha_apertura   DATE NOT NULL,
    fecha_cierre     DATE,
    clasificacion    VARCHAR2(20)
)
LOGGING;

ALTER TABLE cuenta_fintech ADD CONSTRAINT cuenta_fintech_pk PRIMARY KEY ( cuenta_cuenta_id );

CREATE TABLE cuenta_referencia (
    cuenta_cuenta_id   NUMBER NOT NULL,
    nombre_banco       VARCHAR2(20) NOT NULL,
    sucursal           VARCHAR2(20),
    pais               VARCHAR2(20),
    saldo              NUMBER(12,0) NOT NULL,  -- Se considera como saldo máximo el patrimonio de Elon Musk
    fecha_apertura     DATE,
    estado             VARCHAR2(20),
    divisa_abreviatura VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE cuenta_referencia ADD CONSTRAINT cuenta_referencia_pk PRIMARY KEY ( cuenta_cuenta_id );

CREATE TABLE depositar_en (
    saldo         NUMBER(12,0) NOT NULL,       -- Se considera como saldo máximo el patrimonio de Elon Musk
    cuenta_ref_id NUMBER NOT NULL,
    pool_id       NUMBER NOT NULL
)
LOGGING;

CREATE TABLE divisa (
    abreviatura VARCHAR2(20) NOT NULL,
    nombre      VARCHAR2(20) NOT NULL,
    simbolo     BLOB,
    cambio_euro NUMBER NOT NULL
)
LOGGING;

ALTER TABLE divisa ADD CONSTRAINT divisa_pk PRIMARY KEY ( abreviatura );

CREATE TABLE empresa (
    cliente_id   VARCHAR2(20) NOT NULL,
    razon_social VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE empresa ADD CONSTRAINT empresa_pk PRIMARY KEY ( cliente_id );

CREATE TABLE individual (
    cliente_id       VARCHAR2(20) NOT NULL,
    nombre           VARCHAR2(20) NOT NULL,
    apellido         VARCHAR2(20) NOT NULL,
    fecha_nacimiento DATE
)
LOGGING;

ALTER TABLE individual ADD CONSTRAINT individual_pk PRIMARY KEY ( cliente_id );

CREATE TABLE persona_autorizada (
    id               VARCHAR2(20) NOT NULL,
    identificacion   VARCHAR2(20) NOT NULL,
    nombre           VARCHAR2(20) NOT NULL,
    apellidos        VARCHAR2(20) NOT NULL,
    direccion        VARCHAR2(30) NOT NULL,
    fecha_nacimiento DATE,
    fecha_inicio     DATE,
    estado           VARCHAR2(20),
    fecha_fin        DATE
)
LOGGING;

ALTER TABLE persona_autorizada ADD CONSTRAINT persona_autorizada_pk PRIMARY KEY ( id );

ALTER TABLE persona_autorizada ADD CONSTRAINT persona_autorizada_id_un UNIQUE ( identificacion );

CREATE TABLE pooled_account (
    cuenta_fintech_id NUMBER NOT NULL
)
LOGGING;

ALTER TABLE pooled_account ADD CONSTRAINT pooled_account_pk PRIMARY KEY ( cuenta_fintech_id );

CREATE TABLE segregada (
    cuenta_fintech_id NUMBER NOT NULL,
    comision          VARCHAR2(20),
    cuenta_ref_id     NUMBER NOT NULL
)
LOGGING;

CREATE UNIQUE INDEX segregada__idx ON
    segregada (
        cuenta_ref_id
    ASC );

ALTER TABLE segregada ADD CONSTRAINT segregada_pk PRIMARY KEY ( cuenta_fintech_id );

CREATE TABLE tarjetas (
    numero            NUMBER(16,0) NOT NULL,
    nombre_titular    VARCHAR2(20) NOT NULL,
    cvv               NUMBER(3,0) NOT NULL,
    marca             VARCHAR2(20) NOT NULL,
    fecha_cad         DATE NOT NULL,
    cliente_id        VARCHAR2(20) NOT NULL,
    cuenta_fintech_id NUMBER NOT NULL
)
LOGGING;

ALTER TABLE tarjetas ADD CONSTRAINT tarjetas_pk PRIMARY KEY ( numero );

CREATE TABLE transaccion (
    id                  VARCHAR2(20) NOT NULL,
    fecha_instruccion   DATE NOT NULL,
    cantidad            NUMBER(9,0),          -- Transacción permite máximo 999.999.999
    fecha_ejecucion     DATE,
    tipo                VARCHAR2(20) NOT NULL,
    comision            NUMBER(8,0),          -- Máxima comisión contemplada es de 10% sobre 999.999.999 -> 99.999.999
    internacional       VARCHAR2(20),
    divisa_abreviatura2 VARCHAR2(20) NOT NULL,
    divisa_abreviatura  VARCHAR2(20) NOT NULL,  
    cuenta_cuenta_id    NUMBER NOT NULL,
    cuenta_cuenta_id1   NUMBER NOT NULL         
)
LOGGING;

ALTER TABLE transaccion ADD CONSTRAINT transaccion_pk PRIMARY KEY ( id );

ALTER TABLE autorizacion
    ADD CONSTRAINT autorizacion_empresa_fk FOREIGN KEY ( empresa_id )
        REFERENCES empresa ( cliente_id )
    NOT DEFERRABLE;

ALTER TABLE autorizacion
    ADD CONSTRAINT autorizacion_pers_autrzda_fk FOREIGN KEY ( persona_autorizada_id )
        REFERENCES persona_autorizada ( id )
    NOT DEFERRABLE;

ALTER TABLE cuenta_fintech
    ADD CONSTRAINT cuenta_fintech_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE cuenta_fintech
    ADD CONSTRAINT cuenta_fintech_cuenta_fk FOREIGN KEY ( cuenta_cuenta_id )
        REFERENCES cuenta ( cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE cuenta_referencia
    ADD CONSTRAINT cuenta_referencia_cuenta_fk FOREIGN KEY ( cuenta_cuenta_id )
        REFERENCES cuenta ( cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE cuenta_referencia
    ADD CONSTRAINT cuenta_referencia_divisa_fk FOREIGN KEY ( divisa_abreviatura )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

ALTER TABLE depositar_en
    ADD CONSTRAINT depositar_en_cuenta_ref_fk FOREIGN KEY ( cuenta_ref_id )
        REFERENCES cuenta_referencia ( cuenta_cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE depositar_en
    ADD CONSTRAINT depositar_en_pool_acc_fk FOREIGN KEY ( pool_id )
        REFERENCES pooled_account ( cuenta_fintech_id )
    NOT DEFERRABLE;

ALTER TABLE empresa
    ADD CONSTRAINT empresa_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE individual
    ADD CONSTRAINT individual_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE pooled_account
    ADD CONSTRAINT pool_acc_cuenta_ft_fk FOREIGN KEY ( cuenta_fintech_id )
        REFERENCES cuenta_fintech ( cuenta_cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE segregada
    ADD CONSTRAINT segregada_cuenta_fintech_fk FOREIGN KEY ( cuenta_fintech_id )
        REFERENCES cuenta_fintech ( cuenta_cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE segregada
    ADD CONSTRAINT segregada_cuenta_referencia_fk FOREIGN KEY ( cuenta_ref_id )
        REFERENCES cuenta_referencia ( cuenta_cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE tarjetas
    ADD CONSTRAINT tarjetas_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id )
    NOT DEFERRABLE;

ALTER TABLE tarjetas
    ADD CONSTRAINT tarjetas_cuenta_fintech_fk FOREIGN KEY ( cuenta_fintech_id )
        REFERENCES cuenta_fintech ( cuenta_cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_cuenta_fk FOREIGN KEY ( cuenta_cuenta_id )
        REFERENCES cuenta ( cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_cuenta_fkv2 FOREIGN KEY ( cuenta_cuenta_id1 )
        REFERENCES cuenta ( cuenta_id )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_divisa_fk FOREIGN KEY ( divisa_abreviatura )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_divisa_fkv2 FOREIGN KEY ( divisa_abreviatura2 )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER cuenta_cuenta_id_trg BEFORE
    INSERT ON cuenta
    FOR EACH ROW
    WHEN ( new.cuenta_id IS NULL )
BEGIN
    :new.cuenta_id := cuenta_cuenta_id_seq.nextval;
END;
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             1
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           1
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          1
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0