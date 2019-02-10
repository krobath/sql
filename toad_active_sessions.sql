--
-- active_sessions
--
SELECT DISTINCT
    s.sid           sid
  , s.serial#       serial_id
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.module
  , s.seconds_in_wait
  --, substr(sql.sql_text,0,20) SQL_TEXT
  , s.event
  , sql_text SQL_TEXT
  , SQL.SQL_ID sql_id
FROM 
    gv$process p,
    gv$session s,
    gv$sql sql
WHERE
    s.inst_id = p.inst_id(+)
    AND S.INST_ID = sql.inst_id(+)
    AND s.paddr = p.addr (+)
    --AND S.SQL_ID = sql.SQL_ID(+)
    AND s.SQL_ADDRESS = sql.ADDRESS(+)
    AND s.status = 'ACTIVE'
    AND s.username IS NOT NULL
ORDER BY seconds_in_wait desc
/

--
-- active_sessions_with_extended_wait_details
--
SELECT DISTINCT
    s.sid           sid
  , s.serial#       serial_id
  , s.logon_time
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.module
  , s.seconds_in_wait
  , substr(sql.sql_text,0,20) SQL_TEXT
  , SQL.SQL_ID sql_id
  , s.event
  , s.blocking_session
  , s.p1text
  , s.p1
  , p2text
  , p2
  , p3text
  ,p3
FROM 
    gv$process p,
    gv$session s,
    gv$sql sql
WHERE
    s.inst_id = p.inst_id(+)
    AND S.INST_ID = sql.inst_id(+)
    AND s.paddr = p.addr (+)
    AND s.SQL_ADDRESS = sql.ADDRESS(+)
    AND s.status = 'ACTIVE'
    --AND s.sid = 1524
    AND s.username IS NOT NULL
    --AND s.username IN ('BOS','BOS_FAG')
ORDER BY seconds_in_wait desc
/


SELECT DISTINCT
    s.sid           sid
  , s.serial#       serial_id
  , s.logon_time
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.module
  , s.seconds_in_wait
  , S.SQL_ID sql_id
  , s.event
  , s.blocking_session
  , s.p1text
  , s.p1
  , p2text
  , p2
  , p3text
  , p3
  , ex.segment_name
  , substr(sql.sql_text,0,2000) SQL_TEXT
  --, sa.sql_fulltext
FROM 
    gv$process p,
    gv$session s,
    gv$sql sql,
    --gv$sqlarea sa,
    dba_extents ex
WHERE
    s.inst_id = p.inst_id(+)
    AND S.INST_ID = sql.inst_id(+)
    AND s.paddr = p.addr (+)
    AND s.SQL_ADDRESS = sql.ADDRESS(+)
    --AND sa.sql_id = s.sql_id --AND sa.ROWNUM = 1
    --AND s.event = 'read by other session' 
    AND (s.p1text = 'file#' AND s.p2text = 'block#')
    --AND s.status = 'ACTIVE'
    --AND s.sid = 1524
    AND s.username IS NOT NULL
    AND ex.file_id = s.p1
    and s.p2 between ex.block_id and ex.block_id + blocks - 1
    AND s.username IN ('BOS','BOS_FAG')
--ORDER BY seconds_in_wait desc
UNION
SELECT DISTINCT
    s.sid           sid
  , s.serial#       serial_id
  , s.logon_time
  , s.inst_id
  , s.status        session_status
  , s.username      oracle_username
  , s.osuser        os_username
  , p.spid          os_pid
  , s.program       session_program
  , s.module
  , s.seconds_in_wait
  , S.SQL_ID sql_id
  , s.event
  , s.blocking_session
  , s.p1text
  , s.p1
  , p2text
  , p2
  , p3text
  , p3
  , '<Unknown>' AS segment_name
  , substr(sql.sql_text,0,2000) SQL_TEXT
  --, sa.sql_fulltext
FROM 
    gv$process p,
    gv$session s,
    gv$sql sql--,
    --gv$sqlarea sa,
    --dba_extents ex
WHERE
    s.inst_id = p.inst_id(+)
    AND S.INST_ID = sql.inst_id(+)
    AND s.paddr = p.addr (+)
    AND s.SQL_ADDRESS = sql.ADDRESS(+)
    --AND (s.p1text = 'file#' AND s.p2text = 'block#')
    --AND s.status = 'ACTIVE'
    AND s.sid IN (
      SELECT DISTINCT
        s.blocking_session
      FROM 
        gv$session s
      WHERE s.blocking_session IS NOT NULL
    )
    --AND s.username IS NOT NULL
    --AND ex.file_id = s.p1
    --and s.p2 between ex.block_id and ex.block_id + blocks - 1
