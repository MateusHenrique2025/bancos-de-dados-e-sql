# Gabarito Oficial: Consultas SQL Avançadas (`escola_db`)

> **Gabarito Liberado: ITEAM Capacitação Full Stack**  
> **Documento de Referência:** [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md)  
> **Base de dados:** `escola_db` (MySQL / MariaDB / DBeaver)

---

## Parte 1 — WHERE e ORDER BY

### 1. Liste todos os alunos em ordem alfabética pelo nome.
```sql
SELECT id_aluno, nome, email, telefone, data_nascimento, cidade
FROM alunos
ORDER BY nome ASC;
```

### 2. Liste os alunos da cidade de Boa Vista em ordem alfabética.
```sql
SELECT id_aluno, nome, email, telefone, data_nascimento, cidade
FROM alunos
WHERE cidade = 'Boa Vista'
ORDER BY nome ASC;
```

### 3. Mostre as turmas do período `2026.1` ordenadas pelo turno.
```sql
SELECT id_turma, nome_turma, periodo, turno, vagas
FROM turmas
WHERE periodo = '2026.1'
ORDER BY turno ASC;
```

### 4. Liste os cursos da área de Desenvolvimento Web em ordem crescente de nome.
```sql
SELECT id_curso, nome, carga_horaria, area
FROM cursos
WHERE area = 'Desenvolvimento Web'
ORDER BY nome ASC;
```

### 5. Mostre os professores da área Banco de Dados.
```sql
SELECT id_professor, nome, email, especialidade
FROM professores
WHERE especialidade = 'Banco de Dados';
```
*(Nota: dependendo da carga inicial do script DDL, a coluna de área/especialidade pode se chamar `especialidade` ou `area`. Ambas devem ser aceitas).*

---

## Parte 2 — GROUP BY e Funções Agregadas

### 6. Conte quantos alunos estão matriculados em cada turma.
```sql
SELECT id_turma, COUNT(*) AS total_alunos
FROM matriculas
GROUP BY id_turma;
```

### 7. Conte quantas matrículas existem por curso.
```sql
SELECT t.id_curso, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_curso;
```

### 8. Mostre a média das notas por turma.
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 9. Mostre a soma das notas por turma.
```sql
SELECT t.id_turma, SUM(n.media) AS soma_notas
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 10. Mostre a maior e a menor nota por turma.
```sql
SELECT t.id_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 11. Liste a quantidade de alunos por cidade.
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
ORDER BY total_alunos DESC;
```

### 12. Mostre a média de notas por aluno.
```sql
SELECT m.id_aluno, ROUND(AVG(n.media), 2) AS media_aluno
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
GROUP BY m.id_aluno;
```

---

## Parte 3 — HAVING

### 13. Liste as turmas com média de notas maior ou igual a 7.
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma
HAVING AVG(n.media) >= 7.0;
```

### 14. Mostre os cursos com mais de 5 matrículas.
```sql
SELECT c.id_curso, c.nome, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso
GROUP BY c.id_curso, c.nome
HAVING COUNT(*) > 5;
```

### 15. Liste os alunos cuja média geral seja maior ou igual a 8.
```sql
SELECT a.id_aluno, a.nome, ROUND(AVG(n.media), 2) AS media_geral
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY a.id_aluno, a.nome
HAVING AVG(n.media) >= 8.0;
```

### 16. Mostre as turmas com pelo menos 4 matrículas.
```sql
SELECT id_turma, COUNT(*) AS total_matriculas
FROM matriculas
GROUP BY id_turma
HAVING COUNT(*) >= 4;
```

### 17. Liste as cidades que possuem mais de 10 alunos cadastrados.
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
HAVING COUNT(*) > 10;
```

---

## Parte 4 — JOINs

### 18. Mostre o nome do aluno, a turma e o curso em que ele está matriculado.
```sql
SELECT a.nome AS aluno, t.nome_turma, c.nome AS curso
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso;
```

### 19. Liste o nome do professor e o curso que ele ministra.
```sql
SELECT p.nome AS professor, c.nome AS curso
FROM turmas t
JOIN professores p ON t.id_professor = p.id_professor
JOIN cursos c ON t.id_curso = c.id_curso;
```

### 20. Mostre alunos, turmas e turnos em uma única consulta.
```sql
SELECT a.nome AS aluno, t.nome_turma, t.turno
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma;
```

### 21. Liste os cursos com seus respectivos professores.
```sql
SELECT DISTINCT c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

