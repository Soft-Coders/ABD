-- Creación del job J_LIQUIDAR
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'J_LIQUIDAR',
   job_action         =>  'P_COBRO',
   start_date         =>  '01-JUN-22 00.00.00 AM',
   repeat_interval    =>  'FREQ=MONTHLY');
END;
/