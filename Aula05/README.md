# Aula 05: Linguagem SQL — Comandos DML (`INSERT`, `SELECT`, `UPDATE`, `DELETE`), Filtragem (`WHERE`) e Ordenação (`ORDER BY`)

**Data Oficial:** `06/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Inserir registros únicos e em lote nas tabelas utilizando `INSERT INTO`.
2. Atualizar e remover registros com segurança usando `UPDATE` e `DELETE` sempre acompanhados de cláusula `WHERE`.
3. Consultar dados específicos com `SELECT`, renomeando colunas (`AS`) e eliminando duplicidades (`DISTINCT`).
4. Filtrar dados com `WHERE` (operadores relacionais, lógicos `AND`/`OR`/`NOT`, `BETWEEN`, `IN`, `LIKE` e `IS NULL`) e ordenar resultados com `ORDER BY` e `LIMIT`.

---

## 1. Manipulação de Dados (DML) e o Ciclo CRUD

No desenvolvimento de aplicações web e APIs (como vimos em Node.js e Express), todas as operações de negócio se apoiam nas 4 operações conhecidas como **CRUD**, que têm correspondência direta com os comandos **DML**:

| Operação CRUD | Verbo HTTP na API | Comando SQL (DML/DQL) | Descrição |
| :--- | :---: | :---: | :--- |
| **C**reate (Criar) | `POST` | `INSERT INTO` | Insere novas linhas na tabela. |
| **R**ead (Ler) | `GET` | `SELECT` | Consulta e filtra linhas existentes. |
| **U**pdate (Atualizar) | `PUT` / `PATCH` | `UPDATE` | Modifica valores de linhas existentes. |
| **D**elete (Excluir) | `DELETE` | `DELETE FROM` | Remove linhas da tabela. |

---

## 2. Inserindo Dados (`INSERT INTO`)

### 2.1. Inserção Simples
Sempre declare explicitamente a lista de colunas antes do `VALUES`. Como as chaves primárias do nosso banco `escola_db` possuem `AUTO_INCREMENT`, não precisamos passá-las no `INSERT`:

```sql
USE escola_db;

INSERT INTO cursos (nome, area, carga_horaria)
VALUES ('Desenvolvimento Mobile com Flutter', 'Desenvolvimento Mobile', 40);
```

### 2.2. Inserção em Lote (Múltiplos Registros)
Inserir várias linhas em um único comando `INSERT` é muito mais rápido do que enviar vários comandos separados pela rede:

```sql
INSERT INTO alunos (nome, cpf, email, telefone, data_nascimento, cidade, data_cadastro)
VALUES
    ('Gabriel Monteiro', '80123456789', 'gabriel.m@email.com', '95991102030', '2002-03-18', 'Boa Vista', '2026-02-01'),
    ('Helena Vasconcelos', '80234567890', 'helena.v@email.com', '95991203040', '2000-11-05', 'Rorainópolis', '2026-02-01'),
    ('Igor Cavalcante', '80345678901', 'igor.c@email.com', '95991304050', '1998-07-29', 'Mucajaí', '2026-02-02');
```

---

## 3. Atualizando (`UPDATE`) e Removendo (`DELETE`) com Segurança

> **A Regra de Ouro de Produção:** Jamais execute um comando `UPDATE` ou `DELETE` sem cláusula `WHERE`!
> * Um `UPDATE alunos SET cidade = 'Boa Vista';` (sem `WHERE`) mudará a cidade de **todos os alunos da escola**.
> * Um `DELETE FROM matriculas;` (sem `WHERE`) apagará **todas as matrículas do banco**.

### Protocolo Seguro em 2 Passos (SELECT antes do UPDATE/DELETE)

```sql
-- PASSO 1: Sempre rode um SELECT primeiro usando o mesmo WHERE para conferir quem será afetado!
SELECT id_aluno, nome, cidade, telefone
FROM alunos
WHERE id_aluno = 10;

-- PASSO 2: Após confirmar que é apenas o registro desejado, execute o UPDATE:
UPDATE alunos
SET telefone = '95999887766',
    cidade = 'Boa Vista'
WHERE id_aluno = 10;
```

### Excluindo um Registro Específico (`DELETE FROM`)
```sql
-- PASSO 1: Conferir o registro
SELECT * FROM notas WHERE id_nota = 50;

