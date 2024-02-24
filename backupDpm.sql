use master


declare @now varchar(20)

declare @path varchar(256)

declare @filename varchar(150)


set @now= format(getdate(),'yyyy-MM-dd-HHmm')

set @path='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup\'

set @filename= @path + 'DPM_' + @now + '.bak'


backup database DPMDB_SC_BACKUP to disk = @filename with compression