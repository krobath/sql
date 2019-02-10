-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sp_auto_15.sql                                                  |
-- | CLASS    : Statspack                                                       |
-- | PURPOSE  : This script is responsible to configure a DBMS Job to be run    |
-- |            every 15 minutes starting at the quarter of each hour. For      |
-- |            example, if this script is run at 10:32 pm, the first job will  |
-- |            be run at 10:45 pm, then the next job at 11:00 pm and so on     |
-- |            every 15 minutes.                                               |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

prompt 
prompt =========================================================================
prompt The following script will create a new DBMS Job to be run at the quarter
prompt of each hour. (i.e. Every 15 minutes). The job will perform a Statspack
prompt snapshot using the Oracle supplied STATSPACK package.
prompt 
prompt Note that this script should be run as the owner of the 
prompt STATSPACK repository. (i.e. PERFSTAT)
prompt This script will prompt you for the PERFSTAT password.
prompt 
prompt Also note that in order to submit and run a job, the init.ora parameter
prompt job_queue_processes must be set to a value greater than zero.
prompt =========================================================================
prompt
prompt Hit [ENTER] to continue or CTRL-C to cancel ...
pause

prompt Supply the password for the PERFSTAT user:
connect perfstat


-- +------------------------------------------------------------------------+
-- | SCHEDULE A SNAPSHOT TO BE RUN EVERY 15 MINUTES.                        |
-- +------------------------------------------------------------------------+

VARIABLE jobno  NUMBER;
VARIABLE instno NUMBER;

BEGIN

  SELECT instance_number into :instno
  FROM   v$instance;

  DBMS_JOB.SUBMIT(   :jobno
                   , 'statspack.snap;'
                   , TRUNC(sysdate,'HH24')+((FLOOR(TO_NUMBER(TO_CHAR(sysdate,'MI'))/15)+1)*15)/(24*60)
                   , 'TRUNC(sysdate,''HH24'')+((FLOOR(TO_NUMBER(TO_CHAR(sysdate,''MI''))/15)+1)*15)/(24*60)'
                   , TRUE
                   , :instno);

  COMMIT;

END;
/

prompt 
prompt 
prompt +----------------------------------+
prompt | JOB NUMBER                       |
prompt |------------------------------------------------------------------+
prompt | The following job number should be noted as it will be required  |
prompt | when modifying or removing prompt the job:                       |
prompt +------------------------------------------------------------------+
prompt 
print jobno


prompt 
prompt 
prompt +----------------------------------+
prompt | JOB QUEUE PROCESS CONFIGURATION  |
prompt |------------------------------------------------------------------+
prompt | Below is the current setting of the job_queue_processes init.ora |
prompt | parameter - the value for this parameter must be greater than 0  |
prompt | to use automatic statistics gathering:                           |
prompt +------------------------------------------------------------------+
prompt 
show parameter job_queue_processes

prompt 
prompt 
prompt +----------------------------------+
prompt | NEXT SCHEDULED RUN               |
prompt |------------------------------------------------------------------+
prompt | The next scheduled run for this job is:                          |
prompt +------------------------------------------------------------------+
prompt 
SELECT job, next_date, next_sec
FROM   user_jobs
WHERE  job = :jobno;

