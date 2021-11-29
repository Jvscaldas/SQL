CREATE DATABASE ex6
GO
USE ex6
GO
CREATE TABLE motorista (
codigo				INT					NOT NULL	IDENTITY(12341, 1),
nome				VARCHAR(100)		NOT NULL,
data_nasc			DATE				NOT NULL,
naturalidade		VARCHAR(100)		NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE onibus (
placa				CHAR(7)				NOT NULL,
marca				VARCHAR(60)			NOT NULL,
ano					INT					NOT NULL,
descricao			VARCHAR(100)		NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE viagem (
codigo				INT					NOT NULL	IDENTITY(101, 1),
onibus				CHAR(7)				NOT NULL,
motorista			INT					NOT NULL,
hr_saida			TIME				NOT NULL,
hr_chegada			TIME				NOT NULL,
destino				VARCHAR(100)		NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (onibus) REFERENCES onibus (placa),
FOREIGN KEY (motorista) REFERENCES motorista (codigo)
)

INSERT INTO motorista (nome, data_nasc, naturalidade) VALUES
('Julio Cesar', '1978-04-18', 'São Paulo'),
('Mario Carmo', '2002-07-29', 'Americana'),
('Lucio Castro', '1969-12-01', 'Campinas'),
('André Figueiredo', '1999-05-14', 'São Paulo'),
('Luiz Carlos',	'2001-01-09', 'São Paulo')

INSERT INTO onibus (placa, marca, ano, descricao) VALUES
('adf0965',	'Mercedes',	1999, 'Leito'),
('bhg7654',	'Mercedes',	2002, 'Sem Banheiro'),
('dtr2093',	'Mercedes',	2001, 'Ar Condicionado'),
('gui7625',	'Volvo', 2001, 'Ar Condicionado')

INSERT INTO viagem (onibus, motorista, hr_saida, hr_chegada, destino) VALUES
('adf0965', 12343, '10:00', '12:00', 'Campinas'),
('gui7625', 12341, '07:00', '12:00', 'Araraquara'),
('bhg7654',	12345, '14:00', '22:00', 'Rio de Janeiro'),
('dtr2093',	12344, '18:00', '21:00', 'Sorocaba')

-- Consultar, da tabela viagem, todas as horas de chegada e saída, 
-- convertidas em formato HH:mm (108) e seus destinos
SELECT CONVERT(CHAR(10), hr_saida, 108) AS saida, CONVERT(CHAR(10), hr_chegada, 108) AS chegada, destino
FROM viagem

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba	
SELECT nome
FROM motorista
WHERE codigo = (
SELECT motorista
FROM viagem
WHERE destino = 'Sorocaba'
)

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro		
SELECT descricao
FROM onibus
WHERE placa = (
SELECT onibus
FROM viagem
WHERE destino = 'Rio de Janeiro'
)

-- Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos	
SELECT descricao, marca, ano
FROM onibus
WHERE placa = (
	SELECT onibus
	FROM viagem
	WHERE motorista = (
		SELECT codigo
		FROM motorista
		WHERE nome = 'Luiz Carlos'
					)
				)

-- Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos					
SELECT nome, DATEDIFF(YEAR, data_nasc, GETDATE()) AS idade, naturalidade
FROM motorista
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 30