CREATE DATABASE abc
GO
USE abc 

CREATE TABLE filme(
id					INT				NOT NULL,
titulo				VARCHAR(40)		NOT NULL,
ano					INT				NULL			CHECK (ano <= 2021),
PRIMARY KEY (id)
)
GO
CREATE TABLE estrela(
id					INT				NOT NULL,
nome				VARCHAR(50)		NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE cliente(
num_cadastro		INT				NOT NULL,
nome				VARCHAR(70)		NOT NULL,
logradouro			VARCHAR(150)	NOT NULL,
num					INT				NOT NULL		CHECK (num > 0),
cep					CHAR(8)			NULL			CHECK(LEN(cep) = 8)
PRIMARY KEY (num_cadastro)
)
GO
CREATE TABLE dvd(
id_filme			INT			NOT NULL,		
num					INT			NOT NULL,
data_fabricacao		DATE		NOT NULL		CHECK (data_fabricacao < GETDATE()),
PRIMARY KEY (num),
FOREIGN KEY (id_filme) REFERENCES filme(id)
)
GO
CREATE TABLE locacao(
dvd_num					INT				NOT NULL,
cliente_num_cadastro	INT				NOT NULL,
data_locacao			DATE			NOT NULL			DEFAULT (GETDATE()),
data_devolucao			DATE			NOT NULL,
valor					DECIMAL(7,2)	NOT NULL			CHECK (valor > 0),
CONSTRAINT chk_dt CHECK(data_devolucao > data_locacao),
PRIMARY KEY (dvd_num, cliente_num_cadastro, data_locacao),
FOREIGN KEY (dvd_num) REFERENCES dvd(num),
FOREIGN KEY (cliente_num_cadastro) REFERENCES cliente(num_cadastro)
)
GO
CREATE TABLE filme_estrela(
id_filme			INT			NOT NULL,	
id_estrela			INT			NOT NULL,
PRIMARY KEY (id_filme, id_estrela),
FOREIGN KEY (id_filme) REFERENCES filme(id),
FOREIGN KEY (id_estrela) REFERENCES estrela(id)
)

EXEC sp_help filme
EXEC sp_help estrela
EXEC sp_help dvd
EXEC sp_help cliente
EXEC sp_help locacao
EXEC sp_help filme_estrela

SELECT * FROM filme  
SELECT * FROM estrela
SELECT * FROM dvd
SELECT * FROM cliente
SELECT * FROM locacao
SELECT * FROM filme_estrela

ALTER TABLE filme
ALTER COLUMN titulo VARCHAR(80) NOT NULL

ALTER TABLE estrela
ADD nome_real VARCHAR(50)  NULL

INSERT INTO filme(id, titulo, ano) VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)


INSERT INTO estrela(id, nome, nome_real) VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela(id_filme, id_estrela) VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO dvd(num, data_fabricacao, id_filme) VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

INSERT INTO cliente(num_cadastro, nome, logradouro, num, cep) VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

INSERT INTO locacao(dvd_num, cliente_num_cadastro, data_locacao, data_devolucao, valor) VALUES
(10001, 5502, '2021-02-18', '2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20', '2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE data_locacao = '2021-02-18' AND cliente_num_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE data_locacao = '2021-02-24' AND cliente_num_cadastro = 5501

UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE num = 10005

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE id = 9903

DELETE filme
WHERE id = 1006

SELECT titulo
FROM filme
WHERE ano = 2014

SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'

SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash%'

SELECT id, nome, nome_real
FROM estrela
WHERE nome LIKE '%Steve%'

SELECT id_filme, CONVERT(CHAR(10), data_fabricacao, 103) AS fab 
FROM dvd
ORDER BY fab

SELECT dvd_num, data_locacao, data_devolucao, valor, (valor + 2) AS valor_multa_acréscimo
FROM locacao
WHERE cliente_num_cadastro = 5505

SELECT logradouro, num, cep
FROM cliente
WHERE nome =  'Matilde Luz'

SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'

SELECT num_cadastro, nome, logradouro + ' - ' + CAST(num AS VARCHAR(5))+ ' - ' + cep AS end_completo
FROM cliente
WHERE num_cadastro >= 5503

SELECT id, ano,
	CASE 
		WHEN LEN(titulo) > 10 THEN
		RTRIM(SUBSTRING(titulo, 1, 10)) + '...'
		ELSE
		titulo
	END AS titulo
FROM filme
WHERE (id % 2) <> 0

SELECT num, data_fabricacao,
DATEDIFF(MONTH, '2020-04-03', GETDATE()) AS qtd_meses_desde_fabricacao
FROM dvd
WHERE id_filme = 1003

SELECT dvd_num, data_locacao, data_devolucao,
DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugado, valor
FROM locacao
WHERE cliente_num_cadastro = 
(SELECT num_cadastro
FROM cliente 
WHERE nome LIKE '%Rosa%')

SELECT nome, 
logradouro + '' + CAST(num AS VARCHAR(5)) AS endereço_completo, SUBSTRING(cep, 1, 5) + '-' +  SUBSTRING(cep, 6, 4) AS cep
FROM cliente 
WHERE num_cadastro = 5503 OR num_cadastro = 5505