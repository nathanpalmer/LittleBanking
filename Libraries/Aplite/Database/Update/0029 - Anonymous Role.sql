if not exists (select null from INFORMATION_SCHEMA.COLUMNS c where c.COLUMN_NAME = 'IsAnonymousRole' and c.TABLE_NAME = 'tbmRole')
begin
ALTER TABLE dbo.tbmRole ADD
	IsAnonymousRole bit NOT NULL CONSTRAINT DF_tbmRole_IsAnonymousRole DEFAULT 0
end
go
UPDATE tbmRole 
SET IsAnonymousRole = 1
WHERE
	Title = 'Anonymous User'