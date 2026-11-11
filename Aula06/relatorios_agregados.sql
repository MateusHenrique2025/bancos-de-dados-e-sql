-- ============================================================================
-- ITEAM - Módulo 09: Bancos de Dados e SQL
-- Aula 06 (09/11/2026): Funções Agregadas (COUNT, SUM, AVG, MAX, MIN),
--                       Agrupamento com GROUP BY e Filtragem com HAVING
-- Professor: Janei Vieira Pereira
-- ============================================================================

USE escola_db;

-- 1. Indicadores globais da instituição (Sem GROUP BY = 1 linha de resumo)
SELECT COUNT(*) AS total_alunos,
       COUNT(DISTINCT cidade) AS total_municipios_atendidos
FROM alunos;

SELECT COUNT(*) AS total_avaliacoes,
       ROUND(AVG(media), 2) AS media_institucional,
       MAX(media) AS maior_media_registrada,
       MIN(media) AS menor_media_registrada
FROM notas;

-- 2. Agrupamento simples por dimensão (GROUP BY)
-- Total de alunos por cidade em Roraima
SELECT cidade,
       COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
ORDER BY total_alunos DESC;

-- Quantidade de cursos e soma de carga horária por área tecnológica
SELECT area,
       COUNT(*) AS qtd_cursos,
       SUM(carga_horaria) AS carga_horaria_total,
       ROUND(AVG(carga_horaria), 1) AS media_horas_por_curso
FROM cursos
GROUP BY area
ORDER BY carga_horaria_total DESC;

-- 3. Agrupamento com filtro de grupos (GROUP BY + HAVING)
-- Turmas com 4 ou mais matrículas registradas
SELECT id_turma,
       COUNT(*) AS total_matriculas
FROM matriculas
GROUP BY id_turma
HAVING COUNT(*) >= 4
ORDER BY total_matriculas DESC;

-- 4. Combinando WHERE (filtro de linha) + GROUP BY + HAVING (filtro de grupo)
-- Considerando apenas matrículas com status 'Ativo', listar turmas com 3 ou mais alunos
SELECT id_turma,
       COUNT(*) AS alunos_ativos
FROM matriculas
WHERE status = 'Ativo'
GROUP BY id_turma
HAVING COUNT(*) >= 3
ORDER BY alunos_ativos DESC;

