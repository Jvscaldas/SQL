CREATE DATABASE ex8
GO
USE ex8
GO
CREATE TABLE cliente (
codigo						INT				NOT NULL	IDENTITY,
nome						VARCHAR(60)		NOT NULL,
endereco					VARCHAR(100)	NOT NULL,
telefone					CHAR(8)			NOT NULL,
telefone_comercial			CHAR(8)			NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE compra (
nota						INT				NOT NULL,
codigo_cliente				INT				NOT NULL,
valor						DECIMAL(7,2)	NOT NULL,
PRIMARY KEY (nota),
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo)
)
GO
CREATE TABLE tipo (
codTipo						INT				NOT NULL,
nome						VARCHAR(60)		NULL
PRIMARY KEY (codTipo)
)
GO
CREATE TABLE corredores (
codCorre		INT				NOT NULL,
tipoCorre		INT				NOT NULL,
nome			VARCHAR(60)		NULL,
PRIMARY KEY (codCorre),
FOREIGN KEY (tipoCorre) REFERENCES tipo (codTipo)
)
GO
CREATE TABLE mercadoria(
codMerc		INT				NOT NULL,
nome		VARCHAR(60)		NULL,
mercCorre	INT				NOT NULL,
mercTipo	INT				NOT NULL,
valor		DECIMAL(7,2)	NOT NULL,
PRIMARY KEY (codMerc),
FOREIGN KEY (mercCorre) REFERENCES corredores (codCorre),
FOREIGN KEY (mercTipo) REFERENCES tipo (codTipo)
)

INSERT INTO cliente (nome, endereco, telefone, telefone_comercial) VALUES
('Luis Paulo',		'R. Xv de Novembro, 100',			 45657878,	NULL),	
('Maria Fernanda',	'R. Anhaia, 1098',					27289098,	40040090),
('Ana Claudia',		'Av. Voluntários da Pátria, 876',	21346548,	NULL),	
('Marcos Henrique',	'R. Pantojo, 76',					51425890,	30394540),
('Emerson Souza',	'R. Pedro Álvares Cabral, 97',		44236545,	39389900),
('Ricardo Santos',	'Trav. Hum, 10',					98789878,	NULL)

INSERT INTO compra (nota, codigo_cliente, valor) VALUES
(1234,	2,	200),
(2345,	4,	156),
(3456,	6,	354),
(4567,	3,	19)

INSERT INTO tipo (codTipo, nome) VALUES
(10001,	'Pães'),
(10002,	'Frios'),
(10003,	'Bolacha'),
(10004,	'Clorados'),
(10005,	'Frutas'),
(10006,	'Esponjas'),
(10007,	'Massas'),
(10008,	'Molhos')

INSERT INTO corredores (codCorre, tipoCorre, nome) VALUES
(101,	10001,	'Padaria'),
(102,	10002,	'Calçados'),
(103,	10003,	'Biscoitos'),
(104,	10004,	'Limpeza'),
(105,	1, NULL),
(106,	1, NULL),
(107,	10007,	'Congelados')

INSERT INTO mercadoria (nome, mercCorre, mercTipo, valor) VALUES
('Pão de Forma',	101,	10001,	3.5),
('Presunto',		101,	10002,	2.0),
('Cream Cracker',	103,	10003,	4.5),
('Água Sanitária',	104,	10004,	6.5),
('Maçã',			105,	10005,	0.9),
('Palha de Aço',	106,	10006,	1.3),
('Lasanha',			107,	10007,	9.7)

select * from cliente
select * from compra
select * from tipo
select * from corredores

DROP TABLE tipo
DROP TABLE corredores
DROP TABLE mercadoria
DELETE FROM tipo

DBCC CHECKIDENT('tipo', RESEED)

ALTER TABLE tipo
ALTER COLUMN codigo						INT				 NULL	IDENTITY(1001, 1)