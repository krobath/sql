spool c:\private\spool\&report_name
select  to_char(begin_interval_time,'YYYYMMDDHH24MISS') "sample_end"
,number_of_waits_dif
,wait_time_dif
,round(decode(number_of_waits_dif,0,0,wait_time_dif/number_of_waits_dif),3) ms_per_wait from (
 select s.begin_interval_time,
    s.snap_id,
    f.small_write_megabytes-lag(f.small_write_megabytes, 1, 0) over (order by f.snap_id) as small_write_megabytes_dif,
    f.small_write_reqs-lag(f.small_write_reqs, 1, 0) over (order by f.snap_id) as small_write_reqs_dif,
    f.large_write_megabytes-lag(f.large_write_megabytes, 1, 0) over (order by f.snap_id) as large_write_megabytes_dif,
    f.large_write_reqs-lag(f.large_write_reqs, 1, 0) over (order by f.snap_id) as large_write_reqs_dif,
    f.number_of_waits-lag(f.number_of_waits, 1, 0) over (order by f.snap_id) as number_of_waits_dif,
    f.wait_time-lag(f.wait_time, 1, 0) over (order by f.snap_id) as wait_time_dif
from dba_hist_iostat_function f, DBA_HIST_snapshot s
where f.function_name = '&iostat_function'
and f.snap_id = s.snap_id)
where snap_id between ((SELECT min(snap_id) FROM dba_hist_snapshot) + 1) and (SELECT max(snap_id) FROM dba_hist_snapshot) -- all AWR snapshots
order by begin_interval_time
/
spool off