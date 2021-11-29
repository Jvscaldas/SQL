CREATE DATABASE ex5
GO
USE ex5
GO
CREATE TABLE produto (
codigo					INT					NOT NULL		IDENTITY,
nome					VARCHAR(150)		NOT NULL,	
valor_unitario			DECIMAL (7, 2)		NOT NULL,
quantidade_estoque		INT					NULL,
descricao				VARCHAR(200)		NOT NULL,
codigo_fornecedor		INT					NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codigo_fornecedor) REFERENCES fornecedores (codigo)
)
GO
CREATE TABLE fornecedores (
codigo					INT					NOT NULL		IDENTITY (1001, 1),
nome					VARCHAR(100)		NOT NULL,
atividade				VARCHAR(150)		NOT NULL,
telefone				CHAR(9)				NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE cliente (
codigo					INT					NOT NULL		IDENTITY (33601, 1),
nome					VARCHAR(100)		NOT NULL,
logradouro				VARCHAR(150)		NOT NULL,
numero					INT					NOT NULL,
telefone				CHAR(9)				NOT NULL,
data_nasc				DATE				NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE pedido (
codigo					INT					NOT NULL,
codigo_cliente			INT					NOT NULL,
codigo_produto			INT					NOT NULL,
quantidade				INT					NOT NULL,
previsao_entrega		DATE				NOT NULL,
PRIMARY KEY (codigo, codigo_cliente, codigo_produto),
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo),
FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)

INSERT INTO produto (nome, valor_unitario, quantidade_estoque, descricao, codigo_fornecedor) VALUES 
('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
('Faqueiro', 350.00, 0,	'120 peças', 1004),
('Jogo para churrasco',	75.00, 3, '7 peças', 1004),
('Tablet', 750.00,	29,	'Tablet', 1003),
('Detetive', 49.00,	0, 'Nova Versão do Jogo', 1001),
('Chocolate com Paçoquinha', 6.00,	0, 'Barra', 1002),
('Galak', 5.00,	65,	'Barra', 1002)

INSERT INTO fornecedores (nome, atividade, telefone) VALUES
('Estrela',	'Brinquedo', 41525898),
('Lacta', 'Chocolate', 42698596),
('Asus', 'Informática', 52014596),
('Tramontina', 'Utensílios Domésticos',	50563985),
('Grow', 'Brinquedos', 47896325),
('Mattel', 'Bonecos',	59865898)

INSERT INTO cliente (nome, logradouro, numero, telefone, data_nasc) VALUES
('Maria Clara',	'R. 1° de Abril', 870, 96325874, '2000-08-15'),
('Alberto Souza', 'R. XV de Novembro', 987, 95873625, '1985-02-02'),
('Sonia Silva',	'R. Voluntários da Pátria',	1151, 75418596, '1957-08-23'),
('José Sobrinho', 'Av. Paulista',	250, 85236547, '1986-12-09'),
('Carlos Camargo', 'Av. Tiquatira', 9652, 75896325, '1971-03-25')

INSERT INTO pedido (codigo, codigo_cliente, codigo_produto, quantidade, previsao_entrega) VALUES
(99001,	33601,	1,	1,	'2012-06-07'),
(99001,	33601,	2,	1,	'2012-06-07'),
(99001,	33601,	8,	3,	'2012-06-07'),
(99002,	33602,	2,	1,	'2012-06-09'),
(99002,	33602,	4,	3,	'2012-06-09'),
(99003,	33605,	5,	1,	'2012-06-15')

SELECT * FROM produto
SELECT * FROM fornecedores
SELECT * FROM cliente
SELECT * FROM pedido

-- Consultar a quantidade, valor total e valor total com desconto (25%) 
-- dos itens comprados par Maria Clara.

SELECT pe.quantidade, p.valor_unitario ,SUM(p.valor_unitario * 0.25) AS total
FROM pedido pe, produto p, cliente c
WHERE pe.codigo_produto = p.codigo
	AND pe.codigo_cliente = c.codigo
	AND c.nome LIKE '%Maria%'
GROUP BY c.codigo, pe.quantidade, p.valor_unitario
HAVING SUM(p.valor_unitario) > 0

-- Verificar quais brinquedos não tem itens em estoque.
SELECT p.nome AS brinquedo
FROM fornecedores f, produto p
WHERE f.atividade LIKE '%Brinquedo%'
	AND p.codigo_fornecedor = f.codigo
	AND p.quantidade_estoque = 0 

--Alterar para reduzir em 10% o valor das barras de chocolate.				
UPDATE produto
SET valor_unitario = valor_unitario - (valor_unitario * 0.10)
WHERE descricao = 'Barra' 

--Alterar a quantidade em estoque do faqueiro para 10 peças.	
UPDATE produto
SET quantidade_estoque = 10
WHERE nome = 'Faqueiro'

--Consultar quantos clientes tem mais de 40 anos.	
SELECT COUNT(data_nasc) AS clintes_com_mais_de_40
FROM cliente
WHERE DATEDIFF(YEAR, data_nasc, GETDATE()) > 40

--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.	
SELECT nome, telefone
FROM fornecedores
WHERE atividade = 'Chocolate'
	OR atividade LIKE '%Brinquedo%'

--Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00
SELECT nome, (valor_unitario - (valor_unitario * 0.25)) AS valor_com_desconto
FROM produto
WHERE valor_unitario < 50

--Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00		
SELECT nome, (valor_unitario + (valor_unitario * 0.10)) AS valor_com_acrescimo
FROM produto
WHERE valor_unitario > 100

--Consultar desconto de 15% no valor total de cada produto da venda 99001.
SELECT (p.valor_unitario - (p.valor_unitario * 0.15)) AS valor_com_desconto
FROM produto p, pedido pe
WHERE pe.codigo_produto = p.codigo
	AND pe.codigo = 99001

--Consultar Código do pedido, nome do cliente e idade atual do cliente				
SELECT pe.codigo, c.nome, DATEDIFF(YEAR, c.data_nasc, GETDATE()) AS idade_cliente
FROM cliente c, pedido pe
WHERE pe.codigo_cliente = c.codigo