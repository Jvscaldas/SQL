CREATE DATABASE ex2
GO
USE ex2
GO
CREATE TABLE carro(
placa	CHAR(7)			NOT NULL,
marca	VARCHAR(20)		NOT NULL,
modelo	VARCHAR(20)		NOT NULL,
cor		VARCHAR(20)		NOT NULL,
ano		DATE			NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE cliente(
nome			VARCHAR(60)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
nmr				INT				NOT NULL,
bairro			VARCHAR(100)	NOT NULL,
telefone		CHAR(9)			NOT NULL,
carro			CHAR(7)			NOT NULL,
PRIMARY KEY (carro),
FOREIGN KEY (carro) REFERENCES carro(placa)
)
GO
CREATE TABLE pecas(
codigo		INT					NOT NULL		IDENTITY,
nome		VARCHAR(60)			NOT NULL,
valor		INT					NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE servico(
carro			CHAR(7)			NOT NULL,
peca			INT				NOT NULL,
quantidade		INT				NOT NULL,
valor			INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (carro, peca, data),
FOREIGN KEY (carro) REFERENCES carro(placa),
FOREIGN KEY (peca) REFERENCES pecas(codigo)
)

SELECT * FROM cliente
SELECT * FROM carro
SELECT * FROM pecas
SELECT * FROM servico

INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES
('AFT9087', 'VW', 'Gol', 'Preto', '2007'),
('DXO9876', 'Ford', 'Ka', 'Azul', '2000'),
('EGT4631', 'Renault', 'Clio', 'Verde',	'2004'),
('LKM7380',	'Fiat',	'Palio', 'Prata', '1997'),
('BCD7521',	'Ford',	'Fiesta', 'Preto', '1999')

INSERT INTO cliente(nome, logradouro, nmr, bairro, telefone, carro)
VALUES
('João Alves',	'R. Pereira Barreto',	1258,	'Jd. Oliveiras',	'2154-9658',	'DXO9876'),
('Ana Maria',	'R. 7 de Setembro',	259,	'Centro',	'9658-8541',	'LKM7380'),
('Clara Oliveira',	'Av. Nações Unidas',	10254,	'Pinheiros',	'2458-9658',	'EGT4631'),
('José Simões', 'R. XV de Novembro',	36,	'Água Branca',	'7895-2459',	'BCD7521'),
('Paula Rocha',	'R. Anhaia',	548,	'Barra Funda',	'6958-2548',	'AFT9087')

INSERT INTO pecas(nome, valor) 
VALUES
('Vela', 70),
('Correia Dentada',	125),
('Trambulador',	90),
('Filtro de Ar', 30)

INSERT INTO servico(carro, peca, quantidade, valor, data)
VALUES
('DXO9876',	1,	4, 280, '2020-08-01'), 
('DXO9876',	4,	1, 30, '2020-08-01'),
('EGT4631',	3,	1, 90, '2020-08-02'),
('DXO9876',	2,	1, 125, '2020-08-07')

SELECT telefone
FROM cliente
WHERE  carro IN (
SELECT placa FROM carro
WHERE cor = 'Azul' AND modelo = 'Ka'
)

SELECT logradouro + ', ' + CAST(nmr AS VARCHAR(5)) + ', ' + bairro AS Endereço
FROM cliente
WHERE carro IN (
SELECT carro FROM servico
WHERE data = '2020-08-02'
)

SELECT placa 
FROM carro
WHERE ano < '2001'

SELECT marca + ' '+ modelo + ' ' + cor 
FROM carro
WHERE ano > '2005'

SELECT codigo, nome 
FROM pecas
WHERE valor < 80