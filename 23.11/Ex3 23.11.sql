CREATE DATABASE ex3
GO
USE ex3
GO
CREATE TABLE paciente(
cpf				CHAR(11)			NOT NULL,
nome			VARCHAR(60)			NOT NULL,
rua				VARCHAR(100)		NOT NULL,
nmr				INT					NOT NULL,
bairro			VARCHAR(100)		NOT NULL,
telefone		CHAR(9)				NULL,
data_nasc		DATE				NOT NULL
PRIMARY KEY (cpf)
)
GO
CREATE TABLE medico(
codigo			INT					NOT NULL		IDENTITY,
nome			VARCHAR(60)			NOT NULL,
especialidade	VARCHAR(80)			NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE prontuario(
data			DATE				NOT NULL,
cpf_paciente	CHAR(11)			NOT NULL,
codigo_medico	INT					NOT NULL,
diagnostico		VARCHAR(100)		NOT NULL,
medicamento		VARCHAR(100)		NOT NULL,
PRIMARY KEY (data, cpf_paciente, codigo_medico),
FOREIGN KEY (cpf_paciente) REFERENCES paciente (cpf),
FOREIGN KEY (codigo_medico) REFERENCES medico (codigo)
)

INSERT INTO paciente (cpf, nome, rua, nmr, bairro, telefone, data_nasc)
VALUES
('35454562890', 'José Rubens' , 'Campos Salles', 2750, 'Centro', '21450998', '1954-10-18'),
('29865439810', 'Ana Claudia', 'Sete de Setembro', 178, 'Centro', '97382764', '1960-05-29'),
('82176534800',	'Marcos Aurélio', 'Timóteo Penteado', 236, 'Vila Galvão', '68172651', '1980-09-24'),
('12386758770',	'Maria Rita', 'Castello Branco', 7765, 'Vila Rosália',	NULL, '1975-03-30'),
('92173458910',	'Joana de Souza', 'XV de Novembro',	298, 'Centro', '21276578', '1944-04-24')

INSERT INTO medico (nome, especialidade) 
VALUES
('Wilson Cesar', 'Pediatra'),
('Marcia Matos', 'Geriatra'),
('Carolina Oliveira', 'Ortopedista'),
('Vinicius Araujo', 'Clínico Geral')

INSERT INTO prontuario (data, cpf_paciente, codigo_medico, diagnostico, medicamento)
VALUES
('2020-09-10', '35454562890', 2, 'Reumatismo', 'Celebra'),
('2020-09-10', '92173458910', 2, 'Renite Alérgica', 'Allegra'),
('2020-09-12', '29865439810', 1, 'Inflamação de garganta', 'Nimesulida'),
('2020-09-13', '35454562890', 2, 'H1N1', 'Tamiflu'),
('2020-09-15', '82176534800', 4, 'Gripe', 'Resprin'),
('2020-09-15', '12386758770', 3, 'Braço Quebrado', 'Dorflex + Gesso')

SELECT nome, rua + ', ' + CAST(nmr AS VARCHAR(5)) + ', ' + bairro AS endereço
FROM paciente
WHERE  DATEDIFF(YEAR, data_nasc, GETDATE()) > 50

SELECT especialidade 
FROM medico
WHERE nome = 'Carolina Oliveira'

SELECT medicamento
FROM prontuario
WHERE diagnostico = 'Reumatismo'

SELECT diagnostico, medicamento
FROM prontuario
WHERE cpf_paciente IN 
(SELECT cpf
FROM paciente
WHERE nome = 'José Rubens'
)

SELECT nome, 
	CASE
		WHEN LEN(especialidade) > 3 THEN
		RTRIM(SUBSTRING(especialidade, 1, 3)) + '.'
		ELSE
		especialidade
	END AS especialidade
FROM medico
WHERE codigo IN
	(SELECT codigo_medico
	FROM prontuario
	WHERE cpf_paciente IN
		(SELECT cpf
		FROM paciente
		WHERE nome = 'José Rubens'
		)
)

SELECT SUBSTRING(cpf, 1, 3) + '.' + SUBSTRING(cpf, 4, 3) + '.' + 
SUBSTRING(cpf, 7, 3) + '-' + SUBSTRING(cpf, 10, 2) AS cpf, 
nome, rua + ', ' + CAST(nmr AS VARCHAR(5)) + ' ' + bairro AS endereço, 
	CASE
		WHEN telefone IS NULL THEN
		'telefone' 
		ELSE
		telefone
	END AS telefone
FROM paciente
WHERE cpf IN
	(SELECT cpf_paciente
	FROM prontuario
	WHERE codigo_medico IN
		(SELECT codigo
		FROM medico
		WHERE nome = 'Vinicius Araujo'
		)
	)

SELECT DATEDIFF(DAY, data, GETDATE()) AS dias
FROM prontuario
WHERE cpf_paciente IN 
	(SELECT cpf
	FROM paciente
	WHERE nome = 'Maria Rita'
	)

UPDATE paciente
SET telefone = '98345621'
WHERE nome = 'Maria Rita'

UPDATE paciente
SET rua = 'Voluntários da Pátria', nmr = 1980, bairro = 'Jd. Aeroporto'
WHERE nome = 'Joana de Souza'

SELECT * FROM paciente
SELECT * FROM medico
SELECT * FROM prontuario