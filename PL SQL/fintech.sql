SELECT 'DROP TABLE ' || TABLE_NAME || ' CASCADE CONSTRAINTS;' AS D FROM USER_TABLES;

DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE CUENTA CASCADE CONSTRAINTS;
DROP TABLE CUENTA_FINTECH CASCADE CONSTRAINTS;
DROP TABLE CUENTA_REFERENCIA CASCADE CONSTRAINTS;
DROP TABLE DEPOSITAR_EN CASCADE CONSTRAINTS;
DROP TABLE DIVISA CASCADE CONSTRAINTS;
DROP TABLE EMPRESA CASCADE CONSTRAINTS;
DROP TABLE INDIVIDUAL CASCADE CONSTRAINTS;
DROP TABLE PERSONA_AUTORIZADA CASCADE CONSTRAINTS;
DROP TABLE POOLED_ACCOUNT CASCADE CONSTRAINTS;
DROP TABLE SEGREGADA CASCADE CONSTRAINTS;
DROP TABLE TARJETAS CASCADE CONSTRAINTS;
DROP TABLE TRANSACCION CASCADE CONSTRAINTS;
DROP TABLE AUTORIZACION CASCADE CONSTRAINTS;
DROP SEQUENCE CUENTA_CUENTA_ID_SEQ;


SELECT * FROM USER_TABLES;

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
    nombre      VARCHAR2(30) NOT NULL,
    simbolo     NVARCHAR2(5),
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
    ASC ) TABLESPACE TS_INDICES;

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

CREATE TABLE movimientos (
    numero              VARCHAR2(20) NOT NULL,
    numero_tarjeta      NUMBER(16,0) NOT NULL,
    divisa              VARCHAR2(20) NOT NULL,   
    fecha               DATE NOT NULL,
    cantidad            NUMBER(9,0),
    estado              VARCHAR2(20) NOT NULL,
    modo                VARCHAR2(20),
    tipo_emisor         VARCHAR2(20)
)
LOGGING;

ALTER TABLE movimientos ADD CONSTRAINT movimientos_pk PRIMARY KEY ( numero );

ALTER TABLE movimientos
    ADD CONSTRAINT tarjeta_fk FOREIGN KEY ( numero_tarjeta )
        REFERENCES tarjeta ( numero )
    NOT DEFERRABLE;

--Esta relación no tiene en cuenta la inflación en la cuenta, 
--Aplicar el cambio del momento del movimiento de cada moneda a cada movimiento que se ejecutó en el pasado
--para obtener un total real complicaría demasiado la lógica. Por ello no lo hemos tenido en cuenta
ALTER TABLE movimientos
    ADD CONSTRAINT divisa_fk FOREIGN KEY ( divisa )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;

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
