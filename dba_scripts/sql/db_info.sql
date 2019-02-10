

PROMPT Database info...


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

col host_name for a20
col force_logging for a14

SELECT a.name DB_NAME, b.instance_name, a.created, a.log_mode, 
       a.open_mode, a.database_role, a.force_logging FORCE_LOGGING, b.host_name, 
       b.database_status 
from v$database a, gv$instance b
/

PROMPT Database version...

col db_version for a32

SELECT SUBSTR (SUBSTR (BANNER, INSTR (BANNER, 'Release ') + 8),
               1,
               INSTR (SUBSTR (BANNER, INSTR (BANNER, 'Release ') + 8), ' ')) DB_VERSION
  FROM V$VERSION
 WHERE BANNER LIKE 'Oracle%' OR BANNER LIKE 'Personal Oracle%'
/

SELECT TO_NUMBER (SUBSTR (VERSION,
                          1,
                          INSTR (VERSION,
                                 '.',
                                 1,
                                 2)
                          - 1),
                  '99.99')
          VERSION_NUM,
       TO_NUMBER (SUBSTR (VERSION,
                          INSTR (VERSION,
                                 '.',
                                 1,
                                 2)
                          + 1,
                            INSTR (VERSION,
                                   '.',
                                   1,
                                   4)
                          - INSTR (VERSION,
                                   '.',
                                   1,
                                   2)
                          - 1),
                  '99.99')
          PATCH_LEVEL,
       INSTANCE_NAME
  FROM V$INSTANCE
/

col comp_name for a40
col version for a16

SELECT comp_name, version, status FROM dba_registry
/

col BACKUP for a20 HEAD BACKUP_IS_RUNNING

SELECT DECODE (os_backup.backup + rman_backup.backup, 0, 'FALSE', 'TRUE')
          backup
  FROM (SELECT COUNT (*) backup
          FROM v$backup
         WHERE status = 'ACTIVE') os_backup,
       (SELECT COUNT (*) backup
          FROM v$session
         WHERE status = 'ACTIVE' AND client_info LIKE '%id=rman%') rman_backup
/

