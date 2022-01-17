# Triggers

Restricoes que envolvem outras tabelas e que acontecem disparam depois de um determinado evento.

### Event-Condition-Action-Rules"

When event occurs, check condition : if true,do action

**Motive** : Move monitoring logic form apps into DBMS


## Triggers in SQL

Create trigger **name**

Before | After | Instead Of **events**

[referencing-variables]

[Fro each row]

When ( **condition**)

**action**

### For Each Row

Optional Statement, if present trigger will happen once for each "altered" row
if not  will only  run the entire statement once

### Referencing Variables

To reference the data that was modified and caused the trigger to be activated

- Only in table level triggers
 - old row as var
 - new row as var
- Can  be used in row level triggers or in table level triggers
 - old table as var 
 - new  table as var


### Referential Integrity - Row Level trigger

#### Row Level Trigger
R.A refernces S.B , cascaded delete
```sql 
create trigger cascade
after Delete on S
Referencing Old Row as O
for each row 
[no condition]
Delete From R where A= O.B
```
#### Table Level Trigger

R.A references S.B, cascaded delete

```sql
create trigger cascade
after delete on S
Referencin old Row As O
[For each row]
[No condition]
Delete From R where A= O.B
```

# Triggers in Sqlite

## Structure

-Row-level triggers, immediate activation
-For Each Row implicit if not specified
- No Old Table or New Table
- No Referencing clause
 - Old and New predefined for Old Row and New Row
- Trigger action: SQL statements in begin-end block

```sql
create trigger R1
After Insert On student
for each row
when New.GPA >3.3 AND New.GPA <= 3.6
Begin
    Insert into Apply values(New.sId, 'Stanford','geology',null);
    Insert into Apply values(New.sId, 'MIT','biology',null);
End;
```

```sql
Create Trigger R3
After Update of cName on Collage
For Each Row
Begin
    Update Apply 
    Set cName = New.cName
    Where cName = Old.cName;
End;
```
Old for comparing with the old value.New to insert the new value


## Simulating Key Constraints
>  *Note* Key constraint : no two tuples can have the same key

```sql
Create Trigger R4
Before Insert on College
For Each Row
When exists (select * from College where cName = New.cName)
Begin
    Select raise(ignore);
End;
```
```sql
Create Trigger R4
Before Update of cName on College
For Each Row
When exists (select * from College where cName = New.cName)
Begin
Select raise(ignore);
End;
```

Having triggers like this can prevent keys constraints violations.