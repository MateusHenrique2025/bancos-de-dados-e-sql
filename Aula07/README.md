# Aula 07: Consultas Relacionais com `JOINs` (`INNER`, `LEFT`, `RIGHT`, `FULL`) e Subconsultas Aplicadas

**Data Oficial:** `10/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Compreender como as junções (`JOINs`) reconectam dados distribuídos em tabelas normalizadas por meio de Chaves Primárias (`PK`) e Chaves Estrangeiras (`FK`).
2. Dominar a diferença prática entre `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` e `FULL OUTER JOIN`.
3. Encadear múltiplos `JOINs` (3, 4 ou 5 tabelas) para construir relatórios completos do sistema `escola_db`.
4. Escrever **Subconsultas (`Subqueries`)** escalares, com operador `IN` e como tabelas derivadas no `FROM` e `HAVING`.

---

## 1. Por que Precisamos de `JOINs`?

Na Aula 03 nós **normalizamos** o banco de dados: separamos `alunos`, `cursos`, `professores`, `turmas`, `matriculas` e `notas` em 6 tabelas diferentes para evitar redundância.
Porém, quando o usuário abre a tela do sistema, ele não quer ver códigos numéricos soltos (`id_aluno = 4`, `id_turma = 2`, `id_curso = 1`): ele quer ver o **Nome do Aluno**, o **Nome da Turma**, o **Nome do Curso** e o **Nome do Professor** lado a lado.

O comando `JOIN` é a ponte que cruza a **Chave Estrangeira (`FK`)** de uma tabela com a **Chave Primária (`PK`)** da outra tabela no momento da consulta:

```text
Tabela: TURMAS                                Tabela: CURSOS
+----------+----------+-----------------+     +----------+----------------------+
| id_turma | id_curso | nome_turma      |     | id_curso | nome                 |
|   [PK]   |   [FK]   |                 |     |   [PK]   |                      |
+----------+----------+-----------------+     +----------+----------------------+
|    1     |    10    | Turma BD 2026.1 | --> |    10    | Banco de Dados e SQL |
+----------+----------+-----------------+     +----------+----------------------+
                       \                       /
                        ON turmas.id_curso = cursos.id_curso
```

---

## 2. Os 4 Tipos de `JOIN` e a Teoria dos Conjuntos

```text
  1. INNER JOIN              2. LEFT JOIN               3. RIGHT JOIN             4. FULL OUTER JOIN
  +---+   +---+             +---+   +---+              +---+   +---+              +---+   +---+
 /  A  \ /  B  \           /  A  \ /  B  \            /  A  \ /  B  \            /  A  \ /  B  \
|   |   X   |   |         |###|###X   |   |          |   |   X###|###|          |###|###X###|###|
 \  |  / \  |  /           \###/ \  |  /              \  |  / \###/              \###/ \###/
  +---+   +---+             +---+   +---+              +---+   +---+              +---+   +---+
Apenas registros que      TODOS da esquerda (A)      TODOS da direita (B)       TODOS de A e de B
têm par em A e B          + correspondentes em B     + correspondentes em A     (com ou sem par)
```

### 2.1. `INNER JOIN` (ou simplesmente `JOIN`)
Retorna **apenas as linhas que possuem correspondência nas duas tabelas**. Se um aluno foi cadastrado na tabela `alunos`, mas ainda não possui nenhuma matrícula na tabela `matriculas`, ele **não aparece** no `INNER JOIN`.

```sql
-- Apelidos de tabela (m = matriculas, a = alunos) deixam o código limpo e legível:
SELECT a.nome AS aluno,
       m.data_matricula,
       m.status
FROM matriculas m
INNER JOIN alunos a ON m.id_aluno = a.id_aluno;
```

### 2.2. `LEFT JOIN` (`LEFT OUTER JOIN`)
Retorna **todas as linhas da tabela da esquerda** (a que está no `FROM`), mesmo que não exista registro correspondente na tabela da direita. Quando não houver correspondência na direita, as colunas da direita vêm preenchidas com `NULL`.

**Caso de uso clássico:** *"Quais alunos estão cadastrados na escola, mas nunca fizeram matrícula em nenhuma turma?"*
```sql
SELECT a.id_aluno,
       a.nome AS aluno_sem_matricula,
       m.id_matricula
FROM alunos a
LEFT JOIN matriculas m ON a.id_aluno = m.id_aluno
WHERE m.id_matricula IS NULL;
```

### 2.3. `RIGHT JOIN` (`RIGHT OUTER JOIN`)
É o espelho do `LEFT JOIN`: garante **todas as linhas da tabela da direita** (a que está logo após o `RIGHT JOIN`), preenchendo com `NULL` o lado esquerdo caso não haja par.

```sql
-- Listar todos os cursos (mesmo aqueles que ainda não têm turmas abertas)
SELECT t.nome_turma,
       c.nome AS curso
