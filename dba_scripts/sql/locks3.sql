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
COLUMN obj_owner           FORMAT a18        HEADING 'Owner'
COLUMN obj_name            FORMAT a24        HEADING 'Object name'
COLUMN object_type         FORMAT a20        HEADING 'Object type'
COLUMN os_user    	   FORMAT a18        HEADING 'OS User'
COLUMN mode_held    	   FORMAT a20        HEADING 'Mode'

 
SELECT s.username, s.sid, s.serial#, s.osuser, k.ctime, o.object_name
object, k.kaddr, DECODE(l.locked_mode,
  1, 'No Lock',
  2, 'Row Share',
  3, 'Row Exclusive',
  4, 'Shared Table',
  5, 'Shared Row Exclusive',
  6, 'Exclusive') locked_mode,
  DECODE(k.TYPE,
    'BL','Buffer Cache Management (PCM lock)',
  'CF','Controlfile Transaction',
  'CI','Cross Instance Call',
  'CU','Bind Enqueue',
  'DF','Data File',
  'DL','Direct Loader',
  'DM','Database Mount',
  'DR','Distributed Recovery',
  'DX','Distributed Transaction',
  'FS','File Set',
  'IN','Instance Number',
  'IR','Instance Recovery',
  'IS','Instance State',
  'IV','Library Cache Invalidation',
  'JQ','Job Queue',
  'KK','Redo Log Kick',
  'LA','Library Cache Lock',
  'LB','Library Cache Lock',
  'LC','Library Cache Lock',
  'LD','Library Cache Lock',
  'LE','Library Cache Lock',
  'LF','Library Cache Lock',
  'LG','Library Cache Lock',
  'LH','Library Cache Lock',
  'LI','Library Cache Lock',
  'LJ','Library Cache Lock',
  'LK','Library Cache Lock',
  'LL','Library Cache Lock',
  'LM','Library Cache Lock',
  'LN','Library Cache Lock',
  'LO','Library Cache Lock',
  'LP','Library Cache Lock',
  'MM','Mount Definition',
  'MR','Media Recovery',
  'NA','Library Cache Pin',
  'NB','Library Cache Pin',
  'NC','Library Cache Pin',
  'ND','Library Cache Pin',
  'NE','Library Cache Pin',
  'NF','Library Cache Pin',
  'NG','Library Cache Pin',
  'NH','Library Cache Pin',
  'NI','Library Cache Pin',
  'NJ','Library Cache Pin',
  'NK','Library Cache Pin',
  'NL','Library Cache Pin',
  'NM','Library Cache Pin',
  'NN','Library Cache Pin',
  'NO','Library Cache Pin',
  'NP','Library Cache Pin',
  'NQ','Library Cache Pin',
  'NR','Library Cache Pin',
  'NS','Library Cache Pin',
  'NT','Library Cache Pin',
  'NU','Library Cache Pin',
  'NV','Library Cache Pin',
  'NW','Library Cache Pin',
  'NX','Library Cache Pin',
  'NY','Library Cache Pin',
  'NZ','Library Cache Pin',
  'PF','Password File',
  'PI','Parallel Slaves',
  'PR','Process Startup',
  'PS','Parallel Slave Synchronization',
  'QA','Row Cache Lock',
  'QB','Row Cache Lock',
  'QC','Row Cache Lock',
  'QD','Row Cache Lock',
  'QE','Row Cache Lock',
  'QF','Row Cache Lock',
  'QG','Row Cache Lock',
  'QH','Row Cache Lock',
  'QI','Row Cache Lock',
  'QJ','Row Cache Lock',
  'QK','Row Cache Lock',
  'QL','Row Cache Lock',
  'QM','Row Cache Lock',
  'QN','Row Cache Lock',
  'QO','Row Cache Lock',
  'QP','Row Cache Lock',
  'QQ','Row Cache Lock',
  'QR','Row Cache Lock',
  'QS','Row Cache Lock',
  'QT','Row Cache Lock',
  'QU','Row Cache Lock',
  'QV','Row Cache Lock',
  'QW','Row Cache Lock',
  'QX','Row Cache Lock',
  'QY','Row Cache Lock',
  'QZ','Row Cache Lock',
  'RT','Redo Thread',
  'SC','System Commit number',
  'SM','SMON synchronization',
  'SN','Sequence Number',
  'SQ','Sequence Enqueue',
  'SR','Synchronous Replication',
  'SS','Sort Segment',
  'ST','Space Management Transaction',
  'SV','Sequence Number Value',
  'TA','Transaction Recovery',
  'TM','DML Enqueue',
  'TS','Table Space (or Temporary Segment)',
  'TT','Temporary Table',
  'TX','Transaction',
  'UL','User-defined Locks',
  'UN','User Name',
  'US','Undo segment Serialization',
  'WL','Writing redo Log',
  'XA','Instance Attribute Lock',
  'XI','Instance Registration Lock') TYPE
FROM gv$session s, sys.gv$lock c, sys.gv$locked_object l,
     dba_objects o, sys.gv$lock k, gv$lock v
WHERE o.object_id = l.object_id
AND l.session_id = s.sid
AND k.sid = s.sid
AND s.saddr = c.addr
AND k.kaddr = c.kaddr
AND k.kaddr = v.kaddr
AND v.saddr = s.saddr
AND k.lmode = l.locked_mode
AND k.lmode = c.lmode
AND k.request = c.request
ORDER BY object
/


