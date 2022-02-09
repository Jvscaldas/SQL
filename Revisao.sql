create database revisao
go 
use revisao

create table aluno (
ra		int				not null	primary key,
nome	varchar(100)	not null,
idade	int				not null,
check	(idade > 0)
)

create table disciplina (
codigo	int				not null	primary key,
nome	varchar(80)		not null,
ch		int				not null,
check	(ch >= 32)
)

create table aluno_disciplina (
aluno_ra				int				not null,
disciplina_codigo		int				not null,
primary key (aluno_ra, disciplina_codigo),
foreign key (aluno_ra) references aluno(ra),
foreign key (disciplina_codigo) references disciplina (codigo)
)

create table curso (
codigo	int				not null	primary key,
nome	varchar(50)		not null,
area	varchar(100)	not null
)

create table curso_disciplina (
curso_codigo			int				not null,
disciplina_codigo		int				not null,
primary key (curso_codigo, disciplina_codigo),
foreign key (curso_codigo) references curso (codigo),
foreign key (disciplina_codigo) references disciplina (codigo)
)

create table titulacao (
codigo		int				not null	primary key,
titulo		varchar(40)		not null
)

create table professor (
registro	int				not null	primary key,
nome		varchar(100)	not null,
titulacao	int				not null,
foreign key (titulacao) references titulacao (codigo)
)

create table disciplina_professor (
disciplina_codigo		int				not null,
professor_registro		int				not null,
primary key (disciplina_codigo, professor_registro),
foreign key (disciplina_codigo) references disciplina (codigo),
foreign key (professor_registro) references professor (registro)
)

insert into aluno(ra, nome, idade) values 
(3416,	'DIEGO PIOVESAN DE RAMOS',	18),
(3423,	'LEONARDO MAGALHÃES DA ROSA',	17),
(3434,	'LUIZA CRISTINA DE LIMA MARTINELI',	20),
(3440,	'IVO ANDRÉ FIGUEIRA DA SILVA',	25),
(3443,	'BRUNA LUISA SIMIONI',	37),
(3448,	'THAÍS NICOLINI DE MELLO',	17),
(3457,	'LÚCIO DANIEL TÂMARA ALVES',	29),
(3459,	'LEONARDO RODRIGUES',	25),
(3465,	'ÉDERSON RAFAEL VIEIRA',	19),
(30466,	'DAIANA ZANROSSO DE OLIVEIRA',	21),
(3467,	'DANIELA MAURER',	23),
(3470,	'ALEX SALVADORI PALUDO',	42),
(3471,	'VINÍCIUS SCHVARTZ',	19),
(3472,	'MARIANA CHIES ZAMPIERI',	18),
(3482,	'EDUARDO CAINAN GAVSKI',	19),
(3483,	'REDNALDO ORTIZ DONEDA',	20),
(3499,	'MAYELEN ZAMPIERON',	22)

insert into disciplina (codigo, nome, ch) values
(1,	'Laboratório de Banco de Dados',	80),
(2,	'Laboratório de Engenharia de Software',	80),
(3,	'Programação Linear e Aplicações',	80),
(4,	'Redes de Computadores',	80),
(5,	'Segurança da informação',	40),
(6,	'Teste de Software',	80),
(7,	'Custos e Tarifas Logísticas',	80),
(8,	'Gestão de Estoques',	40),
(9,	'Fundamentos de Marketing',	40),
(10,'Métodos Quantitativos de Gestão',	80),
(11,'Gestão do Tráfego Urbano',	80),
(12,'Sistemas de Movimentação e Transporte',	40)

insert into aluno_disciplina (disciplina_codigo, aluno_ra) values

insert into curso (codigo, nome, area) values
(1,	'ADS',		'Ciências da Computação'),
(2,	'Logística',	'Engenharia Civil')

insert into curso_disciplina (disciplina_codigo, curso_codigo) values 
(1,	1),
(2,	1),
(3,	1),
(4,	1),
(5,	1),
(6,	1),
(7,	2),
(8,	2),
(9,	2),
(10,	2),
(11,	2),
(12,	2)

