IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbdUser]') AND name = N'_dta_index_User_5_1730105204__K2_1_3_4_5_6_7_8_9_10_11_12_13_14_16_17')
DROP INDEX [_dta_index_User_5_1730105204__K2_1_3_4_5_6_7_8_9_10_11_12_13_14_16_17] ON [dbo].[tbdUser] 
GO

CREATE UNIQUE NONCLUSTERED INDEX UQ_tbdUser_UserName ON dbo.tbdUser
(
	UserName
) 
INCLUDE 
( 
	[UserID]
	,[LoginName]
	,[Password]
	,[Email]
	,[DateCreated]
	,[DateLastAccessed]
	,[DateLastLogin]
	,[DateLastMark]
	,[DateLastOperation]
	,[AvatarUrl]
	,[Subnick]
	,[Location]
	,[HomePage]
	,[ProviderUserKey]
	,[OneTimeLogin]
	,[StateUserID]
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
