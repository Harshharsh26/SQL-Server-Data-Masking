USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rGetDistinctWordsCnt]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[rGetDistinctWordsCnt](@table varchar(max),@column varchar(max))
As
Begin
DECLARE @sqlCommand varchar(max)

SET @sqlCommand = 'Select len(data) wordlen,count(1) cnt from ( SELECT distinct dbo.RemoveSpecialChars(Data) data
  FROM '+@table+' AS s
  CROSS APPLY dbo.Split(s.'+@column+', '' '')
  where ISNUMERIC(dbo.RemoveSpecialChars(Data)) = 0 and dbo.RemoveSpecialChars(Data) is not null ) a
  Group by len(data)'

EXEC (@sqlCommand)

End
GO
