# SQl

Stands for Structured Query Language

Data Definition Language (DDl)
  - Define relational schemata
  - Create alter delete tables and their attributes

Data Manipulation language (Dml)
  - Insert delete modify tuples in tables
  - Query one or more tables

SQL is a rich programming language that handles the
way data is processed declaratively.

## Relations in SQL 
- **Tables**: normal type of realtion exists in the database and can be modified as well as queried

- [**Views**](views.md) : Relations defined by  computation not stored and are constructed when needed

- **Temporary tables** : constructed on the run and are not stored

## Data Types in Sql 

CHAR(n) Stores fixed length string of up to n characters

VARCHAR(n) Stores variable-length string of up to n characters

INt 
SHORT INT 
FLOAT
DECIMAL(n ,d)

BOOLEAN TRUE FALSE UNKNOWN

DATE /TIMES

NULL
TEXT 
BLOB large files or large objects are stored as blobs

Type Affinities in Sqlite
each column has a type affinity which means it stores one type
and it tries to convert the inserted data type into the correct one


## TABLE DECLARATIONS
```
CREATE TABLE <table_name> (
    <column_name> <data_type>,
    <column_name> <data_type>,
    <column_name> <data_type>,
    ....
    <column_name> <data_type>,
);
```

Exemple:
```sql
CREATE TABLE MovieStar (
    id INTEGER,
    name CHAR(30),
    address VARCHAR(255),
    gnder CHAR(1),
    birthdate DATE   
);
```

basically beacause of the type affinity i can insert the data in another type and
it will convert it into the correct one.

## MODIFYING RELATION SCHEMAS

- To remove an entire table and all its tuples:
`DROP TABLE <table_name>`;

- To modify the schema of an existing relation
```sql 
-- Adding another column
ALTER TABLE <tablew_name> ADD <column_name> <data_type>;
-- Removing an existing column
ALTER TABLE <table_name> DROP <column_name>;

Default values 
CREATE TABLE <table_name> (
    <column_name> <column_type> DEFAULT <default_value>
    ....
)

ALTER TABLE <table_name> ADD <column_name> <column_type> DEFAULT <value>;
-- This will populate  table missing values with the specified value.
```
---

# Integrity -> Constraints

- Data entry errors (inserts)
- Correctness criteria (update)
- Enforce consistency 
- Tell system about data - store query processing

## Classification of Constraints
- Non-Null Constraints
- Key Constraints
- Attribute-based and tuple based Constraints
- referential integrity (foreign key)
- General assertions
## Exemples:

## Not Null 

```sql
create table <table_name> (
    <column_name> <data_type> NOT NULL,
    ...
);
```
## Primary Key

Primary key is a constraint that obligates an attribute to be not null and to be unique
```sql
create table <table_name> (
    <column_name> <data_type> PRIMARY KEY,
    ...
)
```
## AutoIncrement Unique and composed keys
```sql
-- autoincrement is a nice thing to add to an id
-- Composed primary key
create table <table_name> (

    <column_name> <data_type>,
    <column_name> <data_type>,
    PRIMARY KEY(<column_name>,column_name>)
);

insert into <table_name> (<column_name>,<column_name>,<column_name>) values (value, value,value);
-- ROWID in SQLITE as a default value for a row id 
update table_name set column_name = value where ROWID = 2;

-- Unique values values that are unique and are not keys but can be null
create <table_name> (
    <column_name> <column_type> unique
);

CREATE TABLE MovieStar (
id INTEGER PRIMARY KEY,
name CHAR(30),
address VARCHAR(255) UNIQUE,
gender CHAR(1) DEFAULT ‘?’,
birthdate DATE,
phone CHAR(16) UNIQUE
);
-- We can have several attr bein unique like so:
--the combination of them must be unique between tuples
create <table_name> (
    <column_name> <column_type> 
    <column_name> <column_type> 
    <column_name> <column_type> 
    Unique(attr1, attr2)
    UNIQUE(attr1,attr3)
);

CREATE TABLE MovieStar (
id INTEGER PRIMARY KEY,
name CHAR(30),
address VARCHAR(255),
gender CHAR(1) DEFAULT ‘?’,
birthdate DATE,
UNIQUE (name, birthdate),
UNIQUE (name, address)
);
```

## CHECK PER COLLUMN

Checked whenever we insert or update a tuple q 
>collumn_name collumn_type CHECK(condition)

```sql

CREATE TABLE Student (
sID INTEGER PRIMARY KEY,
sName TEXT,
GPA REAL CHECK (GPA<=4.0 and GPA>0.0),
sizeHS INTEGER CHECK (sizeHS < 5000),
);
```
## CHECK  PER TUPPLE
> CHECK(condition)

