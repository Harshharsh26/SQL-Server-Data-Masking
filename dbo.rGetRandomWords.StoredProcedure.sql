USE [MaskDB]
GO
/****** Object:  StoredProcedure [dbo].[rGetRandomWords]    Script Date: 1/1/2018 11:50:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[rGetRandomWords](@Dict varchar(10),@MinLen varchar(10), @MaxLen varchar(10), @Count int)
as
Begin

Declare @Object as Int,@split as int;
Declare @ResponseText as Varchar(8000);
Declare @ApiURL as nVarchar(max);
Create Table #tmp_words (stringvalue varchar(max));

Set @split = 50

WHILE (1=1)
BEGIN
	
	if (@Count > @split)
	Begin
		print 'Batch - ' + cast(@split as varchar)
		Set @ApiURL = 'http://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef='+@Dict+'&minCorpusCount=0&minLength='
				+@MinLen+'&maxLength='+@Maxlen+'&limit='+cast(@split as nvarchar(10))+'&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5'

		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
						 @ApiURL,
						 'false'
		Exec sp_OAMethod @Object, 'send'
		Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

		Insert into #tmp_words 
		Select stringvalue from parseJSON(@ResponseText)
		where name like 'word'
		Exec sp_OADestroy @Object
		set @Count = @Count - @split
	end
	else
	Begin		
		Print 'Batch end -'  + cast(@Count as varchar);
		Set @ApiURL = 'http://api.wordnik.com/v4/words.json/randomWords?hasDictionaryDef='+@Dict+'&minCorpusCount=0&minLength='
				+@MinLen+'&maxLength='+@Maxlen+'&limit='+cast(@Count as nvarchar(10))+'&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5'
		
		Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
		Exec sp_OAMethod @Object, 'open', NULL, 'get',
						 @ApiURL,
						 'false'
		Exec sp_OAMethod @Object, 'send'
		Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

		Insert into #tmp_words 
		Select stringvalue from parseJSON(@ResponseText)
		where name like 'word'
		Exec sp_OADestroy @Object
		Break;
	End
END;
select * from #tmp_words
End
GO
