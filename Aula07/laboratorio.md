# Laboratório Prático 07: Consultas Multi-Tabelas (`JOINs`), Subconsultas e Desafios

**Aula de Referência:** [Aula 07 — Consultas Relacionais com `JOINs` e Subconsultas](./README.md)  
**Tempo Estimado:** 120 minutos  
**Base de Dados:** `escola_db` ([`base/escola_db.sql`](../base/escola_db.sql))  
**Script de Apoio:** [`joins_subconsultas.sql`](./joins_subconsultas.sql)  

---

## Objetivos do Laboratório

1. Escrever junções multi-tabelas com `INNER JOIN` e `LEFT JOIN` sobre a base `escola_db`.
2. Construir subconsultas aninhadas com `IN`, comparações escalares (`>= AVG(...)`) e tabelas derivadas.
3. Resolver as **Partes 4, 5 e os Desafios (Questões 18 a 30)** da lista oficial ([`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md)).

---

## Etapa 1: Lista Oficial de Exercícios — Parte 4 (`JOINs` Multi-Tabelas) (40 min)

Abra o arquivo [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md) e desenvolva no DBeaver as consultas das **Questões 18 a 23**:

18. **Questão 18:** Exiba o **nome do aluno**, o **nome da turma** e o **nome do curso** para todas as matrículas cadastradas (cruzando `matriculas`, `alunos`, `turmas` e `cursos`).
19. **Questão 19:** Exiba o **nome do professor** e o **nome do curso** que ele leciona (cruzando `turmas`, `professores` e `cursos`).
20. **Questão 20:** Exiba o **nome do aluno**, o **nome da turma** e o **turno** em que ele estuda.
21. **Questão 21:** Exiba o **nome do curso** e o **nome do professor** responsável por cada turma aberta.
22. **Questão 22:** Exiba o **nome do aluno** e o **status** de sua matrícula.
23. **Questão 23:** Exiba o **nome da turma**, o **nome do curso** e o **nome do professor** responsável.

---

## Etapa 2: Prática de `LEFT JOIN` — Auditoria de Cadastros Sem Vínculo (15 min)

A coordenação quer identificar registros cadastrados que ainda não tiveram movimentação:

1. Escreva uma consulta usando `LEFT JOIN` entre `alunos` e `matriculas` para listar se existe algum aluno cadastrado que **não possui nenhuma matrícula** (`WHERE m.id_matricula IS NULL`).
2. Escreva uma consulta usando `LEFT JOIN` entre `matriculas` e `notas` para verificar se existe alguma matrícula ativa que **ainda não possui notas lançadas** (`WHERE n.id_nota IS NULL`).

---

## Etapa 3: Lista Oficial de Exercícios — Parte 5 (`Subconsultas`) (40 min)

Desenvolva no DBeaver as consultas das **Questões 24 a 28** de [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md):

24. **Questão 24:** Liste o nome dos alunos cuja média de notas seja **maior ou igual à média da sua própria turma** (subconsulta correlacionada).
25. **Questão 25:** Liste o nome (sem repetição, usando `DISTINCT`) dos alunos que tiraram nota maior ou igual a `9.0` em qualquer uma das três avaliações (`nota1`, `nota2` ou `nota3`).
26. **Questão 26:** Descubra o nome do curso que possui o **maior número de matrículas** na escola usando subconsulta no `HAVING`.
27. **Questão 27:** Usando subconsultas aninhadas com `IN`, liste o nome dos alunos matriculados em turmas do curso `'Banco de Dados e SQL'`.
28. **Questão 28:** Usando subconsulta com `IN` e `=`, liste o nome dos alunos que estudam em turmas ministradas pela professora `'Ana Paula Souza'`.

---

## Etapa 4: Desafios Integradores da Lista Oficial (Questões 29 e 30) (25 min)

Combine `JOINs`, `GROUP BY`, funções agregadas (`COUNT`, `AVG`, `MAX`, `MIN`), `HAVING` e `ORDER BY` para fechar as duas questões finais da lista:

29. **Questão 29 (Painel Executivo por Turma):** Gere um relatório exibindo o **nome do curso**, o **nome da turma**, o **total de alunos matriculados**, a **média das notas da turma**, a **maior nota** e a **menor nota**, ordenando da turma de maior média para a de menor média (`ORDER BY media_notas DESC`).
30. **Questão 30 (Turmas de Excelência):** Liste o **nome da turma**, o **total de alunos** e a **média da turma** apenas para as turmas que possuam simultaneamente **média superior a `7.5`** e **pelo menos 5 alunos matriculados**.

