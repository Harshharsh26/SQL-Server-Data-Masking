USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rLoadRWordsTbl]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[rLoadRWordsTbl] (@SrcTable_Full varchar(max),@SrcColumn varchar(100))
As
Begin
IF OBJECT_ID('tempdb..#tmp_DstWords') IS NOT NULL DROP TABLE #tmp_DstWords
	
Create Table #tmp_DstWords (words varchar(max))
Insert into #tmp_DstWords EXEC rGetDistinctWords @SrcTable_Full,@SrcColumn

truncate table rWords;

Declare @wordlen int, @cnt int
DECLARE get_Record1 CURSOR FOR select len(words) wordlen,count(1) cnt from #tmp_DstWords group by len(words);
 OPEN get_Record1 
 FETCH NEXT FROM get_Record1 into @wordlen,@cnt;
 
 WHILE @@FETCH_STATUS = 0
  begin 
	Print 'WordLen:' + cast(@wordlen as varchar) + ' Cnt:' + cast(@cnt as varchar)
	exec rLoadRandomWords @wordlen,@wordlen,@cnt

   FETCH NEXT FROM get_Record1 into @wordlen,@cnt;   
  end
 CLOSE get_Record1
 DEALLOCATE get_Record1

End



GO
