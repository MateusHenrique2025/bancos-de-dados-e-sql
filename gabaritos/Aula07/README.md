# Gabarito - Aula 07: Junções Relacionais (`JOIN`) e Subconsultas

## Objetivo
Avaliar a resolução de consultas multibilaterais com `INNER JOIN`, o uso adequado de aliases de tabela (`m`, `a`, `t`, `c`) e subconsultas em cláusulas `WHERE` (`IN`, escalares e correlacionadas).

## Checklist de Verificação
- [ ] Todas as junções possuem a condição explícita `ON` com as respectivas chaves (`PK = FK`)?
- [ ] As questões 18 a 28 da lista oficial foram resolvidas?
- [ ] Os Desafios Integradores 29 e 30 foram concluídos?

---

## Solução do Laboratório

### Parte 4: Junções Relacionais com `JOIN` (Questões 18 a 23)

#### 18. Nome do aluno, nome da turma e nome do curso
```sql
SELECT a.nome AS aluno, t.nome_turma, c.nome AS curso
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma
JOIN cursos c ON t.id_curso = c.id_curso;
```

#### 19. Nome do professor e o curso que ele leciona
```sql
SELECT p.nome AS professor, c.nome AS curso
FROM turmas t
JOIN professores p ON t.id_professor = p.id_professor
JOIN cursos c ON t.id_curso = c.id_curso;
```

#### 20. Nome do aluno, turma e turno
```sql
SELECT a.nome AS aluno, t.nome_turma, t.turno
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma;
```

#### 21. Curso e respectivo professor responsável
```sql
SELECT c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

#### 22. Nome do aluno e status da matrícula
```sql
SELECT a.nome AS aluno, m.status
FROM matriculas m
JOIN alunos a ON m.id_aluno = a.id_aluno;
```

#### 23. Turma, curso e professor responsável
```sql
SELECT t.nome_turma, c.nome AS curso, p.nome AS professor
FROM turmas t
JOIN cursos c ON t.id_curso = c.id_curso
JOIN professores p ON t.id_professor = p.id_professor;
```

---

### Parte 5: Subconsultas (Questões 24 a 28)

#### 24. Alunos com média igual ou superior à média de sua turma
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

#### 25. Alunos que tiraram nota igual ou superior a 9 em qualquer avaliação
```sql
SELECT DISTINCT a.nome
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN notas n ON m.id_matricula = n.id_matricula
WHERE n.nota1 >= 9.00 OR n.nota2 >= 9.00 OR n.nota3 >= 9.00;
```

#### 26. Curso com o maior número de matrículas
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

#### 27. Alunos matriculados no curso de Banco de Dados e SQL
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

#### 28. Alunos que estudam em turmas da professora Ana Paula Souza
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

### Desafios Integradores (Questões 29 e 30)

#### 29. Relatório completo por turma ordenado pela maior média
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

#### 30. Turmas de alto desempenho com pelo menos 5 alunos e média acima de 7.5
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

---

## Pontos Comuns de Dificuldade
* **Omissão da cláusula `ON`:** Gera produto cartesiano (`CROSS JOIN`), multiplicando todas as linhas de uma tabela por todas as linhas da outra.
