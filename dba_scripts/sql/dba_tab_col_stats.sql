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
PROMPT | Report   : List table column statistics                                |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

PROMPT 
ACCEPT owner CHAR PROMPT 'Enter table owner : '
ACCEPT table_name CHAR PROMPT 'Enter table name  : '

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    250
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN owner            FORMAT a10              HEADING "Owner"
COLUMN table_name       FORMAT a10              HEADING "Table"
COLUMN column_name    FORMAT a20              HEADING "Column Name"
COLUMN data_type    FORMAT a12              HEADING "Data type"
COLUMN histogram  FORMAT a15              HEADING "Histogram"
COLUMN num_buckets  FORMAT 9999999              HEADING "Buckets"
COLUMN num_distinct  FORMAT 99999999              HEADING "Distinct"
COLUMN num_distinct  FORMAT 99999999              HEADING "Sample"


COLUMN index_name  FORMAT a16              HEADING "Index Name"



SELECT distinct 
    tc.owner
  , tc.table_name
  , tc.column_name
  , tc.column_id AS COL_ID
  , tc.data_type
  , tc.histogram  
  , TC.NUM_BUCKETS
  , tc.num_distinct
--  , t.num_rows
  , tc.sample_size TAB_SAMPLE_SIZE
  , (round(tc.sample_size/t.num_rows,4))*100 TAB_Sample_pct
  , tc.last_analyzed AS TAB_LAST_ANALYZE
  , ic.index_name
  , ic.column_position IND_COL_POS
  , i.last_analyzed AS IND_LAST_ANALYZE
  , i.sample_size IND_SAMPLE_SIE
  , (round(i.sample_size/i.num_rows,4))*100 IND_Sample_pct
FROM dba_ind_columns ic, dba_tab_columns tc, dba_indexes i, dba_tables t
WHERE tc.owner = UPPER('&owner')
AND ic.index_owner(+) =  tc.owner
AND tc.table_name = UPPER('&table_name') 
AND tc.table_name = ic.table_name(+)
AND tc.column_name = ic.column_name(+)
AND IC.INDEX_OWNER = I.OWNER(+)
AND IC.INDEX_NAME = i.index_name(+)
AND TC.OWNER = t.owner
AND tc.table_name = t.table_name
ORDER BY 
    tc.owner
  , tc.table_name
  , tc.column_id
/

