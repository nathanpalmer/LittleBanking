CREATE TABLE [dbo].[tbeRole_Type](
	[RoleTypeID] [tinyint] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tbeRole_Type] PRIMARY KEY CLUSTERED 
(
	[RoleTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO tbeRole_Type (RoleTypeID, Name)
VALUES (0, 'Custom')
GO

INSERT INTO tbeRole_Type (RoleTypeID, Name)
VALUES (1, 'Anonymous User')
GO

INSERT INTO tbeRole_Type (RoleTypeID, Name)
VALUES (2, 'Authenticated User')
GO

INSERT INTO tbeRole_Type (RoleTypeID, Name)
VALUES (3, 'Site Admin')
GO

ALTER TABLE [dbo].[tbmRole] DROP CONSTRAINT [DF_tbmRole_IsAnonymousRole]
GO

sp_RENAME 'tbmRole.IsAnonymousRole', 'RoleTypeID', 'COLUMN'
GO

ALTER TABLE tbmRole
	ALTER COLUMN RoleTypeID TINYINT NOT NULL
GO

ALTER TABLE [dbo].[tbmRole] ADD  CONSTRAINT [DF_tbmRole_RoleTypeID]  DEFAULT ((0)) FOR [RoleTypeID]
GO

-- Create filtered index
CREATE UNIQUE NONCLUSTERED INDEX UQ_tbmRole_RoleType ON dbo.tbmRole
(
	RoleTypeID
) 
WHERE RoleTypeID > 0
GO

-- Add foreign key 
ALTER TABLE dbo.tbmRole ADD CONSTRAINT
FK_tbmRole_tbeRole_Type FOREIGN KEY
(
RoleTypeID
) REFERENCES dbo.tbeRole_Type
(
RoleTypeID
) ON UPDATE  NO ACTION 
 ON DELETE  NO ACTION 
 