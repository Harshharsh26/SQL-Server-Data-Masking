USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rMaskTableInd]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[rMaskTableInd] 
As
begin
Declare @srcDBSchemaTable varchar(200),@srcColumn varchar(200),@tgtDBSchemaTable varchar(200),@tgtColumn varchar(200);

DECLARE get_TableList CURSOR FOR select Distinct srcDBSchemaTable,srcColumn,tgtDBSchemaTable,tgtColumn from rTableList where Status = 'Pending';
 OPEN get_TableList 
 FETCH NEXT FROM get_TableList into @srcDBSchemaTable,@srcColumn,@tgtDBSchemaTable,@tgtColumn;
 
 WHILE @@FETCH_STATUS = 0
  begin 
	Print 'Start Masking Table:' + @srcDBSchemaTable + ' Column:' + @srcColumn + ' To Table:' +@tgtDBSchemaTable + ' Column:' +@tgtColumn
	
	exec rLoadRWordsTbl @srcDBSchemaTable,@srcColumn

	exec rMaskColumn @srcDBSchemaTable,@srcColumn,@tgtDBSchemaTable,@tgtColumn
	
	update rTableList
	Set Status = 'Done'
	where srcDBSchemaTable = @srcDBSchemaTable and
		srcColumn = @srcColumn and tgtDBSchemaTable = @tgtDBSchemaTable and tgtColumn = @tgtColumn

   FETCH NEXT FROM get_TableList into  @srcDBSchemaTable,@srcColumn,@tgtDBSchemaTable,@tgtColumn;  
  end
 CLOSE get_TableList
 DEALLOCATE get_TableList

 End
GO
