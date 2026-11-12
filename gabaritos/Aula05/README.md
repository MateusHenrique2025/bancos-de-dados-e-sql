# Gabarito - Aula 05: Comandos DML, Filtros com `WHERE` e Ordenação (`ORDER BY`)

## Objetivo
Avaliar a execução segura de operações de manipulação de dados (`INSERT`, `UPDATE`, `DELETE` respeitando integridade referencial), consultas de seleção com filtros múltiplos e o domínio de colunas calculadas e operadores lógicos.

## Checklist de Verificação
- [ ] O aluno executou `INSERT` em `alunos` e depois em `matriculas` com integridade?
- [ ] O aluno usou `WHERE` obrigatório em `UPDATE` e `DELETE`?
- [ ] O aluno observou o bloqueio de exclusão por Foreign Key (Error 1451)?
- [ ] As 5 questões da Parte 1 da lista oficial foram resolvidas?
- [ ] As 4 perguntas da Etapa 3 foram resolvidas?
- [ ] O **Desafio Extra** da tabela `notas` com coluna calculada `pontos_para_dez` foi resolvido?

---

## Solução do Laboratório

### Etapa 1: Prática de Escrita Segura (DML)

#### 1. Inserção Segura
```sql
INSERT INTO alunos (nome, cpf, email, telefone, data_nascimento, cidade, data_cadastro)
VALUES ('Aluno Teste', '12345678999', 'aluno.teste@iteam.br', '(95) 99111-2233', '2005-03-15', 'Boa Vista', CURDATE());

-- Vincular matrícula:
INSERT INTO matriculas (id_aluno, id_turma, data_matricula, status)
VALUES (LAST_INSERT_ID(), 1, CURDATE(), 'Ativo');
```

#### 2. Atualização Segura em 2 Passos
```sql
-- Passo 1: Conferir antes
SELECT * FROM alunos WHERE id_aluno = 101;

-- Passo 2: Atualizar com filtro PK estrito
UPDATE alunos 
SET telefone = '(95) 98888-7766', email = 'novo.email@iteam.br'
WHERE id_aluno = 101;
```

#### 3. Teste de Exclusão e Integridade Referencial
```sql
-- Tentativa com matrícula ativa:
DELETE FROM alunos WHERE id_aluno = 101;
-- Retorno esperado: Error 1451 (Cannot delete or update a parent row: a foreign key constraint fails)
-- Justificativa: A constraint fk_matriculas_alunos protege contra registros órfãos.

-- Exclusão ordenada com sucesso:
DELETE FROM matriculas WHERE id_aluno = 101;
DELETE FROM alunos WHERE id_aluno = 101;
```

---

### Etapa 2: Lista Oficial de Exercícios — Parte 1 (`WHERE` e `ORDER BY`)

#### 1. Listar todos os alunos em ordem alfabética
```sql
SELECT *
FROM alunos
ORDER BY nome ASC;
```

#### 2. Listar alunos da cidade de Boa Vista ordenados por nome
```sql
SELECT *
FROM alunos
WHERE cidade = 'Boa Vista'
ORDER BY nome ASC;
```

#### 3. Listar turmas do período `2026.1` ordenadas pelo turno
```sql
SELECT *
FROM turmas
WHERE periodo = '2026.1'
ORDER BY turno ASC;
```

#### 4. Listar cursos da área de Desenvolvimento Web ordenados pelo nome
```sql
SELECT *
FROM cursos
WHERE area = 'Desenvolvimento Web'
ORDER BY nome ASC;
```

#### 5. Listar professores cuja especialidade é Banco de Dados
```sql
SELECT *
FROM professores
WHERE area = 'Banco de Dados';
```

---

### Etapa 3: Filtros Avançados de Investigação no `escola_db`

#### 1. Busca por Padrão (`LIKE`)
```sql
SELECT id_aluno, nome, email
FROM alunos
WHERE nome LIKE 'M%' 
   OR nome LIKE '%Silva%';
```

#### 2. Filtro por Lista (`IN`)
```sql
SELECT nome, cidade
FROM alunos
WHERE cidade IN ('Rorainópolis', 'Caracaraí', 'Mucajaí', 'Pacaraima')
ORDER BY cidade ASC, nome ASC;
```

#### 3. Filtro por Intervalo (`BETWEEN`)
```sql
SELECT id_matricula, nota1, nota2, nota3, media
FROM notas
WHERE media BETWEEN 8.00 AND 10.00
ORDER BY media DESC;
```

#### 4. Ranking Paginado (`LIMIT`)
```sql
SELECT id_aluno, nome, data_nascimento, cidade
FROM alunos
ORDER BY data_nascimento DESC
LIMIT 10;
```

---

### Desafio Extra: Análise de Extremos e Coluna Calculada

> **Enunciado:** Escreva uma única consulta SQL na tabela `notas` que exiba o `id_matricula`, `nota1`, `nota2`, `nota3`, `media` e uma coluna calculada chamada `pontos_para_dez` (`10.00 - media`) apenas para os registros que tiveram pelo menos uma das três notas igual a `10.00` ou cuja média ficou abaixo de `6.00`.

```sql
SELECT id_matricula,
       nota1,
       nota2,
       nota3,
       media,
       ROUND(10.00 - media, 2) AS pontos_para_dez
FROM notas
WHERE nota1 = 10.00
   OR nota2 = 10.00
   OR nota3 = 10.00
   OR media < 6.00
ORDER BY media DESC;
```

#### Comentário Pedagógico:
1. **Expressão Dinâmica:** `ROUND(10.00 - media, 2) AS pontos_para_dez` gera o cálculo em tempo de execução sem redundância física.
2. **Lógica Booleana:** O operador `OR` atende aos dois extremos escolares (alunos que tiraram nota máxima em qualquer avaliação individual e alunos que necessitam de recuperação de média).

---

## Pontos Comuns de Dificuldade
* **Esquecer o alias (`AS`):** O cálculo `10.00 - media` sem `AS` gera uma coluna no cabeçalho do DBeaver com o texto literal da fórmula.
* **Precedência de operadores:** Ao combinar `AND` com `OR`, lembre os alunos de que o `AND` tem precedência maior, recomendando o uso de parênteses explicadores.
