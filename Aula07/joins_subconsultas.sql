-- ============================================================================
-- ITEAM - Módulo 09: Bancos de Dados e SQL
-- Aula 07 (10/11/2026): Consultas Relacionais com JOINs e Subconsultas
-- Professor: Janei Vieira Pereira
-- ============================================================================

USE escola_db;

-- 1. INNER JOIN entre 3 tabelas: Turma + Curso + Professor
SELECT t.id_turma,
       t.nome_turma,
       c.nome AS curso,
       p.nome AS professor,
       t.periodo,
       t.turno
FROM turmas t
INNER JOIN cursos c      ON t.id_curso = c.id_curso
INNER JOIN professores p ON t.id_professor = p.id_professor
ORDER BY t.nome_turma ASC;

-- 2. INNER JOIN entre 5 tabelas: Boletim detalhado por Aluno
SELECT a.nome AS aluno,
       c.nome AS curso,
       t.nome_turma,
       n.nota1,
       n.nota2,
       n.nota3,
       n.media
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id_matricula
INNER JOIN alunos a     ON m.id_aluno = a.id_aluno
INNER JOIN turmas t     ON m.id_turma = t.id_turma
INNER JOIN cursos c     ON t.id_curso = c.id_curso
ORDER BY n.media DESC;

-- 3. LEFT JOIN para auditoria: Verificar alunos sem matrícula registrada
SELECT a.id_aluno,
       a.nome AS aluno,
       a.cidade,
       m.id_matricula
FROM alunos a
LEFT JOIN matriculas m ON a.id_aluno = m.id_aluno
WHERE m.id_matricula IS NULL;

-- 4. Subconsulta Escalar: Alunos com média superior à média geral da escola
SELECT a.nome AS aluno,
       n.media AS media_aluno
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id_matricula
INNER JOIN alunos a     ON m.id_aluno = a.id_aluno
WHERE n.media > (
    SELECT AVG(media) FROM notas
)
ORDER BY n.media DESC;

-- 5. Subconsulta com IN: Alunos matriculados na área de 'Banco de Dados'
SELECT id_aluno, nome, email, cidade
FROM alunos
WHERE id_aluno IN (
    SELECT m.id_aluno
    FROM matriculas m
    INNER JOIN turmas t ON m.id_turma = t.id_turma
    INNER JOIN cursos c ON t.id_curso = c.id_curso
    WHERE c.area = 'Banco de Dados'
)
ORDER BY nome ASC;

