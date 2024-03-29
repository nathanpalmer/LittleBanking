/*
Run this script on:

MAIN.CodeKaraoke    -  This database will be modified

to synchronize it with:

MAIN.VoteForTheWorst

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 8.1.0 from Red Gate Software Ltd at 5/19/2010 5:44:01 PM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)

-- Drop constraint FK_User_State_User from [dbo].[tbdUser]
ALTER TABLE [dbo].[tbdUser] DROP CONSTRAINT [FK_User_State_User]

-- Drop constraint FK_Forum_tbeState_Area from [dbo].[tbdArea]
ALTER TABLE [dbo].[tbdArea] DROP CONSTRAINT [FK_Forum_tbeState_Area]

-- Add 5 rows to [dbo].[tbeFormat]
INSERT INTO [dbo].[tbeFormat] ([FormatID], [Name]) VALUES (1, N'FilteredHtml')
INSERT INTO [dbo].[tbeFormat] ([FormatID], [Name]) VALUES (2, N'Php')
INSERT INTO [dbo].[tbeFormat] ([FormatID], [Name]) VALUES (3, N'FullHtml')
INSERT INTO [dbo].[tbeFormat] ([FormatID], [Name]) VALUES (4, N'RichText')
INSERT INTO [dbo].[tbeFormat] ([FormatID], [Name]) VALUES (5, N'BbCode')

-- Add 2 rows to [dbo].[tbeState_Area]
INSERT INTO [dbo].[tbeState_Area] ([StateAreaID], [Name]) VALUES (0, N'Active')
INSERT INTO [dbo].[tbeState_Area] ([StateAreaID], [Name]) VALUES (1, N'Inactive')

-- Add 4 rows to [dbo].[tbeState_Content]
INSERT INTO [dbo].[tbeState_Content] ([StateContentID], [Name]) VALUES (0, N'Normal')
INSERT INTO [dbo].[tbeState_Content] ([StateContentID], [Name]) VALUES (1, N'Locked')
INSERT INTO [dbo].[tbeState_Content] ([StateContentID], [Name]) VALUES (2, N'Deleted')
INSERT INTO [dbo].[tbeState_Content] ([StateContentID], [Name]) VALUES (3, N'Unpublished')

-- Add 3 rows to [dbo].[tbeState_User]
INSERT INTO [dbo].[tbeState_User] ([StateUserID], [Name]) VALUES (0, N'Not Activated')
INSERT INTO [dbo].[tbeState_User] ([StateUserID], [Name]) VALUES (1, N'Active')
INSERT INTO [dbo].[tbeState_User] ([StateUserID], [Name]) VALUES (2, N'Blocked')

-- Add 3 rows to [dbo].[tbeStatus]
INSERT INTO [dbo].[tbeStatus] ([StatusID], [Name]) VALUES (0, N'None')
INSERT INTO [dbo].[tbeStatus] ([StatusID], [Name]) VALUES (1, N'Sticky')
INSERT INTO [dbo].[tbeStatus] ([StatusID], [Name]) VALUES (2, N'Annoucement')

-- Add constraint FK_User_State_User to [dbo].[tbdUser]
ALTER TABLE [dbo].[tbdUser] WITH NOCHECK ADD CONSTRAINT [FK_User_State_User] FOREIGN KEY ([StateUserID]) REFERENCES [dbo].[tbeState_User] ([StateUserID])

-- Add constraint FK_Forum_tbeState_Area to [dbo].[tbdArea]
ALTER TABLE [dbo].[tbdArea] WITH NOCHECK ADD CONSTRAINT [FK_Forum_tbeState_Area] FOREIGN KEY ([StateAreaID]) REFERENCES [dbo].[tbeState_Area] ([StateAreaID])
COMMIT TRANSACTION
GO
