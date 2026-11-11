-- ============================================================================
-- ITEAM - Módulo 09: Bancos de Dados e SQL
-- Aula 05 (06/11/2026): Comandos DML (INSERT, SELECT, UPDATE, DELETE),
--                       Filtros com WHERE e Ordenação com ORDER BY
-- Professor: Janei Vieira Pereira
-- ============================================================================

USE escola_db;

-- 1. Consultas básicas com projeção de colunas e apelidos (Aliases)
SELECT id_aluno,
       nome AS nome_aluno,
       cidade AS municipio,
       data_nascimento
FROM alunos
ORDER BY nome ASC;

-- 2. Listando valores únicos sem repetição (DISTINCT)
SELECT DISTINCT cidade FROM alunos ORDER BY cidade ASC;
SELECT DISTINCT area FROM cursos ORDER BY area ASC;

-- 3. Filtragem com operadores relacionais e lógicos (WHERE + AND / OR)
SELECT id_aluno, nome, cidade, data_cadastro
FROM alunos
WHERE cidade = 'Boa Vista'
  AND data_nascimento >= '2000-01-01'
ORDER BY data_nascimento DESC;

-- 4. Filtragem com IN, BETWEEN e LIKE
SELECT id_curso, nome, area, carga_horaria
FROM cursos
WHERE carga_horaria BETWEEN 30 AND 60
  AND area IN ('Banco de Dados', 'Desenvolvimento Web')
ORDER BY carga_horaria DESC;

SELECT id_aluno, nome, email
FROM alunos
WHERE nome LIKE '%Souza%'
   OR nome LIKE '%Silva%'
ORDER BY nome ASC;

-- 5. Ranking com ORDER BY e LIMIT
SELECT id_nota, id_matricula, nota1, nota2, nota3, media
FROM notas
WHERE media >= 8.50
ORDER BY media DESC
LIMIT 10;

-- 6. Demonstração do Protocolo Seguro de UPDATE e DELETE (Transação de teste)
START TRANSACTION;

INSERT INTO cursos (nome, area, carga_horaria)
VALUES ('Curso Teste Temporário', 'Tecnologia', 20);

-- Conferir antes de atualizar
SELECT * FROM cursos WHERE nome = 'Curso Teste Temporário';

-- Atualizar filtrando pelo nome ou chave primária
UPDATE cursos
SET carga_horaria = 24
WHERE nome = 'Curso Teste Temporário';

-- Remover o curso temporário de teste
DELETE FROM cursos
WHERE nome = 'Curso Teste Temporário';

COMMIT;

