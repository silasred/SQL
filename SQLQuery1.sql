 IF EXISTS (SELECT * FROM TEMPDB.dbo.sysobjects WHERE NAME IN ('##Users')) 

BEGIN

  DROP TABLE ##Users

END

GO

IF EXISTS (SELECT * FROM TEMPDB.dbo.sysobjects WHERE NAME IN (N'##ACESSO')) 

BEGIN

  DROP TABLE ##ACESSO

END

GO

CREATE TABLE ##Users (

[sid] varbinary(100) NULL,

[Login Name] varchar(100) NULL

)

CREATE TABLE ##ACESSO ([USER ID] VARCHAR(MAX), [SERVER LOGIN] VARCHAR(MAX), [DATABASE ROLE] VARCHAR(MAX), [DATABASE] VARCHAR(MAX))

declare @cmd1 nvarchar(500)

declare @cmd2 nvarchar(500)

set @cmd1 = '

INSERT INTO ##Users ([sid],[Login Name]) SELECT sid, loginname FROM master.dbo.syslogins

INSERT INTO ##ACESSO 

 SELECT su.[name] ,  

 u.[Login Name]  , 

  sug.name   , ''?''

  FROM [?].[dbo].[sysusers] su 

  LEFT OUTER JOIN ##Users u 

  ON su.sid = u.sid 

  LEFT OUTER JOIN ([?].[dbo].[sysmembers] sm  

  INNER JOIN [?].[dbo].[sysusers] sug 

  ON sm.groupuid = sug.uid) 

  ON su.uid = sm.memberuid  

  WHERE su.hasdbaccess = 1 

  AND su.[name] != ''dbo''

'

exec sp_MSforeachdb @command1=@cmd1

SELECT * FROM ##ACESSO  GROUP BY [USER ID] , [SERVER LOGIN]  , [DATABASE ROLE]  , [DATABASE]  ORDER BY [DATABASE]