-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : rman_progress.sql                                               |
-- | CLASS    : Recovery Manager                                                |
-- | PURPOSE  : Provide a listing of all current RMAN operations and their      |
-- |            estimated timings.                                              |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : RMAN Backup Progress                                        |
PROMPT | Instance : &current_instance                                           |
PROMPT | Note     : A listing of all current RMAN operations and their          |
PROMPT |            estimated timings.                                          |
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

COLUMN SPID FORMAT a10
COLUMN EVENT FORMAT a30
COLUMN DB_USER FORMAT a10
COLUMN OS_USER FORMAT a10
COLUMN PROGRAM FORMAT a30
COLUMN SECONDS_IN_WAIT FORMAT 999
COLUMN STATE FORMAT a20
COLUMN CLIENT_INFO FORMAT a30

SELECT s.inst_id, i.host_name, p.SPID, s.sid, s.serial#, p.username os_user, s.username db_user, s.program, s.EVENT, s.SECONDS_IN_WAIT AS SEC_WAIT, 
       sw.STATE, CLIENT_INFO
FROM sys.GV$SESSION_WAIT sw, sys.GV$SESSION s, sys.GV$PROCESS p, GV$INSTANCE i
WHERE s.inst_id = p.inst_id
AND s.inst_id = sw.inst_id
AND s.inst_id = i.inst_id
AND lower(s.program) LIKE 'rman%'
    AND s.SID=sw.SID
    AND s.PADDR=p.ADDR
/
/
