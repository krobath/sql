

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value
FROM dba_objects obj, v$segstat stat
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND stat.statistic_name = 'physical write requests'
ORDER by stat.value DESC;

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value
FROM dba_objects obj, v$segstat stat
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND stat.statistic_name = 'physical write requests'
ORDER by stat.value DESC;

SELECT obj.owner, obj.object_type, obj.object_name, stat.statistic_name, stat.value
FROM dba_objects obj, v$segstat stat
WHERE obj.object_id = stat.obj# AND obj.data_object_id = stat.DATAOBJ#
AND stat.statistic_name IN ('physical write requests','physical writes direct','physical writes','db block changes')
ORDER by stat.value DESC;



SELECT sid, serial#, username, module, action, sql_id, seconds_in_wait, event 
FROM V$session 
WHERE status = 'ACTIVE'
AND username IS NOT NULL AND event = 'latch free';

SELECT /*+ ORDERED */
        DISTINCT sql.sql_text,
                 RAWTOHEX (sql.address),
                 sql.hash_value,
                 0 piece,
                 sql.sql_id,
                 sql.child_number
    FROM v$session s, v$sql sql
   WHERE     sid = 210
         AND sql.address = s.sql_address
         AND sql.hash_value = s.sql_hash_value
         AND sql.child_number = s.sql_child_number
ORDER BY address, piece
/

select *
from 
v$session_wait WHERE wait_class != 'Idle';


/* Formatted on 20-06-2018 11:18:20 (QP5 v5.326) */
SELECT GLACCT.GL_ACCT            AS GL_ACCT,
       CI_LOOKUP_VAL_L.DESCR     AS ACCT_NAME,
       SUM (GLACCT.TRAN_SUM)     AS SUMMARY,
       SUM (DEBIT)               AS DEBIT,
       SUM (CREDIT)              AS CREDIT
  FROM ((SELECT ACCOUNTING_DATE,
                NVL (DEBIT, 0) + NVL (CREDIT, 0)     AS TRAN_SUM,
                GL_ACCT,
                NVL (DEBIT, 0)                       AS DEBIT,
                NVL (CREDIT, 0)                      AS CREDIT
           FROM DK_REC_OF_STAT_OF_ACCOUNT
          WHERE    TRANSACTION_ID IS NULL
                OR     TRANSACTION_TYPE_LANG = 'DK '
                   AND ACCOUNT_TYPE_LANG = 'DK '
                   AND CLAIM_TYPE_LANG = 'DK ')
        UNION ALL
        (SELECT ACCOUNTING_DATE,
                0     AS TRAN_SUM,
                GL_ACCT,
                0     AS DEBIT,
                0     AS CREDIT
           FROM (SELECT TO_CHAR (
                            TO_DATE ('01-01-1950', 'dd-mm-yyyy') + ROWNUM - 1,
                            'YYYY-MM-DD')
                            AS ACCOUNTING_DATE
                   FROM ALL_OBJECTS
                  WHERE ROWNUM <=
                          TO_DATE ('01-01-2100', 'dd-mm-yyyy')
                        - TO_DATE ('01-01-1950', 'dd-mm-yyyy')
                        + 1) ALL_DATES,
                (SELECT GL_ACCT
                   FROM CI_DST_CODE_EFF WHER
                   
                   
                   
                   desc cisadm.XT112S6
                   
                   desc cisadm.ci_sa_char