CREATE DATABASE ex1
GO
USE ex1

CREATE TABLE aluno(
ra			INT				NOT NULL,
nome		VARCHAR(60)		NOT NULL,
sobrenome	VARCHAR(60)		NOT NULL,
rua			VARCHAR(100)	NOT NULL,
nmr			INT				NOT NULL,
bairro		VARCHAR(100)	NOT NULL,
cep			CHAR(8)			NOT NULL,
telefone	VARCHAR(10)		NULL
PRIMARY KEY (ra)
)
GO
CREATE TABLE cursos(
codigo		INT				NOT NULL		IDENTITY,
nome		VARCHAR(60)		NOT NULL,
carga		INT				NOT NULL,
turno		VARCHAR(6)		NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE disciplinas(
codigo		INT				NOT NULL		IDENTITY,
nome		VARCHAR(60)		NOT NULL,
carga		INT				NOT NULL,
turno		VARCHAR(6)		NOT NULL,
semestre	INT				NOT NULL
PRIMARY KEY (codigo)
)

SELECT * FROM aluno
SELECT * FROM cursos
SELECT * FROM disciplinas

INSERT INTO aluno (ra, nome, sobrenome, rua, nmr, bairro, cep, telefone)
VALUES
(12345, 'José', 'Silva', 'Almirante Noronha', 236, 'Jardim São Paulo', '1589000', '69875287'),
(12346,	'Ana', 'Maria Bastos', 'Anhaia',	1568,	'Barra Funda',	'3569000',	'25698526'),
(12347,	'Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', '1020030', NULL),	
(12348,	'Marcia', 'Neves', 'Voluntários da Patria', 225, 'Santana',	'2785090',	'78964152')

INSERT INTO cursos (nome, carga, turno)
VALUES
('Informática',	2800,	'Tarde'),
('Informática',	2800,	'Noite'),
('Logística',	2650,	'Tarde'),
('Logística',	2650,	'Noite'),
('Plásticos',	2500,	'Tarde'),
('Plásticos',	2500,	'Noite')

INSERT INTO disciplinas(nome, carga, turno, semestre)
VALUES
('Informática', 4, 'Tarde',	1),
('Informática', 4, 'Noite',	1),
('Quimica',	4, 'Tarde',	1),
('Quimica',	4, 'Noite',	1),
('Banco de Dados I', 2,	'Tarde', 3),
('Banco de Dados I', 2,	'Noite', 3),
('Estrutura de Dados', 4, 'Tarde', 4),
('Estrutura de Dados', 4, 'Noite', 4)

SELECT nome + ' '+ sobrenome AS NomeCompleto
FROM aluno

SELECT rua + ', ' + CAST(nmr AS VARCHAR(5)) + ', ' + bairro + ', CEP:'+ cep AS Endereço
FROM aluno
WHERE telefone IS NULL

SELECT telefone 
FROM aluno
WHERE ra = 12348

SELECT nome, turno 
FROM cursos
WHERE carga = 2800

SELECT semestre
FROM disciplinas
WHERE nome LIKE '%Banco%' AND turno = 'Noite'