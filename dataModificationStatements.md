# Data Modification Statements

## Inserting new data

Insert into Table (A1,A2,...., An)
    Values(v1,v2,.....,vn);

Other option is 

Insert into Table 
    Select statement that has the same schema has the table we want to insert into


```sql
Insert into apply 
Select sID,'Carnegie Mellon' ,'CS', Null
from Student
Where sId not in (select sID FROM Apply);
```

Here we are giving every student that hasn't applied to any college  a row in apply that means theyve applied to Carnagie Mellon  computer science

## Delete existing Data

Delete from table
Where condition;

Appagar as candidaturas de estudantes que se candidataram  a 2 ou mais mestrados.

Delete From student
where sId in (
    Select sid from Apply Group By sid Having count(distinct Major) > 2);
)


Not all database systems allow deletion commands where the subquery includes the same relation that your deleting from.

## Updating existing data

Update Table 
Set Attr = Expression 
Where Condition

> Conditions and expressions can include subqueries and queries over other tables or the same table.

