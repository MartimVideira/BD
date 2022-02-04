.mode column PRAGMA foreign_keys = On; .read college.sql
-- 1. Quais os números dos alunos?
SELECT  nr
FROM Aluno;
-- 2. Qual o código e designação das cadeiras do curso 'AC'?
SELECT  cod
       ,design
FROM Cadeira
WHERE curso = 'AC';
-- 3. Existem nomes comuns a alunos e profs? Quais?
SELECT  Nome
FROM Prof INTERSECT
SELECT  Nome
FROM Aluno;
-- 4. Quais os nomes específicos dos alunos, i.e., que nenhum professor tem?
SELECT  name
FROM Student except
SELECT  name
FROM Prof;

SELECT  Student.name
FROM Student
WHERE not exists (
SELECT  Prof.name
FROM Prof
WHERE Prof.name = Student.name );

SELECT  S.name
FROM Student S
WHERE S.name not IN ( SELECT name FROM Prof );
-- 5. Quais os nomes das pessoas relacionadas com a faculdade?
-- SELECT name
FROM Prof Union
SELECT  name
FROM Student;
-- 6. Quais os nomes dos alunos que fizeram alguma prova de 'TS1'?
SELECT  Distinct name
FROM Student S
JOIN Exam E
ON (S.nr = E.student_nr)
WHERE E.course_code = 'TS1';

SELECT  name
FROM Student S
WHERE exists (
SELECT  *
FROM Exam E
WHERE S.nr = E.student_nr
AND E.course_code = 'TS1' )
ORDER BY name;

SELECT  name
FROM Student S
WHERE S.nr IN ( SELECT student_nr FROM Exam WHERE course_code = 'TS1' )
ORDER BY name;
-- 7. Quais os nomes dos alunos com inscrição no curso 'IS'?
SELECT  Distinct S.nr
       ,S.name
FROM
( Exam
	JOIN
	(
		SELECT  code
		FROM Course
		WHERE department = 'IS' 
	) C
	ON C.code = Exam.course_code
) D
JOIN Student S
ON D.student_nr = S.nr;
-- 8. Quais os nomes dos alunos que concluíram o curso 'IS'.
SELECT  T.name
FROM
(
	SELECT  *
	FROM Exam E
	JOIN Student
	ON E.student_nr = Student.nr
	JOIN
	(
		SELECT  code
		FROM Course
		WHERE department = 'IS' 
	) C
	ON E.course_code = C.code
	WHERE E.grade > 9.5 
) T
GROUP BY  T.student_nr
HAVING COUNT(Distinct T.course_code) = (
SELECT  COUNT(code)
FROM Course
WHERE department = 'IS' );
-- 9. Qual a nota máxima existente nas provas?
SELECT  MAX(grade)
FROM Exam;
-- 10. Qual a nota média nas provas de BD?
SELECT  AVG(grade)
FROM Exam
WHERE course_code = 'BD';
-- 11. Qual o número de alunos?
SELECT  COUNT(nr)
FROM Student;
-- 12. Qual o número de cadeiras de cada curso?
SELECT  COUNT(code)
FROM Course
GROUP BY  department;
-- 13. Qual o número de provas de cada aluno?
SELECT  S.name
       ,COUNT(grade)
FROM Exam E
JOIN Student S
ON S.nr = E.student_nr
GROUP BY  E.student_nr;
-- 14. Qual a média do número de provas por aluno?
SELECT  AVG(cnt)
FROM
(
	SELECT  S.name
	       ,COUNT(grade) cnt
	FROM Exam E
	JOIN Student S
	ON S.nr = E.student_nr
	GROUP BY  E.student_nr
);
-- 15. Qual o nome e respetiva média atual (cadeiras feitas, em qualquer curso) de
-- cada aluno?
SELECT  Student.nr
       ,Student.name
       ,AVG(Maximo) Media
FROM
(
	SELECT  student_nr
	       ,MAX(grade) Maximo
	       ,course_code
	FROM Exam E
	WHERE grade >= 9.5
	GROUP BY  student_nr
	         ,course_code
) Notas
JOIN Student
ON Student.nr = Notas.student_nr
GROUP BY  Notas.student_nr;
-- 16. Qual a nota máxima de cada cadeira e qual o aluno que a obteve?
SELECT  Student.name
       ,MAX(grade)
       ,course_code
FROM Exam
JOIN Student
ON Student.nr = student_nr
GROUP BY  course_code;
-- 17. Obtenha a relação ordenada por curso dos nomes dos alunos formados.
SELECT  DISTINCT nome
       ,curso
FROM Aluno, Prova, Cadeira C
WHERE Aluno.nr = Prova.nr
AND Prova.cod = C.cod
AND Aluno.nr NOT IN (
SELECT  nr AS alunonr
FROM Aluno, Cadeira
WHERE Cadeira.curso = C.curso
AND NOT ( cod IN (
SELECT  cod
FROM Prova
WHERE nota >= 10
AND nr = alunonr ) ) )
ORDER BY curso, nome;