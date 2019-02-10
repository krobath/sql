set lines 120
col sid for 99999
col serial# for 9999999
col username for a16
col status for a12
col name for a20
col sql_text for a20
SELECT s.sid, 
       s.serial#, 
       u.username,
	   r.status, 
	   r.start_time, 
	   r.suspend_time, 
	   r.resume_time,
       r.name,
	   r.sql_text,
	   r.error_number,
	   r.error_msg
FROM v$session s, dba_users u, dba_resumable r
WHERE r.session_id = s.sid
AND r.user_id = u.user_id;