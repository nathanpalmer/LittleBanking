/*
   Wednesday, August 18, 20109:48:36 PM
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
CREATE TABLE dbo.Tmp_tbmType
	(
	TypeID tinyint NOT NULL,
	Name nvarchar(250) NOT NULL,
	Description nvarchar(250) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbmType SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tbmType)
	 EXEC('INSERT INTO dbo.Tmp_tbmType (TypeID, Name, Description)
		SELECT TypeID, Name, Description FROM dbo.tbmType WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.tbdPost
	DROP CONSTRAINT FK_Node_Type
GO
DROP TABLE dbo.tbmType
GO
EXECUTE sp_rename N'dbo.Tmp_tbmType', N'tbmType', 'OBJECT' 
GO
ALTER TABLE dbo.tbmType ADD CONSTRAINT
	PK_Type PRIMARY KEY CLUSTERED 
	(
	TypeID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdPost SET (LOCK_ESCALATION = TABLE)
GO
IF ( SELECT COUNT(*) FROM tbmType ) = 1
	UPDATE tbmType SET TypeID = 8 WHERE TypeID = 1
GO
IF ( SELECT COUNT(*) FROM tbmType ) = 1
	UPDATE tbdPost SET TypeID = 8 WHERE TypeID = 1
GO
ALTER TABLE dbo.tbdPost ADD CONSTRAINT
	FK_Node_Type FOREIGN KEY
	(
	TypeID
	) REFERENCES dbo.tbmType
	(
	TypeID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


