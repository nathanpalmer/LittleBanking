ALTER TABLE [dbo].[tbdArea] DROP CONSTRAINT [DF_tbdArea_PreCache]
ALTER TABLE dbo.tbdArea DROP COLUMN PreCache

DROP INDEX [IX_Node_TopicID] ON [dbo].[tbdPost] WITH ( ONLINE = OFF )
ALTER TABLE dbo.tbdPost DROP COLUMN TopicID
