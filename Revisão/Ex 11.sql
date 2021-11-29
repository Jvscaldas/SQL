CREATE DATABASE ex11
GO
USE ex11
GO
CREATE TABLE planoSaude (
codigoPlano			INT				NOT NULL	IDENTITY (1234, 1111),
nomePlano			VARCHAR(60)		NOT NULL,
telefonePlano		CHAR(9)			NOT NULL
PRIMARY KEY (codigoPlano)
)
GO
CREATE TABLE paciente(
cpfPaciente				CHAR(11)		NOT NULL,
nomePaciente			VARCHAR(60)		NOT NULL,
rua						VARCHAR(80)		NOT NULL,
nmr						INT				NOT NULL,
bairro					VARCHAR(40)		NOT NULL,
telefone				CHAR(9)			NOT NULL,
plano					INT				NOT NULL,
PRIMARY KEY (cpfPaciente),
FOREIGN KEY (plano) REFERENCES planoSaude (codigoPlano)
)
GO
CREATE TABLE medico (
codigoMedico			INT					NOT NULL	IDENTITY,
nomeMedico				VARCHAR(60)			NOT NULL,
especialidade			VARCHAR(100)		NOT NULL,
plano					INT					NOT NULL,
PRIMARY KEY (codigoMedico),
FOREIGN KEY (plano) REFERENCES planoSaude (codigoPlano)
)
GO
CREATE TABLE consulta (
consultaMedico			INT					NOT NULL,
consultaPaciente		CHAR(11)			NOT NULL,
dataHora				DATETIME			NOT NULL,
diagnostico				VARCHAR(100)		NOT NULL,
PRIMARY KEY (dataHora),
FOREIGN KEY (consultaMedico) REFERENCES medico (codigoMedico),
FOREIGN KEY (consultaPaciente) REFERENCES paciente (cpfPaciente)
)

INSERT INTO planoSaude (nomePlano, telefonePlano) VALUES
('Amil',				41599856),
('Sul Am�rica',			45698745),
('Unimed',				48759836),
('Bradesco Sa�de',		47265897),
('Interm�dica',			41415269)

INSERT INTO paciente (cpfPaciente, nomePaciente, rua, nmr, bairro, telefone, plano) VALUES
('85987458920',	'Maria Paula',	'R. Volunt�rios da P�tria',		589,	'Santana',		98458741,	2345),
('87452136900',	'Ana Julia',	'R. XV de Novembro',			657,	'Centro',		69857412,	5678),
('23659874100',	'Jo�o Carlos',	'R. Sete de Setembro',			12,		'Rep�blica',	74859632,	1234),
('63259874100',	'Jos� Lima',	'R. Anhaia',					768,	'Barra Funda',	96524156,	2345)

INSERT INTO medico (nomeMedico, especialidade, plano) VALUES
('Claudio',		'Cl�nico Geral',			1234),
('Larissa',		'Ortopedista',				2345),
('Juliana',		'Otorrinolaringologista',	4567),
('S�rgio',		'Pediatra',					1234),
('Julio',		'Cl�nico Geral',			4567),
('Samara',		'Cirurgi�o',				1234)

INSERT INTO consulta (consultaMedico, consultaPaciente, dataHora, diagnostico) VALUES
(1,	'85987458920',	'2021-02-10 10:30:00',	'Gripe'),
(2,	'23659874100',	'2021-02-10 11:00:00',	'P� Fraturado'),
(4,	'85987458920',	'2021-02-11 14:00:00',	'Pneumonia'),
(1,	'23659874100',	'2021-02-11 15:00:00',	'Asma'),
(3,	'87452136900',	'2021-02-11 16:00:00',	'Sinusite'),
(5,	'63259874100',	'2021-02-11 17:00:00',	'Rinite'),
(4,	'23659874100',	'2021-02-11 18:00:00',	'Asma'),
(5,	'63259874100',	'2021-02-12 10:00:00',	'Rinoplastia')

-- Nome e especialidade dos m�dicos da Amil	
SELECT m.nomeMedico, m.especialidade
FROM medico m, planoSaude ps
WHERE m.plano = ps.codigoPlano
	AND ps.nomePlano LIKE '%Amil%'

-- Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes	
SELECT nomePaciente, rua + ', ' + CAST(nmr AS VARCHAR(5)) + ', ' + bairro AS endereco, telefone, plano
FROM paciente 

-- Telefone do Plano de  Sa�de de Ana J�lia		
SELECT ps.telefonePlano
FROM planoSaude ps, paciente p
WHERE ps.codigoPlano = p.plano
	AND p.nomePaciente LIKE '%Ana%'

-- Plano de Sa�de que n�o tem pacientes cadastrados									
SELECT ps.nomePlano
FROM planoSaude ps LEFT OUTER JOIN paciente p
ON ps.codigoPlano = p.plano
WHERE p.plano IS NULL

-- Planos de Sa�de que n�o tem m�dicos cadastrados	
SELECT ps.nomePlano
FROM planoSaude ps LEFT OUTER JOIN medico m
ON ps.codigoPlano = m.plano
WHERE m.plano IS NULL

-- Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas	
SELECT dataHora, m.nomeMedico, p.nomePaciente, c.diagnostico
FROM consulta c, medico m, paciente p
WHERE c.consultaMedico = m.codigoMedico
	AND c.consultaPaciente = p.cpfPaciente

-- Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima	
SELECT m.nomeMedico, c.dataHora, c.diagnostico
FROM medico m, consulta c, paciente p 
WHERE m.codigoMedico = c.consultaMedico
	AND c.consultaPaciente = p.cpfPaciente
	AND p.nomePaciente LIKE '%Jos�%'

-- Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva	
UPDATE paciente
SET nomePaciente = 'Jo�o Carlos da Silva'
WHERE nomePaciente = 'Jo�o Carlos'

-- Deletar o plano de Sa�de Unimed	
DELETE FROM planoSaude
WHERE nomePlano = 'Unimed' 

-- Renomear a coluna Rua da tabela Paciente para Logradouro	
exec sp_rename 'paciente.[rua]', 'logradouro', 'column'

-- Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente	
ALTER TABLE paciente
ADD data_nasc DATE NULL

INSERT INTO paciente (data_nasc) VALUES
('1990-04-18'),
('1981-03-25'),
('2004-09-04'), 
('1986-06-18')

SELECT * FROM planoSaude
SELECT * FROM paciente
SELECT * FROM medico
SELECT * FROM consulta
