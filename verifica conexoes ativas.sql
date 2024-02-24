select distinct login_name, 
(select count(*) from sys.dm_exec_sessions a
where a.status = 'sleeping'
and a.login_name = se.login_name
group by login_name) as Sleeping,
Isnull((select count(*) from sys.dm_exec_sessions a
where a.status = 'running'
and a.login_name = se.login_name
group by login_name),0) as Running
from
	sys.dm_exec_sessions as se
	inner join sys.dm_exec_connections as con on se.session_id = con.session_id
order by 1