--
-- Blackout overview
--
-- Lists summary of indefinite blackouts affecting 
-- components OTHER THAN:
-- ('Database Instance','Cluster Database','Database System')
--
SELECT a.blackout_guid, a.created_by, a.blackout_name, b.description, c.type_display_name, count(*) Affected_components
FROM mgmt$blackout_history a,
     mgmt$blackouts b,
     mgmt$target c
WHERE a.blackout_guid = b.blackout_guid
AND a.target_guid = c.target_guid
AND c.type_display_name NOT IN('Database','Database Instance','Cluster Database','Database System')
AND b.status NOT IN ('Ended', 'Stopped')
AND b.schedule_type = 'One Time'
AND b.duration = -1
GROUP BY a.blackout_guid, a.created_by, a.blackout_name, b.description, c.type_display_name
ORDER BY  a.created_by, a.blackout_name, c.type_display_name;

--
-- Lists summary of indefinite blackouts affecting 
-- components OTHER THAN:
-- ('Database Instance','Cluster Database','Database System')
--
SELECT a.blackout_guid, a.created_by, a.blackout_name, b.description, c.type_display_name, count(*) Affected_components
FROM mgmt$blackout_history a,
     mgmt$blackouts b,
     mgmt$target c
WHERE a.blackout_guid = b.blackout_guid
AND a.target_guid = c.target_guid
AND b.status NOT IN ('Ended', 'Stopped')
AND b.schedule_type = 'One Time'
AND b.duration = -1
GROUP BY a.blackout_guid, a.created_by, a.blackout_name, b.description, c.type_display_name
ORDER BY  a.created_by, a.blackout_name, c.type_display_name;

--
-- Blackout overview
--
-- Lists targets related to indefinite blackouts affecting 
-- components OTHER THAN:
-- ('Database Instance','Cluster Database','Database System')
--
SELECT  c.target_guid, a.blackout_guid, a.created_by,
        a.blackout_name,
        b.description, 
        a.target_name,
        c.type_display_name,
        b.duration,
        b.status,
        b.last_start_time
FROM    mgmt$blackout_history a,
        mgmt$blackouts b,
        mgmt$target c
WHERE a.blackout_guid = b.blackout_guid
AND a.target_guid = c.target_guid
AND c.type_display_name NOT IN('Database','Database Instance','Cluster Database','Database System')
AND b.status NOT IN ('Ended', 'Stopped')
AND b.schedule_type = 'One Time'
AND b.duration = -1
ORDER BY a.created_by, a.blackout_name, a.created_by, c.type_display_name;

--
-- Lists all targets affected by an indefinite blackout 
--
SELECT  a.blackout_guid, a.created_by,
        a.blackout_name,
        b.description, 
        a.target_name,
        c.type_display_name,
        b.duration,
        b.status,
        b.last_start_time
FROM    mgmt$blackout_history a,
        mgmt$blackouts b,
        mgmt$target c
WHERE a.blackout_guid = b.blackout_guid
AND a.target_guid = c.target_guid
AND b.status NOT IN ('Ended', 'Stopped')
AND b.schedule_type = 'One Time'
AND b.duration = -1
ORDER BY a.blackout_guid, a.created_by, a.blackout_name, b.description, c.type_display_name;