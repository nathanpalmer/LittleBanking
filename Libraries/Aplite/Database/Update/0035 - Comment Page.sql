ALTER TABLE dbo.tbdComment ADD
	Page int NOT NULL CONSTRAINT DF_tbdComment_Page DEFAULT 0
GO

ALTER TABLE dbo.tbdArea ADD
	PostPerPage int NOT NULL CONSTRAINT DF_tbdArea_PostPerPage DEFAULT 20
GO