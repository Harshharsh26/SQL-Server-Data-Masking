USE [MaskDB]
GO
/****** Object:  Table [dbo].[rTableList]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rTableList](
	[srcDBSchemaTable] [varchar](200) NULL,
	[srcColumn] [varchar](100) NULL,
	[tgtDBSchemaTable] [varchar](200) NULL,
	[tgtColumn] [varchar](200) NULL,
	[Status] [varchar](10) NULL DEFAULT ('Pending'),
	[ModifiedDt] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
