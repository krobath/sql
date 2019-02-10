

/* Formatted on 21-06-2018 12:24:49 (QP5 v5.326) */
SELECT nm.snap_id,
       nm.snap_time,
       to_char(nm.snap_time,'yyyymmddhh24miss') snap_time_frmt,
       '',
       sql_id || '::' || hash_value
           AS sqlexec,
       NVL (
           DECODE (
               GREATEST (
                   executions,
                   NVL (
                       LAG (executions)
                           OVER (
                               PARTITION BY stats$sql_summary.dbid,
                                            stats$sql_summary.instance_number,
                                            sql_id || '::' || hash_value
                               ORDER BY stats$sql_summary.snap_id),
                       0)),
               executions,   executions
                           - LAG (executions)
                                 OVER (
                                     PARTITION BY stats$sql_summary.dbid,
                                                  stats$sql_summary.instance_number,
                                                     sql_id
                                                  || '::'
                                                  || hash_value
                                     ORDER BY stats$sql_summary.snap_id),
               executions),
           0)
           EXECS,
         NVL (
             DECODE (
                 GREATEST (
                     elapsed_time,
                     NVL (
                         LAG (elapsed_time)
                             OVER (
                                 PARTITION BY stats$sql_summary.dbid,
                                              stats$sql_summary.instance_number,
                                              sql_id || '::' || hash_value
                                 ORDER BY stats$sql_summary.snap_id),
                         0)),
                 elapsed_time,   elapsed_time
                               - LAG (elapsed_time)
                                     OVER (
                                         PARTITION BY stats$sql_summary.dbid,
                                                      stats$sql_summary.instance_number,
                                                         sql_id
                                                      || '::'
                                                      || hash_value
                                         ORDER BY stats$sql_summary.snap_id),
                 elapsed_time),
             0)
       / 1000000
           ELAPS,
        NVL (
             DECODE (
                 GREATEST (
                     buffer_gets,
                     NVL (
                         LAG (buffer_gets)
                             OVER (
                                 PARTITION BY stats$sql_summary.dbid,
                                              stats$sql_summary.instance_number,
                                              sql_id || '::' || hash_value
                                 ORDER BY stats$sql_summary.snap_id),
                         0)),
                 buffer_gets,   buffer_gets
                               - LAG (buffer_gets)
                                     OVER (
                                         PARTITION BY stats$sql_summary.dbid,
                                                      stats$sql_summary.instance_number,
                                                         sql_id
                                                      || '::'
                                                      || hash_value
                                         ORDER BY stats$sql_summary.snap_id),
                 buffer_gets),
             0)
           BUFFER_GETS,
        NVL (
             DECODE (
                 GREATEST (
                     disk_reads,
                     NVL (
                         LAG (disk_reads)
                             OVER (
                                 PARTITION BY stats$sql_summary.dbid,
                                              stats$sql_summary.instance_number,
                                              sql_id || '::' || hash_value
                                 ORDER BY stats$sql_summary.snap_id),
                         0)),
                 disk_reads,   disk_reads
                               - LAG (disk_reads)
                                     OVER (
                                         PARTITION BY stats$sql_summary.dbid,
                                                      stats$sql_summary.instance_number,
                                                         sql_id
                                                      || '::'
                                                      || hash_value
                                         ORDER BY stats$sql_summary.snap_id),
                 buffer_gets),
             0)
           DISK_READS
  FROM stats$sql_summary, stats$snapshot nm
 WHERE     stats$sql_summary.snap_id = nm.snap_id
       AND nm.snap_time >= SYSDATE - 7
       AND sql_id = 'gddpu21rzmdfp'
;



DESC stats$sql_summary

SELECT sql_id, count(*) from v$session where sql_id is NOT NULL GROUP BY sql_id;

