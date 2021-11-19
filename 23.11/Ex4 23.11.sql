CREATE DATABASE ex4
GO
USE ex4
GO
CREATE TABLE cliente(
cpf			CHAR(12)		NOT NULL,
nome		VARCHAR(60)		NOT NULL,
telefone	CHAR(9)			NOT NULL
PRIMARY KEY (cpf)
)
GO
CREATE TABLE fornecedor(
id				INT				NOT NULL		IDENTITY,
nome			VARCHAR(60)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
nmr				INT				NOT NULL,
complemento		VARCHAR(60)		NOT NULL,
cidade			VARCHAR(60)		NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE produto(
codigo		INT				NOT NULL		IDENTITY,
descricao	VARCHAR(100)	NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7, 2)	NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (fornecedor) REFERENCES fornecedor (id)
)
GO
CREATE TABLE venda(
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(12)		NOT NULL,
quantidade		INT				NOT NULL,
valor_total		DECIMAL(7, 2)	NOT NULL,
data			DATE			NOT NULL,
PRIMARY KEY (codigo, produto, cliente),
FOREIGN KEY (produto) REFERENCES produto (codigo), 
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)

INSERT INTO cliente (cpf, nome, telefone)
VALUES
('345789092-90', 'Julio Cesar', '8273-6541'),
('251865337-10', 'Maria Antonia', '8765-2314'),
('876273154-16', 'Luiz Carlos',	'6128-9012'),
('791826398-00', 'Paulo Cesar',	'9076-5273')

INSERT INTO fornecedor (nome, logradouro, nmr, complemento, cidade)
VALUES
('LG',	'Rod. Bandeirantes',	70000,	'Km 70',	'Itapeva'),
('Asus',	'Av. Nações Unidas',	10206,	'Sala 225',	'São Paulo'),
('AMD',	'Av. Nações Unidas',	10206,	'Sala 1095',	'São Paulo'),
('Leadership', 'Av. Nações Unidas',	10206,	'Sala 87',	'São Paulo'),
('Inno', 'Av. Nações Unidas',	10206, 'Sala 34', 'São Paulo')

INSERT INTO produto (descricao, fornecedor, preco)
VALUES
('Monitor 19 pol.',	1, '449.99'),
('Netbook 1GB Ram 4 Gb HD', 2, '699.99'),
('Gravador de DVD - Sata', 1, '99.99'),
('Leitor de CD', 1,	'49.99'),
('Processador - Phenom X3 - 2.1GHz', 3,	'349.99'),
('Mouse', 4, '19.99'),
('Teclado',	4, '25.99'),
('Placa de Video - Nvidia 9800 GTX - 256MB/256 bits', 5, '599.99')

INSERT INTO venda(codigo, produto, cliente, quantidade, valor_total, data)
VALUES
(1,	1, '251865337-10', 1, '449.99', '2009-09-03'),
(1,	4, '251865337-10', 1, '49.99', '2009-09-03'),
(1,	5, '251865337-10', 1,'349.99', '2009-09-03'),
(2,	6, '791826398-00', 4, '79.96', '2009-09-06'),
(3,	8, '876273154-16', 1, '599.99', '2009-09-06'),
(3,	3, '876273154-16', 1, '99.99', '2009-09-06'),
(3,	7, '876273154-16', 1, '25.99', '2009-09-06'),
(4,	2, '345789092-90', 2, '1399.98', '2009-09-08')

SELECT CONVERT(VARCHAR, data, 103) AS data
FROM venda
WHERE codigo = 4

SELECT * FROM fornecedor

ALTER TABLE fornecedor
ADD telefone	CHAR(9)		 NULL

UPDATE fornecedor
SET telefone = '7216-5371'
WHERE id = 1

UPDATE fornecedor
SET telefone = '8715-3738'
WHERE id = 2

UPDATE fornecedor
SET telefone = '3654-6289'
WHERE id = 4

SELECT nome, 
logradouro + ', ' + CAST(nmr AS VARCHAR(5)) + ', ' + complemento + ', ' + cidade AS endereço, 
telefone
FROM fornecedor
ORDER BY nome ASC

SELECT produto, quantidade, valor_total
FROM venda
WHERE cliente IN
	(SELECT cpf
	FROM cliente
	WHERE nome = 'Julio Cesar')

SELECT CONVERT(VARCHAR, data, 103) AS data, valor_total
FROM venda
WHERE cliente IN
	(SELECT cpf
	FROM cliente
	WHERE nome = 'Paulo Cesar')

SELECT descricao, preco
FROM produto
ORDER BY preco DESC