/*
Run this script on:

        MAIN.test    -  This database will be modified

to synchronize it with:

        MAIN.VoteForTheWorst

You are recommended to back up your database before running this script

Script created by SQL Compare version 8.2.0 from Red Gate Software Ltd at 5/19/2010 5:23:30 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [dbo].[tbpPoll_Choice]'
GO
CREATE TABLE [dbo].[tbpPoll_Choice]
(
[PollChoiceID] [int] NOT NULL IDENTITY(1, 1),
[PollID] [int] NOT NULL,
[Choice] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Votes] [int] NOT NULL CONSTRAINT [DF_Poll_Choice_Votes] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Poll_Choices] on [dbo].[tbpPoll_Choice]'
GO
ALTER TABLE [dbo].[tbpPoll_Choice] ADD CONSTRAINT [PK_Poll_Choices] PRIMARY KEY CLUSTERED  ([PollChoiceID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbcSmilies]'
GO
CREATE TABLE [dbo].[tbcSmilies]
(
[SmileyID] [int] NOT NULL IDENTITY(1, 1),
[Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[URL] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Emoticon] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Smilies_enabled] DEFAULT ((1))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Smilies] on [dbo].[tbcSmilies]'
GO
ALTER TABLE [dbo].[tbcSmilies] ADD CONSTRAINT [PK_Smilies] PRIMARY KEY CLUSTERED  ([SmileyID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdUser_Message]'
GO
CREATE TABLE [dbo].[tbdUser_Message]
(
[UserMessageID] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NOT NULL,
[AuthorUserID] [int] NOT NULL,
[AuthorIP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorDelete] [bit] NOT NULL,
[RecipientUserID] [int] NOT NULL,
[RecipientDelete] [bit] NOT NULL,
[Title] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Body] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Read] [bit] NOT NULL CONSTRAINT [DF_PrivateMessage_Read] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_PrivateMessage] on [dbo].[tbdUser_Message]'
GO
ALTER TABLE [dbo].[tbdUser_Message] ADD CONSTRAINT [PK_PrivateMessage] PRIMARY KEY CLUSTERED  ([UserMessageID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [_dta_index_PrivateMessage_5_754101727__K6_K10] on [dbo].[tbdUser_Message]'
GO
CREATE NONCLUSTERED INDEX [_dta_index_PrivateMessage_5_754101727__K6_K10] ON [dbo].[tbdUser_Message] ([RecipientUserID], [Read])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdSite_IP]'
GO
CREATE TABLE [dbo].[tbdSite_IP]
(
[IP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateCreated] [datetime] NOT NULL,
[DateLastAccessed] [datetime] NOT NULL,
[DateBanned] [datetime] NULL,
[Banned] [bit] NOT NULL CONSTRAINT [DF_IP_Banned] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_IP] on [dbo].[tbdSite_IP]'
GO
ALTER TABLE [dbo].[tbdSite_IP] ADD CONSTRAINT [PK_IP] PRIMARY KEY CLUSTERED  ([IP])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [_dta_index_IP_5_1941581955__K5_1_2_3_4] on [dbo].[tbdSite_IP]'
GO
CREATE NONCLUSTERED INDEX [_dta_index_IP_5_1941581955__K5_1_2_3_4] ON [dbo].[tbdSite_IP] ([Banned]) INCLUDE ([DateBanned], [DateCreated], [DateLastAccessed], [IP])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbeFormat]'
GO
CREATE TABLE [dbo].[tbeFormat]
(
[FormatID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Format] on [dbo].[tbeFormat]'
GO
ALTER TABLE [dbo].[tbeFormat] ADD CONSTRAINT [PK_Format] PRIMARY KEY CLUSTERED  ([FormatID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdComment_Raw]'
GO
CREATE TABLE [dbo].[tbdComment_Raw]
(
[CommentID] [int] NOT NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreaterIP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Comment_Raw] on [dbo].[tbdComment_Raw]'
GO
ALTER TABLE [dbo].[tbdComment_Raw] ADD CONSTRAINT [PK_Comment_Raw] PRIMARY KEY CLUSTERED  ([CommentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbeState_Content]'
GO
CREATE TABLE [dbo].[tbeState_Content]
(
[StateContentID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_State_Content] on [dbo].[tbeState_Content]'
GO
ALTER TABLE [dbo].[tbeState_Content] ADD CONSTRAINT [PK_State_Content] PRIMARY KEY CLUSTERED  ([StateContentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdUser]'
GO
CREATE TABLE [dbo].[tbdUser]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[UserName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL,
[DateLastAccessed] [datetime] NOT NULL,
[DateLastLogin] [datetime] NOT NULL,
[DateLastMark] [datetime] NOT NULL,
[DateLastOperation] [datetime] NULL,
[AvatarUrl] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subnick] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePage] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderUserKey] [uniqueidentifier] NULL,
[OneTimeLogin] [uniqueidentifier] NULL,
[StateUserID] [tinyint] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_User] on [dbo].[tbdUser]'
GO
ALTER TABLE [dbo].[tbdUser] ADD CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED  ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [_dta_index_User_5_1730105204__K2_1_3_4_5_6_7_8_9_10_11_12_13_14_16_17] on [dbo].[tbdUser]'
GO
CREATE NONCLUSTERED INDEX [_dta_index_User_5_1730105204__K2_1_3_4_5_6_7_8_9_10_11_12_13_14_16_17] ON [dbo].[tbdUser] ([UserName]) INCLUDE ([AvatarUrl], [DateCreated], [DateLastAccessed], [DateLastLogin], [DateLastMark], [DateLastOperation], [Email], [HomePage], [Location], [OneTimeLogin], [Password], [ProviderUserKey], [StateUserID], [Subnick], [UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbmRole]'
GO
CREATE TABLE [dbo].[tbmRole]
(
[RoleID] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Role] on [dbo].[tbmRole]'
GO
ALTER TABLE [dbo].[tbmRole] ADD CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED  ([RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbeState_Area]'
GO
CREATE TABLE [dbo].[tbeState_Area]
(
[StateAreaID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_State_Area] on [dbo].[tbeState_Area]'
GO
ALTER TABLE [dbo].[tbeState_Area] ADD CONSTRAINT [PK_State_Area] PRIMARY KEY CLUSTERED  ([StateAreaID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbeStatus]'
GO
CREATE TABLE [dbo].[tbeStatus]
(
[StatusID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Status] on [dbo].[tbeStatus]'
GO
ALTER TABLE [dbo].[tbeStatus] ADD CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED  ([StatusID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbmType]'
GO
CREATE TABLE [dbo].[tbmType]
(
[TypeID] [tinyint] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Type] on [dbo].[tbmType]'
GO
ALTER TABLE [dbo].[tbmType] ADD CONSTRAINT [PK_Type] PRIMARY KEY CLUSTERED  ([TypeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbcPost_Radio]'
GO
CREATE TABLE [dbo].[tbcPost_Radio]
(
[PostRadioID] [int] NOT NULL IDENTITY(1, 1),
[PostID] [int] NOT NULL,
[Date] [datetime] NULL,
[Duration] [tinyint] NULL,
[FileName] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_NodeRadio] on [dbo].[tbcPost_Radio]'
GO
ALTER TABLE [dbo].[tbcPost_Radio] ADD CONSTRAINT [PK_NodeRadio] PRIMARY KEY CLUSTERED  ([PostRadioID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_NodeRadio_NodeID] on [dbo].[tbcPost_Radio]'
GO
CREATE NONCLUSTERED INDEX [IX_NodeRadio_NodeID] ON [dbo].[tbcPost_Radio] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbcPost_SiteBanner]'
GO
CREATE TABLE [dbo].[tbcPost_SiteBanner]
(
[PostSiteBannerID] [int] NOT NULL IDENTITY(1, 1),
[PostID] [int] NOT NULL,
[ImageName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_NodeSiteBanner] on [dbo].[tbcPost_SiteBanner]'
GO
ALTER TABLE [dbo].[tbcPost_SiteBanner] ADD CONSTRAINT [PK_NodeSiteBanner] PRIMARY KEY CLUSTERED  ([PostSiteBannerID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_NodeSiteBanner_NodeID] on [dbo].[tbcPost_SiteBanner]'
GO
CREATE NONCLUSTERED INDEX [IX_NodeSiteBanner_NodeID] ON [dbo].[tbcPost_SiteBanner] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdPost_Tag]'
GO
CREATE TABLE [dbo].[tbdPost_Tag]
(
[PostID] [int] NOT NULL,
[TagID] [int] NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__NodeTag__3214EC2733D4B598] on [dbo].[tbdPost_Tag]'
GO
ALTER TABLE [dbo].[tbdPost_Tag] ADD CONSTRAINT [PK__NodeTag__3214EC2733D4B598] PRIMARY KEY CLUSTERED  ([PostID], [TagID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_NodeTag_NodeID] on [dbo].[tbdPost_Tag]'
GO
CREATE NONCLUSTERED INDEX [IX_NodeTag_NodeID] ON [dbo].[tbdPost_Tag] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbmTag]'
GO
CREATE TABLE [dbo].[tbmTag]
(
[TagID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__Tag__3214EC272D27B809] on [dbo].[tbmTag]'
GO
ALTER TABLE [dbo].[tbmTag] ADD CONSTRAINT [PK__Tag__3214EC272D27B809] PRIMARY KEY CLUSTERED  ([TagID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbpPoll_Tracking]'
GO
CREATE TABLE [dbo].[tbpPoll_Tracking]
(
[PollTrackingID] [int] NOT NULL IDENTITY(1, 1),
[PollID] [int] NOT NULL,
[UserIP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Poll_Tracking_Poll_IP] on [dbo].[tbpPoll_Tracking]'
GO
ALTER TABLE [dbo].[tbpPoll_Tracking] ADD CONSTRAINT [PK_Poll_Tracking_Poll_IP] PRIMARY KEY CLUSTERED  ([PollTrackingID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbeState_User]'
GO
CREATE TABLE [dbo].[tbeState_User]
(
[StateUserID] [tinyint] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_State_User] on [dbo].[tbeState_User]'
GO
ALTER TABLE [dbo].[tbeState_User] ADD CONSTRAINT [PK_State_User] PRIMARY KEY CLUSTERED  ([StateUserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdUser_IP]'
GO
CREATE TABLE [dbo].[tbdUser_IP]
(
[UserIPID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[IP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateCreated] [datetime] NOT NULL,
[DateLastAccessed] [datetime] NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserIP] on [dbo].[tbdUser_IP]'
GO
ALTER TABLE [dbo].[tbdUser_IP] ADD CONSTRAINT [PK_UserIP] PRIMARY KEY CLUSTERED  ([UserIPID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_UserIP_UserID] on [dbo].[tbdUser_IP]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserIP_UserID] ON [dbo].[tbdUser_IP] ([IP], [UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdUser_Role]'
GO
CREATE TABLE [dbo].[tbdUser_Role]
(
[UserID] [int] NOT NULL,
[RoleID] [int] NOT NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_UserRole] on [dbo].[tbdUser_Role]'
GO
ALTER TABLE [dbo].[tbdUser_Role] ADD CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED  ([UserID], [RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [_dta_index_UserRole_6_1109578991__K3_K2] on [dbo].[tbdUser_Role]'
GO
CREATE NONCLUSTERED INDEX [_dta_index_UserRole_6_1109578991__K3_K2] ON [dbo].[tbdUser_Role] ([RoleID], [UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_UserRole_UserID] on [dbo].[tbdUser_Role]'
GO
CREATE NONCLUSTERED INDEX [IX_UserRole_UserID] ON [dbo].[tbdUser_Role] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdComment]'
GO
CREATE TABLE [dbo].[tbdComment]
(
[CommentID] [int] NOT NULL IDENTITY(1, 1),
[PostID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[UserIDModerated] [int] NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_tbdComment_DateCreated] DEFAULT (getdate()),
[DateModified] [datetime] NULL,
[DateLastAction] [datetime] NOT NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormatID] [tinyint] NOT NULL,
[StateContentID] [tinyint] NOT NULL,
[Rank] [smallint] NOT NULL CONSTRAINT [DF_Comment_Rank] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Comment] on [dbo].[tbdComment]'
GO
ALTER TABLE [dbo].[tbdComment] ADD CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED  ([CommentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [_dta_index_tbdComment_5_814625945__K2_K10_K3_K4_K5_1_6_7_8_9_11] on [dbo].[tbdComment]'
GO
CREATE NONCLUSTERED INDEX [_dta_index_tbdComment_5_814625945__K2_K10_K3_K4_K5_1_6_7_8_9_11] ON [dbo].[tbdComment] ([PostID], [StateContentID], [UserID], [UserIDModerated], [DateCreated]) INCLUDE ([Body], [CommentID], [DateLastAction], [DateModified], [FormatID], [Rank])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [INX_tbdComment_User_Post] on [dbo].[tbdComment]'
GO
CREATE NONCLUSTERED INDEX [INX_tbdComment_User_Post] ON [dbo].[tbdComment] ([UserID], [PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating statistics [_dta_stat_814625945_10_2_3_4_5] on [dbo].[tbdComment]'
GO
CREATE STATISTICS [_dta_stat_814625945_10_2_3_4_5] ON [dbo].[tbdComment] ([StateContentID], [PostID], [UserID], [UserIDModerated], [DateCreated])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating statistics [_dta_stat_814625945_3_4_2] on [dbo].[tbdComment]'
GO
CREATE STATISTICS [_dta_stat_814625945_3_4_2] ON [dbo].[tbdComment] ([UserID], [UserIDModerated], [PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating statistics [_dta_stat_814625945_5_2_10] on [dbo].[tbdComment]'
GO
CREATE STATISTICS [_dta_stat_814625945_5_2_10] ON [dbo].[tbdComment] ([DateCreated], [PostID], [StateContentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbpPoll]'
GO
CREATE TABLE [dbo].[tbpPoll]
(
[PollID] [int] NOT NULL IDENTITY(1, 1),
[PostID] [int] NULL,
[Question] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PollTrackingID] [tinyint] NOT NULL CONSTRAINT [DF_Poll_TrackingMethod] DEFAULT ((0)),
[DateStart] [datetime] NULL,
[DateEnd] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Poll_Active] DEFAULT ((1))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Poll] on [dbo].[tbpPoll]'
GO
ALTER TABLE [dbo].[tbpPoll] ADD CONSTRAINT [PK_Poll] PRIMARY KEY CLUSTERED  ([PollID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdArea_Tracking]'
GO
CREATE TABLE [dbo].[tbdArea_Tracking]
(
[UserID] [int] NOT NULL CONSTRAINT [DF__ForumTrac__user___0D7A0286] DEFAULT ((0)),
[AreaID] [int] NOT NULL CONSTRAINT [DF__ForumTrac__forum__0E6E26BF] DEFAULT ((0)),
[DateMarked] [datetime] NOT NULL CONSTRAINT [DF__ForumTrac__mark___0F624AF8] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_forum_track] on [dbo].[tbdArea_Tracking]'
GO
ALTER TABLE [dbo].[tbdArea_Tracking] ADD CONSTRAINT [PK_forum_track] PRIMARY KEY CLUSTERED  ([UserID], [AreaID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdPost_Tracking]'
GO
CREATE TABLE [dbo].[tbdPost_Tracking]
(
[UserID] [int] NOT NULL CONSTRAINT [DF__TopicTrac__user___123EB7A3] DEFAULT ((0)),
[PostID] [int] NOT NULL CONSTRAINT [DF__TopicTrac__topic__1332DBDC] DEFAULT ((0)),
[AreaID] [int] NOT NULL CONSTRAINT [DF__TopicTrac__forum__14270015] DEFAULT ((0)),
[DateMarked] [datetime] NOT NULL CONSTRAINT [DF__TopicTrac__mark___151B244E] DEFAULT ((0))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_topic_track] on [dbo].[tbdPost_Tracking]'
GO
ALTER TABLE [dbo].[tbdPost_Tracking] ADD CONSTRAINT [PK_topic_track] PRIMARY KEY CLUSTERED  ([UserID], [PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [forum_id] on [dbo].[tbdPost_Tracking]'
GO
CREATE NONCLUSTERED INDEX [forum_id] ON [dbo].[tbdPost_Tracking] ([AreaID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdPost]'
GO
CREATE TABLE [dbo].[tbdPost]
(
[PostID] [int] NOT NULL IDENTITY(1, 1),
[AreaID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[UserIDModerated] [int] NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Node_DateCreated] DEFAULT (getdate()),
[DateModified] [datetime] NULL,
[DateLastAction] [datetime] NOT NULL,
[TeaserPosition] [int] NOT NULL CONSTRAINT [DF_tbdPost_TeaserPosition] DEFAULT ((0)),
[Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Body] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HasPlugin] [bit] NOT NULL CONSTRAINT [DF_Node_HasPlugin] DEFAULT ((0)),
[Promote] [bit] NOT NULL CONSTRAINT [DF_tbdPost_Promote] DEFAULT ((0)),
[FormatID] [tinyint] NOT NULL,
[StateContentID] [tinyint] NOT NULL,
[StatusID] [tinyint] NOT NULL,
[TypeID] [tinyint] NOT NULL,
[Rank] [smallint] NOT NULL CONSTRAINT [DF_tbdPost_Rank] DEFAULT ((0)),
[CommentCount] [int] NOT NULL CONSTRAINT [DF_tbdPost_TotalChildCount] DEFAULT ((0)),
[LastCommentID] [int] NULL,
[BodyRaw] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserIP] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TopicID] [int] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Node] on [dbo].[tbdPost]'
GO
ALTER TABLE [dbo].[tbdPost] ADD CONSTRAINT [PK_Node] PRIMARY KEY CLUSTERED  ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Node_DateCreated] on [dbo].[tbdPost]'
GO
CREATE NONCLUSTERED INDEX [IX_Node_DateCreated] ON [dbo].[tbdPost] ([DateCreated])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Node_Title] on [dbo].[tbdPost]'
GO
CREATE NONCLUSTERED INDEX [IX_Node_Title] ON [dbo].[tbdPost] ([Title])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Node_TopicID] on [dbo].[tbdPost]'
GO
CREATE NONCLUSTERED INDEX [IX_Node_TopicID] ON [dbo].[tbdPost] ([TopicID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbdArea]'
GO
CREATE TABLE [dbo].[tbdArea]
(
[AreaID] [int] NOT NULL IDENTITY(1, 1),
[ParentAreaID] [int] NULL,
[Tier] [tinyint] NOT NULL CONSTRAINT [DF_tbdArea_Tier] DEFAULT ((0)),
[Order] [tinyint] NOT NULL CONSTRAINT [DF_tbdArea_Order] DEFAULT ((0)),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_tbdArea_DateCreated] DEFAULT (getdate()),
[DateModified] [datetime] NULL,
[DateLastAction] [datetime] NOT NULL,
[Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DescriptionRaw] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CommentsAllowed] [bit] NOT NULL CONSTRAINT [DF_tbdArea_CommentsAllowed] DEFAULT ((1)),
[PreCache] [bit] NOT NULL CONSTRAINT [DF_tbdArea_PreCache] DEFAULT ((1)),
[StateAreaID] [tinyint] NOT NULL,
[RoleIDView] [int] NOT NULL,
[RoleIDCreate] [int] NOT NULL,
[RoleIDModerate] [int] NOT NULL,
[RoleIDDelete] [int] NOT NULL,
[AreaCount] [int] NOT NULL CONSTRAINT [DF_tbdArea_AreaCount] DEFAULT ((0)),
[PostCount] [int] NOT NULL CONSTRAINT [DF_tbdArea_PostCount] DEFAULT ((0)),
[CommentCount] [int] NOT NULL CONSTRAINT [DF_tbdArea_CommentCount] DEFAULT ((0)),
[LastPostID] [int] NULL,
[LastCommentID] [int] NULL,
[Action] [xml] NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_Forum] on [dbo].[tbdArea]'
GO
ALTER TABLE [dbo].[tbdArea] ADD CONSTRAINT [PK_Forum] PRIMARY KEY CLUSTERED  ([AreaID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [dbo].[tbdComment]'
GO
ALTER TABLE [dbo].[tbdComment] ADD CONSTRAINT [CK_Comment_DateEditied_DateCreated] CHECK (([DateCreated]<[DateModified]))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [dbo].[tbmTag]'
GO
ALTER TABLE [dbo].[tbmTag] ADD CONSTRAINT [UQ__Tag__737584F6300424B4] UNIQUE NONCLUSTERED  ([Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbcPost_Radio]'
GO
ALTER TABLE [dbo].[tbcPost_Radio] ADD
CONSTRAINT [FK_NodeRadio_Node] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbcPost_SiteBanner]'
GO
ALTER TABLE [dbo].[tbcPost_SiteBanner] ADD
CONSTRAINT [FK_NodeSiteBanner_Node] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdArea_Tracking]'
GO
ALTER TABLE [dbo].[tbdArea_Tracking] ADD
CONSTRAINT [FK_forum_track_Forum] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[tbdArea] ([AreaID]),
CONSTRAINT [FK_forum_track_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tbdUser] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdPost]'
GO
ALTER TABLE [dbo].[tbdPost] ADD
CONSTRAINT [FK_Node_Forum] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[tbdArea] ([AreaID]),
CONSTRAINT [FK_Node_LastChild] FOREIGN KEY ([LastCommentID]) REFERENCES [dbo].[tbdComment] ([CommentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdPost_Tracking]'
GO
ALTER TABLE [dbo].[tbdPost_Tracking] ADD
CONSTRAINT [FK_topic_track_Forum] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[tbdArea] ([AreaID]),
CONSTRAINT [FK_topic_track_Topic] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID]),
CONSTRAINT [FK_topic_track_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tbdUser] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdArea]'
GO
ALTER TABLE [dbo].[tbdArea] ADD
CONSTRAINT [FK_Forum_RoleView] FOREIGN KEY ([RoleIDView]) REFERENCES [dbo].[tbmRole] ([RoleID]),
CONSTRAINT [FK_Forum_RoleCreate] FOREIGN KEY ([RoleIDCreate]) REFERENCES [dbo].[tbmRole] ([RoleID]),
CONSTRAINT [FK_Forum_RollModerate] FOREIGN KEY ([RoleIDModerate]) REFERENCES [dbo].[tbmRole] ([RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdPost_Tag]'
GO
ALTER TABLE [dbo].[tbdPost_Tag] ADD
CONSTRAINT [FK_NodeTag_Node] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID]),
CONSTRAINT [FK_NodeTag_Tag] FOREIGN KEY ([TagID]) REFERENCES [dbo].[tbmTag] ([TagID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbpPoll]'
GO
ALTER TABLE [dbo].[tbpPoll] ADD
CONSTRAINT [FK_Poll_Node] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdUser_IP]'
GO
ALTER TABLE [dbo].[tbdUser_IP] ADD
CONSTRAINT [FK_UserIP_IP] FOREIGN KEY ([IP]) REFERENCES [dbo].[tbdSite_IP] ([IP]),
CONSTRAINT [FK_UserIP_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tbdUser] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdUser_Message]'
GO
ALTER TABLE [dbo].[tbdUser_Message] ADD
CONSTRAINT [FK_PrivateMessage_AuthorUser] FOREIGN KEY ([AuthorUserID]) REFERENCES [dbo].[tbdUser] ([UserID]),
CONSTRAINT [FK_PrivateMessage_RecipientUser] FOREIGN KEY ([RecipientUserID]) REFERENCES [dbo].[tbdUser] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdUser_Role]'
GO
ALTER TABLE [dbo].[tbdUser_Role] ADD
CONSTRAINT [FK_UserRole_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tbdUser] ([UserID]),
CONSTRAINT [FK_UserRole_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[tbmRole] ([RoleID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbpPoll_Choice]'
GO
ALTER TABLE [dbo].[tbpPoll_Choice] ADD
CONSTRAINT [FK_Poll_Choices_Poll] FOREIGN KEY ([PollID]) REFERENCES [dbo].[tbpPoll] ([PollID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbpPoll_Tracking]'
GO
ALTER TABLE [dbo].[tbpPoll_Tracking] ADD
CONSTRAINT [FK_Poll_Tracking_Poll] FOREIGN KEY ([PollID]) REFERENCES [dbo].[tbpPoll] ([PollID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdArea]'
GO
ALTER TABLE [dbo].[tbdArea] ADD
CONSTRAINT [FK_tbdArea_tbdArea] FOREIGN KEY ([ParentAreaID]) REFERENCES [dbo].[tbdArea] ([AreaID]),
CONSTRAINT [FK_Forum_tbeState_Area] FOREIGN KEY ([StateAreaID]) REFERENCES [dbo].[tbeState_Area] ([StateAreaID]),
CONSTRAINT [FK_tbdArea_Role] FOREIGN KEY ([RoleIDDelete]) REFERENCES [dbo].[tbmRole] ([RoleID]),
CONSTRAINT [FK_Forum_LastPost] FOREIGN KEY ([LastPostID]) REFERENCES [dbo].[tbdPost] ([PostID]),
CONSTRAINT [FK_Forum_LastComment] FOREIGN KEY ([LastCommentID]) REFERENCES [dbo].[tbdComment] ([CommentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdComment_Raw]'
GO
ALTER TABLE [dbo].[tbdComment_Raw] ADD
CONSTRAINT [FK_Comment_Raw_Comment] FOREIGN KEY ([CommentID]) REFERENCES [dbo].[tbdComment] ([CommentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdPost]'
GO
ALTER TABLE [dbo].[tbdPost] ADD
CONSTRAINT [FK_Node_tbdComment] FOREIGN KEY ([LastCommentID]) REFERENCES [dbo].[tbdComment] ([CommentID]),
CONSTRAINT [FK_Node_Format] FOREIGN KEY ([FormatID]) REFERENCES [dbo].[tbeFormat] ([FormatID]),
CONSTRAINT [FK_Node_State_Content] FOREIGN KEY ([StateContentID]) REFERENCES [dbo].[tbeState_Content] ([StateContentID]),
CONSTRAINT [FK_Node_Status] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[tbeStatus] ([StatusID]),
CONSTRAINT [FK_Node_Type] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[tbmType] ([TypeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdComment]'
GO
ALTER TABLE [dbo].[tbdComment] ADD
CONSTRAINT [FK_Comment_Post] FOREIGN KEY ([PostID]) REFERENCES [dbo].[tbdPost] ([PostID]),
CONSTRAINT [FK_Comment_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tbdUser] ([UserID]),
CONSTRAINT [FK_Comment_User_Moderated] FOREIGN KEY ([UserIDModerated]) REFERENCES [dbo].[tbdUser] ([UserID]),
CONSTRAINT [FK_Comment_Format] FOREIGN KEY ([FormatID]) REFERENCES [dbo].[tbeFormat] ([FormatID]),
CONSTRAINT [FK_Comment_State_Content] FOREIGN KEY ([StateContentID]) REFERENCES [dbo].[tbeState_Content] ([StateContentID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [dbo].[tbdUser]'
GO
ALTER TABLE [dbo].[tbdUser] ADD
CONSTRAINT [FK_User_State_User] FOREIGN KEY ([StateUserID]) REFERENCES [dbo].[tbeState_User] ([StateUserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
