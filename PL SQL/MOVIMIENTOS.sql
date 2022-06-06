CREATE TABLE movimientos (
    numero              VARCHAR2(20) NOT NULL,
    divisa              VARCHAR2(20) NOT NULL,
    numero_tarjeta      NUMBER(16,0) NOT NULL,
    fecha               DATE NOT NULL,
    cantidad            NUMBER(9,0),
    estado              VARCHAR2(20) NOT NULL,
    modo                VARCHAR2(20),
    tipo_emisor         VARCHAR2(20)
)
LOGGING;

ALTER TABLE movimientos ADD CONSTRAINT movimientos_pk PRIMARY KEY ( numero );

ALTER TABLE movimientos ADD CONSTRAINT tarjeta_fk FOREIGN KEY ( numero_tarjeta )
        REFERENCES tarjetas ( numero )
    NOT DEFERRABLE;

ALTER TABLE movimientos ADD CONSTRAINT divisa_fk FOREIGN KEY ( divisa )
        REFERENCES divisa ( abreviatura )
    NOT DEFERRABLE;