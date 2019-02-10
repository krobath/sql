SELECT distinct statistic_name FROM v$segstat;

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value
FROM dba_objects obj, v$segstat stat
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND stat.statistic_name = 'physical write requests'
ORDER by stat.value DESC;

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value, seg.bytes/(1024*1024) size_mb
FROM dba_objects obj, 
     v$segstat stat, 
     dba_segments seg
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND obj.owner = seg.owner AND obj.object_name = seg.segment_name
AND stat.statistic_name = 'physical write requests'
--AND obj_size.statistic_name = 'space used'
ORDER by stat.value DESC;

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value
FROM dba_objects obj, v$segstat stat
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND stat.statistic_name IN ('db block changes')
ORDER by stat.value ASC;

SELECT * FROM dba_lobs WHERE segment_name = 'SYS_LOB0000149650C00004$$';
SELECT * FROM dba_lobs WHERE segment_name = 'SYS_LOB0000150365C00004$$';
SELECT * FROM dba_lobs WHERE segment_name = 'SYS_LOB0000149656C00004$$';

desc bos.opgave_data
desc bos.opgave_trin_data_h

SELECT sum(dbms_lob.getLength(INDHOLD))/(1024*1024) MB
FROM bos.opgave_data
WHERE oprettet > sysdate-14;

-- 4777,44 MB

SELECT sum(dbms_lob.getLength(INDHOLD))/(1024*1024) MB
FROM bos.opgave_data
WHERE aendret > sysdate-14;

-- 22272,63 MB

SELECT sum(dbms_lob.getLength(VAERDI))/(1024*1024) MB
FROM bos.opgave_trin_data_h
WHERE oprettet > sysdate-14;

-- 216342,23 MB

SELECT sum(dbms_lob.getLength(VAERDI))/(1024*1024) MB
FROM bos.opgave_trin_data_h
WHERE aendret > sysdate-14;

-- 220127.85

SELECT sum(dbms_lob.getLength(VAERDI))/(1024*1024) MB
FROM bos.opgave_trin_data
WHERE oprettet > sysdate-14;

-- 214765,12 MB

SELECT sum(dbms_lob.getLength(VAERDI))/(1024*1024) MB
FROM bos.opgave_trin_data
WHERE aendret > sysdate-14;

-- 216428,19 MB


desc bos.IXFK_HAENDELSE_PERSON