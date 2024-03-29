/*
   Saturday, May 22, 20109:51:11 PM
   User: 
   Server: MAIN
   Database: VoteForTheWorst
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
ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_AuthorUser
GO
ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_RecipientUser
GO
ALTER TABLE dbo.tbdUser SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT DF_PrivateMessage_Read
GO
CREATE TABLE dbo.Tmp_tbdUser_Message
	(
	UserMessageID int NOT NULL IDENTITY (1, 1),
	DateCreated datetime NOT NULL,
	AuthorUserID int NOT NULL,
	AuthorIP nvarchar(20) NOT NULL,
	AuthorDelete bit NOT NULL,
	RecipientUserID int NOT NULL,
	RecipientDelete bit NOT NULL,
	Title nvarchar(150) NOT NULL,
	Body nvarchar(MAX) NOT NULL,
	[Read] bit NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbdUser_Message SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tbdUser_Message ADD CONSTRAINT
	DF_PrivateMessage_Read DEFAULT ((0)) FOR [Read]
GO
SET IDENTITY_INSERT dbo.Tmp_tbdUser_Message ON
GO
IF EXISTS(SELECT * FROM dbo.tbdUser_Message)
	 EXEC('INSERT INTO dbo.Tmp_tbdUser_Message (UserMessageID, DateCreated, AuthorUserID, AuthorIP, AuthorDelete, RecipientUserID, RecipientDelete, Title, Body, [Read])
		SELECT UserMessageID, DateCreated, AuthorUserID, AuthorIP, AuthorDelete, RecipientUserID, RecipientDelete, Title, CONVERT(nvarchar(MAX), Body), [Read] FROM dbo.tbdUser_Message WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tbdUser_Message OFF
GO
DROP TABLE dbo.tbdUser_Message
GO
EXECUTE sp_rename N'dbo.Tmp_tbdUser_Message', N'tbdUser_Message', 'OBJECT' 
GO
ALTER TABLE dbo.tbdUser_Message ADD CONSTRAINT
	PK_PrivateMessage PRIMARY KEY CLUSTERED 
	(
	UserMessageID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX _dta_index_PrivateMessage_5_754101727__K6_K10 ON dbo.tbdUser_Message
	(
	RecipientUserID,
	[Read]
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tbdUser_Message WITH NOCHECK ADD CONSTRAINT
	FK_PrivateMessage_AuthorUser FOREIGN KEY
	(
	AuthorUserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdUser_Message WITH NOCHECK ADD CONSTRAINT
	FK_PrivateMessage_RecipientUser FOREIGN KEY
	(
	RecipientUserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