insert into titulacao (codigo, titulo) values
(1,	'Especialista'),
(2,	'Mestre'),
(3,	'Doutor')

insert into professor (registro, nome, titulacao) values
(1111,	'Leandro',	2),
(1112,	'Antonio',	2),
(1113,	'Alexandre',	3),
(1114,	'Wellington',	2),
(1115,	'Luciano',	1),
(1116,	'Edson',	2),
(1117,	'Ana',	2),
(1118,	'Alfredo',	1),
(1119,	'Celio',	2),
(1120,	'Dewar',	3),
(1121,	'Julio',	1)

insert into disciplina_professor (disciplina_codigo, professor_registro) values 
(1,	1111),
(2,	1112),
(3,	1113),
(4,	1114),
(5,	1115),
(6,	1116),
(7,	1117),
(8,	1118),
(9,	1117),
(10,	1119),
(11,	1120),
(12,	1121)

--Como fazer as listas de chamadas, com RA e nome por disciplina ?								
SELECT a.ra, a.nome
FROM aluno a, disciplina d
WHERE d.codigo = 'CODIGO_DISCIPLINA'

--Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram								
SELECT p.nome, d.nome
FROM professor p, disciplina d, disciplina_professor dp
WHERE p.registro = dp.professor_registro
AND d.codigo = dp.disciplina_codigo

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso								
SELECT c.nome
FROM curso c, disciplina d, curso_disciplina cd
WHERE d.nome = 'NOME_DISCIPLINA'
AND c.codigo = cd.curso_codigo
AND	d.codigo = cd.disciplina_codigo

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne sua área								
SELECT c.area
FROM curso c, disciplina d, curso_disciplina cd
WHERE d.nome = 'NOME_DISCIPLINA'
AND c.codigo = cd.curso_codigo
AND	d.codigo = cd.disciplina_codigo

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o título do professor que a ministra								
SELECT t.titulo
FROM professor p, titulacao t, disciplina d, disciplina_professor dp
WHERE d.nome = 'NOME_DISCIPLINA'
AND p.registro = dp.professor_registro
AND d.codigo = dp.disciplina_codigo
AND p.titulacao = t.codigo

--Fazer uma pesquisa que retorne o nome da disciplina e quantos alunos estão matriculados em cada uma delas								
SELECT d.nome, COUNT(a.nome) AS qtd_matriculados
FROM aluno a, aluno_disciplina ad, disciplina d
WHERE a.ra = ad.aluno_ra
AND d.codigo = ad.disciplina_codigo
GROUP BY d.nome
ORDER BY d.nome

--Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor.  
--Só deve retornar de disciplinas que tenham, no mínimo, 5 alunos matriculados													
SELECT p.nome AS professor, COUNT(a.nome) AS qtd_matriculados,
	CASE
	WHEN COUNT(a.nome) >= 5 THEN
	d.nome
	ELSE
	''
	END AS disciplina
FROM aluno a, aluno_disciplina ad, disciplina d, professor p, disciplina_professor dp
WHERE a.ra = ad.aluno_ra
AND d.codigo = ad.disciplina_codigo
AND d.nome = 'NOME_DISCIPLINA'
AND p.registro = dp.professor_registro
AND d.codigo = dp.disciplina_codigo
GROUP BY d.nome, p.nome
ORDER BY d.nome, p.nome

--Fazer uma pesquisa que retorne o nome do curso e a quatidade de professores cadastrados que ministram aula nele. 
--A coluna deve se chamar quantidade		
SELECT c.nome, COUNT(p.nome) AS quantidade
FROM professor p, curso c, disciplina_professor dp, curso_disciplina cd, disciplina d
WHERE p.registro = dp.professor_registro
AND c.codigo = cd.curso_codigo
AND cd.disciplina_codigo = d.codigo 
AND cd.disciplina_codigo = dp.disciplina_codigo
GROUP BY c.nome
ORDER BY c.nome
