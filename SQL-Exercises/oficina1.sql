.mode column
PRAGMA foreign_keys = on;


-- Marca (idMarca, nome)  
drop table if exists Marca;
create Table Marca (
    idMarca  integer Primary Key ,
    nome unique not null 
);


-- Modelo (idModelo, nome, idMarca -> Marca)
drop table if exists Modelo;
create Table Modelo (
    idModelo integer  Primary Key ,
    nome text  not null ,
    idMarca integer  References Marca
);

-- CodPostal (codPostal1, localidade)  
drop table if exists CodPostal;
create Table CodPostal (
    codPostal1 text   Primary Key,
    localidade text 
);

-- Cliente (idCliente, nome, morada, codPostal1 -> CodPostal, codPostal2, telefone)  
drop table if exists Cliente;
create table Cliente (
    idCliente integer  Primary Key ,
    nome text   not null,
    morada text ,
    codPostal1 text  References CodPostal,
    codPostal2 text ,
    telefone text
);

-- Carro (idCarro, matricula, idModelo -> Modelo, idCliente -> Cliente)  
drop table if exists Carro;
create table Carro (
    idCarro integer   Primary Key ,
    matricula text  UNIQUE,
    idModelo integer  References Modelo,
    idCliente integer  References Cliente
);

-- Reparacao (idReparacao, dataInicio, dataFim, idCliente -> Cliente, idCarro -> Carro)  
drop table if exists Reparacao;
create Table Reparacao (
    idReparacao integer  Primary Key,
    dataInicio date ,
    dataFim date ,
    idCliente integer  References Cliente,
    idCarro integer  References Carro,
   CONSTRAINT ch_df_di CHECK (dataFim>=dataInicio)
);

-- Peca (idPeca, codigo, designacao, custoUnitario, quantidade)  
drop table if exists Peca;
create Table Peca (
    idPeca integer  Primary Key,
    codigo text ,
    designacao text ,
    custoUnitario real  check (custoUnitario >=0) ,
    quantidade integer  check (quantidade >=0)
);


-- ReparacaoPeca (idReparacao -> Reparacao, idPeca -> Peca, quantidade)  
drop table if exists ReparacaoPeca;
create Table ReparacaoPeca (
        idReparacao integer  References Reparacao,
        idPeca integer  References Peca,
        quantidade integer  Constraint NoNegativeQUantities Check (quantidade >= 0),
        Primary Key (idReparacao, idPeca)
        -- Constraint pk_reparacao_peca Primary Key (idPeca, idReparacao)
);

-- PecaModelo (idPeca -> Peca, idModelo -> Modelo)  
drop table if exists PecaModelo;
create Table PecaModelo (
    idPeca integer  References  Peca,
    idModelo integer  References Modelo,
    Primary Key (idPeca, idModelo)
);

-- Especialidade (idEspecialidade, nome, custoHorario)  
drop table if exists Especialidade;
create Table Especialidade (
    idEspecialidade integer  Primary Key,
    nome text  not null,
    custoHorario real 
);

-- Funcionario (idFuncionario, nome, morada, codPostal1 -> CodPostal, codPostal2,  telefone, idEspecialidade -> Especialidade);  
drop table if exists Funcionario;
create Table Funcionario (
    idFuncionario integer  Primary Key,
    nome text  not null,
    morada text ,
    codPostal1 text  References CodPostal,
    codPostal2 text ,
    telefone text ,
    idEspecialidade integer  References Especialidade
);


-- FuncionarioReparacao (idFuncionario -> Funcionario, idReparacao -> Reparacao, numHoras)  

drop table if exists FuncionarioReparacao;
create Table FuncionarioReparacao (
    idFuncionario integer  References Funcionario,
    idReparacao integer  References Reparacao,
    numHoras float  Check (numHoras >= 0),
    Primary Key (idFuncionario,idReparacao)
);


-- Inserção de registos na tabela codPostal
INSERT INTO CodPostal (codPostal1, localidade) VALUES ('4200','Porto');
INSERT INTO CodPostal (codPostal1, localidade) VALUES ('4400','Vila Nova de Gaia');
INSERT INTO CodPostal (codPostal1, localidade) VALUES ('4450','Matosinhos');

-- Inserção de registos na tabela Cliente
INSERT INTO Cliente (nome, morada, codPostal1, codPostal2, telefone)
	VALUES ('Alberto Sousa', 'Rua Brito e Cunha, 125','4450','086','932853425');
INSERT INTO Cliente (nome, morada, codPostal1, codPostal2, telefone)
	VALUES ('Maria Francisca Pereira Nobre','Avenida Meneres, 201','4450','191','933278005');
