SELECT qu.sql_text, qu.SQL_FULLTEXT, qu.PARSING_SCHEMA_NAME, (qu.ELAPSED_TIME / 1000000) / qu.EXECUTIONS, qu.EXECUTIONS, qu.MODULE 
  FROM v$sql qu 
 INNER JOIN all_users au 
    ON qu.parsing_user_id = au.user_id 
 WHERE qu.LAST_ACTIVE_TIME > sysdate-10 AND qu.EXECUTIONS > 0 AND qu.MODULE='OSSClient.exe' 
 ORDER BY (qu.ELAPSED_TIME / qu.EXECUTIONS) DESC;


SELECT SQL_ID, SQL_FULLTEXT, PLAN_HASH_VALUE, PARSING_SCHEMA_NAME, (ELAPSED_TIME / 1000000)/EXECUTIONS time_exec, ELAPSED_TIME, executions, MODULE FROM V$SQL WHERE ELAPSED_TIME >= 3 AND UPPER(MODULE) = 'OSSCLIENT.EXE' ORDER BY TIME_EXEC DESC

/* Formatted on 17-05-2013 13:29:38 (QP5 v5.163.1008.3004) */
  SELECT STAT.SQL_ID,
         SQL_TEXT,
         PLAN_HASH_VALUE,
         PARSING_SCHEMA_NAME,
         ELAPSED_TIME_TOTAL,
         (ELAPSED_TIME_TOTAL/EXECUTIONS_TOTAL)/ 1000000 TIME_EXEC_TOTAL,
        --(ELAPSED_TIME_DELTA/EXECUTIONS_DELTA)/ 1000000 TIME_EXEC_DELTA,
         --ELAPSED_TIME_DELTA,
         EXECUTIONS_TOTAL,
         STAT.SNAP_ID,
         SS.END_INTERVAL_TIME,
         MODULE
    FROM sys.DBA_HIST_SQLSTAT STAT, sys.DBA_HIST_SQLTEXT TXT, sys.DBA_HIST_SNAPSHOT SS
   WHERE     STAT.SQL_ID = TXT.SQL_ID
         AND STAT.DBID = TXT.DBID
         AND SS.DBID = STAT.DBID
         AND SS.INSTANCE_NUMBER = STAT.INSTANCE_NUMBER
         AND STAT.SNAP_ID = SS.SNAP_ID
         AND STAT.DBID = 3566402544
         AND STAT.EXECUTIONS_TOTAL > 0
         --AND STAT.EXECUTIONS_DELTA > 0
         AND STAT.INSTANCE_NUMBER = 1
         AND SS.BEGIN_INTERVAL_TIME >= SYSDATE - 7
         AND (ELAPSED_TIME_TOTAL/EXECUTIONS_TOTAL)/ 1000000 >= 1
         AND UPPER (MODULE) = 'OSSCLIENT.EXE'
ORDER BY EXECUTIONS_TOTAL DESC, TIME_EXEC_TOTAL DESC


SELECT DBID FROM V$DATABASE;

GRANT SELECT ON sys.DBA_HIST_SQLSTAT TO kawc_ro;
GRANT SELECT ON sys.DBA_HIST_SQLTEXT TO kawc_ro;
GRANT SELECT ON sys.DBA_HIST_SNAPSHOT TO kawc_ro;