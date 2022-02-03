# Data Modification Language

By default, in SQL, the union operator eliminates duplicates
If we want to have duplicates in our result
```sql
SELECT cName AS name FROM College
UNION ALL
SELECT sName AS name FROM Student; 
```