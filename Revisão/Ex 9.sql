CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'2021-07-04'),
(15051,10008,1,95.00,'2021-07-04'),
(15051,10004,1,68.00,'2021-07-04'),
(15051,10007,1,78.00,'2021-07-04'),
(15052,10006,1,49.00,'2021-07-05'),
(15052,10002,3,165.00,'2021-07-05'),
(15053,10001,1,108.00,'2021-07-05'),
(15054,10003,1,79.00,'2021-08-06'),
(15054,10008,1,95.00,'2021-08-06')

--1
SELECT DISTINCT e.nome, c.valor, ed.nome AS nome_editora, a.nome AS nome_autor
FROM estoque e, editora ed, autor a, compra c
WHERE a.codigo = e.codAutor
	AND ed.codigo = e.codEditora
	AND e.codigo = c.codEstoque

--2
SELECT e.nome, c.qtdComprada, c.valor
FROM compra c, estoque e
WHERE c.codEstoque = e.codigo
	AND c.codigo = 15051

--3
SELECT e.nome, 

CASE WHEN LEN(ed.site) > 10 THEN 
		SUBSTRING(ed.site, 5, 13)
ELSE
		ed.site
END AS site

FROM estoque e, editora ed
WHERE ed.codigo = e.codEditora 
	AND ed.nome LIKE '%Makron%'

--4
SELECT e.nome, a.biografia
FROM estoque e, autor a
WHERE a.codigo = e.codAutor
	AND a.nome = 'David Halliday'
	
--5 
SELECT c.codigo, c.qtdComprada
FROM compra c, estoque e
WHERE e.codigo = c.codEstoque
	AND e.nome = 'Sistemas Operacionais Modernos'

--6
SELECT e.nome AS nao_vendidos
FROM estoque e LEFT OUTER JOIN compra c
ON e.codigo = c.codEstoque
WHERE c.codEstoque IS NULL
	
--7
SELECT e.nome AS livros_vendidos
FROM estoque e RIGHT OUTER JOIN compra c
ON e.codigo = c.codEstoque
WHERE e.codigo IS NULL

--8
SELECT ed.nome,
CASE 
	WHEN LEN(ed.site) > 10 THEN 
			SUBSTRING(ed.site, 5, 14)
	ELSE	
		ed.site
END AS site
FROM editora ed LEFT OUTER JOIN estoque e
ON ed.codigo = e.codEditora 
WHERE e.codEditora  IS NULL


--9
SELECT a.nome,
CASE 
	WHEN (a.biografia) LIKE '%Doutorado%' THEN 
			'Ph.D. '+ LTRIM(SUBSTRING(a.biografia, 10, 36))
	ELSE	
		a.biografia
END AS site
FROM autor a LEFT OUTER JOIN estoque e
ON a.codigo = e.codAutor 
WHERE e.codAutor  IS NULL

--10
SELECT a.nome, e.valor
FROM autor a, estoque e
WHERE a.codigo = e.codAutor
ORDER BY valor DESC

--11
SELECT c.codigo, c.qtdComprada, SUM(c.valor) AS valor_gasto
FROM compra c
GROUP BY c.codigo, c.qtdComprada, c.valor
ORDER BY c.codigo ASC

--12
SELECT ed.nome, AVG(e.valor) AS media_preco
FROM editora ed, estoque e
WHERE ed.codigo = e.codEditora
GROUP BY ed.nome, e.valor
ORDER BY e.valor ASC

--13
SELECT e.nome, e.quantidade, ed.nome, 
CASE 
	WHEN LEN(ed.site) > 10 THEN 
			LTRIM(SUBSTRING(ed.site, 5, 19))
	ELSE	
		ed.site
END AS site,
CASE
	WHEN (e.quantidade) < 5 THEN
		'Produto em Ponto de Pedido'
	
	WHEN (e.quantidade) > 5 AND (e.quantidade) < 11 THEN
		'Produto Acabando'

	WHEN (e.quantidade) > 10 THEN
		'Estoque Suficiente' 
END AS status
FROM estoque e, editora ed
WHERE e.codEditora = ed.codigo
ORDER BY e.quantidade ASC

--14
SELECT e.codigo, e.nome AS nome_livro, a.nome AS nome_autor,
CASE 
	WHEN (ed.site) IS NULL THEN
	ed.site 
	ELSE
	ed.nome + ', ' + ed.site
END AS site
FROM estoque e, autor a, editora ed
WHERE e.codAutor = a.codigo
	AND e.codEditora = ed.codigo

--15
SELECT codigo, DATEDIFF(DAY, dataCompra, GETDATE()) AS dias_ate_hoje, DATEDIFF(MONTH, dataCompra, GETDATE()) AS meses_ate_hoje
FROM compra  

--16
SELECT codigo, SUM(valor) AS soma_compra
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200.00


