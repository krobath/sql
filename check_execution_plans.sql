SELECT * FROM v$session;

SELECT owner, table_name, last_analyzed FROM dba_tables WHERE owner = 'DMR_KERNE' ORDER BY 3 DESC;


SELECT sql_id, sum(executions) sum_EXECS, min(elapsed_Time), max(elapsed_time), max(elapsed_time)/min(elapsed_Time) std_dev 
FROM v$sqlarea
GROUP BY sql_id;

SELECT sql_id, child_number, plan_Hash_value, executions, elapsed_time, sql_text
FROM v$sql
WHERE sql_id = 'a8zq568rz37bv'
ORDER BY 1,2,3;

select 
   DBMS_SQL_MONITOR.REPORT_SQL_MONITOR
        (sql_id=>'a8zq568rz37bv',report_level=>'ALL') report
from dual;

SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR(
            SQL_ID=>'a8zq568rz37bv', 
            CHILD_NUMBER=>the_child_number, 
            FORMAT=>'ALL +OUTLINE'));