# Gabarito - Aula 06: Agrupamento (`GROUP BY`), Funções Agregadas e Filtragem com `HAVING`

## Objetivo
Avaliar o domínio de agregações (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`), a regra de ouro de inclusão de colunas não-agregadas no `GROUP BY`, e a distinção fundamental entre pré-filtro (`WHERE`) e pós-filtro (`HAVING`).

## Checklist de Verificação
- [ ] Todas as colunas do `SELECT` que não são funções agregadas constam na cláusula `GROUP BY`?
- [ ] O aluno utilizou `HAVING` (e não `WHERE`) para filtrar resultados de agregações?
- [ ] As questões 6 a 17 da lista oficial foram resolvidas?
- [ ] O diagnóstico da Etapa 4 (`WHERE COUNT(*) > 5`) foi explicado tecnicamente?
- [ ] O **Desafio Extra** de análise cronológica de matrículas foi resolvido?

---

## Solução do Laboratório

### Parte 2: `GROUP BY` e Funções Agregadas (Questões 6 a 12)

#### 6. Total de alunos matriculados por turma
```sql
SELECT id_turma, COUNT(*) AS total_alunos
FROM matriculas
GROUP BY id_turma;
```

#### 7. Total de matrículas por curso
```sql
SELECT t.id_curso, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_curso;
```

#### 8. Média das notas por turma
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

#### 9. Soma das médias por turma
```sql
SELECT t.id_turma, SUM(n.media) AS soma_notas
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

#### 10. Maior e menor média de cada turma
```sql
SELECT t.id_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

#### 11. Quantidade de alunos por cidade
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
ORDER BY total_alunos DESC;
```

#### 12. Média geral de cada aluno
```sql
SELECT m.id_aluno, ROUND(AVG(n.media), 2) AS media_aluno
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
GROUP BY m.id_aluno;
```

---

### Parte 3: Filtragem de Grupos com `HAVING` (Questões 13 a 17)

#### 13. Turmas com média igual ou superior a 7.0
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma
HAVING AVG(n.media) >= 7.0;
```

#### 14. Cursos com mais de 5 matrículas
```sql
SELECT c.id_curso, c.nome, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso
GROUP BY c.id_curso, c.nome
HAVING COUNT(*) > 5;
```

#### 15. Alunos com média geral igual ou superior a 8.0
```sql
SELECT a.id_aluno, a.nome, ROUND(AVG(n.media), 2) AS media_geral
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY a.id_aluno, a.nome
HAVING AVG(n.media) >= 8.0;
```

#### 16. Turmas com pelo menos 4 matrículas
```sql
SELECT id_turma, COUNT(*) AS total_matriculas
FROM matriculas
GROUP BY id_turma
HAVING COUNT(*) >= 4;
```

#### 17. Cidades com mais de 10 alunos cadastrados
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
HAVING COUNT(*) > 10;
```

---

### Etapa 4: Diagnóstico de Erro Comum (`WHERE` vs. `HAVING`)
* **Erro:** `WHERE COUNT(*) > 5`
* **Explicação Técnica:** A cláusula `WHERE` atua linha por linha antes do particionamento dos dados. As funções agregadas operam sobre blocos resultantes e dependem da cláusula `HAVING`.
* **Correção:**
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
HAVING COUNT(*) > 5
ORDER BY total_alunos DESC;
```

---

### Desafio Extra: Análise Cronológica por Status de Matrícula
> **Enunciado:** Construa um único relatório na tabela `matriculas` que mostre, por `status`, a quantidade de matrículas existentes, a data da matrícula mais antiga (`MIN(data_matricula)`) e a data da matrícula mais recente (`MAX(data_matricula)`), ordenando do status mais frequente para o menos frequente.

```sql
SELECT status,
       COUNT(*) AS total_matriculas,
       MIN(data_matricula) AS matricula_mais_antiga,
       MAX(data_matricula) AS matricula_mais_recente
FROM matriculas
GROUP BY status
ORDER BY total_matriculas DESC;
```

---

## Pontos Comuns de Dificuldade
* **Erro `Expression not in GROUP BY` (sql_mode=only_full_group_by):** O MySQL impede selecionar colunas avulsas sem agregação e sem constar no `GROUP BY`.
