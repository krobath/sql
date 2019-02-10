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
SELECT 'Connected to: ' || UPPER(USER) || ' @ ' || global_name||CHR(10)||'SQL> ' AS global_name
FROM   global_name;
SET SQLPROMPT '&gname'
SET TERMOUT ON



@db_info.sql
