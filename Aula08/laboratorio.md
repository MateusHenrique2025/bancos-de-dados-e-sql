# Laboratório Prático 08: Views, Índices com `EXPLAIN`, Transações ACID e Triggers

**Aula de Referência:** [Aula 08 — Recursos Avançados de SQL e Revisão Geral](./README.md)  
**Tempo Estimado:** 120 minutos  
**Base de Dados:** `escola_db` ([`base/escola_db.sql`](../base/escola_db.sql))  
**Script de Apoio:** [`recursos_avancados.sql`](./recursos_avancados.sql)  

---

## Objetivos do Laboratório

1. Criar **Views** prontas para consumo pela aplicação do Projeto Integrador.
2. Analisar o plano de execução de consultas com `EXPLAIN` antes e depois de criar **Índices (`CREATE INDEX`)**.
3. Simular cenários de sucesso (`COMMIT`) e falha (`ROLLBACK`) com **Transações**.
4. Criar uma **Trigger** de cálculo automático de média e auditoria de alterações de notas.

---

## Etapa 1: Criando Views para os Dashboards do Projeto Integrador (30 min)

Conectado ao banco `escola_db` no DBeaver, crie duas **Views** que facilitarão diretamente o desenvolvimento do Projeto Integrador da sua equipe:

### Tarefa 1.1: View do Boletim Geral (`vw_boletim_escolar`)
Execute a criação da view `vw_boletim_escolar` (presente em [`recursos_avancados.sql`](./recursos_avancados.sql)) que une `alunos`, `matriculas`, `turmas`, `cursos`, `professores` e `notas`, calculando a coluna `situacao_final` (`'Aprovado'`, `'Recuperação'` ou `'Reprovado'`).
Em seguida, responda usando apenas `SELECT` sobre a sua nova View:
1. Quantos alunos estão com situação `'Aprovado'` no turno `'Noturno'`?
2. Qual é o boletim completo dos alunos do curso `'Banco de Dados e SQL'`?

### Tarefa 1.2: View Executiva por Turma (`vw_resumo_turmas`)
Crie uma segunda view chamada `vw_resumo_turmas` que exiba:
* `id_turma`, `nome_turma`, `nome` do curso, `nome` do professor, `turno`, `total_alunos` (`COUNT`), `media_turma` (`ROUND(AVG(n.media), 2)`), `maior_nota` (`MAX`) e `menor_nota` (`MIN`).
* Teste sua view com: `SELECT * FROM vw_resumo_turmas ORDER BY media_turma DESC;`.

---

## Etapa 2: Otimização de Consultas com Índices e `EXPLAIN` (30 min)

1. Antes de criar o índice, execute no DBeaver:
   ```sql
   EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
   ```
   Observe o valor da coluna **`type`** (`ALL` = Full Table Scan) e da coluna **`rows`** (quantas linhas o MySQL precisou varrer).
2. Agora crie um índice para otimizar buscas por cidade e nome:
   ```sql
   CREATE INDEX idx_alunos_cidade_nome ON alunos(cidade, nome);
   ```
3. Execute novamente o comando `EXPLAIN`:
   ```sql
   EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
   ```
   Compare o novo valor das colunas **`type`** (`ref`), **`key`** (`idx_alunos_cidade_nome`) e **`rows`**!

---

## Etapa 3: Laboratório de Transações (`COMMIT` vs. `ROLLBACK`) (30 min)

Vamos testar na prática a propriedade de **Atomicidade (ACID)**:

### Tarefa 3.1: Testando o `ROLLBACK` (Desfazendo um erro)
Execute o bloco abaixo linha por linha no DBeaver:
```sql
START TRANSACTION;

-- 1. Imagine que alguém alterou por engano a cidade de TODOS os alunos:
UPDATE alunos SET cidade = 'Cidade Errada';

-- 2. Confira o susto:
SELECT id_aluno, nome, cidade FROM alunos LIMIT 10;

-- 3. Desfaça imediatamente toda a transação com ROLLBACK:
ROLLBACK;

-- 4. Verifique que todos os dados originais voltaram intactos!
SELECT id_aluno, nome, cidade FROM alunos LIMIT 10;
```

### Tarefa 3.2: Testando o `COMMIT` (Matrícula + Lançamento Inicial de Notas)
Escreva uma transação com `START TRANSACTION; ... COMMIT;` que insira uma nova matrícula para o `id_aluno = 1` na `id_turma = 3` e, logo em seguida, insira na tabela `notas` as notas iniciais (`8.0`, `9.0`, `8.5`, média `8.50`) usando `LAST_INSERT_ID()`.

---

## Etapa 4: Automação com Trigger de Auditoria de Notas (30 min)

A direção da escola pediu que toda alteração de nota na tabela `notas` fique registrada em uma tabela de auditoria (`auditoria_notas`) informando a média antiga, a média nova e a data/hora da modificação.

1. Execute no DBeaver os comandos de criação da tabela `auditoria_notas` e da trigger `trg_auditoria_update_notas` presentes no arquivo [`recursos_avancados.sql`](./recursos_avancados.sql).
2. Atualize a `nota1` da matrícula de código `id_nota = 1`:
   ```sql
   UPDATE notas SET nota1 = 9.50 WHERE id_nota = 1;
   ```
3. Consulte a tabela `SELECT * FROM auditoria_notas;` e a linha `SELECT * FROM notas WHERE id_nota = 1;` para comprovar que:
   * A nova `media` foi recalculada automaticamente pela trigger!
   * O registro de auditoria foi gravado automaticamente sem que você precisasse fazer `INSERT` manual na tabela de log!

