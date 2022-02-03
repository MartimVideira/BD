# Null Values

Null in a mathematical expression returns null

Nulls in boolean are UNKNOWN 
think of it has 
TRUE : 1.0
UNKNOWN : 0.5
False : 0.0


Despite the tautology it doesnt return all the values because of the nulls

select sid , sName , GPA from Student 
Where GPA > 3.5 OR GPA <=3.5 

To get all the values
```sql
select sid , sName , GPA from Student 
Where GPA > 3.5 OR GPA <=3.5 or GPA is null
```


When counting (the distinct)
values, NULLs are not included


## Summary

When using a database with NULL values:
- Be careful when writing queries
- Understand how the NULL values are going to influence the
result