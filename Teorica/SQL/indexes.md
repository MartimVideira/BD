# Indexes

Primary mechanism to get improved performance on a database
Persistant data structure, stored in database

The consult optimizer uses the indexes

## Functionality 

If we want tuples with T.A = "cow" , DBMS doesnt  need to scan the entire table

Useres dont access indexes , Indexes are used underneath by the query execution engine.

> One priamry index and many secundary indexes

## Utility 

Index = difference between full table scans and immediate location of tuples
> Increased performance

## Where should indexes be created ?

Many DBMS's build indexes automatically on PRIMARY KEY and sometimes UNIQUE attributes

```sql
Select sID
From Student
Where sName= 'Mary' and GPA >3.9
```
Index on sName 
  - Hash or tree baseed because  ==

Index  on  GPA
 - Tree Based because < 
  
Index on (sName,GPA)

## Downside of Indexes

- Extra space    `small`
- Index Creatio `medium`
- Index Maintenance `large`


## SQL Syntax 

```sql

Create Index IndexName on T(A)

Create Index Index IndexName on T(A1,A2,...An)

Create Unique Index  IndexName on T(A)

Drop Index IndexName
```