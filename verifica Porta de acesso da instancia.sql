-- querye que auxilia a encontrar a porta de coneção usado no SGBD

SELECT TOP 1 local_tcp_port 
FROM sys.dm_exec_connections
WHERE local_tcp_port IS NOT NULL
