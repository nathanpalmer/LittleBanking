ALTER TABLE dbo.tbdUser_Statistics
	DROP CONSTRAINT DF_tbdUser_Statistics_TotalLogins
GO

ALTER TABLE dbo.tbdUser_Statistics
	DROP CONSTRAINT DF_tbdUser_Statistics_TotalLoginAttempts
GO

ALTER TABLE dbo.tbdUser_Statistics
	DROP CONSTRAINT DF_tbdUser_Statistics_TotalPosts
GO

ALTER TABLE dbo.tbdUser_Statistics
	DROP CONSTRAINT DF_tbdUser_Statistics_TotalComments
GO

CREATE TABLE dbo.Tmp_tbdUser_Statistics
	(
	UserID int NOT NULL,
	DateCreated datetime NOT NULL,
	DateLastAccessed datetime NOT NULL,
	DateLastLogin datetime NOT NULL,
	DateLastMark datetime NOT NULL,
	DateLastOperation datetime NULL
	)  ON [PRIMARY]
GO

ALTER TABLE dbo.Tmp_tbdUser_Statistics SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tbdUser_Statistics)
	 EXEC('INSERT INTO dbo.Tmp_tbdUser_Statistics (UserID)
		SELECT UserID FROM dbo.tbdUser_Statistics WITH (HOLDLOCK TABLOCKX)')
GO

DROP TABLE dbo.tbdUser_Statistics
GO

EXECUTE sp_rename N'dbo.Tmp_tbdUser_Statistics', N'tbdUser_Statistics', 'OBJECT' 
GO

INSERT INTO tbdUser_Statistics ( UserID, DateCreated, DateLastAccessed, DateLastLogin, DateLastMark, DateLastOperation )
SELECT UserID, DateCreated, DateLastAccessed, DateLastLogin, DateLastMark, DateLastOperation 
FROM tbdUser
GO

ALTER TABLE dbo.tbdUser
	DROP CONSTRAINT FK_User_State_User
GO

ALTER TABLE dbo.tbeState_User SET (LOCK_ESCALATION = TABLE)
GO

CREATE TABLE dbo.Tmp_tbdUser
	(
	UserID int NOT NULL IDENTITY (1, 1),
	UserName nvarchar(60) NOT NULL,
	LoginName nvarchar(255) NOT NULL,
	Password nvarchar(50) NOT NULL,
	Email nvarchar(64) NULL,
	FirstName nvarchar(100) NULL,
	LastName nvarchar(100) NULL,
	Phone nvarchar(10) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tbdUser (UserID, UserName, LoginName, Password, Email, AvatarUrl, Subnick, Location, HomePage, ProviderUserKey, OneTimeLogin, StateUserID)
		SELECT UserID, UserName, LoginName, Password, Email, AvatarUrl, Subnick, Location, HomePage, ProviderUserKey, OneTimeLogin, StateUserID FROM dbo.tbdUser WITH (HOLDLOCK TABLOCKX)')
GO

SET IDENTITY_INSERT dbo.Tmp_tbdUser OFF
GO

ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_AuthorUser
GO

ALTER TABLE dbo.tbdUser_Message
	DROP CONSTRAINT FK_PrivateMessage_RecipientUser
GO

--ALTER TABLE dbo.tbdUser_Statistics
--	DROP CONSTRAINT FK_tbdUser_tbdUser_Statistics
--GO

ALTER TABLE dbo.tbdPost_Rank
	DROP CONSTRAINT FK_tbdPost_Rank_tbdUser
GO

IF EXISTS ( SELECT null FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'tbcProduct_User_Price' AND Constraint_Name = 'FK_Product_User_Price_User' )
EXEC('ALTER TABLE dbo.tbcProduct_User_Price	DROP CONSTRAINT FK_Product_User_Price_User')
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

CREATE UNIQUE NONCLUSTERED INDEX UQ_tbdUser_UserName ON dbo.tbdUser
	(
	UserName
	) INCLUDE (UserID, LoginName, Password, Email, AvatarUrl, Subnick, Location, HomePage, ProviderUserKey, OneTimeLogin, StateUserID) 
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

ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	FK_tbdPost_Rank_tbdUser FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

ALTER TABLE dbo.tbdPost_Rank SET (LOCK_ESCALATION = TABLE)
GO

ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	PK_tbdUser_Statistics PRIMARY KEY CLUSTERED 
	(
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	FK_tbdUser_tbdUser_Statistics FOREIGN KEY
	(
	UserID
	) REFERENCES dbo.tbdUser
	(
	UserID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
