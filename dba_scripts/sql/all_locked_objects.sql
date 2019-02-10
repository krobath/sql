-- +----------------------------------------------------------------------------+
-- |                         Henrik  Krobath                                    |
-- |                        henrik@krobath.dk                                   |
-- |                         www.krobath.dk                                     |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 2013 Henrik Krobath. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : locks1.sql                                               |
-- | CLASS    : SQL Management                                                  |
-- | PURPOSE  : Displays objects locked for more than 60 seconds.             |
-- | NOTE     : This is for 10g and newer.                                      |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Objects locked for more than 60 seconds                     |
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

COLUMN u_name    	   FORMAT a18        HEADING 'Oracle User'
COLUMN obj_owner           FORMAT a8        HEADING 'Owner'
COLUMN obj_name            FORMAT a20        HEADING 'Object name'
COLUMN object_type         FORMAT a14        HEADING 'Object type'
COLUMN os_user    	   FORMAT a10        HEADING 'OS User'
COLUMN mode_held    	   FORMAT a20        HEADING 'Mode'

 
SELECT s.sid SID, username U_NAME, owner OBJ_OWNER,
object_name, object_type, s.osuser os_user,
DECODE(l.block,
  0, 'Not Blocking',
  1, 'Blocking',
  2, 'Global') STATUS,
  DECODE(v.locked_mode,
    0, 'None',
    1, 'Null',
    2, 'Row-S (SS)',
    3, 'Row-X (SX)',
    4, 'Share',
    5, 'S/Row-X (SSX)',
    6, 'Exclusive', TO_CHAR(lmode)
  ) MODE_HELD
FROM gv$locked_object v, dba_objects d,
gv$lock l, gv$session s
WHERE v.object_id = d.object_id
AND (v.object_id = l.id1)
AND v.session_id = s.sid
ORDER BY username, session_id
/

SELECT O.OBJECT_NAME, S.SID, S.SERIAL#, P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.LOGON_TIME,SQ.SQL_FULLTEXT ,L.*
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS order by S.LOGON_TIME desc
/

select object_name, s.sid, s.serial#, p.spid 
from v$locked_object l, dba_objects o, v$session s, v$process p
where l.object_id = o.object_id and l.session_id = s.sid and s.paddr = p.addr
/



