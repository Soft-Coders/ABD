-- Creación del job J_LIQUIDAR
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'J_LIQUIDAR',
   job_type            => 'PLSQL_BLOCK',
   job_action         =>  'P_COBRO',
   start_date         =>  TIMESTAMP '2022-06-01 00:00:00',
   end_date            => null,
   enabled             => TRUE,
   repeat_interval    =>  'FREQ=MONTHLY');
END;
/
