-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.krobath.dk                                     |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 2015 Henrik Krobath. All rights reserved.               |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sess_traced.sql                                                 |
-- | CLASS    : Session Management                                              |
-- | PURPOSE  : Displays the SQL being run by a given session given the SID.    |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : SQL Query Search Interface                                  |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN sid                FORMAT 999999     HEADING 'SID'
COLUMN serial_id          FORMAT 99999999   HEADING 'Serial ID'
COLUMN session_status     FORMAT a9         HEADING 'Status'
COLUMN oracle_username    FORMAT a18        HEADING 'Oracle User'
COLUMN os_username        FORMAT a18        HEADING 'O/S User'
COLUMN os_pid             FORMAT a8         HEADING 'O/S PID'
COLUMN session_program    FORMAT a40        HEADING 'Session Program'  TRUNC
COLUMN sql_text           FORMAT a180         HEADING 'SQL TEXT'

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Listing all Sessions being traced                                      |
PROMPT +------------------------------------------------------------------------+

SELECT
    s.sid           sid
  , s.serial#       serial_id
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.seconds_in_wait
  , s.event
  ,sql_trace
  , sql_trace_waits
  , sql_trace_binds
  , SQL.SQL_ID sql_id
  , substr(sql.sql_text,0,20) SQL_TEXT
  , pSQL.SQL_ID prev_sql_id
  , substr(psql.sql_text,0,20) PREV_SQL_TEXT
  FROM 
    gv$process p,
    gv$session s,
    gv$sql sql,
    gv$sql psql
WHERE s.status = 'ACTIVE'
--s.module LIKE 'ServerInstanceId_210%'
--s.sqL_trace = 'TRUE' 
	AND s.inst_id = p.inst_id
    AND p.addr (+) = s.paddr
    AND S.SQL_ID = sql.SQL_ID(+)
    AND s.prev_sql_id = psql.sql_id(+)
ORDER BY seconds_in_wait desc
/




SELECT
    s.sid           sid
  , s.serial#       serial_id
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.blocking_session
  , s.seconds_in_wait
  , S.EVENT
  , substr(sql.sql_text,0,60) SQL_TEXT
  , SQL.SQL_ID sql_id
    , substr(psql.sql_text,0,60) PREV_SQL_TEXT
  , pSQL.SQL_ID prev_sql_id
FROM 
    gv$process p,
    gv$session s,
    gv$sql sql,
    gv$sql psql
WHERE
    s.inst_id = p.inst_id --AND s.sid IN (625)
    AND S.INST_ID = sql.inst_id(+)
    AND p.addr (+) = s.paddr
    AND S.SQL_ID =  sql.SQL_ID(+)
    AND s.prev_sql_id = psql.sql_id(+)
    AND (lower(substr(sql.sql_text,0,60)) LIKE '%asymmetric_counterparties%' OR lower(substr(psql.sql_text,0,60)) LIKE '%asymmetric_counterparties%')
ORDER BY seconds_in_wait desc
/

SELECT * FROM DBA_RESUMABLE;

SELECT * FROM v$session where blocking_session is not null;


SELECT rowid from system.sa_eqtrd_stat;





