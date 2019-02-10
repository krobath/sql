--
-- Get Latch wait locations
--
SELECT sid, p1raw,p2, p3 seconds_in_wait, wait_time, state
FROM v$session_wait
WHERE event = 'latch free'
ORDER BY p2, p1raw;


--
-- Get object waited for using P1RAW from previous query
--

SELECT a.hladdr, a.file#, a.dbablk, a.tch, a.obj, b.object_name
FROM sys.x$bh a, dba_objects b
WHERE (a.obj = b.object_id OR a.obj = b.data_object_id)
AND a.hladdr = '<P1RAW>'
UNION
SELECT h1addr, file#, dbablk, tch, obj, null
FROM x$bh
WHERE obj in (SELECT obj FROM x$bh WHERE h1addr = '<P1ADDR>'
              MINUS 
              SELECT object_id FROM dba_objects
              MINUS
              SELECT data_object_id FROM dba_objects)
AND h1addr = '<P1ADDR>'
ORDER BY 4;