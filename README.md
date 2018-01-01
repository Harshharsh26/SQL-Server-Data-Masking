# SQL-Server-Data-Masking
Data masking scripts - A WIP project

A simple project to setup masking structure using online dictionaries - 

Features:
1.Replaces the Complete set of word with a masked word across the table
2.Connects with webservices for getting Random words
3.Maintains the Word mapping across all rows (i.e distinct word will be always replaced by same masked substitute)

Tables:
1. rTableList : Holds the Source and Target Tables and columns which needs to be masked.
2.rWords
