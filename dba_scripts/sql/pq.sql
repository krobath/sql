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
PROMPT | Report   : Parallel Query Overview                                     |
PROMPT | Instance : &current_instance                                           |
PROMPT | Note     : List details about PQ server processes and PQ sessions      |
PROMPT |                                                                        |
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

PROMPT +------------------------------------------------------------------------+
PROMPT | Parallel Query Servers                                                 |
PROMPT +------------------------------------------------------------------------+
SELECT * FROM V$PX_PROCESS
/

COLUMN SPID FORMAT a10
COLUMN EVENT FORMAT a30
COLUMN DB_USER FORMAT a10
COLUMN OS_USER FORMAT a10
COLUMN PROGRAM FORMAT a30
COLUMN SECONDS_IN_WAIT FORMAT 999
COLUMN STATE FORMAT a20
COLUMN CLIENT_INFO FORMAT a30

PROMPT +------------------------------------------------------------------------+
PROMPT | Parallel Query Degree requests                                         |
PROMPT +------------------------------------------------------------------------+
SELECT QCSID, SID, INST_ID "Inst", SERVER_GROUP "Group", SERVER_SET "Set",
  DEGREE "Degree", REQ_DEGREE "Req Degree"
FROM GV$PX_SESSION ORDER BY QCSID, QCINST_ID, SERVER_GROUP, SERVER_SET
/

PROMPT +------------------------------------------------------------------------+
PROMPT | Parallel Query progress                                                |
PROMPT +------------------------------------------------------------------------+
SELECT QCSID, SID, INST_ID "Inst", SERVER_GROUP "Group", SERVER_SET "Set",
  NAME "Stat Name", VALUE
FROM GV$PX_SESSTAT A, V$STATNAME B
WHERE A.STATISTIC# = B.STATISTIC# AND NAME LIKE 'PHYSICAL READS'
  AND VALUE > 0 ORDER BY QCSID, QCINST_ID, SERVER_GROUP, SERVER_SET
/

PROMPT +------------------------------------------------------------------------+
PROMPT | PQ wait state of each slave and query coordinator                      |
PROMPT +------------------------------------------------------------------------+

COLUMN SPID FORMAT a10
COLUMN EVENT FORMAT a30
COLUMN DB_USER FORMAT a10
COLUMN OS_USER FORMAT a10
COLUMN PROGRAM FORMAT a30
COLUMN SECONDS_IN_WAIT FORMAT 999
COLUMN STATE FORMAT a20
COLUMN CLIENT_INFO FORMAT a30

SELECT px.SID "SID", p.PID, p.SPID "SPID", px.INST_ID "Inst",
       px.SERVER_GROUP "Group", px.SERVER_SET "Set",
       px.DEGREE "Degree", px.REQ_DEGREE "Req Degree", w.event "Wait Event"
FROM GV$SESSION s, GV$PX_SESSION px, GV$PROCESS p, GV$SESSION_WAIT w
WHERE s.sid (+) = px.sid AND s.inst_id (+) = px.inst_id AND
      s.sid = w.sid (+) AND s.inst_id = w.inst_id (+) AND
      s.paddr = p.addr (+) AND s.inst_id = p.inst_id (+)
ORDER BY DECODE(px.QCINST_ID,  NULL, px.INST_ID,  px.QCINST_ID), px.QCSID, 
DECODE(px.SERVER_GROUP, NULL, 0, px.SERVER_GROUP), px.SERVER_SET, px.INST_ID
/
