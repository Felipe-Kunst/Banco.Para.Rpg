CREATE DATABASE IF NOT EXISTS rpg;
USE rpg;

CREATE TABLE `Classe` (
  `classe_id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text,
  PRIMARY KEY (`classe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Classe` VALUES 
(1, 'Guerreiro', 'Lutador corpulento que usa armaduras pesadas e espadas.'),
(2, 'Mago', 'Usuário de magias que utiliza cajados e grimórios para controlar os elementos.');

CREATE TABLE `Habilidade` (
  `habilidade_id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `custo_mana` int NOT NULL,
  PRIMARY KEY (`habilidade_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Habilidade` VALUES 
(1, 'Espada Flamejante', 'Ataque com espada envolta em chamas.', 20),
(2, 'Cura Menor', 'Recupera uma pequena quantidade de vida.', 15);

CREATE TABLE `Inventario` (
  `inventario_id` int NOT NULL AUTO_INCREMENT,
  `personagem_id` int NOT NULL,
  PRIMARY KEY (`inventario_id`),
  KEY `personagem_id` (`personagem_id`),
  CONSTRAINT `Inventario_ibfk_1` FOREIGN KEY (`personagem_id`) REFERENCES `Personagem` (`personagem_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Inventario` VALUES 
(1, 1),
(2, 2);

CREATE TABLE `InventarioItem` (
  `inventario_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantidade` int NOT NULL,
  PRIMARY KEY (`inventario_id`, `item_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `InventarioItem_ibfk_1` FOREIGN KEY (`inventario_id`) REFERENCES `Inventario` (`inventario_id`),
  CONSTRAINT `InventarioItem_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `Item` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `InventarioItem` VALUES 
(1, 1, 1),
(2, 2, 1);

CREATE TABLE `Item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text,
  `tipo` enum('arma', 'armadura', 'poção') NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Item` VALUES 
(1, 'Espada Longa', 'Uma espada longa de ferro.', 'arma'),
(2, 'Capa da Invisibilidade', 'Uma capa que torna o usuário invisível temporariamente.', 'armadura');

CREATE TABLE `Jogador` (
  `jogador_id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `data_criacao` date NOT NULL,
  PRIMARY KEY (`jogador_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Jogador` VALUES 
(1, 'Ana Silva', 'ana.silva@example.com', '2023-05-01'),
(2, 'Carlos Souza', 'carlos.souza@example.com', '2023-05-02');

CREATE TABLE `Personagem` (
  `personagem_id` int NOT NULL AUTO_INCREMENT,
  `jogador_id` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `classe_id` int NOT NULL,
  `nivel` int DEFAULT '1',
  `vida` int NOT NULL,
  `mana` int NOT NULL,
  PRIMARY KEY (`personagem_id`),
  KEY `jogador_id` (`jogador_id`),
  KEY `classe_id` (`classe_id`),
  CONSTRAINT `Personagem_ibfk_1` FOREIGN KEY (`jogador_id`) REFERENCES `Jogador` (`jogador_id`),
  CONSTRAINT `Personagem_ibfk_2` FOREIGN KEY (`classe_id`) REFERENCES `Classe` (`classe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `Personagem` VALUES 
(1, 1, 'Thorin', 1, 5, 100, 30),
(2, 2, 'Eldor', 2, 10, 60, 150);

CREATE TABLE `PersonagemHabilidade` (
  `personagem_id` int NOT NULL,
  `habilidade_id` int NOT NULL,
  PRIMARY KEY (`personagem_id`, `habilidade_id`),
  KEY `habilidade_id` (`habilidade_id`),
  CONSTRAINT `PersonagemHabilidade_ibfk_1` FOREIGN KEY (`personagem_id`) REFERENCES `Personagem` (`personagem_id`),
  CONSTRAINT `PersonagemHabilidade_ibfk_2` FOREIGN KEY (`habilidade_id`) REFERENCES `Habilidade` (`habilidade_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `PersonagemHabilidade` VALUES 
(1, 1),
(2, 2);


-- Questão 1: Adicione um novo jogador ao banco de dados com o nome "Julia Pereira", e-mail " julia.pereira@example.com", e a data de criação da conta sendo a data atual.

INSERT INTO Jogador (nome, email, data_criacao) 
VALUES ('Julia Pereira', 'julia.pereira@example.com', CURDATE());

-- Questão 2: Remova o personagem chamado "Eldor" do banco de dados.

DELETE FROM InventarioItem WHERE inventario_id IN (SELECT inventario_id FROM Inventario WHERE personagem_id IN (SELECT personagem_id FROM Personagem WHERE nome = 'Eldor'));
DELETE FROM Inventario WHERE personagem_id IN (SELECT personagem_id FROM Personagem WHERE nome = 'Eldor');
DELETE FROM PersonagemHabilidade WHERE personagem_id IN (SELECT personagem_id FROM Personagem WHERE nome = 'Eldor');
DELETE FROM Personagem WHERE nome = 'Eldor';

-- Questão 3: Atualize a vida e a mana do personagem "Thorin" para 120 de vida e 40 de mana.

UPDATE Personagem 
SET vida = 120, mana = 40 
WHERE personagem_id = (
    SELECT personagem_id 
    FROM (SELECT * FROM Personagem) AS p 
    WHERE nome = 'Thorin'
);

-- Questão 4: Selecione todos os itens do tipo "arma" presentes no banco de dados.

SELECT * FROM Item WHERE tipo = 'arma';

-- Questão 5: Insira uma habilidade chamada "Bola de Fogo" para o personagem "Thorin". Assuma que a habilidade "Bola de Fogo" já existe na tabela Habilidade e possui habilidade_id igual a 3.

INSERT INTO PersonagemHabilidade (personagem_id, habilidade_id)
SELECT p.personagem_id, 3
FROM Personagem p
LEFT JOIN PersonagemHabilidade ph ON p.personagem_id = ph.personagem_id AND ph.habilidade_id = 3
WHERE p.nome = 'Thorin' AND ph.habilidade_id IS NULL;

-- Questão 6: Atualize o tipo de todos os itens cujo nome contém a palavra "Espada" para "arma especial".

UPDATE Item AS i
JOIN InventarioItem AS ii ON i.item_id = ii.item_id
JOIN Inventario AS inv ON ii.inventario_id = inv.inventario_id
JOIN Personagem AS p ON inv.personagem_id = p.personagem_id
SET i.tipo = 'arma'
WHERE i.nome LIKE '%Espada%';


-- Questão 7: Liste os nomes de todos os personagens junto com os nomes de suas classes.

SELECT Personagem.nome AS personagem_nome, Classe.nome AS classe_nome 
FROM Personagem 
JOIN Classe ON Personagem.classe_id = Classe.classe_id;

-- Questão 8: Exiba os nomes dos personagens e as descrições das habilidades que eles possuem, para habilidades que consomem mais de 15 de mana.
SELECT Personagem.nome, Habilidade.descricao
FROM Personagem
INNER JOIN PersonagemHabilidade ON Personagem.personagem_id = PersonagemHabilidade.personagem_id
INNER JOIN Habilidade ON PersonagemHabilidade.habilidade_id = Habilidade.habilidade_id
WHERE Habilidade.custo_mana > 15;

-- Questão 9: Selecione todos os itens que estão em inventários de personagens da classe "Mago".

SELECT Item.*
FROM Item
INNER JOIN InventarioItem ON Item.item_id = InventarioItem.item_id
INNER JOIN Inventario ON InventarioItem.inventario_id = Inventario.inventario_id
INNER JOIN Personagem ON Inventario.personagem_id = Personagem.personagem_id
INNER JOIN Classe ON Personagem.classe_id = Classe.classe_id
WHERE Classe.nome = 'Mago';

-- Questão 10: Conte quantos personagens existem em cada classe e apresente o nome da classe junto com a contagem.

SELECT Classe.nome AS classe_nome, COUNT(Personagem.personagem_id) AS contagem 
FROM Personagem 
JOIN Classe ON Personagem.classe_id = Classe.classe_id 
GROUP BY Classe.nome;



-- Questão 11: Liste os nomes dos personagens, os itens que eles possuem em seu inventário e a quantidade de cada item, ordenando pelo nome do personagem e depois pelo nome do item.

SELECT Personagem.nome AS personagem_nome, Item.nome AS item_nome, InventarioItem.quantidade 
FROM Personagem 
JOIN Inventario ON Personagem.personagem_id = Inventario.personagem_id 
JOIN InventarioItem ON Inventario.inventario_id = InventarioItem.inventario_id 
JOIN Item ON InventarioItem.item_id = Item.item_id 
ORDER BY Personagem.nome, Item.nome;


-- Questão 12: Liste os nomes dos personagens que têm o maior nível dentro de sua própria classe.

SELECT nome, classe_id, nivel 
FROM Personagem p1 
WHERE nivel = (SELECT MAX(nivel) 
               FROM Personagem p2 
               WHERE p1.classe_id = p2.classe_id);


-- Questao 13: Liste o nome, classe e nível de todos os personagens, junto com o ranking de nível dentro de sua classe, ordenado pela classe e pelo ranking.

SELECT 
    p.nome,
    c.nome AS classe,
    p.nivel,
    (SELECT COUNT(*) FROM Personagem p2 WHERE p2.classe_id = p.classe_id AND p2.nivel > p.nivel) + 1 AS ranking
FROM Personagem p
INNER JOIN Classe c ON p.classe_id = c.classe_id
ORDER BY c.nome, ranking;

-- Questão 14: Para cada classe, exiba o nome da classe, o total de mana e vida de todos os seus personagens, e a média de nível dos personagens.

SELECT 
    Classe.nome AS classe,
    SUM(Personagem.vida) AS total_vida,
    SUM(Personagem.mana) AS total_mana,
    AVG(Personagem.nivel) AS media_nivel
FROM Personagem
INNER JOIN Classe ON Personagem.classe_id = Classe.classe_id
GROUP BY Classe.nome;

-- Questão 15: Selecione os personagens que possuem pelo menos um item no inventário cuja quantidade é maior que 1. Exiba o nome do personagem e o nome dos itens.

SELECT 
    Personagem.nome,
    Item.nome AS nome_item
FROM Personagem
INNER JOIN Inventario ON Personagem.personagem_id = Inventario.personagem_id
INNER JOIN InventarioItem ON Inventario.inventario_id = InventarioItem.inventario_id
INNER JOIN Item ON InventarioItem.item_id = Item.item_id
WHERE InventarioItem.quantidade > 1;

-- Questão 16: Liste todos os personagens junto com o nome da habilidade mais custosa em termos de mana que eles possuem. Ordene o resultado pelo custo de mana em ordem decrescente
 
SELECT Personagem.nome AS personagem_nome, Habilidade.nome AS habilidade_nome, Habilidade.custo_mana 
FROM Personagem 
JOIN PersonagemHabilidade ON Personagem.personagem_id = PersonagemHabilidade.personagem_id 
JOIN Habilidade ON PersonagemHabilidade.habilidade_id = Habilidade.habilidade_id 
WHERE Habilidade.custo_mana = (SELECT MAX(h.custo_mana) 
                                FROM Habilidade h 
                                JOIN PersonagemHabilidade ph ON h.habilidade_id = ph.habilidade_id 
                                WHERE ph.personagem_id = Personagem.personagem_id) 
ORDER BY Habilidade.custo_mana DESC;