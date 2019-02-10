-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sp_purge.sql                                                    |
-- | CLASS    : Statspack                                                       |
-- | PURPOSE  : This is a wrapper script to the Oracle supplied sppurge.sql.    |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

prompt 
prompt =========================================================================
prompt The following script is a wrapper script to the Oracle supplied SQL
prompt script ?/rdbms/admin/sppurge.sql.
prompt 
prompt The Oracle supplied script sppurge.sql will prompt the user for two 
prompt snapshot IDs; a low snapshot ID and a high snapshot ID. The script
prompt will then remove all records contained in that range.
prompt 
prompt Note that this script should be run as the owner of the 
prompt STATSPACK repository.
prompt 
prompt Also note that a major portion of the sppurge.sql script is
prompt commented out for performance reasons. Search for the string
prompt "Delete any dangling SQLtext" and uncomment out the section
prompt below it.
prompt =========================================================================
prompt
prompt Hit [ENTER] to continue or CTRL-C to cancel ...
pause

@?/rdbms/admin/sppurge.sql
