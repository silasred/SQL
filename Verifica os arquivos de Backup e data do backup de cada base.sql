SELECT
   msdb.dbo.backupset.database_name,  
   msdb.dbo.backupset.backup_start_date,  
   msdb.dbo.backupset.backup_finish_date, 
   datediff(minute, msdb.dbo.backupset.backup_start_date,  msdb.dbo.backupset.backup_finish_date) as elapsed_time_minutes,
   CASE msdb.dbo.backupset.type  
       WHEN 'D' THEN 'Database (Full)'
       WHEN 'L' THEN 'Log'
       WHEN 'I' THEN 'Differential'
       WHEN 'F' THEN 'File or filegroup'
       WHEN 'G' THEN 'Differential file'
       WHEN 'P' THEN 'Partial'
       WHEN 'Q' THEN 'Differential partial'
   END AS backup_type,  
   msdb.dbo.backupset.is_copy_only as [Copy_Only],
   cast(msdb.dbo.backupset.backup_size / 1073741824 as decimal(10,2)) backup_size_GB,   
   cast(msdb.dbo.backupset.compressed_backup_size / 1073741824 as decimal(10,2)) as compressed_backup_size_GB,
   CASE msdb.dbo.backupmediafamily.device_type
    WHEN 2 THEN 'DISK'
    WHEN 5 THEN 'TAPE'
    WHEN 7 THEN 'VIRTUAL DEVICE'
    WHEN 105 THEN 'PERMANCE BACKUP DEVICE'
    ELSE 'OTHER'
    END AS device_type_desc,
    msdb.dbo.backupmediafamily.logical_device_name,
   msdb.dbo.backupmediafamily.physical_device_name
FROM   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7)  
--and msdb.dbo.backupset.type  = 'L'
ORDER BY
   msdb.dbo.backupset.backup_finish_date desc,
   msdb.dbo.backupset.database_name