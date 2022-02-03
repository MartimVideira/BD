.mode column
PRAGMA foreign_keys= On;



.read college.sql



-- 1. Quais	os	números	dos	alunos?
-- select nr from Aluno;

-- 2. Qual	o	código	e	designação	das	cadeiras	do	curso	'AC'?
-- select cod , design from Cadeira where curso = 'AC';


-- 3. Existem	nomes	comuns	a	alunos	e	profs?	Quais?
-- select Nome From Prof INTERSECT select Nome From Aluno;


-- 4. Quais	os	nomes	específicos	dos	alunos,	i.e.,	que	nenhum	professor	tem?
/*
select name from Student except select name from Prof;

select Student.name 
from Student 
where not exists (
        select Prof.name 
        from Prof
        where Prof.name = Student.name);

select S.name
from Student S 
where S.name not in (
        select name 
        from Prof
);

*/
-- 5. Quais	os	nomes	das	pessoas	relacionadas	com	a	faculdade?
-- select name From Prof Union select name From Student;


-- 6. Quais	os	nomes	dos	alunos	que	fizeram	alguma	prova	de	'TS1'?

/*
select Distinct  name  From  Student S Join  Exam  E
on  (S.nr = E.student_nr)
where E.course_code = 'TS1';
*/
/*
select name From Student  S
where exists (select * 
            From Exam E 
            where S.nr = E.student_nr and E.course_code ='TS1')
order by name;

select  name From Student S
where S.nr in (select student_nr 
                From Exam where course_code = 'TS1' )
order by name;
*/


-- 7. Quais	os	nomes	dos	alunos	com	inscrição	no	curso	'IS'?
/*
select Distinct S.nr, S.name From 
(Exam join
(select code from Course where department = 'IS') C
on  C.code = Exam.course_code) D
join  Student S
on D.student_nr = S.nr;
*/


-- 8. Quais	os	nomes	dos	alunos	que	concluíram	o	curso	'IS'.
/*
select T.name From 
(select  * From  Exam E join Student on E.student_nr = Student.nr
join
(select code From Course where department = 'IS' ) C
on E.course_code = C.code 
where E.grade > 9.5) T
group by T.student_nr 
having count(Distinct T.course_code) = (select count(code) from Course where department = 'IS');
*/
-- 9. Qual	a	nota	máxima	existente	nas	provas?
-- select Max(grade)  From Exam;

-- 10. Qual	a	nota	média	nas	provas	de	BD?
-- select AVG(grade) From Exam where course_code = 'BD';

-- 11. Qual	o	número	de	alunos?
-- select count(nr) from Student;

-- 12. Qual	o	número	de	cadeiras	de	cada	curso?
/*
select count(code) From Course
group by  department;
*/
-- 13. Qual	o	número	de	provas	de	cada	aluno?
/*
select S.name, count(grade) From Exam  E
join Student  S
on S.nr = E.student_nr
group by E.student_nr;
*/
-- 14. Qual	a	média	do	número	de	provas	por	aluno?
/*
select avg( cnt) From (
select S.name, count(grade)  cnt From Exam  E
join Student  S
on S.nr = E.student_nr
group by E.student_nr);
*/
-- 15. Qual	o	nome	e	respetiva	média	atual	(cadeiras	feitas,	em	qualquer	curso)	de	
-- cada	aluno?

select  Student.nr, Student.name , avg(Maximo) Media  from 
(
select student_nr , max(grade) Maximo, course_code  From Exam E 
where grade >= 9.5
group by student_nr , course_code) Notas
join Student 
on Student.nr = Notas.student_nr
group by Notas.student_nr;
-- 16. Qual	a	nota	máxima	de	cada	cadeira	e	qual	o	aluno	que	a	obteve?

select Student.name ,max(grade), course_code from Exam
join Student on Student.nr = student_nr
group by course_code;
-- 17. Obtenha	a	relação	ordenada	por	curso	dos	nomes	dos	alunos	formados.
SELECT	DISTINCT	nome,	curso
FROM	Aluno,	Prova,	Cadeira	C
WHERE	Aluno.nr	=	Prova.nr	AND	Prova.cod	=	C.cod	AND	Aluno.nr	NOT	
IN
(SELECT	nr	AS	alunonr
FROM	Aluno,	Cadeira
WHERE	Cadeira.curso	=	C.curso	AND	NOT	(cod	IN
(SELECT	cod
FROM	Prova
WHERE	nota	>=	10	AND	nr=alunonr))
)
ORDER	BY	curso, nome;                