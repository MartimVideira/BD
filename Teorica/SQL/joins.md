# The Join Family Of Operators


## Explicit Joins
- Inner join on condition ⋈cond
- Natural join ⋈
- Inner join using (attrs)  ⋈ explicitly listing the attributes to be equated
- Left | Right | Full Outer Join :Combines tuples as in ⋈cond but when they
don’t match they are added to the result with
NULL values
None of these operators adds expressive power to SQL
Implicit join


## Inner Join 

Using inner join or just join is the same 

```sql

select Distinct sname ,major
from  student,apply
where student.id  = apply.id

select Distinct sname ,major
from  student inner join apply
on  student.id  = apply.id

select Distinct sname ,major
from  student join apply
on student.id  = apply.id
```

## Natural Join 

```sql
SELECT sName, GPA
FROM Student JOIN Apply
ON Student.sID=Apply.sID
WHERE HS<1000 AND major=‘CS’ AND cName=‘Stanford’;

select sname,gpa 
from Student Natural Join Apply
WHERE HS<1000 AND major=‘CS’ AND cName=‘Stanford’;
```

## Inner join using (attribute)

```sql
SELECT sName, GPA
FROM Student NATURAL JOIN Apply
WHERE HS<1000 AND major=‘CS’ AND cName=‘Stanford’;

select sname,gpa 
from student joinn apply using (sId)
where hs <1000 and major ='CS' and cName = 'Stanford';
-- Better use than natural join 
```

## Left Outer Join 

Takes any tuples on the left side and if they don’t have a
match on a tuple from the right, it is still added to the
result and padded with NULL values

Tuples with no matches are dangling tuples

> Left outter join or left join  is just an abbreviation

There is a Natural left join 

```sql
-- Rewriting left outer join
SELECT sName, Student.sID, cName, major
FROM Student, Apply
Where Student.sID=Apply.sID
UNION
SELECT sName, sID, NULL, NULL
FROM Student
WHERE sID NOT IN (select sID from Apply`
```

## Right Outer Join 

The same as the left but for the right relation


## Full Outer Join

To include unmatched tuples from both sides of a join

```sql
SELECT sName, sID, cName, major
FROM Student FULL OUTER JOIN Apply using(sID);

-- Withou full outer join       
SELECT sName, Student.sID, cName, major
FROM Student LEFT JOIN Apply using(sID)
UNION
SELECT sName, Student.sID, cName, major
FROM Student RIGHT JOIN Apply using(sID);


-- Witout using outer joins

SELECT sName, Student.sID, cName, major
FROM Student, Apply
Where Student.sID=Apply.sID
UNION
SELECT sName, sID, NULL, NULL
FROM Student
WHERE sID NOT IN (select sID from Apply)
UNION
SELECT NULL, sID, cName, major
FROM Apply
WHERE sID NOT IN (select sID from Student);
```

## Outer Joins Summary

- Left and Right Outer Joins are not commutative
- Full Outer Join is commutative
- Left and right outer joins are not associative either



+ Left outer join 
  - Include the left tuple even if there’s no match
+ Right outer join 
  - Include the right tuple even if there’s no match
+ Full outer join 
  - Include the both left and right tuples even if there’s no match