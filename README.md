# SQL-Server-Data-Masking
Data masking scripts - A WIP project

A simple project to setup masking structure using online dictionaries - 

Features:
1.Replaces the Complete set of word with a masked word across the table.
2.Connects with webservices for getting Random words.
3.Maintains the Word mapping across all rows (i.e distinct word will be always replaced by same masked substitute).

Out of Scope:
1. Currently the logic does not replace numbers or special characters from column
2. Random word logic is specific to a column - using same random masked word across the DB is not considered.(WIP)

Tables:
1. rTableList : Holds the Source and Target Tables and columns which needs to be masked.
2. rWords : Holds the random words fetched from webservice.

Procedures:
1. rMaskTableInd : Final procedure to be called to mask all the Table/columns. It iterates through rTableList and calles other procedures for each entry. After each iteration updates the rTableList for completed set.
2. rLoadRWordsTbl : Loads Random words to Table rWords. It takes source tables name and column to be masked and reloads rWords table with random words for each distinct word within the column. First calculates the count and length of all distinct words and then calls rLoadRandomWords procedure for each word as per the length of the word.
3. rMaskColumn : Maps each word from source with the masked word and replaces in the target column.
4. rLoadRandomWords : Inserts words to rWords table. Calls rGetRandomWords by passing count and length of Random words needed.
5. rGetRandomWords : Call webservice and returns the list of Random words as per the count and length passed.
6. rGetDistinctWords : Gets Dsitinct words from Columns (For Ex - a Cell1 contains 'John Carry' and Cell2 contain 'Mary John' - it gets John,Mary and Carry as distinct words).

Functions:
1. parseJSON : Standard function to parse the webservice response which is in JSON format.
2. Split : Standard split function to get distinct words in a cell.
3. RemoveSpecialChars : Function to remove special characters from cell.
