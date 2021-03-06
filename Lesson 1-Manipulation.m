{\rtf1\ansi\ansicpg936\deff0\nouicompat\deflang1033\deflangfe2052{\fonttbl{\f0\fnil\fcharset0 Calibri;}{\f1\fnil\fcharset134 \'cb\'ce\'cc\'e5;}}
{\colortbl ;\red192\green192\blue192;}
{\*\generator Riched20 10.0.14393}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\b\f0\fs44\lang2052 Database\par
\b0\fs22 First, we take a look what relational databases are and how they are organized:\par

\pard 
{\pntext\f0 1.\tab}{\*\pn\pnlvlbody\pnf0\pnindent0\pnstart1\pndec{\pntxta.}}
\fi-426\li426\sa200\sl276\slmult1 A relational database is a database that organizes information into one or more tables. \par
{\pntext\f0 2.\tab}A table is a collection of data organized into rows and columns. Tables are sometimes referred to as relations(it can identify get data from which table). \par
{\pntext\f0 3.\tab}A column is a set of data values of a particular type, eg: id, name, and age are each columns. \par
{\pntext\f0 4.\tab}A row is a single record in a table\par

\pard\sa200\sl276\slmult1\par
\par
\b\fs44 Statements\par
\b0\fs22 CREATE TABLE table_name (\par
    column_1 data_type, \par
    column_2 data_type, \par
    column_3 data_type\par
  );\par
The above code is a SQL statement. A statement is text that the database recognizes as a valid command. \ul Statements always end in a semi-colon ;.\ulnone\par
\par
Let's break down the components of a statement:\par
\par
\highlight1 CREATE TABLE\highlight0  is a clause. Clauses perform specific tasks in SQL. \ul By convention, clauses are written in capital letters\ulnone . Clauses can also be referred to as commands.\par
\highlight1 table_name \highlight0 refers to the name of the table that the command is applied to.\par
\par
\highlight1 (column_1 data_type, column_2 data_type, column_3 data_type) \highlight0 is a parameter. A parameter is a list of columns, data types, or values that are passed to a clause as an argument. Here, the parameter is a list of column names and the associated data type.\par
The structure of SQL statements vary. The number of lines used do not matter. A statement can be written all on one line, or split up across multiple lines if it makes it easier to read. \par
\par
\b\fs44 Select\par
\ul\b0\fs22 SELECT name FROM celebs;\par
\ulnone SELECT statements are used to fetch data from a database. Here, SELECT returns all data in the name column of the celebs table.\par
1. \highlight1 SELECT\highlight0  is a clause that indicates that the statement is a query. You will use SELECT every time you query data from a database. \par
\par
2. \highlight1 name\highlight0  specifies the column to query data from. \par
\par
3. \highlight1 FROM celebs\highlight0  specifies the name of the table to query data from. In this statement, data is queried from the celebs table. \par
\par
You can also query data from all columns in a table with \highlight1 SELECT\highlight0 .\par
\par
\ul SELECT * FROM celebs;\par
\highlight1\ulnone *\highlight0  is a special wildcard character(\f1\fs20\'cd\'a8\'c5\'e4\'b7\'fb\f0\fs22 ) that we have been using. It allows you to select every column in a table without having to name each one individually. Here, the result set contains every column in the celebs table.\par
SELECT statements always return a new table called the result set.\par
\par
\highlight1 NULL\highlight0  is a special value in SQL that represents missing or unknown data. Here, the rows that existed before the column was added have NULL values for twitter_handle\par
\par
\fs44 IS\fs22\par
\highlight1 DELETE FROM celebs WHERE twitter_handle IS NULL;\par
\par
\highlight0 in this statement:\highlight1\par
WHERE\highlight0  is a clause that lets you select which rows you want to delete.\par
\par
\highlight1 IS NULL \highlight0 is a condition in SQL that returns true when the value is NULL and false otherwise.\par
}
 