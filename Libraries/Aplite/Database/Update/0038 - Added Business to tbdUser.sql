/*
   Monday, May 30, 201110:00:58 PM
   User: 
   Server: .
   Database: InvitationStudio
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdUser ADD
	Business nvarchar(100) NULL
GO
ALTER TABLE dbo.tbdUser SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
