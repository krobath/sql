spool c:\private\spool\&report_name
SELECT  to_char(sn.end_interval_time,'YYYYMMDDHH24MISS') "sample_end"
, st.stat_name
, st.value
, st.value - LAG(st.value) OVER (ORDER BY sn.snap_id) delta_value 
from dba_hist_sysstat st, dba_hist_snapshot sn
where st.stat_Name like '&stat_name'
AND sn.snap_id = st.snap_id
and sn.snap_id between ((SELECT min(snap_id) FROM dba_hist_snapshot) + 1) and (SELECT max(snap_id) FROM dba_hist_snapshot)
order by sn.snap_id;
/
spool off


SELECT  to_char(sn.end_interval_time,'YYYYMMDDHH24MISS')||','||st.stat_name||','||st.value||','||st.value - LAG(st.value) OVER (ORDER BY sn.snap_id) delta_value 
from dba_hist_sysstat st, dba_hist_snapshot sn
where st.stat_Name like 'log file sync'
AND sn.snap_id = st.snap_id
and sn.snap_id between ((SELECT min(snap_id) FROM dba_hist_snapshot) + 1) and (SELECT max(snap_id) FROM dba_hist_snapshot)
order by sn.snap_id;
/

SELECT --TO_CHAR(b.begin_interval_time,'YYYYMMDDHH24MISS')||';'||
    TO_CHAR(b.end_interval_time,'YYYYMMDDHH24MISS')||' '||
    --a.snap_id||';'||
    a.event_name||';'||
    CASE WHEN nvl((nullif(a.tot_time_waite_mic_curr_snap,0)/nullif(a.tot_wait_fg_curr_snap,0))/1000,0) < 0 THEN 0
    ELSE round(nvl((nullif(a.tot_time_waite_mic_curr_snap,0)/nullif(a.tot_wait_fg_curr_snap,0))/1000,0),2)
    END avg_ms  FROM (
  select
    c.snap_id,
    c.event_name,
    c.total_waits_fg - LAG(c.total_waits_fg) OVER (ORDER BY c.snap_id) tot_wait_fg_curr_snap,
    c.time_waited_micro_fg - LAG(c.time_waited_micro_fg) OVER (ORDER BY c.snap_id) tot_time_waite_mic_curr_snap
from
  dba_hist_system_event c
where
  c.instance_number = 1
  and c.event_name = 'db file sequential read'
) a, dba_hist_snapshot b
where
  --a.snap_id between ((SELECT max(snap_id) FROM dba_hist_snapshot) - 1000) and (SELECT max(snap_id) FROM dba_hist_snapshot) -- last 1000 AWR snapshots
  a.snap_id between ((SELECT min(snap_id) FROM dba_hist_snapshot) + 1) and (SELECT max(snap_id) FROM dba_hist_snapshot) -- all AWR snapshots
AND a.snap_id = b.snap_id
order by
  a.snap_id
/