/* Formatted on 21-06-2018 12:24:39 (QP5 v5.326) */
  SELECT totals.instance_number,
         totals.event,
         SUM (totals.tot_waits),
         SUM (totals.tot_time)
    FROM (SELECT dhs.instance_number,
                 dhs.snap_time,
                 dsys.event,
                 NVL (
                     DECODE (
                         GREATEST (
                             TOTAL_WAITS,
                             NVL (
                                 LAG (TOTAL_WAITS)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TOTAL_WAITS,   TOTAL_WAITS
                                      - LAG (TOTAL_WAITS)
                                            OVER (
                                                PARTITION BY dsys.dbid,
                                                             dsys.instance_number,
                                                             dsys.event
                                                ORDER BY dhs.snap_id),
                         TOTAL_WAITS),
                     0)
                     tot_waits,
                 NVL (
                     DECODE (
                         GREATEST (
                             TIME_WAITED_MICRO,
                             NVL (
                                 LAG (TIME_WAITED_MICRO)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TIME_WAITED_MICRO,   TIME_WAITED_MICRO
                                            - LAG (TIME_WAITED_MICRO)
                                                  OVER (
                                                      PARTITION BY dsys.dbid,
                                                                   dsys.instance_number,
                                                                   dsys.event
                                                      ORDER BY dhs.snap_id),
                         TIME_WAITED_MICRO),
                     0)
                     tot_time
            FROM STATS$SYSTEM_EVENT dsys, stats$snapshot dhs
           WHERE     dsys.instancE_number = dhs.instance_number
                 AND dhs.snap_id = dsys.snap_id
                 AND dhs.snap_time >= SYSDATE - 360) totals
GROUP BY totals.instance_number, totals.event
ORDER BY SUM (totals.tot_waits) DESC
;


/* Formatted on 21-06-2018 12:24:12 (QP5 v5.326) */
SELECT nm.snap_id,
       nm.snap_time,
       '',
       o.owner || ':' || o.object_name || ':' || o.subobject_name
           AS objname,
       NVL (
           DECODE (
               GREATEST (
                   PHYSICAL_READS,
                   NVL (
                       LAG (PHYSICAL_READS)
                           OVER (
                               PARTITION BY ss.dbid,
                                            ss.instance_number,
                                               o.owner
                                            || ':'
                                            || o.object_name
                                            || ':'
                                            || o.subobject_name
                               ORDER BY ss.snap_id),
                       0)),
               PHYSICAL_READS,   PHYSICAL_READS
                               - LAG (PHYSICAL_READS)
                                     OVER (
                                         PARTITION BY ss.dbid,
                                                      ss.instance_number,
                                                         o.owner
                                                      || ':'
                                                      || o.object_name
                                                      || ':'
                                                      || o.subobject_name
                                         ORDER BY ss.snap_id),
               PHYSICAL_READS),
           0)
           AS phyr,
       NVL (
           DECODE (
               GREATEST (
                   DIRECT_PHYSICAL_READS,
                   NVL (
                       LAG (DIRECT_PHYSICAL_READS)
                           OVER (
                               PARTITION BY ss.dbid,
                                            ss.instance_number,
                                               o.owner
                                            || ':'
                                            || o.object_name
                                            || ':'
                                            || o.subobject_name
                               ORDER BY ss.snap_id),
                       0)),
               DIRECT_PHYSICAL_READS,   DIRECT_PHYSICAL_READS
                                      - LAG (DIRECT_PHYSICAL_READS)
                                            OVER (
                                                PARTITION BY ss.dbid,
                                                             ss.instance_number,
                                                                o.owner
                                                             || ':'
                                                             || o.object_name
                                                             || ':'
                                                             || o.subobject_name
                                                ORDER BY ss.snap_id),
               DIRECT_PHYSICAL_READS),
           0)
           AS phyrd
  FROM stats$seg_stat ss, stats$snapshot nm, dba_objects o
 WHERE     ss.snap_id = nm.snap_id
       AND ss.obj# = o.object_id
       AND o.owner = 'PERFSTAT'
       AND o.object_name = 'STATS$SQL_SUMMARY'
       AND o.subobject_name IS NULL
       AND nm.snap_time >= SYSDATE - 7
       ;
       
       
       

/* Formatted on 21-06-2018 12:24:39 (QP5 v5.326) */
  SELECT totals.instance_number,
         totals.event,
         totals.snap_time,
         totals.tot_waits,
         totals.tot_time
  FROM (SELECT dhs.instance_number,
                 dhs.snap_time,
                 dsys.event,
                 NVL (
                     DECODE (
                         GREATEST (
                             TOTAL_WAITS,
                             NVL (
                                 LAG (TOTAL_WAITS)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TOTAL_WAITS,   TOTAL_WAITS
                                      - LAG (TOTAL_WAITS)
                                            OVER (
                                                PARTITION BY dsys.dbid,
                                                             dsys.instance_number,
                                                             dsys.event
                                                ORDER BY dhs.snap_id),
                         TOTAL_WAITS),
                     0)
                     tot_waits,
                 NVL (
                     DECODE (
                         GREATEST (
                             TIME_WAITED_MICRO,
                             NVL (
                                 LAG (TIME_WAITED_MICRO)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TIME_WAITED_MICRO,   TIME_WAITED_MICRO
                                            - LAG (TIME_WAITED_MICRO)
                                                  OVER (
                                                      PARTITION BY dsys.dbid,
                                                                   dsys.instance_number,
                                                                   dsys.event
                                                      ORDER BY dhs.snap_id),
                         TIME_WAITED_MICRO),
                     0)
                     tot_time
            FROM STATS$SYSTEM_EVENT dsys, stats$snapshot dhs
           WHERE     dsys.instancE_number = dhs.instance_number
                 AND dhs.snap_id = dsys.snap_id
                 AND dhs.snap_time >= SYSDATE - 360
                 AND dsys.event = 'log file sync') totals
--GROUP BY totals.instance_number, totals.event
ORDER BY SUM (totals.tot_waits) DESC
;

--
-- Get SYSTEM_EVENT stats
alter session set NLS_NUMERIC_CHARACTERS = ',.';
       
SELECT snap_time,snap_time_frmt, event, tot_waits, tot_time/1000000 seconds_waited, (tot_time/1000)/nullif(tot_waits,0) elapsed_ms_avg
FROM (
SELECT dhs.instance_number,
                 dhs.snap_time,
                 to_char(dhs.snap_time,'yyyymmddhh24mmss') snap_time_frmt,
                 dsys.event,
                 NVL (
                     DECODE (
                         GREATEST (
                             TOTAL_WAITS,
                             NVL (
                                 LAG (TOTAL_WAITS)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TOTAL_WAITS,   TOTAL_WAITS
                                      - LAG (TOTAL_WAITS)
                                            OVER (
                                                PARTITION BY dsys.dbid,
                                                             dsys.instance_number,
                                                             dsys.event
                                                ORDER BY dhs.snap_id),
                         TOTAL_WAITS),
                     0)
                     tot_waits,
                 NVL (
                     DECODE (
                         GREATEST (
                             TIME_WAITED_MICRO,
                             NVL (
                                 LAG (TIME_WAITED_MICRO)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.instance_number,
                                                      dsys.event
                                         ORDER BY dhs.snap_id),
                                 0)),
                         TIME_WAITED_MICRO,   TIME_WAITED_MICRO
                                            - LAG (TIME_WAITED_MICRO)
                                                  OVER (
                                                      PARTITION BY dsys.dbid,
                                                                   dsys.instance_number,
                                                                   dsys.event
                                                      ORDER BY dhs.snap_id),
                         TIME_WAITED_MICRO),
                     0)
                     tot_time
            FROM STATS$SYSTEM_EVENT dsys, stats$snapshot dhs
           WHERE     dsys.instancE_number = dhs.instance_number
                 AND dhs.snap_id = dsys.snap_id
                 AND dhs.snap_time >= SYSDATE - 360
                 AND dsys.event = 'log file sync'
) ORDER BY snap_time ASC;


--
-- Get perfstat.stats$system_statisics





SELECT dhs.snap_time,
                 to_char(dhs.snap_time,'yyyymmddhh24miss') snap_time_frmt,
                 dsys.name,
                 DECODE (
                         GREATEST (
                             dhs.snap_time,
                                 LAG (dhs.snap_time)
                                     OVER (
                                         PARTITION BY dhs.snap_id
                                         ORDER BY dhs.snap_id)),
                         dhs.snap_time,   dhs.snap_time
                                            - LAG (dhs.snap_time)
                                                  OVER (
                                                      PARTITION BY dhs.snap_id
                                                      ORDER BY dhs.snap_id),
                         dhs.snap_time)
                     minutes,
                                      NVL (
                     DECODE (
                         GREATEST (
                             value,
                             NVL (
                                 LAG (value)
                                     OVER (
                                         PARTITION BY dsys.dbid,
                                                      dsys.name
                                         ORDER BY dhs.snap_id),
                                 0)),
                         value,   value
                                            - LAG (value)
                                                  OVER (
                                                      PARTITION BY dsys.dbid,
                                                                   dsys.name
                                                      ORDER BY dhs.snap_id),
                         value),
                     0)
                     total
            FROM STATS$SYSSTAT dsys, stats$snapshot dhs
           WHERE     dhs.snap_id = dsys.snap_id
                 AND dhs.snap_time >= SYSDATE - 7
                 AND dsys.name = 'consistent gets'
ORDER BY snap_time ASC;

SELECT distinct name FROM STATS$SYSSTAT ORDER BY 1;


SELECT --u1.product,
       u1.name,
       u1.detected_usages,
       u1.currently_used,
       u1.version;


SELECT * FROM (       
SELECT u1.name,
      case when u1.name = 'Active Data Guard - Real-Time Query on Physical Standby' then 'Active Data Guard' 
           when u1.name = 'Data Mining' then 'Advanced Analytics' 
           when u1.name LIKE 'Backup % Compression' then 'Advanced Compression' 
           when u1.name = 'HeapCompression' then 'Advanced Compression' 
           when u1.name = 'SecureFile Compression (user)' then 'Advanced Compression' 
           when u1.name = 'SecureFile Deduplication (user)  ' then 'Advanced Compression' 
           when u1.name = 'Backup Encryption' then 'Advanced Security' 
           when u1.name = 'Encrypted Tablespaces  ' then 'Advanced Security' 
           when u1.name = 'SecureFile Encryption (user) ' then 'Advanced Security' 
           when u1.name = 'Transparent Data Encryption  ' then 'Advanced Security' 
           when u1.name = 'Oracle Database Vault  ' then 'Database Vault  ' 
           when u1.name = 'ADDM' then 'Diagnostics Pack' 
           when u1.name = 'AWR Baseline' then 'Diagnostics Pack' 
           when u1.name = 'AWR Baseline Template ' then 'Diagnostics Pack' 
           when u1.name = 'AWR Report' then 'Diagnostics Pack' 
           when u1.name = 'Baseline Adaptive Thresholds' then 'Diagnostics Pack' 
           when u1.name = 'Label Security' then 'Label Security' 
           when u1.name = 'OLAP - Analytic Workspaces' then 'OLAP' 
           when u1.name = 'OLAP - Cubes' then 'OLAP' 
           when u1.name = 'Partitioning (user)' then 'Partitioning' 
           when u1.name = 'Real Application Clusters (RAC)' then 'Real Application Clusters' 
           when u1.name = 'Database Replay: Workload Capture' then 'Real Application Testing' 
           when u1.name = 'Database Replay: Workload Replay  ' then 'Real Application Testing' 
           when u1.name = 'SQL Performance Analyzer ' then 'Real Application Testing' 
           when u1.name = 'Real-Time SQL Monitoring' then 'Tuning Pack' 
           when u1.name = 'SQL Access Advisor ' then 'Tuning Pack' 
           when u1.name = 'SQL Profile' then 'Tuning Pack' 
           when u1.name = 'SQL Tuning Advisor' then 'Tuning Pack' 
           when u1.name = 'Exadata' then 'Exadata' 
           when u1.name = 'Hybrid Columnar Compression' then 'Exadata' 
           when u1.name = 'Hybrid Columnar Compression Row Level Locking' then 'Exadata' 
           when u1.name = 'In-Memory Aggregation' then 'In-Memory Database' 
           when u1.name = 'In-Memory Column Store' then 'In-Memory Database' 
           when u1.name = 'Oracle Pluggable Databases' then 'Oracle Pluggable Databases' 
           when u1.name = 'Real Application Cluster One Node' then 'Real Application Cluster One Node' 
           when u1.name = 'Real Application Security' then 'Real Application Security' 
           when u1.name = 'SQL Tuning Set (user)' then 'Tuning Pack' 
           when u1.name = 'SQL Repair Advisor' then 'Tuning Pack' 
           when u1.name = 'SecureFile Deduplication (user)' then 'Advanced Compression' 
           when u1.name = 'SecureFile Encryption (user)' then 'Advanced Security' 
           when u1.name = 'Spatial' then 'Spatial' 
           when u1.name = 'Transparent Data Encryption' then 'Advanced Security' 
           when u1.name = 'Transparent Sensitive Data Protection' then 'Advanced Security (Data Redaction)' 
           when u1.name = 'Virtual Private Database (VPD)' then 'Virtual Private Database (VPD)' 
           when u1.name = 'AWR Baseline' then 'Diagnostics Pack' 
           when u1.name = 'AWR Baseline Template' then 'Diagnostics Pack' 
           when u1.name = 'Automatic Maintenance - SQL Tuning Advisor' then 'Tunning Pack' 
           when u1.name = 'Advanced Index Compression' then 'Advanced Compression' 
           when u1.name = 'Advanced Replication' then 'Advanced Replication' 
           when u1.name = 'Automatic SQL Tuning Advisor' then 'Tunning Pack' 
           when u1.name = 'Baseline Static Computations' then 'Diagnostics Pack' 
           when u1.name = '' then '' 
           when u1.name = '' then '' 
           when u1.name = '' then '' 
           else 'UNKNOWN' 
      end product,       
       u1.detected_usages,
       u1.currently_used,
       u1.version       
FROM   dba_feature_usage_statistics u1
WHERE  u1.version = (SELECT MAX(u2.version)
                     FROM   dba_feature_usage_statistics u2
                     WHERE  u2.name = u1.name)
--AND    product IS NOT NULL
AND    u1.dbid = (SELECT dbid FROM v$database)
ORDER BY name)
WHERE product != 'UNKNOWN';



set lines 220
set pages 1000
col cf for 9,999
col df for 9,999
col elapsed_seconds heading "ELAPSED|SECONDS"
col i0 for 9,999
col i1 for 9,999
col l for 9,999
col output_mbytes for 9,999,999 heading "OUTPUT|MBYTES"
col session_recid for 999999 heading "SESSION|RECID"
col session_stamp for 99999999999 heading "SESSION|STAMP"
col status for a10 trunc
col time_taken_display for a10 heading "TIME|TAKEN"
col output_instance for 9999 heading "OUT|INST"
select
  j.session_recid, j.session_stamp,
  to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
  to_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
  (j.output_bytes/1024/1024) output_mbytes, j.status, j.input_type,
  decode(to_char(j.start_time, 'd'), 1, 'Sunday', 2, 'Monday',
                                     3, 'Tuesday', 4, 'Wednesday',
                                     5, 'Thursday', 6, 'Friday',
                                     7, 'Saturday') dow,
  j.elapsed_seconds, j.time_taken_display,
  x.cf, x.df, x.i0, x.i1, x.l,
  ro.inst_id output_instance
from V$RMAN_BACKUP_JOB_DETAILS j
  left outer join (select
                     d.session_recid, d.session_stamp,
                     sum(case when d.controlfile_included = 'YES' then d.pieces else 0 end) CF,
                     sum(case when d.controlfile_included = 'NO'
                               and d.backup_type||d.incremental_level = 'D' then d.pieces else 0 end) DF,
                     sum(case when d.backup_type||d.incremental_level = 'D0' then d.pieces else 0 end) I0,
                     sum(case when d.backup_type||d.incremental_level = 'I1' then d.pieces else 0 end) I1,
                     sum(case when d.backup_type = 'L' then d.pieces else 0 end) L
                   from
                     V$BACKUP_SET_DETAILS d
                     join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
                   where s.input_file_scan_only = 'NO'
                   group by d.session_recid, d.session_stamp) x
    on x.session_recid = j.session_recid and x.session_stamp = j.session_stamp
  left outer join (select o.session_recid, o.session_stamp, min(inst_id) inst_id
                   from GV$RMAN_OUTPUT o
                   group by o.session_recid, o.session_stamp)
    ro on ro.session_recid = j.session_recid and ro.session_stamp = j.session_stamp
where j.start_time > trunc(sysdate)-60
order by j.start_time;

SELECT status, filename FROM V$BLOCK_CHANGE_TRACKING;

select owner, object_name, object_type, statistic_name, value
  from dba_objects,
       (select statistic_name, value, obj#
        from (select a.*, max(value) over (partition by statistic_name) mv
                  from v$segstat a
                 where statistic_name in ( 'logical reads',
                                           'physical reads',
                                           'physical writes',
                                           'physical reads direct',
                                           'physical writes direct' )
               )
         where value = mv
           and mv <> 0) b
  where dba_objects.object_id = b.obj#;
  
  
  select * from BOS.ACT_RU_VARIABLE      where EXECUTION_ID_ = :1  and
 NAME_= :2  and TASK_ID_ is null