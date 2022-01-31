select cName,count(*) as cnt 
from  Apply
group by cName;


## Group-by versus subqueries


Select distinct cName , (
    Select count(*)  
    From Apply A2
    Where A2.cName = A1.cName) As cnt
From Apply;
> This is more efficient

Tambem conseguimos reescrever qualquer query que envolva o having

Select cName From Applyy  Group By cName Havin count(*) < 5;

Select distinct cName  From Apply A1 
Where 5 > (Select count(*) from Apply A2 where A2.cName = A1.cName);
> This is less efficient

Só deve ser usado o group by quando forem usadas funcoes de agregacao
