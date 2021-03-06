USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rGetDistinctWords]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[rGetDistinctWords](@table varchar(max),@column varchar(max))
As
Begin
DECLARE @sqlCommand varchar(max)

SET @sqlCommand = 'SELECT distinct dbo.RemoveSpecialChars(Data)
  FROM '+@table+' AS s
  CROSS APPLY dbo.Split(s.'+@column+', '' '')
  where ISNUMERIC(dbo.RemoveSpecialChars(Data)) = 0 and dbo.RemoveSpecialChars(Data) is not null'

EXEC (@sqlCommand)

End
GO
