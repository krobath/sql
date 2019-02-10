--   login.sql
--   SQL*Plus user login startup file.
--
--   This script is automatically run after glogin.sql
--
-- To change the SQL*Plus prompt to display the current user,
-- connection identifier and current time.

--
-- Set the database date format to show the time.
--
ALTER SESSION SET nls_date_format = 'dd/mm/yyyy HH:MI:SS';

--
-- Adjust layout
--
set lines 200


--
-- Set the SQLPLUS prompt to reflect name of user and database
--
COLUMN global_name new_value gname
SET TERMOUT OFF
SELECT LOWER(USER) || '@' || global_name||CHR(10)||'SQL> ' AS global_name
FROM   global_name;
SET SQLPROMPT '&gname'
SET TERMOUT ON



var sid number
var serial# number
var tracefile VARCHAR2(200)

DECLARE
    v_audsid v$session.audsid%TYPE;
BEGIN
    SELECT sid, serial#, audsid
    INTO   :sid, :serial#, v_audsid
    FROM   v$session
    WHERE  audsid = SYS_CONTEXT('USERENV','SESSIONID');

    SELECT par.value ||
           CASE WHEN par.value LIKE '%/%' THEN '/' ELSE '\' END ||
           LOWER(th.instance) ||
           '_ora_' || LTRIM(TO_CHAR(pro.spid,'fm99999')) || '.trc' AS filename
    INTO   :tracefile
    FROM   v$process   pro
         , v$session   se
         , v$parameter par
         , v$thread    th
    WHERE  se.audsid = v_audsid
    AND    pro.addr = se.paddr
    AND    par.NAME = 'user_dump_dest';
END;
/

BEGIN
    IF :sid IS NULL THEN
    	SELECT sid
    	INTO   :sid
    	FROM   v$mystat
    	WHERE  rownum = 1;
    END IF;
END;
/

set termout on
set feedback off
exec DBMS_OUTPUT.PUT_LINE('Sessie: ' || :sid || CASE WHEN :serial# IS NULL THEN ' (no access to V$ tables)' ELSE ',' || :serial# END)
exec IF :tracefile IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE('Eventueel trace-bestand: ' || :tracefile); END IF
prompt
set feedback on