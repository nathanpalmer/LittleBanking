CREATE TABLE [dbo].[tbcPost_Song](
	[PostID] [int] NOT NULL,
	[Genre] [varchar](100) NULL,
	[SongID] [int] NULL,
	[Song] [varchar](100) NULL,
	[ArtistID] [int] NULL,
	[Artist] [varchar](100) NULL,
 CONSTRAINT [PK_tbcPost_Song] PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO