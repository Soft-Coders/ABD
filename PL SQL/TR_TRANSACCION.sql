CREATE SEQUENCE SQ_TRANSACCION START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER TR_TRANSACCION 
BEFORE INSERT ON TRANSACCION
FOR EACH ROW
BEGIN
    :new.ID := SQ_TRANSACCION.NEXTVAL;
END TR_TRANSACCION;