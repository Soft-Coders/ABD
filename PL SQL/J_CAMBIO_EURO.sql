
CREATE OR REPLACE PROCEDURE P_CAMBIOEURO
IS
BEGIN
    UPDATE DIVISA
        SET 
            DIVISA.CAMBIO_EURO = V_COTIZACIONES.CAMBIOEURO
        WHERE
            DIVISA.ABREVIATURA = V_COTIZACIONES.ABREVIATURA;
            
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
END P_CAMBIOEURO;

begin
DBMS_SCHEDULER.CREATE_JOB(
    job_name            => 'J_CAMBIO_EURO',
    job_type            => 'PLSQL_BLOCK',
    job_action          => 'P_CAMBIOEURO;',
    start_date          => TIMESTAMP '2022-06-06 00:05:00',
    repeat_interval     => 'FREQ=DAILY; INTERVAL=1',
    end_date            => null,
    enabled             => TRUE,
    comments            => 'Actualiza el atributo cambio euro de la tabla divisa tomando el valor de la vista v_cotizaciones cada día a las 00:05'
);
end;