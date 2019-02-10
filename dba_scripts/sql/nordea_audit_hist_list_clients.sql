col os_username for a16
col client_machine for a32
set lines 120 
SELECT distinct os_username, 
userhost CLIENT_MACHINE,
CASE
    WHEN  userhost LIKE 'ONEADR\%'  THEN  'ONEADR'
    WHEN  userhost LIKE 'ND60A600\%'  THEN  'ND60A600'
    ELSE  ''
END domain_name, 
CASE
    WHEN  userhost LIKE 'ONEADR\DK%'  THEN  'DK'
    WHEN  userhost LIKE 'ONEADR\NO%'  THEN  'NO'
    WHEN  userhost LIKE 'ONEADR\SE%'  THEN  'SE'
    WHEN  userhost LIKE 'ND60A600\DK%'  THEN  'DK'
    WHEN  userhost LIKE 'ND60A600\NO%'  THEN  'NO'
    WHEN  userhost LIKE 'ND60A600\SE%'  THEN  'SE'
    WHEN  userhost LIKE 'DK%'  THEN  'DK'
    WHEN  userhost LIKE 'NO%'  THEN  'NO'
    WHEN  userhost LIKE 'SE%'  THEN  'SE'
    WHEN  userhost LIKE '%PL%'  THEN  'PL'
    WHEN  userhost LIKE '%EE%'  THEN  'EE'
    WHEN  userhost LIKE '%LV%'  THEN  'LV'
    WHEN  userhost LIKE '%LT%'  THEN  'LT'
    WHEN  userhost LIKE '%LU%'  THEN  'LU'
    WHEN  userhost LIKE '%DE%'  THEN  'DE'
    WHEN  userhost LIKE '%UK%'  THEN  'UK'
    WHEN  userhost LIKE '%AE%'  THEN  'AE'
    ELSE  'NA'
END country,
CASE
    WHEN  userhost LIKE '%CMD%'  THEN  'Production'
    WHEN  userhost LIKE '%DKD%'  THEN  'Production'
    WHEN  userhost LIKE '%NOD%'  THEN  'Production'
    WHEN  userhost LIKE '%SED%'  THEN  'Production'
    WHEN  userhost LIKE '%CMA%'  THEN  'Acceptance'
    WHEN  userhost LIKE '%DKA%'  THEN  'Acceptance'
    WHEN  userhost LIKE '%NOA%'  THEN  'Acceptance'
    WHEN  userhost LIKE '%SEA%'  THEN  'Acceptance'
    WHEN  userhost LIKE '%CMT%'  THEN  'Test'
    WHEN  userhost LIKE '%DKT%'  THEN  'Test'
    WHEN  userhost LIKE '%NOT%'  THEN  'Test'
    WHEN  userhost LIKE '%SET%'  THEN  'Test'
    WHEN  userhost LIKE '%CMZ%'  THEN  'DMZ'
    WHEN  userhost LIKE '%DKZ%'  THEN  'DMZ'
    WHEN  userhost LIKE '%NOZ%'  THEN  'DMZ'
    WHEN  userhost LIKE '%SEZ%'  THEN  'DMZ'
    ELSE  'NA'
END server_domain,
CASE
    WHEN  userhost LIKE '%CM%'  THEN  'Capital Markets'
    WHEN  userhost LIKE '%NP%'  THEN  'Nordea Production'
    WHEN  userhost LIKE '%NT%'  THEN  'Nordea Test/UAT'
    WHEN  userhost LIKE '%NS%'  THEN  'Nordea Support'
    WHEN  userhost LIKE '%LP%'  THEN  'Nordea Liv og Pension'
    WHEN  userhost LIKE '%FP%'  THEN  'Fidenta Production'
    WHEN  userhost LIKE '%FT%'  THEN  'Fidenta Test'
    ELSE  'NA'
END environment,
CASE
    WHEN  userhost LIKE '%WS%'  THEN  'Workstation'
    WHEN  userhost LIKE '%WM%'  THEN  'Laptop'
    WHEN  userhost LIKE '%WV%'  THEN  'Local Virtual Desktop'
    WHEN  userhost LIKE '%GE%'  THEN  'General Use Server'
    WHEN  userhost LIKE '%TS%'  THEN  'Terminal Server'
    WHEN  userhost LIKE '%DC%'  THEN  'Domain Controller'
    WHEN  userhost LIKE '%CD%'  THEN  'Database Server'
    WHEN  userhost LIKE '%DB%'  THEN  'Database Server'
    WHEN  userhost LIKE '%AP%'  THEN  'Application Server'
    WHEN  userhost LIKE '%IS%'  THEN  'IIS Web / Info Servers'
    ELSE  'NA'
END type               
FROM sys.nordea_audit_history
WHERE timestamp > sysdate-180;