

ALTER SYSTEM SET EVENTS '10046 trace name context off';
ALTER SYSTEM SET sql_trace=FALSE;

set lines 100
set pages 1000
spool /tmp/stop_trace.sql
select 'EXEC DBMS_SYSTEM.set_sql_trace_in_session(sid=>'||sid||', serial#=>'||serial#||', sql_trace=>FALSE);' FROM v$session;
spool off
@/tmp/stop_trace.sql


spool /tmp/stop_10046_trace.sql
select 'EXEC DBMS_SYSTEM.set_ev(si=>'||sid||', se=>'||serial#||', ev=>10046, le=>0, nm=>'' '');' FROM v$session;
spool off
@/tmp/stop_10046_trace.sql

spool /tmp/dbms_monitor_disable_trace.sql
select 'exec DBMS_MONITOR.SESSION_TRACE_DISABLE(session_id=>'||sid||', serial_num=>'||serial#||');' FROM v$session;
spool off
@/tmp/dbms_monitor_disable_trace.sql
