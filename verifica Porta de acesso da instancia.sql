SELECT TOP 1 local_tcp_port 
FROM sys.dm_exec_connections
WHERE local_tcp_port IS NOT NULL