--
-- Fix TIPT temporary tablespaces after duplicates
--

-- Check no tempfiles are zero bytes
col name for a60
SELECT name, bytes FROM v$tempfile



SELECT 'ls -l '||name FROM v$tempfile;



DROP TABLESPACE TEMP INCLUDING CONTENTS AND DATAFILES;

CREATE TEMPORARY TABLESPACE TEMP TEMPFILE 
  '/u04/oradata/tipt8/datafile/temp_01.dbf' SIZE 16385M AUTOEXTEND ON NEXT 8K MAXSIZE 16385M,
  '/u04/oradata/tipt8/datafile/temp_02.dbf' SIZE 16385M AUTOEXTEND ON NEXT 8K MAXSIZE 16385M,
  '/u04/oradata/tipt8/datafile/temp_03.dbf' SIZE 16385M AUTOEXTEND ON NEXT 8K MAXSIZE 16385M
TABLESPACE GROUP ''
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;



DROP TABLESPACE TEMP_MONTAGE_TS INCLUDING CONTENTS AND DATAFILES;

CREATE TEMPORARY TABLESPACE TEMP_MONTAGE_TS TEMPFILE 
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_01.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_02.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_03.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_04.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_05.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_06.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_07.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_08.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_09.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_10.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_11.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_12.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_13.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_14.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_15.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_16.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_17.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_18.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_19.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_20.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_21.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_22.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_23.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_24.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_25.dbf' SIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_26.dbf' SIZE 4097M AUTOEXTEND ON NEXT 1024M MAXSIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_27.dbf' SIZE 4097M AUTOEXTEND ON NEXT 1024M MAXSIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_28.dbf' SIZE 4097M AUTOEXTEND ON NEXT 1024M MAXSIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_29.dbf' SIZE 4097M AUTOEXTEND ON NEXT 1024M MAXSIZE 16385M,
  '/u04/oradata/tipt8/tempfile/temp_montage_ts_30.dbf' SIZE 4097M AUTOEXTEND ON NEXT 1024M MAXSIZE 16385M
TABLESPACE GROUP ''
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp_montage_ts;


SELECT 'ALTER DATABASE TEMPFILE '''||name||''' DROP;' 
FROM v$tempfile
WHERE bytes=0; 

ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_02.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_03.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_21.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_22.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_23.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_24.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_25.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_26.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_27.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_28.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_29.dbf' DROP;
ALTER DATABASE TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_30.dbf' DROP;

SELECT 'ALTER DATABASE TEMPFILE '''||name||''' DROP;' 
FROM v$tempfile
WHERE bytes=0; 

ALTER TABLESPACE TEMP ADD TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_02.dbf' SIZE 16G;
ALTER TABLESPACE TEMP ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_03.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_21.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_22.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_23.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_24.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_25.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_26.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_27.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_28.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_29.dbf' SIZE 16G;
ALTER TABLESPACE TEMP_MONTAGE_TS ADD  TEMPFILE '/u03/oradata/tip7at/datafile/tempfile/temp_montage_ts_30.dbf' SIZE 16G;