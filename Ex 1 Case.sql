CREATE DATABASE ex1case
GO
USE ex1case

CREATE TABLE projects(
id                  INT                NOT NULL    IDENTITY(10001, 1),
name				VARCHAR(45)        NOT NULL,
description         VARCHAR(45)        NULL,
date                VARCHAR(45)        NOT NULL    CHECK(date > '2014-09-01')
PRIMARY KEY (id)
)
GO
CREATE TABLE users(
id                  INT                NOT NULL    IDENTITY(1, 1),
name                VARCHAR(45)        NOT NULL,
username            VARCHAR(45)        NOT NULL,
password            VARCHAR(45)        NOT NULL    DEFAULT('123mudar'),
email               VARCHAR(45)        NOT NULL,
CONSTRAINT unique_user UNIQUE (username),
PRIMARY KEY (id)
)
GO
CREATE TABLE users_has_projects(
users_id			   INT                NOT NULL,
projects_id            INT                NOT NULL,
PRIMARY KEY (users_id, projects_id),
FOREIGN KEY (users_id) REFERENCES users(id),
FOREIGN KEY (projects_id) REFERENCES projects(id)
)

ALTER TABLE users
ALTER COLUMN password VARCHAR(8)    

ALTER TABLE users
DROP CONSTRAINT unique_user

ALTER TABLE users
ALTER COLUMN username VARCHAR(10)

ALTER TABLE users
ADD UNIQUE (username)

INSERT INTO users(name, username, password, email) VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects(name, description, date) VALUES
('Re-folha', 'Refatoração das Folhas', '2014-09-05'),
('Manutenção PC´s', 'Manutenção PC´s', '2014-09-06'),
('Auditoria', NULL, '2014-09-07')

INSERT INTO users_has_projects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

UPDATE projects
SET date = '2014-09-12'
WHERE name = 'Manutenção PC´s'

UPDATE users
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users
SET password = 
(CASE
		WHEN password = '123mudar' THEN '888@*'
END)
WHERE username = 'Rh_maria'

DELETE users_has_projects
WHERE users_id = 2

SELECT id, name, email, username,
	CASE
		WHEN (password != '123mudar') THEN
			'********'
		ELSE
			password
	END AS password
FROM users

SELECT name, description, date,
CONVERT(CHAR(10),DATEADD(DAY, 15, '05-09-2014'), 103) AS data_final
FROM projects
WHERE id = '10001'

SELECT name, email 
FROM users
WHERE id = 3

SELECT name, description, date,
'2014-09-16' AS data_final,
'79.85' AS  custo_total 
FROM projects
WHERE name LIKE '%Manutenção%'

INSERT INTO users (name, username, password, email) VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO projects(name, description, date) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')

INSERT INTO users_has_projects VALUES
(6, NULL),
(NULL, 10004)

SELECT * FROM users_has_projects

SELECT users.id, users.name, users.email, projects.description, projects.date
FROM users_has_projects
INNER JOIN users 
ON users.id = users_has_projects.users_id
INNER JOIN projects
ON projects.id = users_has_projects.projects_id
WHERE projects.name = 'Re-folha'

SELECT projects.name 
FROM users
RIGHT OUTER JOIN projects
ON projects.id = users.id
WHERE users.id IS NULL

SELECT users.name
FROM projects
RIGHT OUTER JOIN users
ON users.id = projects.id
WHERE projects.id IS NULL