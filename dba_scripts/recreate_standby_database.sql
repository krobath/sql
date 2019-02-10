--
-- Run duplicate to create new standby database
-- Login as oracle on the standby host
--
rman target sys/p3triton@bpm1p auxiliary sys/p3triton@bpm2p
duplicate target database for standby from active database nofilenamecheck;
exit

 
--
-- Create the dataguard broker configuration
--  
dgmgrl
connect sys/p3triton@bpm1p
CREATE CONFIGURATION db_bpmp AS PRIMARY DATABASE IS bpm1p CONNECT IDENTIFIER IS 'bpm1p';
add database bpm2p as CONNECT IDENTIFIER IS 'bpm2p';
EDIT DATABASE 'bpm1p' SET PROPERTY StaticConnectIdentifier='bpm1p';
EDIT DATABASE 'bpm2p' SET PROPERTY StaticConnectIdentifier='bpm2p';
EDIT DATABASE 'bpm1p' SET PROPERTY ApplyParallel=12;
EDIT DATABASE 'bpm2p' SET PROPERTY ApplyParallel=12;
enable configuration;
show configuration verbose;
quit


--
-- Setup the standby database in OHAS
--
srvctl add database -d 'bpmp' -o '/u01/app/oracle/product/11.2.0.4/dbhome_1' -i 'bpm2p' -r physical_standby -t immediate -a "data,reco"

srvctl start database -d 'bpmp'

srvctl stop database -d 'bpmp'

srvctl start database -d 'bpmp'

-- Verify that the database is listed as "OPEN"
crsctl status res -t

-- Verify that the bpm2p standy has state APPLY-ON
dgmgrl /
show database bpm2p

--
--Run standby monitor:
--
/me01/oracle/dbadmin/standby/db_standby_monitor.sh ORACLE_SID=bpm2p


--
-- Verify the db_RoleChange trigger exist
--
SELECT * FROM dba_triggers WHERE trigger_name = 'db_RoleChange';

--
-- if no rows are returned then create the trigger below:
--
CREATE OR REPLACE TRIGGER SYS.db_RoleChange After DB_ROLE_CHANGE On Database
Declare
  vcService Varchar2(30);
  vcServiceReadOnly Varchar2(35);
  vcRole v$database.database_role%type;
Begin
  -- Assingn the read only service;
  Select lower(name) into vcService from v$database;
  vcServiceReadOnly := concat(vcService, '_ro');
  -- Get the new Role in the Dataguard Setup
  Select Database_Role
  Into vcRole
  From v$database;
  -- Assign the Service
  If vcRole = 'PRIMARY' Then
    DBMS_SERVICE.START_SERVICE (vcService);
    DBMS_SERVICE.STOP_SERVICE (vcServiceReadOnly);
  Else
    DBMS_SERVICE.START_SERVICE (vcServiceReadOnly);
    DBMS_SERVICE.STOP_SERVICE (vcService);
  End If;
Exception
  When Others Then Raise;
End;
/


  