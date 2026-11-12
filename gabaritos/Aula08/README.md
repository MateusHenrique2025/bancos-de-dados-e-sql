# Gabarito - Aula 08: Views, Índices com `EXPLAIN`, Transações ACID e Triggers

## Objetivo
Avaliar o entendimento de objetos de abstração de dados (Views), análise de custo de consultas e criação de índices, garantia de atomicidade com transações (`START TRANSACTION`, `COMMIT`, `ROLLBACK`) e automações orientadas a eventos (Triggers).

## Checklist de Verificação
- [ ] O aluno criou e consultou a view `vw_boletim_escolar`?
- [ ] O aluno criou a view executiva `vw_resumo_turmas`?
- [ ] O aluno comparou o comando `EXPLAIN` antes (`type = ALL`) e depois (`type = ref`) do índice?
- [ ] A simulação de `ROLLBACK` restaurou o estado original dos dados?
- [ ] A transação de matrícula com `LAST_INSERT_ID()` gravou atômica e corretamente?
- [ ] A trigger de auditoria recalculou a média e gravou log automático?

---

## Solução do Laboratório

### Etapa 1: Views para os Dashboards do Projeto Integrador

#### 1. Consultas sobre a View do Boletim Geral (`vw_boletim_escolar`)
```sql
-- Pergunta 1.1: Alunos aprovados no Noturno
SELECT COUNT(*) AS total_aprovados_noturno
FROM vw_boletim_escolar
WHERE situacao_final = 'Aprovado' 
  AND turno = 'Noturno';

-- Pergunta 1.2: Boletim do curso Banco de Dados e SQL
SELECT aluno, turma, turno, nota1, nota2, nota3, media, situacao_final
FROM vw_boletim_escolar
WHERE curso = 'Banco de Dados e SQL'
ORDER BY turma ASC, aluno ASC;
```

#### 2. Criação da View Executiva por Turma (`vw_resumo_turmas`)
```sql
CREATE OR REPLACE VIEW vw_resumo_turmas AS
SELECT t.id_turma,
       t.nome_turma,
       c.nome AS curso,
       p.nome AS professor,
       t.turno,
       COUNT(m.id_matricula) AS total_alunos,
       ROUND(AVG(n.media), 2) AS media_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor
LEFT JOIN matriculas m ON t.id_turma = m.id_turma
LEFT JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY t.id_turma, t.nome_turma, c.nome, p.nome, t.turno;
```

---

### Etapa 2: Otimização de Consultas com Índices e `EXPLAIN`

#### 1. Análise Sem Índice
```sql
EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
-- Diagnóstico: type = 'ALL' (Full Table Scan), key = NULL, rows = total de linhas da tabela.
```

#### 2. Criação do Índice Composto
```sql
CREATE INDEX idx_alunos_cidade_nome ON alunos(cidade, nome);
```

#### 3. Análise Com Índice
```sql
EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
-- Diagnóstico: type = 'ref', key = 'idx_alunos_cidade_nome', rows reduzido drasticamente.
```

---

### Etapa 3: Transações ACID

#### Tarefa 3.2: Transação Atômica (Matrícula + Lançamento de Notas)
```sql
START TRANSACTION;

INSERT INTO matriculas (id_aluno, id_turma, data_matricula, status)
VALUES (1, 3, CURDATE(), 'Ativo');

SET @nova_matricula = LAST_INSERT_ID();

INSERT INTO notas (id_matricula, nota1, nota2, nota3, media)
VALUES (@nova_matricula, 8.00, 9.00, 8.50, ROUND((8.00 + 9.00 + 8.50) / 3, 2));

COMMIT;
```

---

### Etapa 4: Automação com Trigger de Auditoria de Notas

```sql
-- Teste de disparo da trigger:
UPDATE notas SET nota1 = 9.50 WHERE id_nota = 1;

-- Verificação da auditoria:
SELECT * FROM auditoria_notas;
SELECT id_nota, nota1, nota2, nota3, media FROM notas WHERE id_nota = 1;
```

---

## Pontos Comuns de Dificuldade
* **Esquecer o delimitador em triggers complexas:** Ao criar triggers no terminal ou script via linha de comando, é necessário usar `DELIMITER //`. No DBeaver, selecione o bloco inteiro e execute com `Alt + X`.
* **Dúvida sobre `LAST_INSERT_ID()` em campos Auto Incremento:** A função captura o ID gerado na tabela pai (`matriculas.id_matricula`) para propagar a Foreign Key na tabela filha (`notas.id_matricula`) dentro da mesma sessão/conexão, evitando condições de corrida de `SELECT MAX(id)`. No backend Node.js/Express, isso equivale a ler `result.insertId` após o `INSERT`.
