# Gabarito: Consultas SQL Avançadas (Aulas 05, 06 e 07)

> **Uso Exclusivo do Professor:** Este arquivo é mantido fora do rastreamento público via `.gitignore`. Libere somente após a conclusão e correção das listas em sala de aula.

---

## Parte 1: `WHERE` e `ORDER BY` (Aula 05)

### 1. Listar todos os alunos em ordem alfabética
```sql
SELECT *
FROM alunos
ORDER BY nome ASC;
```

### 2. Listar alunos da cidade de Boa Vista ordenados por nome
```sql
SELECT *
FROM alunos
WHERE cidade = 'Boa Vista'
ORDER BY nome ASC;
```

### 3. Listar turmas do período `2026.1` ordenadas pelo turno
```sql
SELECT *
FROM turmas
WHERE periodo = '2026.1'
ORDER BY turno ASC;
```

### 4. Listar cursos da área de Desenvolvimento Web ordenados pelo nome
```sql
SELECT *
FROM cursos
WHERE area = 'Desenvolvimento Web'
ORDER BY nome ASC;
```

### 5. Listar professores cuja especialidade é Banco de Dados
```sql
SELECT *
FROM professores
WHERE area = 'Banco de Dados';
```

---

## Parte 2: `GROUP BY` e Funções Agregadas (Aula 06)

### 6. Contar o total de alunos matriculados por turma
```sql
SELECT id_turma, COUNT(*) AS total_alunos
FROM matriculas
GROUP BY id_turma;
```

### 7. Contar o total de matrículas por curso
```sql
SELECT t.id_curso, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_curso;
```

### 8. Calcular a média das notas por turma
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 9. Calcular a soma das médias por turma
```sql
SELECT t.id_turma, SUM(n.media) AS soma_notas
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 10. Exibir a maior e a menor média de cada turma
```sql
SELECT t.id_turma,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma;
```

### 11. Contar a quantidade de alunos por cidade
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade;
```

### 12. Calcular a média geral de cada aluno
```sql
SELECT m.id_aluno, ROUND(AVG(n.media), 2) AS media_aluno
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
GROUP BY m.id_aluno;
```

---

## Parte 3: Filtragem de Grupos com `HAVING` (Aula 06)

### 13. Turmas com média igual ou superior a 7.0
```sql
SELECT t.id_turma, ROUND(AVG(n.media), 2) AS media_turma
FROM notas n
JOIN matriculas m ON n.id_matricula = m.id_matricula
JOIN turmas t ON m.id_turma = t.id_turma
GROUP BY t.id_turma
HAVING AVG(n.media) >= 7;
```

### 14. Cursos com mais de 5 matrículas
```sql
SELECT c.id_curso, COUNT(*) AS total_matriculas
FROM matriculas m
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso
GROUP BY c.id_curso
HAVING COUNT(*) > 5;
```

### 15. Alunos com média geral igual ou superior a 8.0
```sql
SELECT a.id_aluno, ROUND(AVG(n.media), 2) AS media_geral
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY a.id_aluno
HAVING AVG(n.media) >= 8;
```

### 16. Turmas com pelo menos 4 matrículas
```sql
SELECT id_turma, COUNT(*) AS total_matriculas
FROM matriculas
GROUP BY id_turma
HAVING COUNT(*) >= 4;
```

### 17. Cidades com mais de 10 alunos cadastrados
```sql
SELECT cidade, COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
HAVING COUNT(*) > 10;
```

---

## Parte 4: Junções Relacionais com `JOIN` (Aula 07)

### 18. Nome do aluno, nome da turma e nome do curso
```sql
SELECT a.nome AS aluno, t.nome_turma, c.nome AS curso
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso;
```

### 19. Nome do professor e o curso que ele leciona
```sql
SELECT p.nome AS professor, c.nome AS curso
FROM turmas t
JOIN professores p ON t.id_professor = p.id_professor
JOIN cursos c ON t.id_curso = c.id_curso;
```

### 20. Nome do aluno, turma e turno
```sql
SELECT a.nome AS aluno, t.nome_turma, t.turno
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma;
```

### 21. Curso e respectivo professor responsável
```sql
SELECT c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

### 22. Nome do aluno e status da matrícula
```sql
SELECT a.nome AS aluno, m.status
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno;
```

### 23. Turma, curso e professor responsável
```sql
SELECT t.nome_turma, c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

---

## Parte 5: Subconsultas (Aula 07)

### 24. Alunos com média igual ou superior à média de sua turma
```sql
SELECT a.nome
FROM alunos a
WHERE a.id_aluno IN (
    SELECT m.id_aluno
    FROM matriculas m
    JOIN notas n ON m.id_matricula = n.id_matricula
    GROUP BY m.id_aluno, m.id_turma
    HAVING AVG(n.media) >= (
        SELECT AVG(n2.media)
        FROM notas n2
        JOIN matriculas m2 ON n2.id_matricula = m2.id_matricula
        WHERE m2.id_turma = m.id_turma
    )
);
```

### 25. Alunos que tiraram nota igual ou superior a 9 em qualquer avaliação
```sql
SELECT DISTINCT a.nome
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
WHERE n.nota1 >= 9 OR n.nota2 >= 9 OR n.nota3 >= 9;
```

### 26. Curso com o maior número de matrículas
```sql
SELECT c.nome
FROM cursos c
JOIN turmas t ON c.id_curso = t.id_curso
JOIN matriculas m ON t.id_turma = m.id_turma
GROUP BY c.nome
HAVING COUNT(*) = (
    SELECT MAX(total_matriculas)
    FROM (
        SELECT COUNT(*) AS total_matriculas
        FROM turmas t2
        JOIN matriculas m2 ON t2.id_turma = m2.id_turma
        GROUP BY t2.id_curso
    ) x
);
```

### 27. Alunos matriculados no curso de Banco de Dados e SQL
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

### 28. Alunos que estudam em turmas da professora Ana Paula Souza
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

## Desafios Integradores

### 29. Relatório completo por turma ordenado pela maior média
```sql
SELECT c.nome AS curso,
       t.nome_turma,
       COUNT(m.id_matricula) AS total_alunos,
       ROUND(AVG(n.media), 2) AS media_notas,
       MAX(n.media) AS maior_nota,
       MIN(n.media) AS menor_nota
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN matriculas m ON t.id_turma = m.id_turma
JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY c.nome, t.nome_turma
ORDER BY media_notas DESC;
```

### 30. Turmas de alto desempenho com pelo menos 5 alunos e média acima de 7.5
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

