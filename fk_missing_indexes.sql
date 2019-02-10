select cc.owner, cc.table_name, cc.column_name, cc.position   
from dba_cons_columns cc
where 
 cc.owner in ('BOS','BOSFAG')
 and position is not null
minus
select i.index_owner, i.table_name, i.column_name, i.column_position
from dba_ind_columns i
where 
 i.index_owner in ('BOS','BOSFAG');