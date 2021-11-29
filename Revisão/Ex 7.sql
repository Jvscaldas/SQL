CREATE DATABASE ex7
GO
USE ex7
GO
CREATE TABLE cliente (
rg				VARCHAR(9)		NOT NULL,
cpf				CHAR(11)		NOT NULL,
nome			VARCHAR(60)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL
PRIMARY KEY (rg)
)
GO
CREATE TABLE pedido (
nota			INT					NOT NULL	IDENTITY(1001, 1),
valor			DECIMAL (7, 2)		NOT NULL,
data			DATE				NOT NULL,
rg_cliente		VARCHAR(9)				NOT NULL,
PRIMARY KEY (nota),
FOREIGN KEY (rg_cliente) REFERENCES cliente(rg)
)
GO
CREATE TABLE fornecedor (
codigo				INT					NOT NULL	IDENTITY,
nome				VARCHAR(60)			NOT NULL,
logradouro			VARCHAR(100)		NOT NULL,
numero				INT					NULL,
pais				VARCHAR(3)			NOT NULL,
area				INT					NOT NULL,
telefone			VARCHAR(11)			NULL,
cnpj				CHAR(14)			NULL,
cidade				VARCHAR(60)			NULL,
transporte			VARCHAR(20)			NULL,
moeda				VARCHAR(6)			NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE mercadoria (
codigo				INT					NOT NULL	IDENTITY (10, 1),
descricao			VARCHAR(80)			NOT NULL,
preco				DECIMAL (7, 2)		NOT NULL,
qtd					INT					NOT NULL,
cod_fornecedor		INT					NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (cod_fornecedor) REFERENCES fornecedor (codigo)
)

INSERT INTO cliente (rg, cpf, nome, logradouro, numero) VALUES 
('29531844', '34519878040', 'Luiz André', 'R. Astorga', 500),
('13514996x', '84984285630', 'Maria Luiza', 'R. Piauí',	174),
('121985541', '23354997310', 'Ana Barbara', 'Av. Jaceguai',	1141),
('23987746x', '43587669920', 'Marcos Alberto', 'R. Quinze', 22)

INSERT INTO pedido (valor, data, rg_cliente) VALUES
(754, '2018-04-01', '121985541'),
(350, '2018-04-02', '121985541'),
(30, '2018-04-02', '29531844'),
(1500, '2018-04-03', '13514996x')

INSERT INTO fornecedor (nome,	logradouro,	numero,	pais,	area,	telefone,	cnpj,	
cidade,	transporte,	moeda) VALUES
('Clone',		'Av. Nações Unidas, 12000',	12000,	'BR',	 55,	1141487000,	NULL,			'São Paulo',	NULL,		'R$'),
('Logitech',	'28th Street, 100',			100,	'USA',	  1,	2127695100, NULL,			NULL,			'Avião',	'US$'),
('LG',			'Rod. Castello Branco',		NULL,	'BR',	 55,	800664400,	4159978100001,	'Sorocaba',		NULL,		'R$'),
('PcChips',		'Ponte da Amizade',			NULL,	'PY',	595,	NULL,		NULL,			NULL,			'Navio',	'US$')

INSERT INTO mercadoria (descricao, preco, qtd, cod_fornecedor) VALUES
('Mouse',		24,		30,		1),
('Teclado',		50,		20,		1),
('Cx. De Som',	30,		8,		2),
('Monitor 17',	350,	4,		3),
('Notebook',	1500,	7,		4)

SELECT * FROM mercadoria
SELECT * FROM cliente
SELECT * FROM pedido
SELECT * FROM fornecedor
											
--Consultar 10% de desconto no pedido 1003															
SELECT (valor - (valor * 0.10)) AS desconto_10
FROM pedido
WHERE nota = 1003

--Consultar 5% de desconto em pedidos com valor maior de R$700,00															
SELECT (valor - (valor * 0.05)) AS desconto_5
FROM pedido
WHERE valor > 700

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10															
SELECT preco
FROM mercadoria
WHERE qtd < 10

UPDATE mercadoria
SET preco = preco + (preco * 0.20)
WHERE qtd < 10

--Data e valor dos pedidos do Luiz															
SELECT p.data, p.valor
FROM pedido p, cliente c
WHERE p.rg_cliente = c.rg
	AND c.nome = 'Luiz André' 

--CPF, Nome e endereço concatenado do cliente de nota 1004															
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 3) AS cpf, 
nome, 
c.logradouro + ', ' + CAST(c.numero AS VARCHAR(10)) AS endereco
	
