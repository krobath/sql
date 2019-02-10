-- +----------------------------------------------------------------------------+
-- |                         Henrik  Krobath                                    |
-- |                        henrik@krobath.dk                                   |
-- |                         www.krobath.dk                                     |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 2013 Henrik Krobath. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sql_top40_10g.sql                                               |
-- | CLASS    : SQL Management                                                  |
-- | PURPOSE  : Displays the top 40 SQL statements on the database.             |
-- | NOTE     : This is for 10g and newer.                                      |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : SQL Query Search Interface                                  |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

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


PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Get SQL by Session ID                                             |
PROMPT +------------------------------------------------------------------------+

SELECT /*+ ORDERED */
        DISTINCT sql.sql_text,
                 RAWTOHEX (sql.address),
                 sql.hash_value,
                 0 piece,
                 sql.sql_id,
                 sql.child_number
    FROM v$session s, v$sql sql
   WHERE     sid = &&sid
         AND sql.address = s.sql_address
         AND sql.hash_value = s.sql_hash_value
         AND sql.child_number = s.sql_child_number
ORDER BY address, piece
/


REM +----------------------------------------------------+
REM | PROMPT USER FOR sql_id and child number.           |
REM +----------------------------------------------------+

PROMPT 
ACCEPT sql_id CHAR PROMPT 'Enter Oracle SQL id: '

PROMPT 
ACCEPT child CHAR PROMPT 'Enter Oracle SQL child number: '

COLUMN sql_text FORMAT a80

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('&&sql_id', &&child))
/
