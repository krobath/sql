GRANT create session TO ggsmgr;
GRANT alter session TO ggsmgr;
GRANT alter system TO ggsmgr;
GRANT resource TO ggsmgr;
GRANT connect TO ggsmgr;
GRANT select any dictionary TO ggsmgr;
GRANT flashback any table TO ggsmgr;
GRANT select any table TO ggsmgr;
GRANT select on sys.dba_clusters TO ggsmgr;
GRANT execute on sys.dbms_flashback TO ggsmgr;
GRANT alter any table TO ggsmgr;


set pages 9999 lines 1024 long 90000 trims on
set head off
set feedback off
spool ggsmgr_object_grants.sql
SELECT 'GRANT insert, update, delete on '||owner||'.'||table_name||' TO ggsmgr;'
FROM dba_tables
WHERE owner NOT IN ('DBSNMP','TRACESVR','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OLAPSYS',
'OSE$HTTP$ADMIN','MDSYS','ORDSYS','ORDPLUGINS','SI_INFORMTN_SCHEMA','CTXSYS','SYSMAN',
'WKSYS','WKUSER','WK_TEST','REPADMIN','LBACSYS','DVF','DVSYS','ODM','ODM_MTR','DMSYS',
'WMSYS','ANONYMOUS','XDB','EXFSYS','DIP','SYS','SYSTEM','ORDDATA','OUTLN','APPQOSSYS',
'XS$NULL','ORACLE_OCM','DBADMIN','BL','IDM','GGSMGR','OPS$ORACLE')
and owner NOT LIKE 'APEX%'
and owner NOT LIKE 'FLOWS_%';

spool off

set feedback on
set head on
@ggsmgr_object_grants.sql



2014-07-14 09:38:20  WARNING OGG-00706  Failed to add supplemental log group on table REMEDY_RAW_GG.H2311_DD due to ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired SQL ALTER TABLE "REMEDY_RAW_GG"."H2311_DD" ADD SUPPLEMENTAL LOG GROUP "GGS_92917" ("ENTRYID") ALWAYS  /* GOLDENGATE_DDL_REPLICATION */.