FROM turmas t
RIGHT JOIN cursos c ON t.id_curso = c.id_curso;
```

### 2.4. `FULL OUTER JOIN` (e como simular no MySQL com `UNION`)
Retorna todas as linhas de ambas as tabelas, tenham elas correspondência ou não. Em SGBDs como PostgreSQL, SQL Server e Oracle existe a sintaxe direta `FULL OUTER JOIN`. No **MySQL**, obtemos o mesmo resultado unindo um `LEFT JOIN` e um `RIGHT JOIN` com o operador `UNION`:

```sql
SELECT a.nome AS aluno, m.id_matricula
FROM alunos a
LEFT JOIN matriculas m ON a.id_aluno = m.id_aluno
UNION
SELECT a.nome AS aluno, m.id_matricula
FROM alunos a
RIGHT JOIN matriculas m ON a.id_aluno = m.id_aluno;
```

---

## 3. Encadeando Múltiplos `JOINs` (Navegando pelo DER)

Para juntar 3, 4 ou 5 tabelas, basta seguir o caminho das setas no **DER** do banco `escola_db`:

```text
[ ALUNOS ] <--- (id_aluno) --- [ MATRICULAS ] --- (id_turma) ---> [ TURMAS ] --- (id_curso) ---> [ CURSOS ]
                                     |                                |
                              (id_matricula)                   (id_professor)
                                     v                                v
                                [ NOTAS ]                      [ PROFESSORES ]
```

```sql
-- Relatório Completo cruzando 5 tabelas: Aluno + Matrícula + Turma + Curso + Professor
SELECT a.nome AS aluno,
       c.nome AS curso,
       t.nome_turma,
       t.turno,
       p.nome AS professor,
       m.status
FROM matriculas m
INNER JOIN alunos a      ON m.id_aluno = a.id_aluno
INNER JOIN turmas t      ON m.id_turma = t.id_turma
INNER JOIN cursos c      ON t.id_curso = c.id_curso
INNER JOIN professores p ON t.id_professor = p.id_professor
ORDER BY c.nome ASC, t.nome_turma ASC, a.nome ASC;
```

---

## 4. Subconsultas (`Subqueries`)

Uma **Subconsulta** é um comando `SELECT` colocado entre parênteses `(SELECT ...)` dentro de outra consulta principal. O SGBD resolve a consulta interna primeiro e usa o resultado dela na consulta externa.

### 4.1. Subconsulta Escalar (Retorna 1 único valor)
Muito usada com operadores `=`, `>`, `>=`, `<`, `<=`.
* **Exemplo:** *"Quais avaliações na tabela `notas` ficaram acima da média geral de toda a escola?"*

```sql
SELECT id_matricula, nota1, nota2, nota3, media
FROM notas
WHERE media > (
    SELECT AVG(media) FROM notas
)
ORDER BY media DESC;
```

### 4.2. Subconsulta de Lista (Operador `IN` / `NOT IN`)
Quando a subconsulta retorna uma coluna com **vários valores**, usamos o operador `IN`:
* **Exemplo:** *"Listar o nome dos alunos que estão matriculados em turmas da professora `'Ana Paula Souza'`."*

```sql
SELECT nome
FROM alunos
WHERE id_aluno IN (
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

### 4.3. Subconsulta no `FROM` (Tabela Derivada)
Podemos usar o resultado de um `SELECT` agrupado como se fosse uma tabela temporária para calcular o máximo de uma contagem:
* **Exemplo:** *"Qual é o curso com o maior número de matrículas na escola?"*

```sql
SELECT c.nome, COUNT(*) AS total_matriculas
FROM cursos c
JOIN turmas t ON c.id_curso = t.id_curso
JOIN matriculas m ON t.id_turma = m.id_turma
GROUP BY c.nome
HAVING COUNT(*) = (
    SELECT MAX(contagem.total)
    FROM (
        SELECT COUNT(*) AS total
        FROM turmas t2
        JOIN matriculas m2 ON t2.id_turma = m2.id_turma
        GROUP BY t2.id_curso
    ) AS contagem
);
```

---

## 5. Para Saber Mais

* **Script de Apoio da Aula:** Consulte [`Aula07/joins_subconsultas.sql`](./joins_subconsultas.sql).
* **Leitura na Apostila:** Revise a [Unidade 7 da Apostila Completa](../apostila.md#unidade-7-consultas-multi-tabelas-joins-e-subconsultas).
* **Próximo Passo Prático:** Siga para o [Laboratório da Aula 07](./laboratorio.md) para concluir as Partes 4, 5 e os Desafios Integradores da lista oficial de exercícios.

