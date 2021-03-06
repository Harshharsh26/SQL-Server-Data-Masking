USE [MaskDB]
GO
/****** Object:  Table [dbo].[rWords]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rWords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WordID] [int] NULL,
	[Word] [varchar](max) NULL,
	[WordLen] [int] NULL,
	[ModifiedDate] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
