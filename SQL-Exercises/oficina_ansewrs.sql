.read oficina1.sql
/*
-- a. Quais as peças com custo unitário inferior a 10€ e cujo código contém ‘98’? 
where custoUnitario < 10 and codigo like '%98%';

-- b. Quais as matrículas dos carros que foram reparados no mês de Setembro de 2010, i.e., cuja reparação terminou nesse mês? 
select * from Carro C
join Reparacao R  on  (R.idCarro = C.idCarro)
where strftime('%m',dataFim) = '09' AND strftime('%Y', dataFim) = '2010';

-- c. Quais os nomes dos clientes proprietários de carros que utilizaram peças com custo unitário superior a 10€? Apresente o resultado ordenado por ordem descendente do custo unitário. 

SELECT nome FROM Cliente, Carro, Reparacao, ReparacaoPeca, Peca 
WHERE Cliente.idCliente=Carro.idCliente 
AND Carro.idCarro=Reparacao.idCarro 
AND Reparacao.idReparacao=ReparacaoPeca.idReparacao 
AND ReparacaoPeca.idPeca=Peca.idPeca 
AND custoUnitario>10 
ORDER BY custoUnitario DESC;


-- d. Quais os nomes dos clientes que não têm (tanto quanto se saiba) carro? 

select nome From Cliente where idCliente in(
select idCliente From Cliente
except
select idCliente from Carro);

select nome from Cliente  C
where not exists (select idCliente from Carro where Carro.idCliente = C.idCliente);

select nome  From Cliente left  join Carro using(idCliente)
where idCarro  is Null;


-- e. Qual o número de reparações feitas a cada carro?  
select Count(idReparacao) from Reparacao 
group by idCarro;

select matricula , count(idReparacao) "Num Reparacoes" from Reparacao
join Carro using(idCarro)
group by matricula;

-- f. Qual o número de dias em que cada carro esteve em reparação? 
-- Aggregar por carro descobri os dias por cada reparacao somar as reparacoes

select matricula , SUM(julianday(dataFim)-julianday(dataInicio)) "No de dias" 
from Carro Join Reparacao using (idCarro)
group by matricula;

-- g. Qual o custo unitário médio, o valor total e o número de unidades das peças, bem como o valor da peça mais cara e da mais barata?

SELECT AVG(custoUnitario) "Média", SUM(custoUnitario*quantidade) 
"Val total", COUNT(*) "No de peças", MIN(custoUnitario) "preço menor", 
MAX(custoUnitario) "preço maior" 
FROM Peca; 

-- h. Qual a especialidade que foi utilizada mais vezes nas reparações dos carros de cada marca? 

create view MarcaidEspecialidadeCount as 
select Modelo.idMarca, Especialidade.nome , count(*) Freq From  (Funcionario Join FuncionarioReparacao  using (idFuncionario))
join Especialidade using (idEspecialidade)
join Reparacao using(idReparacao)
join Carro using(idCarro)
join Modelo using(idModelo)
group by Modelo.idMarca, Especialidade.nome;

-- Esta forma nao me da  os empates!!!!!
select  Marca.nome, M.nome from MarcaidEspecialidadeCount M  join Marca using (idMarca)
group by idMarca    
having M.Freq = Max(M.Freq);

-- Using a subquery i can have draws lets do it 
SELECT idMarca as idMarca1, nome 
FROM MarcaidEspecialidadeCount 
WHERE Freq IN ( 
  SELECT MAX(Freq) 
  FROM  MarcaidEspecialidadeCount
  GROUP BY idMarca
  HAVING idMarca=idMarca1); 

select Marca.nome , M.nome , M.Freq from MarcaidEspecialidadeCount M join Marca using(idMarca)
where Freq = (select Max(Freq) from MarcaidEspecialidadeCount where idMarca=M.idMarca)

*/
-- i. Qual o preço total de cada reparação? 
create view DespesaPecaRepacao as 
select  idReparacao,Sum(R.quantidade * custoUnitario) Total from ReparacaoPeca R join Peca using (idPeca)
group by idReparacao;


create view DespesaPorFuncionarioPorReparacao as
select idReparacao , F.nome, E.nome "Especialidade" ,Sum(R.numHoras * custoHorario) Total 
From FuncionarioReparacao R join Funcionario F using (idFuncionario)
join Especialidade E using (idEspecialidade)
group by idReparacao , F.nome, E.nome;


create view DespesaFuncionarioReparacao as 
select idReparacao , Sum(Total) "Total" from DespesaPorFuncionarioPorReparacao
group by idReparacao;


create view TotalReparacoes as 
select  idReparacao, Sum(Total)  Total from (
select * from DespesaPecaRepacao
Union
select * FROM  DespesaFuncionarioReparacao)
group by idReparacao;

-- select * from TotalReparacoes;
 

-- j. Qual o preço total das reparações com custo total superior a 60€?


-- select * from TotalReparacoes where Total > 60 ;


-- k. Qual o proprietário do carro que teve a reparação mais cara? 
/*
select Cl.nome , Total from TotalReparacoes T,Reparacao R , Carro C , Cliente Cl
where T.idReparacao = R.idReparacao 
and R.idCarro = C.idCarro
and C.idCliente = Cl.idCliente
order by Total desc
limit 1;

select Cl.nome , Total from TotalReparacoes T,Reparacao R , Carro C , Cliente Cl
where T.idReparacao = R.idReparacao 
and R.idCarro = C.idCarro
and C.idCliente = Cl.idCliente
and Total in (select Max(Total) From TotalReparacoes);
*/

-- l. Qual a matrícula do carro com a segunda reparação mais cara? 
/*
select  matricula, Total From TotalReparacoes join Reparacao using (idReparacao)
join Carro using (idCarro)
 where Total in (select Max(Total) From TotalReparacoes where Total not in 
                    (select Max(Total) From TotalReparacoes));
*/

-- m. Quais são as três reparações mais caras (ordenadas por ordem decrescente de preço)? 


-- n. Quais os nomes dos clientes responsáveis por reparações de carros e respetivos proprietários (só para os casos em que não são coincidentes)? 


-- o. Quais as localidades onde mora alguém, seja ele cliente ou funcionário?  


-- p. Quais as localidades onde moram clientes e funcionários?  


-- q. Quais as peças compatíveis com modelos da Volvo cujo preço é maior do que 


-- o de qualquer peça compatível com modelos da Renault? 


-- r. Quais as peças compatíveis com modelos da Volvo cujo preço é maior do que 


-- o de alguma peça compatível com modelos da Renault?  


-- s. Quais as matriculas dos carros que foram reparados mais do que uma vez?  


-- t. Quais as datas de início e de fim e nome do proprietário das reparações feitas por carros que foram reparados mais do que uma vez?  


-- u. Quais as reparações que envolveram todas as especialidades?  


-- v. Calcule as durações de cada reparação, contabilizando até à data atual os não entregues.  


-- w. Substitua Renault por Top, Volvo por Down e os restantes por NoWay.

