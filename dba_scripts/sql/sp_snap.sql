-- +----------------------------------------------------------------------------+
-- |                          Jeffrey M. Hunter                                 |
-- |                      jhunter@idevelopment.info                             |
-- |                         www.idevelopment.info                              |
-- |----------------------------------------------------------------------------|
-- |      Copyright (c) 1998-2012 Jeffrey M. Hunter. All rights reserved.       |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : sp_snap.sql                                                     |
-- | CLASS    : Statspack                                                       |
-- | PURPOSE  : This is a wrapper script used to perform a manual Statspack     |
-- |            snapshot.                                                       |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

prompt 
prompt =========================================================================
prompt The following script is a wrapper script to the Oracle supplied package
prompt Statspack.
prompt =========================================================================
prompt Note that this script should be run as the owner of the 
prompt STATSPACK repository.
prompt =========================================================================
prompt

exec statspack.snap;

