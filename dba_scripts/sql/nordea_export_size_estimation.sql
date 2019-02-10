SELECT sum(bytes)/(1024*1024) Megabytes
FROM dba_Segments
WHERE owner IN (select username from dba_users where username 
not in ('DBSNMP','TRACESVR','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OLAPSYS',
'OSE$HTTP$ADMIN','MDSYS','ORDSYS','ORDPLUGINS','SI_INFORMTN_SCHEMA','CTXSYS','SYSMAN',
'WKSYS','WKUSER','WK_TEST','REPADMIN','LBACSYS','DVF','DVSYS','ODM','ODM_MTR','DMSYS',
'WMSYS','ANONYMOUS','XDB','EXFSYS','DIP','SYS','SYSTEM','ORDDATA','OUTLN','APPQOSSYS',
'XS$NULL','ORACLE_OCM','DBADMIN','IDM','OPS$ORACLE')
and username not like 'APEX%'
and username not like 'FLOWS%') ;


SELECT segment_type, sum(bytes)/(1024*1024) Megabytes
FROM dba_Segments
WHERE owner IN (select username from dba_users where username 
not in ('DBSNMP','TRACESVR','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OLAPSYS',
'OSE$HTTP$ADMIN','MDSYS','ORDSYS','ORDPLUGINS','SI_INFORMTN_SCHEMA','CTXSYS','SYSMAN',
'WKSYS','WKUSER','WK_TEST','REPADMIN','LBACSYS','DVF','DVSYS','ODM','ODM_MTR','DMSYS',
'WMSYS','ANONYMOUS','XDB','EXFSYS','DIP','SYS','SYSTEM','ORDDATA','OUTLN','APPQOSSYS',
'XS$NULL','ORACLE_OCM','DBADMIN','IDM','OPS$ORACLE')
and username not like 'APEX%'
and username not like 'FLOWS%') 
GROUP BY segment_type;

SELECT owner, segment_type, sum(bytes)/(1024*1024) Megabytes
FROM dba_Segments
WHERE owner IN (select username from dba_users where username 
not in ('DBSNMP','TRACESVR','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OLAPSYS',
'OSE$HTTP$ADMIN','MDSYS','ORDSYS','ORDPLUGINS','SI_INFORMTN_SCHEMA','CTXSYS','SYSMAN',
'WKSYS','WKUSER','WK_TEST','REPADMIN','LBACSYS','DVF','DVSYS','ODM','ODM_MTR','DMSYS',
'WMSYS','ANONYMOUS','XDB','EXFSYS','DIP','SYS','SYSTEM','ORDDATA','OUTLN','APPQOSSYS',
'XS$NULL','ORACLE_OCM','DBADMIN','IDM','OPS$ORACLE')
and username not like 'APEX%'
and username not like 'FLOWS%') 
GROUP BY owner, segment_type
ORDER BY 1,2;