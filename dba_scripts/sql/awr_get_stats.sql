set pages 0 heading off lines 512 trims on long 999999
alter session set NLS_NUMERIC_CHARACTERS=',.';
alter session set nls_language=american;
with snapshot as 
(select dbid
,lag(dbid) over (order by dbid,instance_number,begin_interval_time) l_dbid
,instance_number
,lag(instance_number) over (order by dbid,instance_number,begin_interval_time) l_instance_number
,snap_id
,lag(snap_id) over (order by dbid,instance_number,begin_interval_time) l_snap_id
,begin_interval_time
,lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time) l_begin_interval_time
,startup_time
,lag(startup_time) over (order by dbid,instance_number,begin_interval_time) l_startup_time
,extract(second from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time)) 
+(extract(minute from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time))*60) 
+(extract(hour from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time))*24*60) elaps
from (select s.instance_number
,s.snap_id
,s.dbid
,s.begin_interval_time
,to_char(s.begin_interval_time,'dy')
,s.startup_time
from dba_hist_snapshot s
where s.begin_interval_time>sysdate-2
and (to_char(s.begin_interval_time,'mi')>55 or to_char(s.begin_interval_time,'mi')<05)
order by dbid,instance_number,begin_interval_time))
select 'inst;dbid;Snap Time;elaps;db time;Cpu time;seqread;scaread;enqueue;logsync;bufferbusy;sbtwrite;Ctl file;Latch Free;msgdblink;other;cpuusage;cpuparse;cpurecusive;crget;cuget;dirtybufinsp;blockchange;physread;logins;commits;rollbacks;parsecalls;execs;ucalls;roundtripclient;roundtripdblink;redowritetime;redowrites;sortdisk;sortmem;osusertime;ossystime;iowaittime;pxdowngrade;pxnodowngrade;latchnw;latchw;db time;Cpu Time;Java Time;PlSql time;parse time,Avg read,Avg Write,Backup,Flashback write,Archive write'
from dual
union all
select instance_number||';'||dbid||';'||to_char(begin_interval_time,'yyyy-mm-dd hh24:mi:ss')
||';'||trunc(elaps)
||';'||trunc(db_time/elaps/1000,2)
||';'||trunc(cpu_time/elaps/1000,2)
||';'||trunc(seqread/elaps/1000,2)
||';'||trunc(scaread/elaps/1000,2)
||';'||trunc(enqueue/elaps/1000,2)
||';'||trunc(logsync/elaps/1000,2)
||';'||trunc(bufferbusy/elaps/1000,2)
||';'||trunc(sbtwrite/elaps/1000,2)
||';'||trunc(ctlfile/elaps/1000,2)
||';'||trunc(latchfree/elaps/1000,2)
||';'||trunc(msgdblink/elaps/1000,2)
||';'||trunc(other /elaps/1000,2)
||';'||trunc(cpuusage/elaps,2)
||';'||trunc(cpuparse/elaps,2)
||';'||trunc(cpurecusive/elaps,2)
||';'||trunc(crget/elaps,2)
||';'||trunc(cuget/elaps,2)
||';'||trunc(dirtybufinsp/elaps,2)
||';'||trunc(blockchange/elaps,2)
||';'||trunc(physread/elaps,2)
||';'||trunc(logins/elaps,2)
||';'||trunc(commits/elaps,2)
||';'||trunc(rollbacks/elaps,2)
||';'||trunc(parsecalls/elaps,2)
||';'||trunc(execs/elaps,2)
||';'||trunc(ucalls/elaps,2)
||';'||trunc(roundtripclient/elaps,2)
||';'||trunc(roundtripdblink/elaps,2)
||';'||trunc(redowritetime/elaps,2)
||';'||trunc(redowrites/elaps,2)
||';'||trunc(sortdisk/elaps,2)
||';'||trunc(sortmem/elaps,2)
||';'||trunc(osusertime/elaps,2)
||';'||trunc(ossystime/elaps,2)
||';'||trunc(iowaittime/elaps,2)
||';'||trunc(pxdowngrade/elaps,2)
||';'||trunc(pxnodowngrade/elaps,2)
||';'||trunc(latchnw/elaps,2)
||';'||trunc(latchw/elaps,2)
||';'||trunc(db_time/elaps/1000,2)
||';'||trunc(cpu_time/elaps/1000,2)
||';'||trunc(java_time/elaps/1000,2)
||';'||trunc(plsql_time/elaps/1000,2)
||';'||trunc(parse_time/elaps/1000,2)
||';'||trunc(db_read,2)
||';'||trunc(db_write,2)
||';'||trunc(db_backup,2)
||';'||trunc(fb_write,2)
||';'||trunc(arc_write,2)
from
(select dbid
,lag(dbid) over (order by dbid,instance_number,begin_interval_time) l_dbid
,instance_number
,lag(instance_number) over (order by dbid,instance_number,begin_interval_time) l_instance_number
,begin_interval_time
,lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time) l_begin_interval_time
,startup_time
,lag(startup_time) over (order by dbid,instance_number,begin_interval_time) l_startup_time
,seqread-lag(seqread) over(order by dbid,instance_number,begin_interval_time) seqread
,scaread-lag(scaread) over(order by dbid,instance_number,begin_interval_time) scaread
,enqueue-lag(enqueue) over (order by dbid,instance_number,begin_interval_time) enqueue
,logsync-lag(logsync) over (order by dbid,instance_number,begin_interval_time) logsync
,bufferbusy-lag(bufferbusy) over (order by dbid,instance_number,begin_interval_time) bufferbusy
,sbtwrite-lag(sbtwrite) over (order by dbid,instance_number,begin_interval_time) sbtwrite
,ctlfile-lag(ctlfile) over (order by dbid,instance_number,begin_interval_time) ctlfile
,latchfree-lag(latchfree) over (order by dbid,instance_number,begin_interval_time) latchfree
,msgdblink-lag(msgdblink) over (order by dbid,instance_number,begin_interval_time) msgdblink
,other-lag(other ) over (order by dbid,instance_number,begin_interval_time) other
,cpuusage-lag(cpuusage) over (order by dbid,instance_number,begin_interval_time) cpuusage
,cpuparse-lag(cpuparse) over (order by dbid,instance_number,begin_interval_time) cpuparse
,cpurecusive-lag(cpurecusive) over (order by dbid,instance_number,begin_interval_time) cpurecusive
,crget-lag(crget) over (order by dbid,instance_number,begin_interval_time) crget
,cuget-lag(cuget) over (order by dbid,instance_number,begin_interval_time) cuget
,dirtybufinsp-lag(dirtybufinsp) over (order by dbid,instance_number,begin_interval_time) dirtybufinsp
,blockchange-lag(blockchange) over (order by dbid,instance_number,begin_interval_time) blockchange
,physread-lag(physread) over (order by dbid,instance_number,begin_interval_time) physread
,logins-lag(logins) over (order by dbid,instance_number,begin_interval_time) logins
,commits-lag(commits) over (order by dbid,instance_number,begin_interval_time) commits
,rollbacks-lag(rollbacks) over (order by dbid,instance_number,begin_interval_time) rollbacks
,parsecalls-lag(parsecalls) over (order by dbid,instance_number,begin_interval_time) parsecalls
,execs-lag(execs) over (order by dbid,instance_number,begin_interval_time) execs
,ucalls-lag(ucalls) over (order by dbid,instance_number,begin_interval_time) ucalls
,roundtripclient-lag(roundtripclient) over (order by dbid,instance_number,begin_interval_time) roundtripclient
,roundtripdblink-lag(roundtripdblink) over (order by dbid,instance_number,begin_interval_time) roundtripdblink
,redowritetime-lag(redowritetime) over (order by dbid,instance_number,begin_interval_time) redowritetime
,redowrites-lag(redowrites) over (order by dbid,instance_number,begin_interval_time) redowrites
,sortdisk-lag(sortdisk) over (order by dbid,instance_number,begin_interval_time) sortdisk
,sortmem-lag(sortmem) over (order by dbid,instance_number,begin_interval_time) sortmem
,osusertime-lag(osusertime) over (order by dbid,instance_number,begin_interval_time) osusertime
,ossystime-lag(ossystime) over (order by dbid,instance_number,begin_interval_time) ossystime
,iowaittime-lag(iowaittime) over (order by dbid,instance_number,begin_interval_time) iowaittime
,pxdowngrade-lag(pxdowngrade) over (order by dbid,instance_number,begin_interval_time) pxdowngrade
,pxnodowngrade-lag(pxnodowngrade) over (order by dbid,instance_number,begin_interval_time) pxnodowngrade
,latchnw-lag(latchnw) over (order by dbid,instance_number,begin_interval_time) latchnw
,latchw-lag(latchw) over (order by dbid,instance_number,begin_interval_time) latchw
,db_time-lag(db_time) over (order by dbid,instance_number,begin_interval_time) db_time
,cpu_time-lag(cpu_time) over (order by dbid,instance_number,begin_interval_time) cpu_time
,java_time-lag(java_time) over (order by dbid,instance_number,begin_interval_time) java_time
,plsql_time-lag(plsql_time) over (order by dbid,instance_number,begin_interval_time) plsql_time
,parse_time-lag(parse_time) over (order by dbid,instance_number,begin_interval_time) parse_time
,db_read
,db_write
,db_backup
,fb_write
,arc_write
,extract(second from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time)) 
+(extract(minute from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time))*60) 
+(extract(hour from begin_interval_time-lag(begin_interval_time) over (order by dbid,instance_number,begin_interval_time))*60*60) elaps
from
(select stats.instance_number
,stats.snap_id
,stats.dbid
,stats.begin_interval_time
,stats.startup_time
,seqread
,scaread
,enqueue
,logsync
,bufferbusy
,sbtwrite
,ctlfile
,latchfree
,msgdblink
,other
,cpuusage
,cpuparse
,cpurecusive
,crget
,cuget
,dirtybufinsp
,blockchange
,physread
,logins
,commits
,rollbacks
,parsecalls
,execs
,ucalls
,roundtripclient
,roundtripdblink
,redowritetime
,redowrites
,sortdisk
,sortmem
,osusertime
,ossystime
,iowaittime
,pxdowngrade
,pxnodowngrade
,latchnw
,latchw
,db_time
,cpu_time
,java_time
,plsql_time
,parse_time
,db_read
,db_write
,db_backup
,fb_write
,arc_write
from (select s.instance_number
,s.snap_id
,s.dbid
,s.begin_interval_time
,s.startup_time
,sum(decode(e.event_name,'db file sequential read',e.time_waited_micro,0)) seqread
,sum(decode(e.event_name,'db file scattered read',e.time_waited_micro,0)) scaread
,sum(decode(e.event_name,'enq: TX - contention',e.time_waited_micro
,'enq: TX - row lock contention',e.time_waited_micro
,'enq: TX - allocate ITL entry',e.time_waited_micro
,'enq: TX - index contention',e.time_waited_micro
,'enqueue',e.time_waited_micro,0)) enqueue
,sum(decode(e.event_name,'log file sync',e.time_waited_micro,0)) logsync
,sum(decode(e.event_name,'buffer busy waits',e.time_waited_micro,0)) bufferbusy
,sum(decode(e.event_name,'Backup: sbtwrite2',e.time_waited_micro,'sbtwrite2',e.time_waited_micro,0)) sbtwrite
,sum(decode(e.event_name,'control file sequential read',e.time_waited_micro,0)) ctlfile
,sum(decode(e.event_name,'latch free',e.time_waited_micro,0)) latchfree
,sum(decode(e.event_name,'SQL*Net message from dblink',e.time_waited_micro,0)) msgdblink
,sum(case when e.event_name in ('log file sync','db file sequential read','db file scattered read'
,'enq: TX - contention','enq: TX - row lock contention','enq: TX - allocate ITL entry','enq: TX - index contention'
,'buffer busy waits','sbtwrite2','Backup: sbtwrite2','control file sequential read','latch free','SQL*Net message from dblink') then 0 else e.time_waited_micro end) other
from snapshot s
,dba_hist_system_event e
where s.snap_id=e.snap_id
and s.instance_number=e.instance_number
and s.dbid=e.dbid
and e.wait_class not in ('Idle')
and s.instance_number  in (1,2)
group by s.instance_number,s.snap_id,s.dbid,s.begin_interval_time,s.startup_time) stats
,(select s.instance_number
,s.snap_id
,s.dbid
,s.begin_interval_time
,s.startup_time
,sum(decode(ss.stat_name,'CPU used by this session',ss.value*10000,0)) cpuusage
,sum(decode(ss.stat_name,'parse time cpu',ss.value*10000,0)) cpuparse
,sum(decode(ss.stat_name,'recursive cpu usage',ss.value*10000,0)) cpurecusive
,sum(decode(ss.stat_name,'consistent gets',ss.value,0)) crget
,sum(decode(ss.stat_name,'db block gets',ss.value,0)) cuget
,sum(decode(ss.stat_name,'dirty buffers inspected',ss.value,0)) dirtybufinsp
,sum(decode(ss.stat_name,'db block changes',ss.value,0)) blockchange
,sum(decode(ss.stat_name,'physical reads',ss.value,0)) physread
,sum(decode(ss.stat_name,'global cache gets',ss.value,0)) gbget
,sum(decode(ss.stat_name,'logons cumulative',ss.value,0)) logins
,sum(decode(ss.stat_name,'user commits',ss.value,0)) commits
,sum(decode(ss.stat_name,'user rollbacks',ss.value,0)) rollbacks
,sum(decode(ss.stat_name,'parse count (total)',ss.value,0)) parsecalls
,sum(decode(ss.stat_name,'execute count',ss.value,0)) execs
,sum(decode(ss.stat_name,'user calls',ss.value,0)) ucalls
,sum(decode(ss.stat_name,'SQL*Net roundtrips to/from client',ss.value,0)) roundtripclient
,sum(decode(ss.stat_name,'SQL*Net roundtrips to/from dblink',ss.value,0)) roundtripdblink
,sum(decode(ss.stat_name,'redo write time',ss.value,0)) redowritetime
,sum(decode(ss.stat_name,'redo writes',ss.value,0)) redowrites
,sum(decode(ss.stat_name,'sorts (disk)',ss.value,0)) sortdisk
,sum(decode(ss.stat_name,'sorts (memory)',ss.value,0)) sortmem
,sum(decode(ss.stat_name,'OS User time used',ss.value*10000,0)) osusertime
,sum(decode(ss.stat_name,'OS System time used',ss.value*10000,0)) ossystime
,sum(decode(ss.stat_name,'user I/O wait time',ss.value*10000,0)) iowaittime
,sum(decode(ss.stat_name,'Parallel operations downgraded 1',ss.value,'Parallel operations downgraded 25',ss.value,'Parallel operations downgraded 50',ss.value,'Parallel operations downgraded to',ss.value,0)) pxdowngrade
,sum(decode(ss.stat_name,'Parallel operations not downgrade',ss.value,0)) pxnodowngrade
,sum(decode(ss.stat_name,'shared hash latch upgrades - no wait',ss.value,0)) latchnw
,sum(decode(ss.stat_name,'shared hash latch upgrades - wait',ss.value,0)) latchw
from snapshot s
,dba_hist_sysstat ss
where s.snap_id=ss.snap_id
and s.instance_number=ss.instance_number
and s.dbid=ss.dbid
group by s.instance_number,s.snap_id,s.dbid,s.begin_interval_time,s.startup_time) events
,(select s.SNAP_ID,s.DBID,s.INSTANCE_NUMBER,s.begin_interval_time,s.startup_time
,sum(decode(STAT_NAME,'DB CPU',value)) cpu_time
,sum(decode(STAT_NAME,'DB time',value)) db_time
,sum(decode(STAT_NAME,'Java execution elapsed time',value)) java_time
,sum(decode(STAT_NAME,'PL/SQL execution elapsed time',value)) plsql_time
,sum(decode(STAT_NAME,'parse time elapsed',value)) parse_time
from DBA_HIST_SYS_TIME_MODEL tm
,snapshot s
where s.snap_id=tm.snap_id
and s.instance_number=tm.instance_number
and s.dbid=tm.dbid
group by s.instance_number,s.snap_id,s.dbid,s.begin_interval_time,s.startup_time) time_model
,(select s.SNAP_ID,s.DBID,s.INSTANCE_NUMBER,s.begin_interval_time,s.startup_time
,sum(case when FUNCTION_NAME='Buffer Cache Reads' and FILETYPE_NAME='Data File' and NUMBER_OF_WAITS<>0
  then WAIT_TIME/NUMBER_OF_WAITS else 0 end) db_read
,sum(case when FUNCTION_NAME='DBWR' and FILETYPE_NAME='Data File' and NUMBER_OF_WAITS<>0
  then WAIT_TIME/NUMBER_OF_WAITS else 0 end) db_write
,sum(case when FUNCTION_NAME='RMAN' and FILETYPE_NAME='Data File' and NUMBER_OF_WAITS<>0
  then WAIT_TIME/NUMBER_OF_WAITS else 0 end) db_backup
,sum(case when FUNCTION_NAME='Others' and FILETYPE_NAME='Flashback Log' and NUMBER_OF_WAITS<>0 
  then WAIT_TIME/NUMBER_OF_WAITS else 0 end) fb_write
,sum(case when FUNCTION_NAME='Others' and FILETYPE_NAME='Archive Log' and NUMBER_OF_WAITS<>0
  then WAIT_TIME/NUMBER_OF_WAITS else 0 end) arc_write
from DBA_HIST_IOSTAT_DETAIL ios
,snapshot s
where s.snap_id=ios.snap_id
and s.instance_number=ios.instance_number
and s.dbid=ios.dbid
group by s.instance_number,s.snap_id,s.dbid,s.begin_interval_time,s.startup_time) ios
where stats.snap_id=events.snap_id
and stats.instance_number=events.instance_number
and stats.dbid=events.dbid
and stats.snap_id=time_model.snap_id
and stats.instance_number=time_model.instance_number
and stats.dbid=time_model.dbid
and stats.snap_id=ios.snap_id
and stats.instance_number=ios.instance_number
and stats.dbid=ios.dbid)
order by dbid,instance_number,begin_interval_time)
where dbid=l_dbid
and instance_number=l_instance_number
and startup_time=l_startup_time
/
