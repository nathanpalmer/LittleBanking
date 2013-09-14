USE [master]
GO
if not exists (select null from sys.syslogins where name = 'LittleBankingUser')
	CREATE LOGIN [LittleBankingUser] WITH PASSWORD=N'zcmp3DbhxbMa', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [LittleBanking]
GO
if not exists (select null from sysusers where name = 'LittleBankingUser')
	CREATE USER [LittleBankingUser] FOR LOGIN [LittleBankingUser]
GO
USE [LittleBanking]
GO
EXEC sp_addrolemember N'db_owner', N'LittleBankingUser'
GO
