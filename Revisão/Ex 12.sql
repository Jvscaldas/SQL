CREATE DATABASE ex12
GO
USE ex12
GO
CREATE TABLE planos (
codPlano			INT				NOT NULL	IDENTITY,
nomePlano			VARCHAR(60)		NOT NULL,
valorPlano			DECIMAL(7, 2)	NOT NULL
PRIMARY KEY (codPlano)
)
GO
CREATE TABLE servicos (
codServico			INT					NOT NULL	IDENTITY,
nomeServico			VARCHAR(100)		NOT NULL,
valorServico		DECIMAL(7, 2)		NOT NULL
PRIMARY KEY (codServico)
)
GO
CREATE TABLE cliente (
codCliente			INT					NOT NULL	IDENTITY(1024, 1024),
nomeCliente			VARCHAR(60)			NOT NULL,
dataInicio			DATE				NOT NULL
PRIMARY KEY (codCliente)
)
GO
CREATE TABLE contratos (
codCliente			INT					NOT NULL,
codPlano			INT					NOT NULL,
codServico			INT					NOT NULL,
status				CHAR(1)				NOT NULL,
data				DATE				NOT NULL,
PRIMARY KEY (codCliente, codPlano, codServico),
FOREIGN KEY (codCliente) REFERENCES cliente (codCliente),
FOREIGN KEY (codPlano) REFERENCES planos (codPlano),
FOREIGN KEY (codServico) REFERENCES servicos (codServico)
)

INSERT INTO planos (nomePlano, valorPlano) VALUES
('100 Minutos',	80),
('150 Minutos',	130),
('200 Minutos',	160),
('250 Minutos',	220),
('300 Minutos',	260),
('600 Minutos',	350)

INSERT INTO servicos (nomeServico, valorServico) VALUES
('100 SMS',	10),
('SMS Ilimitado',	30),
('Internet 500 MB',	40),
('Internet 1 GB',	60),
('Internet 2 GB',	70)

INSERT INTO cliente (nomeCliente, dataInicio) VALUES
('Cliente A',	'2012-10-15'),
('Cliente B',	'2012-11-20'),
('Cliente C',	'2012-11-25'),
('Cliente D',	'2012-12-01'),
('Cliente E',	'2012-12-18'),
('Cliente F',	'2013-01-20'),
('Cliente G',	'2013-01-25')

INSERT INTO contratos (codCliente, codPlano, codServico, status, data) VALUES
(1234,	3,	1,	'E',	'2012-10-15'),
(1234,	3,	3,	'E',	'2012-10-15'),
(1234,	3,	3,	'A',	'2012-10-16'),
(1234,	3,	1,	'A',	'2012-10-16'),
(2468,	4,	4,	'E',	'2012-11-20'),
(2468,	4,	4,	'A',	'2012-11-21'),
(6170,	6,	2,	'E',	'2012-12-18'),
(6170,	6,	5,	'E',	'2012-12-19'),
(6170,	6,	2,	'A',	'2012-12-20'),
(6170,	6,	5,	'A',	'2012-12-21'),
(1234,	3,	1,	'D',	'2013-01-10'),
(1234,	3,	3,	'D',	'2013-01-10'),
(1234,	2,	1,	'E',	'2013-01-10'),
(1234,	2,	1,	'A',	'2013-01-11'),
(2468,	4,	4,	'D',	'2013-01-25'),
(7404,	2,	1,	'E',	'2013-01-20'),
(7404,	2,	5,	'E',	'2013-01-20'),
(7404,	2,	5,	'A',	'2013-01-21'),
(7404,	2,	1,	'A',	'2013-01-22'),
(8638,	6,	5,	'E',	'2013-01-25'),
(8638,	6,	5,	'A',	'2013-01-26'),
(7404,	2,	5,	'D',	'2013-02-03')

SELECT * FROM planos
SELECT * FROM servicos
SELECT * FROM cliente
SELECT * FROM contratos