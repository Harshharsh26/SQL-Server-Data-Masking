USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rLoadRandomWords]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[rLoadRandomWords](@MinLen int, @MaxLen int, @EachCount int,@cleanload bit =0) as
Begin 

if (@cleanload = 1)
Begin
	Truncate Table rWords;
End
Create Table #tmp_wrdlst (word varchar(max));

DECLARE @cnt INT = @MinLen;

WHILE @cnt <= @MaxLen
BEGIN
    print 'Inserting Word with Len' + cast(@cnt as varchar)
	--TODO : Address duplicate words
	INSERT INTO #tmp_wrdlst EXEC rGetRandomWords 'true',@cnt,@cnt,@EachCount
   SET @cnt = @cnt + 1;
END;

Insert into rWords (Word, WordLen) select word, len(word) from #tmp_wrdlst

End



GO
