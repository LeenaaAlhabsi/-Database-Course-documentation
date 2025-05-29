USE TrainingDB; 

GO 

CREATE TABLE Students ( 
StudentID INT PRIMARY KEY, 
FullName NVARCHAR(100), 
EnrollmentDate DATE 
); 

INSERT INTO Students VALUES  
(1, 'Sara Ali', '2023-09-01'), 
(2, 'Mohammed Nasser', '2023-10-15');


BACKUP DATABASE TrainingDB TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Full.bak';

INSERT INTO Students VALUES (3, 'Fatma Said', '2024-01-10');

BACKUP DATABASE TrainingDB TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Diff.bak' WITH DIFFERENTIAL;

ALTER DATABASE TrainingDB SET RECOVERY FULL; 

BACKUP LOG TrainingDB TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Log.trn';

BACKUP DATABASE TrainingDB TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_CopyOnly.bak' WITH COPY_ONLY;

USE master;
GO
DROP DATABASE TrainingDB;

RESTORE DATABASE TrainingDB
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Full.bak'
WITH NORECOVERY;

RESTORE DATABASE TrainingDB
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Diff.bak'
WITH NORECOVERY;

RESTORE LOG TrainingDB
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\TrainingDB_Log.trn'
WITH RECOVERY;

USE TrainingDB;
SELECT * FROM Students;

-- 1.What would happen if you skipped the differential backup step?
-- Answer:
--	Skipping the differential backup means you’d need every transaction log backup taken since the full backup — which is riskier and slower to restore.
--  If you have a differential, it saves you from restoring many log files.

-- 2.What’s the difference between restoring a full vs. copy-only backup?
-- Answer:
--	A full backup resets the backup chain — it becomes the new base for future differential/log backups.
--  A copy-only backup does not affect the backup chain. It's used for ad hoc backups (e.g., dev/testing) without disrupting scheduled backups.
--  So in restores:
--  Full = part of the recovery path.
--  Copy-only = good for isolated restores but not linked to differential/log backups.

-- 3.What happens if you use WITH RECOVERY in the middle of a restore chain?
-- Answer:
--	SQL Server will finalize the database, making it impossible to apply further backups in that chain.
--	You’ll get an error like:
--	"The database is not in a restoring state."
--	Fix: Always use WITH NORECOVERY until the final restore step.

-- 4.Which backup types are optional and which are mandatory for full recovery?
-- Answer:
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- BackupType				Mandatory?					Purpose
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Full Backup				Yes							Baseline — required for any restore
-- Differential Backup		Optional					Speeds up recovery (vs. many log files)
-- Transaction Log			Yes (for point-in-time)		Required for full recovery to crash point
-- Copy-Only Backup			Optional					Does not participate in recovery chain
-- -----------------------------------------------------------------------------------------------------------------------------------------------