INSERT INTO Cliente (nome, morada, codPostal1, codPostal2, telefone)
	VALUES ('Rodrigo Meireles de Aguiar','Rua da Cunha, 310 1º Dir','4200','250','928604666');
INSERT INTO Cliente (nome, morada, codPostal1, codPostal2, telefone)
	VALUES ('Adão Lopes Sá','Rua Domingos de Matos, 200 3º Esq','4400','120','963670913');

-- Inserção de registos na tabela Marca
INSERT INTO Marca (nome) VALUES ('Renault');
INSERT INTO Marca (nome) VALUES ('Volvo');

-- Inserção de registos na tabela Modelo
INSERT INTO Modelo (nome, idMarca) 
	VALUES ('Clio 1.9D', 1);
INSERT INTO Modelo (nome, idMarca)
	VALUES ('V50 Momentum', 2);
INSERT INTO Modelo (nome, idMarca)
	VALUES ('C30 Drive', 2);

-- Inserção de registos na tabela Carro
INSERT INTO Carro (matricula, idModelo, idCliente)
	VALUES ('2490CV', 1, 4);
INSERT INTO Carro (matricula, idModelo, idCliente)
	VALUES ('36DH79', 2, 2);
INSERT INTO Carro (matricula, idModelo, idCliente)
	VALUES ('1127XY', 3, 3);
INSERT INTO Carro (matricula, idModelo, idCliente)
	VALUES ('78AB27', 3, 2);
INSERT INTO Carro (matricula, idModelo, idCliente)
	VALUES ('16IU02', 3, 4);

-- Inserção de registos na tabela Reparacao
INSERT INTO Reparacao (dataInicio, dataFim, idCliente, idCarro)
	VALUES ('2010-09-17', '2010-09-20', 1, 3);
INSERT INTO Reparacao (dataInicio, dataFim, idCliente, idCarro)
	VALUES ('2010-09-15', '2010-09-16', 4, 1);
INSERT INTO Reparacao (dataInicio, dataFim, idCliente, idCarro)
	VALUES ('2009-09-18', '2009-09-27', 4, 5);

-- SELECT * FROM Reparacao; -- Ver que o idCliente já não é NULL;

-- Inserção de registos na tabela Peca
INSERT INTO Peca (codigo, designacao, custoUnitario, quantidade)
	VALUES ('37XX98', NULL, 3, 100);
INSERT INTO Peca (codigo, designacao, custoUnitario, quantidade)
	VALUES ('75VBO98', NULL, 25, 10);

-- Inserção de registos na tabela PecaModelo
INSERT INTO PecaModelo (idPeca, idModelo) VALUES (1, 1);
INSERT INTO PecaModelo (idPeca, idModelo) VALUES (2, 3);

-- Inserção de registos na tabela ReparacaoPeca
INSERT INTO ReparacaoPeca (idReparacao, idPeca, quantidade) VALUES (2, 1, 8);
INSERT INTO ReparacaoPeca (idReparacao, idPeca, quantidade) VALUES (3, 2, 2);

-- Inserção de registos na tabela Especialidade
INSERT INTO Especialidade(nome, custoHorario)
	VALUES ('Electricista', 15);
INSERT INTO Especialidade(nome, custoHorario)
	VALUES ('Mecânico', 12);
INSERT INTO Especialidade(nome, custoHorario)
	VALUES ('Chapeiro', 10);

-- Inserção de registos na tabela Funcionario
INSERT INTO Funcionario(nome, morada, codPostal1, codpostal2, telefone, idEspecialidade)
	VALUES ('Abel Sousa', 'Rua da Preciosa, 317-1º Esq', 4200, 137, '226903271', 1);
INSERT INTO Funcionario(nome, morada, codPostal1, codpostal2, telefone, idEspecialidade)
	VALUES ('Mário Teixeira', 'Rua Seca, 17', 4400, 210, '227519090', 2);
INSERT INTO Funcionario(nome, morada, codPostal1, codpostal2, telefone, idEspecialidade)
	VALUES ('Rogério Silva', 'Rua dos Caldeireiros, 312, 3ºF', 4400, 112, '227403728', 2);
INSERT INTO Funcionario(nome, morada, codPostal1, codpostal2, telefone, idEspecialidade)
	VALUES ('Luís Pereira', 'Rua Teixeira de Pascoaes, 117, 2º D', 4450, 117, '225901707', 3);

-- Inserção de registos na tabela FuncionarioReparacao
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (1,1,1);
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (4,1,4);
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (1,2,1);
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (2,2,6);
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (4,2,2);
INSERT INTO FuncionarioReparacao (idFuncionario, idReparacao, numHoras) VALUES (1,3,1);