

PROMPT Top database waits...


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



select * from (
select  event, total_waits, total_timeouts, time_waited
from v$system_event
where event not like 'SQL*Net%'
and event not in ('pmon timer','rdbms ipc message','dispatcher timer','smon timer')
and upper(event) not like '%IDLE%'
order by time_waited desc )
where rownum < 6
/