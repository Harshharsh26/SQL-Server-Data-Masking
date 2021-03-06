USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rMaskColumn]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[rMaskColumn] (@SrcTable_Full varchar(max),@SrcColumn varchar(100),
@TgtTable_Full varchar(max),@TgtColumn varchar(100)) As
Begin
 
--set @SrcTable_Full = 'FundServices.warehouse.fpl_org_dim'
--set @SrcColumn = 'org_nme'
--set @TgtTable_Full = 'MaskDB.dbo.fpl_org_dim'
--set @TgtColumn = 'org_nme'
DECLARE @sqlCommand nvarchar(max)

IF OBJECT_ID('tempdb..##tmp_src') IS NOT NULL DROP TABLE ##tmp_src
SET @sqlCommand = 'SELECT distinct '+@SrcColumn+'
  into ##tmp_src FROM '+@SrcTable_Full+' AS s'

EXEC (@sqlCommand)
Declare @src_wrd varchar(max),@tgt_wrd varchar(max)
DECLARE @combinedString VARCHAR(MAX)

------------Create Mapping Table -----------
IF OBJECT_ID('tempdb..#tmp_DstWords') IS NOT NULL DROP TABLE #tmp_DstWords
Create Table #tmp_DstWords (words varchar(max))
Insert into #tmp_DstWords EXEC rGetDistinctWords @SrcTable_Full,@SrcColumn
-----Map Words
IF OBJECT_ID('tempdb..#tmp_map') IS NOT NULL DROP TABLE #tmp_map

 select * into #tmp_map
 from (select a.words src_wrd,len(a.words) src_len, ROW_NUMBER() over (partition by len(a.words) order by a.words ) src_id
 from #tmp_DstWords a) src
 left join (select b.word tgt_wrd,len(b.word) tgt_len, ROW_NUMBER() over (partition by len(b.word) order by b.word desc ) tgt_id from rWords b)
 tgt on src_id = tgt_id and src_len=tgt_len
 order by 2


--------------Loop and Update------------ 
DECLARE get_Record2 CURSOR FOR select * from ##tmp_src
 OPEN get_Record2 
 FETCH NEXT FROM get_Record2 into @src_wrd;
 
 WHILE @@FETCH_STATUS = 0
  begin 

	set @combinedString = ''
	select @combinedString = COALESCE(@combinedString + ' ', ' ') + isnull(REPLACE(data,dbo.RemoveSpecialChars(a.Data),isnull(b.tgt_wrd,dbo.RemoveSpecialChars(a.Data))),data)
	from dbo.Split(@src_wrd,' ') a
	left join #tmp_map b on dbo.RemoveSpecialChars(a.Data) = b.src_wrd

	--SET @sqlCommand = 'Update A Set ' +@TgtColumn+ ' = ''' + substring(@combinedString,2,len(@combinedstring)) + ''' from ' + @TgtTable_Full +' A Where ' + @TgtColumn +' = ''' + @src_wrd + ''';';
	SET @sqlCommand = 'Update A Set ' +@TgtColumn+ ' = substring(@combinedString,2,len(@combinedstring)) from ' + @TgtTable_Full +' A Where ' + @TgtColumn +' = @src_wrd ;';

	Print @sqlcommand
	--EXEC (@sqlCommand)
	EXEC sp_executesql @sqlCommand, N'@combinedString varchar(max),@src_wrd varchar(max)', @combinedString,@src_wrd;
			 
   FETCH NEXT FROM get_Record2 into @src_wrd;  
  end
 CLOSE get_Record2
 DEALLOCATE get_Record2

 IF OBJECT_ID('tempdb..##tmp_src') IS NOT NULL DROP TABLE ##tmp_src
 
 Print 'Done'

 End
GO