FROM cliente c, pedido p
WHERE c.rg = p.rg_cliente
	AND p.nota = 1004

--País e meio de transporte da Cx. De som															
SELECT f.pais, f.transporte
FROM mercadoria m, fornecedor f
WHERE f.codigo = m.cod_fornecedor
	AND m.descricao = 'Cx. De som'

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone															
SELECT m.descricao, m.qtd
FROM fornecedor f, mercadoria m
WHERE f.codigo = m.cod_fornecedor
	AND f.nome = 'Clone' 

--Endereço concatenado e telefone dos fornecedores do monitor. 
--(Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800), Telefone Americano (XXX)XXX-XXXX)
SELECT 
	CASE 
	WHEN f.numero IS NULL THEN
		f.logradouro + ', ' + f.pais

	ELSE
		f.logradouro + ', ' + CAST(f.numero AS VARCHAR(10)) + ', ' + f.pais

	END AS endereco,

		CASE
		WHEN f.pais = 'USA' THEN
			'(' + SUBSTRING(f.telefone, 1, 2) + ')' + SUBSTRING(f.telefone, 3, 4) + '-' + SUBSTRING(f.telefone, 7, 4)

		ELSE 
			CASE
			WHEN	LEN(f.telefone) > 9 THEN
				'(' + SUBSTRING(f.telefone, 1, 3) + ')' + SUBSTRING(f.telefone, 4, 3) + '-' + SUBSTRING(f.telefone, 7, 4) 
			
			ELSE
				 SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4) 
			END

		END AS telefone

FROM fornecedor f, mercadoria m
WHERE f.codigo = m.cod_fornecedor
	AND m.descricao LIKE '%Monitor%'

--Tipo de moeda que se compra o notebook
SELECT f.moeda
FROM fornecedor f, mercadoria m
WHERE f.codigo = m.cod_fornecedor
	AND m.descricao = 'Notebook' 

--Considerando que hoje é 03/02/2019, há quantos dias foram feitos os pedidos e, 
--criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses e pedido recente para os outros	
SELECT	DATEDIFF(DAY, data, '2019-02-03') AS dias_pedido, 
		DATEDIFF(MONTH, data, '2019-02-03') AS pedido_antigo, 
		DATEDIFF(MONTH, data, '2019-02-03') AS pedido_recente
FROM pedido  

--Nome e Quantos pedidos foram feitos por cada cliente		
SELECT DISTINCT c.nome, COUNT(p.rg_cliente) AS pedidos_feitos
FROM pedido P , cliente c
WHERE c.rg = p.rg_cliente
GROUP BY p.nota, c.nome



--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos															
SELECT 
	CASE
	WHEN LEN(c.rg) > 8 THEN 
	SUBSTRING(c.rg, 1, 8) + '-' + SUBSTRING(c.rg, 9, 1)
	
	ELSE
	SUBSTRING(c.rg, 1, 7) + '-' + SUBSTRING(c.rg, 8, 1)
	
	END AS rg, 
	SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 3) AS cpf,
	c.nome, 
	c.logradouro + ', ' + CAST(c.numero AS VARCHAR(10)) AS endereco
FROM cliente c LEFT OUTER JOIN  pedido p
ON c.rg = p.rg_cliente
WHERE p.rg_cliente IS NULL

