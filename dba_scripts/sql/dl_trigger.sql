select * from db_ddl_log where usr not in ('SYS','SYSTEM','GGSMGR');

CREATE OR REPLACE TRIGGER db_ddl_trig
BEFORE DDL ON DATABASE
DECLARE
   sql_text     ora_name_list_t;
   stmt         clob;
   n            INTEGER;
BEGIN
   -- Only below users are allowed to proceed
    IF (ora_login_user in ('BL','SYS','SYSTEM','ARADMIN')) THEN
      -- Extract the original DDL statement and piece it together into a LONG
      n := ora_sql_txt( sql_text );
      FOR i IN 1..n LOOP
         stmt := stmt || sql_text(i);
      END LOOP;
      -- Insert into log table.  Note, if original DDL statement fails, this
      -- insert will also be rolled back (statement level rollback), so this
      -- only logs successful DDL statements.
      INSERT INTO db_ddl_log
         VALUES ( sysdate, ora_login_user, ora_sysevent, stmt);
    ELSE
      raise_application_error(-20001,'DDL is not allowed in the database during migration');
    END IF;
END;
/
