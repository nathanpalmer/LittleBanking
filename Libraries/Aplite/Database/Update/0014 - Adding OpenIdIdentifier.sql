/*
   Sunday, August 22, 201011:55:23 AM
   User: 
   Server: localhost\SQLEXPRESS
   Database: CodeKaraoke
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
	OpenIdIdentifier varchar(255) NULL
GO
CREATE NONCLUSTERED INDEX IX_tbdUser_OpenIdIdentifier ON dbo.tbdUser
	(
	OpenIdIdentifier
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tbdUser SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
