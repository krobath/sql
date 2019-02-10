-- +----------------------------------------------------------------------------+
-- |                         Henrik  Krobath                                    |
-- |                        henrik@krobath.dk                                   |
-- |                         www.krobath.dk                                     |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 2013 Henrik Krobath. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sql_top40_10g.sql                                               |
-- | CLASS    : SQL Management                                                  |
-- | PURPOSE  : Displays the top 40 SQL statements on the database.             |
-- | NOTE     : This is for 10g and newer.                                      |
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
PROMPT | List heavy SQL statements                                              |
PROMPT +------------------------------------------------------------------------+

SELECT * FROM
(SELECT
    sql_fulltext,
    sql_id,
    child_number,
    disk_reads,
    executions,
    first_load_time,
    last_load_time
FROM    v$sql
ORDER BY elapsed_time DESC)
WHERE ROWNUM < 40
/


REM +----------------------------------------------------+
REM | PROMPT USER FOR sql_id and child number.           |
REM +----------------------------------------------------+

PROMPT 
ACCEPT sql_id CHAR PROMPT 'Enter Oracle SQL id: '

PROMPT 
ACCEPT child CHAR PROMPT 'Enter Oracle SQL child number: '

COLUMN sql_text FORMAT a80

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&sql_id', &&child))
/
