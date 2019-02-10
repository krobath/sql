-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sess_query_sql.sql                                              |
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

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Listing all Active User Sessions                                              |
PROMPT +------------------------------------------------------------------------+

SELECT distinct 
    s.sid           sid
  , s.serial#       serial_id
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , s.machine
  , p.spid          os_pid
  , s.program       session_program
  , s.seconds_in_wait
  , s.event
  , s.p1text
  , s.p1
  , s.p2text
  , s.p2
  , s.p3text
  , s.p3
  , SQL.SQL_ID sql_id
  --, substr(sql.sql_text,0,20) SQL_TEXT
  , sql_text SQL_TEXT

FROM 
    gv$process p,
    gv$session s,
    gv$sql sql
WHERE
    s.inst_id = p.inst_id (+)
    -- AND s.sid = 7348
    --AND p.spid IN (3102,3088,3100,13192,13050,13291)
    AND s.machine LIKE 'skmi-icip-btc%'
    AND S.INST_ID = sql.inst_id (+)
    AND p.addr (+) = s.paddr
    AND S.SQL_ID = sql.SQL_ID (+)
    --AND s.status = 'ACTIVE'
    --AND event != 'SQL*Net message from client'
    AND s.username IS NOT null
ORDER BY 8 asc --seconds_in_wait desc
/

SELECT * FROM v$session where sid = 1181;

SELECT distinct 
    s.sid           sid
  , s.serial#       serial_id
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , s.machine
  , p.spid          os_pid
  , s.program       session_program
  , s.seconds_in_wait
  , s.event
  , s.p1text
  , s.p1
  , s.p2text
  , s.p2
  , s.p3text
  , s.p3
  , s.SQL_ID sql_id
FROM 
    gv$process p,
    gv$session s
WHERE
    s.inst_id = p.inst_id 
    --AND s.sid = 23057
   AND p.spid IN (24949, 20214, 17784)
    AND p.addr (+) = s.paddr
    --AND s.status = 'ACTIVE'
ORDER BY seconds_in_wait desc
/



SELECT username, machine, status, event, sql_id, count(*) FROM v$session 
WHERE (username != 'SYS' OR username IS NOT null )
AND event != 'SQL*Net message from client'
group by username, machine, status, event, sql_id 
order by 1,2,3;


