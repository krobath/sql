-- +----------------------------------------------------------------------------+
-- |                         Henrik  Krobath                                    |
-- |                        henrik@krobath.dk                                   |
-- |                         www.krobath.dk                                     |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 2013 Henrik Krobath. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : locks1.sql                                               |
-- | CLASS    : SQL Management                                                  |
-- | PURPOSE  : Displays objects locked for more than 60 seconds.             |
-- | NOTE     : This is for 10g and newer.                                      |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Show relevant NLS settings                                  |
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

 
PROMPT +------------------------------------------------------------------------+
PROMPT | NLS_SESSION_PARAMETERS		                                        |
PROMPT +------------------------------------------------------------------------+

SELECT * FROM nls_session_parameters
/

PROMPT +------------------------------------------------------------------------+
PROMPT | NLS_INSTANCE_PARAMETERS		                                        |
PROMPT +------------------------------------------------------------------------+

SELECT * FROM nls_instance_parameters
/

PROMPT +------------------------------------------------------------------------+
PROMPT | NLS_DATABASE_PARAMETERS		                                        |
PROMPT +------------------------------------------------------------------------+

SELECT * FROM nls_database_parameters
/



