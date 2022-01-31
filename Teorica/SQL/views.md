# Views

- Hide some data from some users
- Make some queries easier / more natural 
- Modularity of database access
- Real Applications tend to turn to views as applications grow larger.

A view is created through a querie and after its creation it can be used as if it is just a regular table

## Structure 
```sql
create view CSaccept as 
select sID, cName
From Apply
where major ='CS' and dec = 'Y'
```

The view is actually not stored, query is rewritten based on the view definition.
Querying a view creates a temporary table.

A view can be created through queyring another view.
Creating a view doesnt create the tuples right away i need to query it so the tuples are created.

You can simplify some queries using views.

## Changing the View - Triggers Instead Of

Given the view CSaccept look at the following code :
```sql
Delete from CSaccept
Where sID = 123; 
```

This will cause an error because sqlite does not allow to modify views.

So to combat this we create a trigger like so:
```sql
Create trigger CSacceptDelete
instead of delete on Csaccept
For each row
Begin
    Delete from Apply
    Where sID = Old.sID and cName = Old.cName and
    major = ‘CS’ and dec = ‘Y’;
    End;
```
> Instead of deleting on Csaccept which wouldl cause and error we delete on apply which is fine

### Conclusion on changing views

Everything that would delete/update/insert on a view 
we *exchange it for a trigger*

Another example but **updating**

```sql
Create trigger CSacceptUpdate
instead of update of cName on Csaccept
For each row
Begin
    Update Apply
    Set cName = New.cName
    Where sID = Old.sID and cName = Old.cName and
    major = ‘CS’ and dec = ‘Y’;
End; 
```
A change will be done in the concrete table and will be reflected on the virtual table : **the view**

Another exemple but **inserting**

```sql
-- Having This View
Create View CSEE As
Select sID, cName, major
From Apply
Where major = ‘CS’ or major = ‘EE’;

-- Creating a trigger to insert on the view
Create trigger CSEEinsert
Instead of insert on CSEE
For each row
Begin
    Insert into Apply values (New.sID, New.cName, New.major, null);
End;

--inserting a value into CSSE
Insert into CSEE values
(222, ‘Berkeley’, ‘biology’);
```
Do you see any problems here? 
If we queryied our view we wouldn't see the change as it is a biology master and our view has only master CS and EE.

>Its our responsability to secure that operations on the views are consistent with the view conditions

```sql
-- Should be something like this
Drop trigger CSEEinsert;

Create trigger CSEEinsert
Instead of insert on CSEE
For each row
-- Condition that  will only allow to trigger when a value belongs in our view
When New.major = ‘CS’ or New.major = ‘EE’
Begin
    Insert into Apply values (New.sID, New.cName, New.major, null);
End; 
```