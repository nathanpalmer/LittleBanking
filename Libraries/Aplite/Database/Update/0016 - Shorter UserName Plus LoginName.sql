/*
   Sunday, August 22, 20101:23:37 PM
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
ALTER TABLE dbo.tbdUser
	DROP CONSTRAINT FK_User_State_User
GO
ALTER TABLE dbo.tbeState_User SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tbdUser
	(
	UserID int NOT NULL IDENTITY (1, 1),
	UserName nvarchar(60) NOT NULL,
	LoginName nvarchar(255) NULL,
	Password nvarchar(50) NOT NULL,
	Email nvarchar(64) NULL,
	DateCreated datetime NOT NULL,
	DateLastAccessed datetime NOT NULL,
	DateLastLogin datetime NOT NULL,
	DateLastMark datetime NOT NULL,
	DateLastOperation datetime NULL,
	AvatarUrl nvarchar(100) NULL,
	Subnick nvarchar(50) NULL,
	Location nvarchar(100) NULL,
	HomePage nvarchar(100) NULL,
	ProviderUserKey uniqueidentifier NULL,
	OneTimeLogin uniqueidentifier NULL,
	StateUserID tinyint NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbdUser SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tbdUser ON
GO
IF EXISTS(SELECT * FROM dbo.tbdUser)
	 EXEC('INSERT INTO dbo.Tmp_tbdUser (UserID, UserName, Password, Email, DateCreated, DateLastAccessed, DateLastLogin, DateLastMark, DateLastOperation, AvatarUrl, Subnick, Location, HomePage, ProviderUserKey, OneTimeLogin, StateUserID)
		SELECT UserID, CONVERT(nvarchar(60), UserName), Password, Email, DateCreated, DateLastAccessed, DateLastLogin, DateLastMark, DateLastOperation, AvatarUrl, Subnick, Location, HomePage, ProviderUserKey, OneTimeLogin, StateUserID FROM dbo.tbdUser WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tbdUser OFF
GO
ALTER TABLE dbo.tbdComment
	DROP CONSTRAINT FK_Comment_User
GO
ALTER TABLE dbo.tbdComment
	DROP CONSTRAINT FK_Comment_User_Moderated
GO
ALTER TABLE dbo.tbdUser_Role
	DROP CONSTRAINT FK_UserRole_User
GO
ALTER TABLE dbo.tbdUser_IP
	DROP CONSTRAINT FK_UserIP_User
GO
ALTER TABLE dbo.tbdPost_Tracking
	DROP CONSTRAINT FK_topic_track_User
GO
ALTER TABLE dbo.tbdArea_Tracking
	DROP CONSTRAINT FK_forum_track_User
GO
ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_AuthorUser
GO
ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_RecipientUser
GO
DROP TABLE dbo.tbdUser
GO
EXECUTE sp_rename N'dbo.Tmp_tbdUser', N'tbdUser', 'OBJECT' 
GO
ALTER TABLE dbo.tbdUser ADD CONSTRAINT
	PK_User PRIMARY KEY CLUSTERED 
	(
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX _dta_index_User_5_1730105204__K2_1_3_4_5_6_7_8_9_10_11_12_13_14_16_17 ON dbo.tbdUser
	(
	UserName
	) INCLUDE (AvatarUrl, DateCreated, DateLastAccessed, DateLastLogin, DateLastMark, DateLastOperation, Email, HomePage, Location, OneTimeLogin, Password, ProviderUserKey, StateUserID, Subnick, UserID) 
 WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tbdUser WITH NOCHECK ADD CONSTRAINT
	FK_User_State_User FOREIGN KEY
	(
	StateUserID
	) REFERENCES dbo.tbeState_User
	(
	StateUserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tbdUser_Message SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea_Tracking ADD CONSTRAINT
	FK_forum_track_User FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea_Tracking SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdPost_Tracking ADD CONSTRAINT
	FK_topic_track_User FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdPost_Tracking SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdUser_IP ADD CONSTRAINT
	FK_UserIP_User FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdUser_IP SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdUser_Role ADD CONSTRAINT
	FK_UserRole_User FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdUser_Role SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdComment ADD CONSTRAINT
	FK_Comment_User FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdComment ADD CONSTRAINT
	FK_Comment_User_Moderated FOREIGN KEY
	(
	UserIDModerated
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdComment SET (LOCK_ESCALATION = TABLE)
GO
UPDATE tbdUser SET LoginName = UserName
GO
COMMIT
