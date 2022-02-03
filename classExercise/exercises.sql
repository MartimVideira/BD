-- SetUp
.read college.sql
.headers on
.mode columns

-- What are the students' numbers? Return them ordered ascendingly.

-- SELECT nr FROM Student ORDER BY  nr ASC;

-- What is the code and name of the units of 'AC' course? Return the courses ordered alphabetically.

-- SELECT  code , name FROM Course WHERE department= 'AC' ORDER BY code ASC;

-- Are there common names for students and teachers? Which ones? Return the names ordered alphabetically.

-- Select Distinct name From Student  Where name in ( Select Distinct name From Prof) Order by name ASC;

-- What are the specific names of students, i.e. that no professors have? Return the names ordered alphabetically.

-- Select Distinct name From Student where name not in (Select DistincT name from Prof) Order by name ASC;

--What are the names of people related to the faculty? Return the names ordered alphabetically.
-- Select Distinct  name From (Select name from Student Union select name from Prof) order by name ASC;

-- What are the names of students who have taken any 'TS1' exams? Return the names ordered alphabetically.

-- Select  Distinct name from student where nr in (Select student_nr from Exam where course_code ='TS1') order by name asc ; 

-- What are the names of the students with 'IS' department enrollment? Return the names ordered alphabetically.
--
--
--Select  name From Student  Where nr in 
--(Select student_nr From Exam Where course_code in 
--(Select code From Course Where department = 'IS')) order by name asc;

--What are the names of the students who completed the course 'IS'? Return them ordered ascendingly.


SELECT Distinct name, course_code From Student as s2 join Exam ON student_nr=nr 
Where (grade >10 and course_code in (Select code From Course where department ='IS')) 
Order by name asc;

--
-- ------      Select code From Course where department = 'IS';
-- ------      Select name From  Student as s1 Where 
-- ------      ((Select code From Course where department = 'IS') = (SELECT course_code From (Student as s2 join Exam ON student_nr=nr) Where (grade >10 and s1.name = s2.name and course_code in (Select code From Course where department ='IS'))));


