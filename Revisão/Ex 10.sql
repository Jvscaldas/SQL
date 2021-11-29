CREATE DATABASE ex10
GO
USE ex10
GO
CREATE TABLE medicamentos (
codigo  				INT				NOT NULL	IDENTITY,
nome					VARCHAR(100)	NOT NULL,
apresentacao			VARCHAR(100)	NOT NULL,
unidadeCadastro			VARCHAR(30)		NOT NULL,
precoProposto			DECIMAL(7,3)	NOT NULL  
PRIMARY KEY (codigo)
)
GO
CREATE TABLE cliente (
cpf						CHAR(11)		NOT NULL,
nomeCliente				VARCHAR(60)		NOT NULL,
rua						VARCHAR(80)	NOT NULL,
nmr						INT				NOT NULL,
bairro					VARCHAR(40)		NOT NULL,
telefone				CHAR(9)			NOT NULL
PRIMARY KEY (cpf)
)
GO
CREATE TABLE venda (
notaFiscal				INT				NOT NULL,
cpfCliente				CHAR(11)		NOT NULL,
codigoMedicamento		INT				NOT NULL,
quantidade				INT				NOT NULL,
valorTotal				DECIMAL(7,2)	NOT NULL,
data					DATE			NOT NULL,
PRIMARY KEY (notaFiscal, cpfCliente, codigoMedicamento),
FOREIGN KEY (codigoMedicamento) REFERENCES medicamentos (codigo),
FOREIGN KEY (cpfCliente) REFERENCES cliente (cpf)
)

INSERT INTO medicamentos (nome, apresentacao, unidadeCadastro, precoProposto) VALUES
(' Acetato de medroxiprogesterona',		'150 mg/ml',				'Ampola',		6.700),
(' Aciclovir',							'200mg/comp.',				'Comprimido',	0.280),
(' Ácido Acetilsalicílico',				'500mg/comp.',				'Comprimido',	0.035),
(' Ácido Acetilsalicílico',				'100mg/comp.',				'Comprimido',	0.030),
(' Ácido Fólico',						'5mg/comp.',				'Comprimido',	0.054),
(' Albendazol',							'400mg/comp. mastigável',	'Comprimido',	0.560),
(' Alopurinol',							'100mg/comp.',				'Comprimido',	0.080),
(' Amiodarona',							'200mg/comp.',				'Comprimido',	0.200),
(' Amitriptilina(Cloridrato)',			'25mg/comp.',				'Comprimido',	0.220),
(' Amoxicilina',						'500mg/cáps.',				'Cápsula',		0.190)

INSERT INTO cliente (cpf, nomeCliente, rua, nmr, bairro, telefone) VALUES
('34390898700',		'Maria Zélia',		'Anhaia',					65,		'Barra Funda',	92103762),
('21345986290',		'Roseli Silva',		'Xv. De Novembro',			987,	'Centro',		82198763),
('86927981825',		'Carlos Campos',	'Voluntários da Pátria',	1276,	'Santana',		98172361),
('31098120900',		'João Perdizes',	'Carlos de Campos',			90,		'Pari',			61982371)

INSERT INTO venda (notaFiscal, cpfCliente, codigoMedicamento, quantidade, valorTotal, data) VALUES
(31501,	'86927981825',	10,	3,	0.6,	'2020-11-01'),
(31501,	'86927981825',	2,	10,	0,		'2020-11-01'),
(31501,	'86927981825',	5,	30,	201,	'2020-11-01'),
(31501,	'86927981825',	8,	30,	2.4,	'2020-11-01'),
(31502,	'34390898700',	8,	15,	8.4,	'2020-11-01'),
(31502,	'34390898700',	2,	10,	0,		'2020-11-01'),
(31502,	'34390898700',	9,	10,	0.8,	'2020-11-01'),
(31503,	'31098120900',	1,	20,	3.8,	'2020-11-02')

-- Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. 
-- Caso a unidade de cadastro seja comprimido, mostrar Comp.							
SELECT m.nome, m.apresentacao, 
	CASE
		WHEN m.unidadeCadastro LIKE '%Comp%' THEN
			'Comp.'
		ELSE
			m.unidadeCadastro
	END AS unidadeCadastro, 
m.precoProposto
FROM medicamentos m LEFT OUTER JOIN venda v
ON m.codigo = v.codigoMedicamento
WHERE v.codigoMedicamento IS NULL

-- Nome dos clientes que compraram Amiodarona
SELECT c.nomeCliente
FROM cliente c, venda v, medicamentos m
WHERE c.cpf = v.cpfCliente
	AND m.codigo = v.codigoMedicamento
	AND m.nome LIKE '%Amiodarona%'

-- CPF do cliente, endereço concatenado, 
-- nome do medicamento (como nome de remédio),  apresentação do remédio, unidade, preço proposto, 
-- quantidade vendida e valor total dos remédios vendidos a Maria Zélia

SELECT c.cpf, c.rua + ', ' + CAST(c.nmr AS VARCHAR(5)) + ', ' + c.bairro AS endereco,
m.nome AS nomeRemedio, m.apresentacao, m.unidadeCadastro, m.precoProposto,
v.quantidade, v.valorTotal
FROM cliente c, medicamentos m, venda v
WHERE c.cpf = v.cpfCliente
	AND m.codigo = v.codigoMedicamento
	AND c.nomeCliente LIKE '%Maria%'

-- Data de compra, convertida, de Carlos Campos
SELECT CONVERT(VARCHAR, v.data, 103) AS dataCompra
FROM cliente c, venda v
WHERE c.cpf = v.cpfCliente
	AND c.nomeCliente LIKE '%Carlos%' 

-- Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
UPDATE medicamentos
SET nome = 'Cloridrato de Amitriptilina' 
WHERE nome LIKE '%Amitriptilina%'