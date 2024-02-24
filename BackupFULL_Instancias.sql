DECLARE @now VARCHAR(50) -- data e hora do backup
DECLARE @name VARCHAR(150) -- Nome do Database  
DECLARE @path VARCHAR(256) -- Caminho do arquivo de backup
DECLARE @fileName VARCHAR(256) -- Arquivo do backup  
 
-- Define caminho de destino do backup
set @now= format(getdate(),'yyyy-MM-dd-HHmm')
SET @path = 'caminho do seu backup'  
 
-- Cria um cursor para selecionar todas as databases,  
--  excluindo model, msdb e tempdb
DECLARE db_cursor CURSOR FOR  
   SELECT name 
     FROM master.dbo.sysdatabases 

	-- selecionar a condição que mais atende a sua necessidade
	
	-- WHERE name NOT IN ('master','model','msdb','tempdb')  
	-- WHERE name IN ('ALVARAS','Bebidas','BuscapeDW','Infraero','nIPOP','SIPOP','SPTUR_20190323', 'SUS')  
	-- WHERE name IN ('SUS')  
	
-- Abre o cursor e faz a primeira leitura 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   
 
-- Loop de leitura das databases selecionadas 
WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @fileName = @path + @name + '_' + @now + '.BAK'  
   -- Executa o backup para o database
   BACKUP DATABASE @name TO DISK = @fileName WITH COPY_ONLY, COMPRESSION;  
 
   FETCH NEXT FROM db_cursor INTO @name   
END   
 
-- Libera recursos alocados pelo cursor
CLOSE db_cursor   
DEALLOCATE db_cursor 