```sql
CREATE TABLE Apply (
sID INTEGER,
cName TEXT,
major TEXT,
decision TEXT,
PRIMARY KEY (sID, cName, major),
CHECK (decision=‘N’ or cName <>’Stanford’ or major <>’CS’)
);
```

# REFERENTIAL INTEGRITY 

### Definitions:

> main table represented by R refered table represented by S

Referential integrity from R.A to S.B
A is called the foreign key
B is usually required to be the primary key for table S or at least unique
Multi-attribute foreign keys are allowed

## Potentially violating modifications:

**Insert into R** -> inserting into the table that references the S table  and if the 
tuple that the insertion refers to doesnt exist in S we have a violation

**Delete From S** -> if we delete a tuple from S we can be deleting a refered attribute from R

**UPdate R.A**
**Update S.B**

the operations that  occur in S may not trigger an error as we can define its behaviour
 
## Delete from S 
 
- **Restrict (default)**
  -   generate an error, modification disallowed
-  **Set Null**
  -   replace R.A by NUll
-   **Cascade**
  -   do the same update to R.A

## Foreign Key Declaration:
```sql
create table <S> (
    <column_nameA> <data_type> PRIMARY KEY,
    <column_nameB> <data_type> ,
    ...
    <column_nameC> <data_type>    
);

create table <R>(
    <column_nameX> <data_type> PRIMARY KEY,
    <column_nameY> <data_type>,
    ...
    <column_nameZ> <data_type> REFERENCES <S>(<column_nameA)
    -- collumn z points to column A in S
```
Example :

```sql
CREATE TABLE College (cName text PRIMARY KEY, state text,
enrollment int);
CREATE TABLE Student (sID int PRIMARY KEY, sName text, GPA
real, sizeHS int);
CREATE TABLE Apply (
sID REFERENCES Student(sID),
cName text REFERENCES College(cName),
major text,
decision text,
PRIMARY KEY(sID, cName)
);
```
> se o atributo for a chave primaria e for uma chave simples nao precisamos de dizer o atributo que referenciamos

No caso de serem chaves compostas:
```sql
CREATE TABLE <table_A> (
<column_A> <data_type>,
<column_B> <data_type>,
...
<column_C> <data_type>,
PRIMARY KEY (<column_A>, <column_B>)
);
CREATE TABLE <table_B> (
<column_X> <data_type> PRIMARY KEY,
<column_Y> <data_type>,
...
<column_Z> <data_type>,
FOREIGN KEY (<column_X>, <column_Y> ) REFERENCES <table_A>(<column_A>, <column_B>)
# uma chave estrangeira composta tem que ser declarada assim
);

CREATE TABLE Apply (
sID REFERENCES Student,
collegeName text,
collegeState text,
major text,
decision text,
FOREIGN KEY (collegeName, collegeState) REFERENCES College(cName, state),
PRIMARY KEY(sID, collegeName, collegeState)
);
```

## ON DELETE AND ON UPDATE ACTIONS

- Define actions that take place when deleting or modifying parent key values.

Use the **ON DELETE** and **ON UPDATE**  clauses with one of the values:
- **Restrict** : prohibit opreation on a parent key when there are child keys mapped to it.
- **Set Default**: child key columns are set to the default value.
- **Cascade** :propagates the operation on the parent key to each dependent child key


Exemple:
```sql
CREATE TABLE College (cName text PRIMARY KEY, state text, enrollment int);

CREATE TABLE Student (sID int PRIMARY KEY, sName text, GPA real, sizeHS int);

CREATE TABLE Apply (
sID REFERENCES Student(ID),
cName text REFERENCES College (cName) ON DELETE SET NULL ON
UPDATE CASCADE,
major text,
decision text,
PRIMARY KEY(sID, cName)
);
```

## Enabling Foreign Key Support in SQLITE
incluir sempre : `PRAGMA  foreign_keys = ON;`

## Constraint Naming

Naming constraints is optional but is a good practice it makes it esier to 
identify the constraints when errors occur and to refer to them.

Exemple:
```sql
CREATE TABLE Student (
sID INTEGER,
sName TEXT,
GPA REAL CONSTRAINT GPARange CHECK (GPA<=4.0),
sizeHS INTEGER CONSTRAINT maxSizeHS CHECK (sizeHS < 5000),
CONSTRAINT StudentPK PRIMARY KEY (sID)
);
```


## ROWID in SQLite

If a table is created without specifying the WITHOUT ROWID
option, SQLite adds an implicit column called rowid that stores 64-
bit signed integer

The rowid is a key that uniquely identifies the row in its table
Can be accessed using ROWID, _ROWID_, or OID (except if ordinary
columns use these names)

On an INSERT, if the ROWID is not explicitly given a value, then it
will be filled automatically with an unused integer greater than 0,
usually one more than the largest ROWID currently in use.

ROWID > AUTOINCREMENT is faster