### 22. Mostre os alunos com seus status de matrícula.
```sql
SELECT a.nome AS aluno, m.status, t.nome_turma
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma;
```

### 23. Liste todas as turmas com nome do curso e nome do professor.
```sql
SELECT t.nome_turma, c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

---

## Parte 5 — Subconsultas

### 24. Mostre os alunos com média maior ou igual à média geral da turma.
```sql
SELECT a.nome, t.nome_turma, n.media
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma
JOIN notas n ON m.id_matricula = n.id_matricula
WHERE n.media >= (
    SELECT AVG(n2.media)
    FROM notas n2
    JOIN matriculas m2 ON n2.id_matricula = m2.id_matricula
    WHERE m2.id_turma = m.id_turma
);
```

### 25. Liste os alunos com nota maior ou igual a 9 em pelo menos uma avaliação.
```sql
SELECT DISTINCT a.nome
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
WHERE n.nota1 >= 9.00 
   OR n.nota2 >= 9.00 
   OR n.nota3 >= 9.00;
```

### 26. Mostre os cursos cuja quantidade de matrículas é igual ao maior número de matrículas entre os cursos.
```sql
SELECT c.nome, COUNT(m.id_matricula) AS total_matriculas
FROM cursos c
JOIN turmas t ON c.id_curso = t.id_curso
JOIN matriculas m ON t.id_turma = m.id_turma
GROUP BY c.id_curso, c.nome
HAVING COUNT(m.id_matricula) = (
    SELECT MAX(total_por_curso)
    FROM (
        SELECT COUNT(m2.id_matricula) AS total_por_curso
        FROM turmas t2
        JOIN matriculas m2 ON t2.id_turma = m2.id_turma
        GROUP BY t2.id_curso
    ) sub
);
```

### 27. Liste os alunos matriculados em turmas do curso Banco de Dados e SQL usando subconsulta.
```sql
SELECT a.nome
FROM alunos a
WHERE a.id_aluno IN (
    SELECT m.id_aluno
    FROM matriculas m
    WHERE m.id_turma IN (
        SELECT t.id_turma
        FROM turmas t
        JOIN cursos c ON t.id_curso = c.id_curso
        WHERE c.nome = 'Banco de Dados e SQL'
    )
);
```

### 28. Mostre os alunos que estão em turmas ministradas pela professora Ana Paula Souza.
```sql
SELECT a.nome
FROM alunos a
WHERE a.id_aluno IN (
    SELECT m.id_aluno
    FROM matriculas m
    JOIN turmas t ON m.id_turma = t.id_turma
    WHERE t.id_professor = (
        SELECT id_professor
        FROM professores
        WHERE nome = 'Ana Paula Souza'
    )
);
```

---

## Desafios

### 29. Consulta única com resumo por turma (curso, turma, total alunos, média, maior e menor nota) ordenada pela média descrescente.
```sql
SELECT c.nome AS curso,
       t.nome_turma,
       COUNT(m.id_matricula) AS total_alunos,
       ROUND(AVG(n.media), 2) AS media_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN matriculas m ON t.id_turma = m.id_turma
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY c.nome, t.nome_turma
ORDER BY media_turma DESC;
```

### 30. Turmas com média acima de 7,5 e pelo menos 5 alunos matriculados.
```sql
SELECT t.nome_turma,
       COUNT(m.id_matricula) AS total_alunos,
       ROUND(AVG(n.media), 2) AS media_turma
FROM turmas t
JOIN matriculas m ON t.id_turma = m.id_turma
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY t.nome_turma
HAVING AVG(n.media) > 7.5
   AND COUNT(m.id_matricula) >= 5;
```

