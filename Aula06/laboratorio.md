# Laboratório Prático 06: Relatórios Estatísticos com `GROUP BY` e `HAVING`

**Aula de Referência:** [Aula 06 — Funções Agregadas, `GROUP BY` e `HAVING`](./README.md)  
**Tempo Estimado:** 120 minutos  
**Base de Dados:** `escola_db` ([`base/escola_db.sql`](../base/escola_db.sql))  
**Script de Apoio:** [`relatorios_agregados.sql`](./relatorios_agregados.sql)  

---

## Objetivos do Laboratório

1. Extrair métricas globais da escola com `COUNT`, `SUM`, `AVG`, `MAX` e `MIN`.
2. Construir relatórios agrupados por turma, curso, cidade e aluno utilizando `GROUP BY`.
3. Filtrar indicadores agregados com `HAVING`, resolvendo as **Partes 2 e 3** da lista oficial de exercícios ([`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md)).

---

## Etapa 1: Aquecimento — Indicadores Globais do `escola_db` (20 min)

No DBeaver, conectado ao banco `escola_db`, escreva consultas rápidas para descobrir os números gerais da instituição:

1. Qual é o total de alunos cadastrados na tabela `alunos`?
2. Quantas cidades diferentes (`DISTINCT`) estão representadas no cadastro de alunos?
3. Qual é a soma total da `carga_horaria` de todos os cursos oferecidos na tabela `cursos`?
4. Na tabela `notas`, qual é a **média geral** de todas as notas (`AVG(media)`), a **maior média** (`MAX(media)`) e a **menor média** (`MIN(media)`) registrada?

---

## Etapa 2: Lista Oficial de Exercícios — Parte 2 (`GROUP BY` e Funções Agregadas) (50 min)

Abra o enunciado em [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md) e desenvolva as consultas correspondentes às **Questões 6 a 12**:

6. **Questão 6:** Conte a quantidade total de alunos matriculados por turma (`id_turma`) na tabela `matriculas`.
7. **Questão 7:** Conte o total de matrículas por curso (`id_curso`, cruzando `matriculas` e `turmas`).
8. **Questão 8:** Calcule a média das notas (`AVG(n.media)`) por turma.
9. **Questão 9:** Calcule a soma das médias (`SUM(n.media)`) por turma.
10. **Questão 10:** Exiba a maior nota (`MAX(n.media)`) e a menor nota (`MIN(n.media)`) de cada turma.
11. **Questão 11:** Conte o total de alunos cadastrados por `cidade`.
12. **Questão 12:** Calcule a média geral de notas de cada aluno (`id_aluno`).

---

## Etapa 3: Lista Oficial de Exercícios — Parte 3 (Filtrando Grupos com `HAVING`) (40 min)

Agora aplique a cláusula `HAVING` após o `GROUP BY` para resolver as **Questões 13 a 17** de [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md):

13. **Questão 13:** Exiba apenas as turmas cuja média de notas (`AVG(n.media)`) seja **maior ou igual a `7.0`**.
14. **Questão 14:** Exiba apenas os cursos que possuem **mais de 5 matrículas** (`COUNT(*) > 5`).
15. **Questão 15:** Exiba apenas os alunos que possuem média geral **maior ou igual a `8.0`**.
16. **Questão 16:** Exiba as turmas que possuem **pelo menos 4 matrículas** (`COUNT(*) >= 4`).
17. **Questão 17:** Exiba as cidades que possuem **mais de 10 alunos** cadastrados (`COUNT(*) > 10`).

---

## Etapa 4: Diagnóstico de Erro Comum (10 min)

Um desenvolvedor júnior tentou rodar a consulta abaixo no DBeaver e recebeu um erro do MySQL:

```sql
-- CONSULTA COM ERRO:
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
WHERE COUNT(*) > 5
GROUP BY cidade;
```

1. Por que o MySQL rejeitou o uso de `COUNT(*) > 5` dentro da cláusula `WHERE`?
2. Reescreva a consulta corrigindo o erro.

---

## Desafio Extra

Construa um único relatório na tabela `matriculas` que mostre, por `status` (`Ativo`, `Concluído`, `Trancado`, etc.), a quantidade de matrículas existentes, a data da matrícula mais antiga (`MIN(data_matricula)`) e a data da matrícula mais recente (`MAX(data_matricula)`), ordenando do status mais frequente para o menos frequente.