-- PASSO 2: Remover pela Chave Primária
DELETE FROM notas
WHERE id_nota = 50;
```
> **Observação sobre Integridade Referencial:** Se você tentar executar `DELETE FROM alunos WHERE id_aluno = 1;`, o MySQL bloqueará a exclusão porque o aluno `1` possui matrículas vinculadas na tabela `matriculas`. Em sistemas reais, em vez de apagar fisicamente o aluno, costumamos fazer **exclusão lógica (*soft delete*)** alterando uma coluna `status = 'Inativo'`.

---

## 4. Consultando e Filtrando Dados (`SELECT ... WHERE`)

### 4.1. Projeção de Colunas, Apelidos (`AS`) e Valores Únicos (`DISTINCT`)
Evite usar `SELECT *` em sistemas de produção quando precisar de apenas duas ou três colunas. Listar apenas as colunas necessárias economiza memória e tráfego de rede:

```sql
-- Selecionando colunas específicas com apelidos legíveis (Aliases)
SELECT nome AS nome_completo,
       email AS correio_eletronico,
       cidade AS municipio
FROM alunos;

-- Listando apenas as cidades distintas onde a escola possui alunos (sem repetição)
SELECT DISTINCT cidade
FROM alunos;
```

### 4.2. Operadores de Filtro na Cláusula `WHERE`

| Operador | Significado | Exemplo Prático em `escola_db` |
| :---: | :--- | :--- |
| `=` | Igual a | `WHERE cidade = 'Boa Vista'` |
| `<>` ou `!=` | Diferente de | `WHERE status <> 'Cancelado'` |
| `>`, `>=`, `<`, `<=` | Comparações numéricas ou de data | `WHERE media >= 7.00` |
| `AND` | E lógico (ambas verdadeiras) | `WHERE turno = 'Noturno' AND periodo = '2026.1'` |
| `OR` | OU lógico (pelo menos uma verdadeira) | `WHERE cidade = 'Pacaraima' OR cidade = 'Bonfim'` |
| `BETWEEN x AND y` | Intervalo inclusivo (inclui `x` e `y`) | `WHERE carga_horaria BETWEEN 30 AND 60` |
| `IN (...)` | Pertence a uma lista de valores | `WHERE cidade IN ('Boa Vista', 'Caracaraí', 'Cantá')` |
| `LIKE` | Busca por padrão textual (`%` e `_`) | `WHERE nome LIKE 'Ana%'` |
| `IS NULL` / `IS NOT NULL` | Verifica se o campo está vazio (`NULL`) | `WHERE telefone IS NULL` |

#### Entendendo os Curingas do `LIKE`:
* `%` (porcentagem): representa **qualquer sequência de zero ou mais caracteres**.
  * `'Ana%'` -> Começa com `"Ana"` (*Ana Paula, Ana Beatriz*).
  * `'%Silva'` -> Termina com `"Silva"` (*Carlos Silva, Maria da Silva*).
  * `'%Dados%'` -> Contém a palavra `"Dados"` em qualquer posição (*Banco de Dados e SQL, Ciência de Dados*).
* `_` (sublinhado): representa **exatamente um único caractere**.

---

## 5. Ordenação (`ORDER BY`) e Paginação (`LIMIT`)

Por padrão, o banco retorna as linhas na ordem em que estão gravadas ou indexadas. Para classificar o resultado, usamos `ORDER BY` ao final da consulta:

* **`ASC` (Ascendente — padrão):** Ordem alfabética (`A -> Z`), crescente (`0 -> 10`) ou cronológica (`mais antigo -> mais recente`).
* **`DESC` (Descendente):** Ordem inversa (`Z -> A`), decrescente (`10 -> 0`, ideal para rankings de maiores notas!) ou `mais recente -> mais antigo`.

```sql
-- Top 5 maiores médias na tabela de notas
SELECT id_matricula, nota1, nota2, nota3, media
FROM notas
ORDER BY media DESC
LIMIT 5;

-- Ordenação por múltiplos critérios: primeiro por cidade (A-Z) e, dentro de cada cidade, por nome (A-Z)
SELECT nome, cidade, data_nascimento
FROM alunos
ORDER BY cidade ASC, nome ASC;
```

---

## 6. Para Saber Mais

* **Script de Prática da Aula:** Abra [`Aula05/pratica_dml.sql`](./pratica_dml.sql) no DBeaver.
* **Leitura na Apostila:** Revise a [Unidade 5 da Apostila Completa](../apostila.md#unidade-5-linguagem-sql--manipulação-e-filtragem-dml-where-order-by).
* **Próximo Passo Prático:** Vá para o [Laboratório da Aula 05](./laboratorio.md) para praticar inserções, atualizações seguras e resolver a Parte 1 da lista oficial de consultas.

