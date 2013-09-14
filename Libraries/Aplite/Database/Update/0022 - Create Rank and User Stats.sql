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
CREATE TABLE dbo.tbdUser_Statistics
	(
	UserID int NOT NULL,
	TotalLogins int NOT NULL,
	TotalLoginAttempts int NOT NULL,
	TotalPosts int NOT NULL,
	TotalComments int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	DF_tbdUser_Statistics_TotalLogins DEFAULT 0 FOR TotalLogins
GO
ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	DF_tbdUser_Statistics_TotalLoginAttempts DEFAULT 0 FOR TotalLoginAttempts
GO
ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	DF_tbdUser_Statistics_TotalPosts DEFAULT 0 FOR TotalPosts
GO
ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	DF_tbdUser_Statistics_TotalComments DEFAULT 0 FOR TotalComments
GO
ALTER TABLE dbo.tbdUser_Statistics ADD CONSTRAINT
	PK_tbdUser_Statistics PRIMARY KEY CLUSTERED 
	(
	UserID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tbdUser_Statistics SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdPost SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tbdUser SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.tbdPost_Rank
	(
	UserID int NOT NULL,
	PostID int NOT NULL,
	AreaID int NOT NULL,
	DateInserted datetime NOT NULL,
	Rank smallint NOT NULL,
	Attempt int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	DF_tbdPost_Rank_DateInserted DEFAULT getdate() FOR DateInserted
GO
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	DF_tbdPost_Rank_Rank DEFAULT 0 FOR Rank
GO
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	DF_tbdPost_Rank_Attempt DEFAULT 0 FOR Attempt
GO
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	PK_tbdPost_Rank PRIMARY KEY CLUSTERED 
	(
	UserID,
	PostID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	FK_tbdPost_Rank_tbdPost FOREIGN KEY
	(
	PostID
	) REFERENCES dbo.tbdPost
	(
	PostID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.tbdPost_Rank ADD CONSTRAINT
	FK_tbdPost_Rank_tbdArea FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.tbdArea
	(
	AreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdPost_Rank SET (LOCK_ESCALATION = TABLE)
GO
COMMIT