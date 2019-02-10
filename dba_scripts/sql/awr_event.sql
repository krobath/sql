set lines 200
SELECT TO_CHAR(b.begin_interval_time,'YYYYMMDDHH24MISS')||';  '||
    TO_CHAR(b.end_interval_time,'YYYYMMDDHH24MISS')||';  '||
    a.snap_id||';  '||
    a.event_name||';  '||
    CASE WHEN nvl((nullif(a.tot_time_waite_mic_curr_snap,0)/nullif(a.tot_wait_fg_curr_snap,0))/1000,0) < 0 THEN 0
	ELSE nvl((nullif(a.tot_time_waite_mic_curr_snap,0)/nullif(a.tot_wait_fg_curr_snap,0))/1000,0)
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
  and c.event_name = '&event_name'
) a, dba_hist_snapshot b
where
  --a.snap_id between ((SELECT max(snap_id) FROM dba_hist_snapshot) - 1000) and (SELECT max(snap_id) FROM dba_hist_snapshot) -- last 1000 AWR snapshots
  a.snap_id between ((SELECT min(snap_id) FROM dba_hist_snapshot) + 1) and (SELECT max(snap_id) FROM dba_hist_snapshot) -- all AWR snapshots
AND a.snap_id = b.snap_id
order by
  a.snap_id
/