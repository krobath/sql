
-- DBA HIST Views‎ > ‎ 

-- scripts putting it all together 

--  To get information on I/O latency run the following SQL 
-- and post process the spool files with  parseoraio.sh 


/* NOTE: doesn't take into account database bounces */

set pagesize 0
set linesize 180
set trims on
set escape on
col event_name for a35

define days=1

--   INSTANCE INFORMATION
spool instance.lst
select 'instance' from dual;
select * from v$instance;
spool off

-- GENERAL WAIT EVENTS
spool waits.lst
select 'average wait times, name, count, avg_ms' from dual;
select
       btime,
       event_name,
                 count_end-count_beg count,
       round((time_ms_end-time_ms_beg)/nullif(count_end-count_beg,0),3) avg_ms
from (
select
       to_char(s.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI')  btime,
       e.event_name,
       total_waits count_end,
       time_waited_micro/1000 time_ms_end,
       Lag (e.time_waited_micro/1000)
              OVER( PARTITION BY e.event_name ORDER BY s.snap_id) time_ms_beg,
       Lag (e.total_waits)
              OVER( PARTITION BY e.event_name ORDER BY s.snap_id) count_beg
from
       DBA_HIST_SYSTEM_EVENT e,
       DBA_HIST_SNAPSHOT s
where
         s.snap_id=e.snap_id
  -- and e.event_name in ()
      and wait_class != 'Idle'
       and BEGIN_INTERVAL_TIME > sysdate - &days
order by begin_interval_time
) where count_end-count_beg  > 0
order by btime;
spool off


spool redo.lst
-- REDO per SECOND
select 'redo per second' from dual;
/* minval maxval average standard_deviation sum_squares */
select   to_char( begin_time ,'YYYY/MM/DD HH24:MI'),
         round(average),
         round(maxval)
from     dba_hist_sysmetric_summary
where    metric_name= 'Redo Generated Per Sec' /* and DBID=[dbid if share repository] */
                     and BEGIN_TIME > sysdate - &days
order by begin_time;
spool off

spool reads.lst
-- READ BYTES per SECOND
select 'reads per second' from dual;
select   dbid, to_char( begin_time ,'YYYY/MM/DD HH24:MI'),
         round(average),
         round(maxval)
from     dba_hist_sysmetric_summary
where    metric_name= 'Physical Read Total Bytes Per Sec' /* and DBID=[dbid if share repository] */
                     and BEGIN_TIME > sysdate - &days
order by begin_time;
spool off

spool writes.lst
-- WRITE BYTES per SECOND
select 'writes per second' from dual;
select   dbid, to_char( begin_time ,'YYYY/MM/DD HH24:MI'),
         round(average),
         round(maxval)
from     dba_hist_sysmetric_summary
where    metric_name= 'Physical Write Total Bytes Per Sec' /* and DBID=[dbid if share repository] */
                     and BEGIN_TIME > sysdate - &days
order by begin_time;
spool off

/*
-- covered by the following query, so commenting this one out
-- REDO WRITE SIZES and LATENCY
select 'log file parallel writes' from dual;
select to_char( sample_time ,'YYYY/MM/DD HH24:MI'),
time_waited, p1, p2,p3 from dba_hist_active_sess_history where event='log file parallel write'
and SAMPLE_TIME > sysdate - &days and sample_time < ( select min(sample_time) from v$active_session_history)
union all
select to_char( sample_time ,'YYYY/MM/DD HH24:MI'),
  time_waited, p1, p2,p3 from v$active_session_history where event='log file parallel write';
*/

spool ash.lst
-- I/O SIZES and LATENCIES
select 'I/O reads from ASH, time, name, elapsed, p1,p2,p3' from dual;
select to_char( sample_time ,'YYYY/MM/DD HH24:MI') timestamp ,event,
time_waited, p1, p2,p3
from dba_hist_active_sess_history where event in
( 'log file parallel write',
     'log file sync',
     'db file sequential read',
     'db file scattered read',
     'direct path read',
     'direct path read temp',
     'direct path write',
     'direct path write temp',
     'db file parallel write',
     'control file sequential read',
     'control file sequential write'
)
and SAMPLE_TIME > sysdate - &days and sample_time < ( select min(sample_time) from v$active_session_history)
union all
select to_char( sample_time ,'YYYY/MM/DD HH24:MI') timestamp ,event,
  time_waited, p1, p2,p3
from v$active_session_history where event in
( 'log file parallel write',
     'db file sequential read',
     'log file sync',
     'db file scattered read',
     'direct path read',
     'direct path read temp',
     'direct path write',
     'direct path write temp',
     'db file parallel write',
     'control file sequential read',
     'control file sequential write'
)
/
spool off

spool iosizes.lst

column event format a35
set  escape on
with  ash as
(
select sample_time,event, p1,p2,p3 from v$active_session_history
where wait_class in ('User I/O', 'System I/O')
union all
select sample_time,event, p1,p2,p3 from dba_hist_active_sess_history
where wait_class in ('User I/O', 'System I/O') and
SAMPLE_TIME > sysdate - &days and sample_time < ( select min(sample_time) from v$active_session_history)
)
select event, round(min(p1)) mn, round(avg(p1)) av,round(max(p1)) mx, count(*)  cnt
from ash
where  event in
     ( 'Datapump dump file I/O',  'dbms_file_transfer I/O',
       'kst: async disk IO', 'ksfd: async disk IO',
       'Log archive I/O', 'RMAN backup \& recovery I/O',
       'Standby redo I/O', 'kfk: async disk IO',
       'DG Broker configuration file I/O',  'Data file init write',   'Log file init write')
group by event
union all
select event, round(min(p3)) mn, round(avg(p3)) av, round(max(p3)) mx, count(*)  cnt
from  ash
where  event in
     ('db file scattered read' ,  'direct path read' ,
      'control file sequential read',  'control file single write',
      'log file sequential read', 'log file single write',
      'direct path read temp' ,  'direct path write' ,
      'direct path write temp' ,  'control file parallel read' )
group by event
union all
select event,round(min(p2)) mn, round(avg(p2)) av,round(max(p2)) mx, count(*)  cnt
from ash
where  event in    ( 'control file parallel write' )
group by event
order by event;
spool off

! tar cvf  oraio.tar waits.lst redo.lst writes.lst reads.lst ash.lst  iosizes.lst  instance.lst

