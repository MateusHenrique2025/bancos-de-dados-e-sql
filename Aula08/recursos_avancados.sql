-- ============================================================================
-- ITEAM - Módulo 09: Bancos de Dados e SQL
-- Aula 08 (11/11/2026): Recursos Avançados de SQL (Views, Índices,
--                       Transações ACID, Stored Procedures e Triggers)
-- Professor: Janei Vieira Pereira
-- ============================================================================

USE escola_db;

-- ============================================================================
-- 1. VIEWS (VISÕES) PARA O PROJETO INTEGRADOR
-- ============================================================================

CREATE OR REPLACE VIEW vw_boletim_escolar AS
SELECT a.id_aluno,
       a.nome AS aluno,
       a.cidade,
       c.nome AS curso,
       t.id_turma,
       t.nome_turma,
       t.periodo,
       t.turno,
       p.nome AS professor,
       m.id_matricula,
       m.status AS status_matricula,
       n.nota1,
       n.nota2,
       n.nota3,
       n.media,
       CASE
           WHEN n.media >= 7.00 THEN 'Aprovado'
           WHEN n.media >= 5.00 THEN 'Recuperação'
           ELSE 'Reprovado'
       END AS situacao_final
FROM matriculas m
INNER JOIN alunos a      ON m.id_aluno = a.id_aluno
INNER JOIN turmas t      ON m.id_turma = t.id_turma
INNER JOIN cursos c      ON t.id_curso = c.id_curso
INNER JOIN professores p ON t.id_professor = p.id_professor
LEFT JOIN  notas n       ON m.id_matricula = n.id_matricula;

CREATE OR REPLACE VIEW vw_resumo_turmas AS
SELECT t.id_turma,
       t.nome_turma,
       c.nome AS curso,
       p.nome AS professor,
       t.periodo,
       t.turno,
       COUNT(m.id_matricula) AS total_alunos,
       ROUND(AVG(n.media), 2) AS media_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM turmas t
INNER JOIN cursos c      ON t.id_curso = c.id_curso
INNER JOIN professores p ON t.id_professor = p.id_professor
LEFT JOIN  matriculas m  ON t.id_turma = m.id_turma
LEFT JOIN  notas n       ON m.id_matricula = n.id_matricula
GROUP BY t.id_turma, t.nome_turma, c.nome, p.nome, t.periodo, t.turno;

-- Testando as Views criadas:
SELECT * FROM vw_boletim_escolar LIMIT 10;
SELECT * FROM vw_resumo_turmas ORDER BY media_turma DESC;

-- ============================================================================
-- 2. ÍNDICES E PLANO DE EXECUÇÃO (EXPLAIN)
-- ============================================================================

-- Analisar consulta antes do índice
EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';

-- Criar índice composto para acelerar filtros por cidade e ordenação por nome
CREATE INDEX idx_alunos_cidade_nome ON alunos(cidade, nome);

-- Analisar consulta após o índice e listar índices da tabela
EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
SHOW INDEX FROM alunos;

-- ============================================================================
-- 3. TRANSAÇÕES ACID (START TRANSACTION, COMMIT, ROLLBACK)
-- ============================================================================

START TRANSACTION;

-- Simulação segura de atualização dentro de transação
UPDATE notas
SET nota1 = nota1
WHERE id_nota = 1;

COMMIT;

-- ============================================================================
-- 4. TABELA DE AUDITORIA E TRIGGERS AUTOMÁTICAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS auditoria_notas (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_nota INT NOT NULL,
    id_matricula INT NOT NULL,
    media_anterior DECIMAL(5,2),
    media_nova DECIMAL(5,2),
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_calcula_media_before_update;
DROP TRIGGER IF EXISTS trg_auditoria_after_update_notas;

DELIMITER $$

-- Trigger 1: Recalcula automaticamente a coluna media antes de salvar qualquer UPDATE em notas
CREATE TRIGGER trg_calcula_media_before_update
BEFORE UPDATE ON notas
FOR EACH ROW
BEGIN
    SET NEW.media = ROUND((NEW.nota1 + NEW.nota2 + NEW.nota3) / 3, 2);
END$$

-- Trigger 2: Registra no log de auditoria sempre que a média de uma nota for alterada
CREATE TRIGGER trg_auditoria_after_update_notas
AFTER UPDATE ON notas
FOR EACH ROW
BEGIN
    IF OLD.media <> NEW.media THEN
        INSERT INTO auditoria_notas (id_nota, id_matricula, media_anterior, media_nova, data_alteracao)
        VALUES (NEW.id_nota, NEW.id_matricula, OLD.media, NEW.media, NOW());
    END IF;
END$$

DELIMITER ;

