/*
   Friday, May 21, 20108:10:50 PM
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
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_LastComment
GO
ALTER TABLE dbo.tbdComment SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_tbeState_Area
GO
ALTER TABLE dbo.tbeState_Area SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_RoleView
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_RoleCreate
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_RollModerate
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_tbdArea_Role
GO
ALTER TABLE dbo.tbmRole SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_Tier
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_Order
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_DateCreated
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_CommentsAllowed
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_PreCache
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_AreaCount
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_PostCount
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT DF_tbdArea_CommentCount
GO
CREATE TABLE dbo.Tmp_tbdArea
	(
	AreaID int NOT NULL IDENTITY (1, 1),
	ParentAreaID int NULL,
	Tier tinyint NOT NULL,
	[Order] tinyint NOT NULL,
	DateCreated datetime NOT NULL,
	DateModified datetime NULL,
	DateLastAction datetime NOT NULL,
	Name nvarchar(250) NOT NULL,
	Description nvarchar(MAX) NOT NULL,
	DescriptionRaw nvarchar(MAX) NOT NULL,
	PreCache bit NOT NULL,
	StateAreaID tinyint NOT NULL,
	PostRoleIDView int NOT NULL,
	PostRoleIDCreate int NOT NULL,
	PostRoleIDModerate int NOT NULL,
	PostRoleIDDelete int NOT NULL,
	CommentRoleIDView int NULL,
	CommentRoleIDCreate int NULL,
	CommentRoleIDModerate int NULL,
	CommentRoleIDDelete int NULL,
	AreaCount int NOT NULL,
	PostCount int NOT NULL,
	CommentCount int NOT NULL,
	LastPostID int NULL,
	LastCommentID int NULL,
	Action xml NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tbdArea SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_Tier DEFAULT ((0)) FOR Tier
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_Order DEFAULT ((0)) FOR [Order]
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_PreCache DEFAULT ((1)) FOR PreCache
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_AreaCount DEFAULT ((0)) FOR AreaCount
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_PostCount DEFAULT ((0)) FOR PostCount
GO
ALTER TABLE dbo.Tmp_tbdArea ADD CONSTRAINT
	DF_tbdArea_CommentCount DEFAULT ((0)) FOR CommentCount
GO
SET IDENTITY_INSERT dbo.Tmp_tbdArea ON
GO
IF EXISTS(SELECT * FROM dbo.tbdArea)
	 EXEC('INSERT INTO dbo.Tmp_tbdArea (AreaID, ParentAreaID, Tier, [Order], DateCreated, DateModified, DateLastAction, Name, Description, DescriptionRaw, PreCache, StateAreaID, PostRoleIDView, PostRoleIDCreate, PostRoleIDModerate, PostRoleIDDelete, AreaCount, PostCount, CommentCount, LastPostID, LastCommentID, Action)
		SELECT AreaID, ParentAreaID, Tier, [Order], DateCreated, DateModified, DateLastAction, Name, Description, DescriptionRaw, PreCache, StateAreaID, RoleIDView, RoleIDCreate, RoleIDModerate, RoleIDDelete, AreaCount, PostCount, CommentCount, LastPostID, LastCommentID, Action FROM dbo.tbdArea WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tbdArea OFF
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_Forum_LastPost
GO
ALTER TABLE dbo.tbdPost
	DROP CONSTRAINT FK_Node_Forum
GO
ALTER TABLE dbo.tbdArea
	DROP CONSTRAINT FK_tbdArea_tbdArea
GO
ALTER TABLE dbo.tbdPost_Tracking
	DROP CONSTRAINT FK_topic_track_Forum
GO
ALTER TABLE dbo.tbdArea_Tracking
	DROP CONSTRAINT FK_forum_track_Forum
GO
DROP TABLE dbo.tbdArea
GO
EXECUTE sp_rename N'dbo.Tmp_tbdArea', N'tbdArea', 'OBJECT' 
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	PK_Forum PRIMARY KEY CLUSTERED 
	(
	AreaID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tbdArea WITH NOCHECK ADD CONSTRAINT
	FK_tbdArea_tbdRole_PostView FOREIGN KEY
	(
	PostRoleIDView
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea WITH NOCHECK ADD CONSTRAINT
	FK_tbdArea_tbdRole_PostCreate FOREIGN KEY
	(
	PostRoleIDCreate
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea WITH NOCHECK ADD CONSTRAINT
	FK_tbdArea_tbdRole_PostModerate FOREIGN KEY
	(
	PostRoleIDModerate
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbdRole_PostDelete FOREIGN KEY
	(
	PostRoleIDDelete
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbeState_Area FOREIGN KEY
	(
	StateAreaID
	) REFERENCES dbo.tbeState_Area
	(
	StateAreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_LastComment FOREIGN KEY
	(
	LastCommentID
	) REFERENCES dbo.tbdComment
	(
	CommentID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbdArea_Parent FOREIGN KEY
	(
	ParentAreaID
	) REFERENCES dbo.tbdArea
	(
	AreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbmRole_CommentView FOREIGN KEY
	(
	CommentRoleIDView
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbmRole_CommentCreate FOREIGN KEY
	(
	CommentRoleIDCreate
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbmRole_CommentModerate FOREIGN KEY
	(
	CommentRoleIDModerate
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_tbmRole_CommentDelete FOREIGN KEY
	(
	CommentRoleIDDelete
	) REFERENCES dbo.tbmRole
	(
	RoleID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea_Tracking WITH NOCHECK ADD CONSTRAINT
	FK_tbdArea_tbdArea_Tracking FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.tbdArea
	(
	AreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdArea_Tracking SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdPost_Tracking WITH NOCHECK ADD CONSTRAINT
	FK_tbdPost_Tracking_tbdArea FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.tbdArea
	(
	AreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdPost_Tracking SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tbdArea ADD CONSTRAINT
	FK_tbdArea_LastPost FOREIGN KEY
	(
	LastPostID
	) REFERENCES dbo.tbdPost
	(
	PostID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdPost WITH NOCHECK ADD CONSTRAINT
	FK_tbdArea_tbdPost FOREIGN KEY
	(
	AreaID
	) REFERENCES dbo.tbdArea
	(
	AreaID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tbdPost SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
