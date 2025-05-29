-- Backup Strategy Overview
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Backup Type	           Frequency	              Purpose
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Full Backup	         - Weekly (Sunday 2 AM)	    - Capture entire DB; base for differential/logs

-- Differential	         - Daily (Mon–Sat, 2 AM)	- Capture changes since last full

-- Transaction Log	     - Hourly (24/7)	        - Capture all transactions for point-in-time restore
-- -----------------------------------------------------------------------------------------------------------------------------------------------

use HospitalDB

-- 1. Set recovery model to FULL (required for log backups)
ALTER DATABASE HospitalDB SET RECOVERY FULL;

-- 2. Full Backup (Run every Sunday at 2 AM)
BACKUP DATABASE HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\HospitalDB_Full_20250525.bak'
WITH FORMAT, INIT, NAME = 'Full Backup of HospitalDB';

-- 3. Differential Backup (Run Mon–Sat at 2 AM)
BACKUP DATABASE HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\HospitalDB_Diff_20250526.bak'
WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup of HospitalDB';

-- 4. Transaction Log Backup (Run every hour, 24/7)
BACKUP LOG HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\HospitalDB_Log_20250526_1300.trn'
WITH INIT, NAME = 'Transaction Log Backup of HospitalDB';

-- Automating with SQL Server Agent
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Job Name	               Script Section	          Schedule
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- FullBackup_HospitalDB   Full Backup	              Every Sunday @ 2 AM

-- DiffBackup_HospitalDB   Differential Backup	      Mon–Sat @ 2 AM

-- LogBackup_HospitalDB	   Transaction Log	          Every hour (24/7)
-- -----------------------------------------------------------------------------------------------------------------------------------------------



