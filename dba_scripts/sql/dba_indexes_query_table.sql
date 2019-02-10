-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : dba_tables_query_user.sql                                       |
-- | CLASS    : Database Administration                                         |
-- | PURPOSE  : Prompt the user for a schema and then query all tables within   |
-- |            that schema.                                                    |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Query Tables for Specified Schema                           |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

PROMPT 
ACCEPT table_owner CHAR PROMPT 'Enter table owner : '
ACCEPT table_name CHAR PROMPT 'Enter table name  : '

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

COLUMN index_owner            FORMAT a16              HEADING "Index Owner"
COLUMN table_owner            FORMAT a16              HEADING "Table Owner"
COLUMN table_name       FORMAT a16              HEADING "Table Name"
COLUMN index_name  FORMAT a16              HEADING "Index Name"
COLUMN column_name    FORMAT a24              HEADING "Column Name"
COLUMN data_type    FORMAT a16              HEADING "Data type"

SELECT distinct 
    ic.index_owner
  , ic.index_name
  , ic.table_owner
  , ic.table_name
  , ic.column_name
  , tc.data_type
  , ic.column_position 
FROM dba_ind_columns ic, dba_tab_columns tc
WHERE ic.table_owner = UPPER('&table_owner') 
AND ic.table_name = UPPER('&table_name') 
AND ic.table_name = tc.table_name
AND ic.column_name = tc.column_name
ORDER BY 
    ic.index_owner
  , ic.index_name
  , ic.column_position
/