ORDER BY seconds_in_wait desc
/

select segment_name
from dba_extents
where file_id = 35
			and 1379344 between block_id and block_id + blocks - 1
			and rownum = 1
			
			
DESC bos.haendelse		

SELECT sql_fulltext
  FROM gv$sqlarea
 WHERE sql_id = 'df43yttrjxnjq' AND ROWNUM = 1; 
 	
 
/* Formatted on 08-08-2018 10:00:10 (QP5 v5.326) */
  SELECT haendelse0_.ID                           AS ID1_97_,
         haendelse0_.AENDRET                      AS AENDRET2_97_,
         haendelse0_.AENDRETAF                    AS AENDRETAF3_97_,
         haendelse0_.ANSOEGNING_ID                AS ANSOEGNING_ID16_97_,
         haendelse0_.BESKEDFORDELER_BESKED_ID     AS BESKEDFORDELER_BE17_97_,
         haendelse0_.YDELSE_ID                    AS YDELSE_ID18_97_,
         haendelse0_.DOKUMENT_ID                  AS DOKUMENT_ID19_97_,
         haendelse0_.ENTITETSTYPE                 AS ENTITETSTYPE4_97_,
         haendelse0_.GENSTARTET_AF_OPGAVE_ID      AS GENSTARTET_AF_OPG20_97_,
         haendelse0_.GYLDIG_FRA                   AS GYLDIG_FRA5_97_,
         haendelse0_.GYLDIG_TIL                   AS GYLDIG_TIL6_97_,
         haendelse0_.HAENDELSE_DATA               AS HAENDELSE_DATA7_97_,
         haendelse0_.HAENDELSE_TEKST              AS HAENDELSE_TEKST8_97_,
         haendelse0_.HAENDELSE_TYPE               AS HAENDELSE_TYPE9_97_,
         haendelse0_.JOURNALNOTAT_ID              AS JOURNALNOTAT_ID21_97_,
         haendelse0_.INITIERET_AF_OPGAVE_ID       AS INITIERET_AF_OPGA22_97_,
         haendelse0_.OPRETTET                     AS OPRETTET10_97_,
         haendelse0_.OPRETTETAF                   AS OPRETTETAF11_97_,
         haendelse0_.PARENT_ID                    AS PARENT_ID12_97_,
         haendelse0_.PERSON_ID                    AS PERSON_ID23_97_,
         haendelse0_.RESERVED_BY                  AS RESERVED_BY13_97_,
         haendelse0_.STATUS                       AS STATUS14_97_,
         haendelse0_.UDK_BESKED_DATO              AS UDK_BESKED_DATO15_97_,
         haendelse0_.VIRKSOMHED_ID                AS VIRKSOMHED_ID24_97_
    FROM HAENDELSE haendelse0_
         LEFT OUTER JOIN HAENDELSE_RELATION haendelser1_
             ON haendelse0_.ID = haendelser1_.HAENDELSE_ID
   WHERE     haendelse0_.PERSON_ID = :1
         AND (   haendelse0_.DOKUMENT_ID IS NOT NULL
              OR haendelse0_.JOURNALNOTAT_ID IS NOT NULL)
         AND haendelser1_.SAG_ID = :2
ORDER BY haendelse0_.OPRETTET DESC


SELECT p1text, p1 "file#", p2text, p2 "block#", p3text, p3 "class#" 
 FROM v$session_wait
 WHERE p1text = 'file#' and p2text = 'block"' --event = 'read by other session';
 
 
ALTER SESSION SET tracefile_identifier='STGADM_SELECT_TRACE';
ALTER SESSION SET EVENTS '10046 trace name context forever, level 8';
 
SELECT 'F1_FACT', CX_ID 
FROM STGADM.CK_F1_FACT K1 
WHERE K1.CX_ID <> ' ' 
AND (1<(SELECT COUNT(*) FROM STGADM.CK_F1_FACT K2 WHERE K1.CI_ID = K2.CI_ID)
OR EXISTS (SELECT 'X' FROM STGADM.CX_F1_FACT TBL WHERE K1.CI_ID = TBL.FACT_ID) OR K1.CI_ID = ' ');