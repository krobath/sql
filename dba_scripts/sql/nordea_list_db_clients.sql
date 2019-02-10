SELECT distinct n.os_username||';'|| 
n.userhost||';'||
CASE
    WHEN  n.userhost LIKE 'ONEADR\%'  THEN  'ONEADR'
    WHEN  n.userhost LIKE 'ND60A600\%'  THEN  'ND60A600'
    ELSE  ''
END||';'|| 
CASE
    WHEN  n.userhost LIKE 'ONEADR\DK%'  THEN  'DK'
    WHEN  n.userhost LIKE 'ONEADR\NO%'  THEN  'NO'
    WHEN  n.userhost LIKE 'ONEADR\SE%'  THEN  'SE'
    WHEN  n.userhost LIKE 'ND60A600\DK%'  THEN  'DK'
    WHEN  n.userhost LIKE 'ND60A600\NO%'  THEN  'NO'
    WHEN  n.userhost LIKE 'ND60A600\SE%'  THEN  'SE'
    WHEN  n.userhost LIKE 'DK%'  THEN  'DK'
    WHEN  n.userhost LIKE 'NO%'  THEN  'NO'
    WHEN  n.userhost LIKE 'SE%'  THEN  'SE'
    WHEN  n.userhost LIKE '%PL%'  THEN  'PL'
    WHEN  n.userhost LIKE '%EE%'  THEN  'EE'
    WHEN  n.userhost LIKE '%LV%'  THEN  'LV'
    WHEN  n.userhost LIKE '%LT%'  THEN  'LT'
    WHEN  n.userhost LIKE '%LU%'  THEN  'LU'
    WHEN  n.userhost LIKE '%DE%'  THEN  'DE'
    WHEN  n.userhost LIKE '%UK%'  THEN  'UK'
    WHEN  n.userhost LIKE '%AE%'  THEN  'AE'
    ELSE  'NA'
END||';'||
CASE
    WHEN  n.userhost LIKE '%CMD%'  THEN  'Production'
    WHEN  n.userhost LIKE '%DKD%'  THEN  'Production'
    WHEN  n.userhost LIKE '%NOD%'  THEN  'Production'
    WHEN  n.userhost LIKE '%SED%'  THEN  'Production'
    WHEN  n.userhost LIKE '%CMA%'  THEN  'Acceptance'
    WHEN  n.userhost LIKE '%DKA%'  THEN  'Acceptance'
    WHEN  n.userhost LIKE '%NOA%'  THEN  'Acceptance'
    WHEN  n.userhost LIKE '%SEA%'  THEN  'Acceptance'
    WHEN  n.userhost LIKE '%CMT%'  THEN  'Test'
    WHEN  n.userhost LIKE '%DKT%'  THEN  'Test'
    WHEN  n.userhost LIKE '%NOT%'  THEN  'Test'
    WHEN  n.userhost LIKE '%SET%'  THEN  'Test'
    WHEN  n.userhost LIKE '%CMZ%'  THEN  'DMZ'
    WHEN  n.userhost LIKE '%DKZ%'  THEN  'DMZ'
    WHEN  n.userhost LIKE '%NOZ%'  THEN  'DMZ'
    WHEN  n.userhost LIKE '%SEZ%'  THEN  'DMZ'
    ELSE  'NA'
END||';'||
CASE
    WHEN  n.userhost LIKE '%CM%'  THEN  'Capital Markets'
    WHEN  n.userhost LIKE '%NP%'  THEN  'Nordea Production'
    WHEN  n.userhost LIKE '%NT%'  THEN  'Nordea Test/UAT'
    WHEN  n.userhost LIKE '%NS%'  THEN  'Nordea Support'
    WHEN  n.userhost LIKE '%LP%'  THEN  'Nordea Liv og Pension'
    WHEN  n.userhost LIKE '%FP%'  THEN  'Fidenta Production'
    WHEN  n.userhost LIKE '%FT%'  THEN  'Fidenta Test'
    ELSE  'NA'
END||';'||
CASE
    WHEN  n.userhost LIKE '%WS%'  THEN  'Workstation'
    WHEN  n.userhost LIKE '%WM%'  THEN  'Laptop'
    WHEN  n.userhost LIKE '%WV%'  THEN  'Local Virtual Desktop'
    WHEN  n.userhost LIKE '%GE%'  THEN  'General Use Server'
    WHEN  n.userhost LIKE '%TS%'  THEN  'Terminal Server'
    WHEN  n.userhost LIKE '%DC%'  THEN  'Domain Controller'
    WHEN  n.userhost LIKE '%CD%'  THEN  'Database Server'
    WHEN  n.userhost LIKE '%DB%'  THEN  'Database Server'
    WHEN  n.userhost LIKE '%AP%'  THEN  'Application Server'
    WHEN  n.userhost LIKE '%IS%'  THEN  'IIS Web / Info Servers'
    ELSE  'NA'
END||';'||
n.terminal||';'||
s.program||';'||
s.module               
FROM sys.nordea_audit_history n, DBA_HIST_ACTIVE_SESS_HISTORY s
WHERE n.timestamp > sysdate-90
AND n.userhost = s.machine(+);