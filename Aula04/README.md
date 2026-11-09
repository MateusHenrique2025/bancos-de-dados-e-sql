# Aula 04: Linguagem SQL — Comandos DDL (`CREATE`, `ALTER`, `DROP`), Tipos de Dados e Constraints

**Data Oficial:** `05/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Compreender as divisões da linguagem SQL (**DDL**, **DML**, **DQL**, **DCL** e **TCL**).
2. Escolher os **tipos de dados** adequados no MySQL (`INT`, `DECIMAL`, `CHAR`, `VARCHAR`, `TEXT`, `DATE`, `DATETIME`).
3. Construir bancos de dados e tabelas físicas com `CREATE DATABASE` e `CREATE TABLE` aplicando restrições de integridade (**Constraints**).
4. Evoluir e manter estruturas existentes com `ALTER TABLE`, `DROP TABLE` e `TRUNCATE TABLE`, respeitando a ordem de dependência entre tabelas pai e tabelas filhas.

---

## 1. Introdução à Linguagem SQL e seus Subconjuntos

A **SQL (Structured Query Language)** nasceu nos laboratórios da IBM nos anos 1970 (originalmente chamada *SEQUEL*) e tornou-se o padrão mundial ANSI/ISO para bancos de dados relacionais.

Para organizar o aprendizado, os comandos SQL são agrupados conforme sua finalidade:

```text
+-----------------------------------------------------------------------------------+
|                           LINGUAGEM SQL (Padrão ANSI)                             |
+-----------------+-----------------+-----------------+--------------+--------------+
|       DDL       |       DML       |       DQL       |     DCL      |     TCL      |
|   (Estrutura)   |    (Dados)      |   (Consultas)   | (Segurança)  | (Transações) |
+-----------------+-----------------+-----------------+--------------+--------------+
| CREATE          | INSERT          | SELECT          | GRANT        | START TRANS. |
| ALTER           | UPDATE          | (FROM, WHERE,   | REVOKE       | COMMIT       |
| DROP            | DELETE          |  GROUP BY,      |              | ROLLBACK     |
| TRUNCATE        |                 |  HAVING, JOIN)  |              | SAVEPOINT    |
+-----------------+-----------------+-----------------+--------------+--------------+
| -> Aula 04      | -> Aula 05      | -> Aulas 05-07  | -> Avançado  | -> Aula 08   |
+-----------------+-----------------+-----------------+--------------+--------------+
```

Nesta **Aula 04**, nosso foco é transformar o **DER (Modelo Lógico)** que desenhamos na Aula 03 em tabelas reais dentro do SGBD usando **DDL (Data Definition Language)**.

---

## 2. Tipos de Dados Fundamentais no MySQL

Escolher o tipo de dado correto para cada coluna economiza memória, evita erros de arredondamento e impede que dados inválidos sejam gravados:

| Categoria | Tipo no MySQL | Tamanho / Comportamento | Quando Utilizar? |
| :--- | :--- | :--- | :--- |
| **Numérico Inteiro** | `INT` | Inteiro de 32 bits (`-2 bilhões` a `+2 bilhões`) | Chaves primárias (`id_aluno`), quantidades, `carga_horaria`. |
| **Numérico Inteiro** | `TINYINT` / `SMALLINT` | Inteiros pequenos (`0 a 255` / `-32 mil a +32 mil`) | Status numéricos, flags (`0` ou `1`), número de parcelas. |
| **Numérico Exato** | `DECIMAL(p, s)` | `p` = total de dígitos; `s` = casas decimais | **Notas escolares** (`DECIMAL(5,2)` -> ex.: `10.00`, `8.75`) e **valores em Reais** (`DECIMAL(10,2)`). Nunca use `FLOAT` para dinheiro ou notas! |
| **Texto Fixo** | `CHAR(n)` | Reserva sempre exatamente `n` caracteres | Sigla de estado (`CHAR(2)` -> `'RR'`), CPF sem pontuação (`CHAR(11)`). |
| **Texto Variável** | `VARCHAR(n)` | Ocupa apenas o tamanho do texto digitado (até o limite `n`) | Nomes (`VARCHAR(120)`), e-mails (`VARCHAR(120)`), cidades (`VARCHAR(80)`). |
| **Texto Longo** | `TEXT` | Textos extensos de até 64 KB | Observações médicas, ementas de cursos, descrições longas. |
| **Data** | `DATE` | Formato padrão ISO `'YYYY-MM-DD'` | `data_nascimento` (`'2001-05-14'`), `data_matricula`. |
| **Data e Hora** | `DATETIME` | Formato `'YYYY-MM-DD HH:MM:SS'` | Registro de agendamentos (`data_consulta`), logs de auditoria. |

---

## 3. Restrições de Integridade (`Constraints`)

As **Constraints** são regras declaradas nas colunas durante o `CREATE TABLE` (ou `ALTER TABLE`) para que o próprio SGBD valide os dados automaticamente:

1. **`PRIMARY KEY`:** Define a chave primária da tabela (única e obrigatória).
2. **`AUTO_INCREMENT`:** Faz o SGBD gerar automaticamente o próximo número inteiro (`1, 2, 3...`) ao inserir um novo registro.
3. **`NOT NULL`:** Obriga o preenchimento da coluna (rejeita `NULL`).
4. **`UNIQUE`:** Impede que duas linhas tenham o mesmo valor naquela coluna (ex.: `cpf UNIQUE`, `email UNIQUE`).
5. **`DEFAULT valor`:** Preenche automaticamente o valor padrão se o comando `INSERT` não informar aquela coluna (ex.: `status VARCHAR(30) DEFAULT 'Ativo'`).
6. **`CHECK (condição)`:** Verifica uma expressão booleana antes de aceitar o dado (ex.: `CHECK (nota1 >= 0 AND nota1 <= 10)`).
7. **`FOREIGN KEY (col) REFERENCES outra_tabela(pk)`:** Cria o vínculo de integridade referencial com a tabela pai.

---

## 4. Comandos DDL na Prática

### 4.1. Criando o Banco de Dados (`CREATE DATABASE`)
```sql
-- Cria o banco caso ainda não exista, definindo suporte completo a acentos e emojis (utf8mb4)
CREATE DATABASE IF NOT EXISTS escola_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Seleciona o banco para que os próximos comandos rodem dentro dele
USE escola_db;
```

### 4.2. Ordem Correta de Criação de Tabelas (`CREATE TABLE`)
> **Atenção à Ordem de Dependência:** Você **sempre** deve criar primeiro as **tabelas fortes/pais** (que não dependem de ninguém, como `alunos`, `professores` e `cursos`) e somente depois criar as **tabelas filhas** (que possuem `FOREIGN KEY`, como `turmas`, `matriculas` e `notas`).

```sql
-- 1. Tabelas Independentes (Pais)
CREATE TABLE alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(30),
    data_nascimento DATE,
    cidade VARCHAR(80) DEFAULT 'Boa Vista',
    data_cadastro DATE NOT NULL
);

CREATE TABLE professores (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) UNIQUE,
    telefone VARCHAR(30),
    area VARCHAR(80) NOT NULL
);

CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    area VARCHAR(80) NOT NULL,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0)
);

-- 2. Tabelas Dependentes (Filhas — possuem FOREIGN KEY)
CREATE TABLE turmas (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    id_professor INT NOT NULL,
    nome_turma VARCHAR(50) NOT NULL,
    periodo VARCHAR(20) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    CONSTRAINT fk_turma_curso
        FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    CONSTRAINT fk_turma_professor
        FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);
```

### 4.3. Modificando Tabelas Existentes (`ALTER TABLE`)
No mundo real, os requisitos mudam após o sistema entrar no ar. Para adicionar, alterar ou remover colunas sem perder os dados já cadastrados, usamos `ALTER TABLE`:

```sql
-- Adicionar uma nova coluna na tabela alunos
ALTER TABLE alunos
ADD COLUMN bairro VARCHAR(60) AFTER cidade;

-- Alterar o tamanho ou tipo de uma coluna existente
ALTER TABLE alunos
MODIFY COLUMN telefone VARCHAR(40) NOT NULL;

-- Renomear uma coluna
ALTER TABLE alunos
RENAME COLUMN bairro TO bairro_residencial;

-- Remover uma coluna da tabela
ALTER TABLE alunos
DROP COLUMN bairro_residencial;
```

### 4.4. Removendo ou Esvaziando Tabelas (`DROP` vs. `TRUNCATE`)
* **`TRUNCATE TABLE nome_tabela;`**: Esvazia rapidamente todas as linhas da tabela e reinicia o contador `AUTO_INCREMENT`, mas **mantém a tabela e suas colunas existindo**.
* **`DROP TABLE IF EXISTS nome_tabela;`**: Destrói completamente a tabela (dados + estrutura + índices).
  * *Nota:* Para apagar tabelas com `DROP TABLE`, a ordem é a **inversa** da criação: apagam-se primeiro as tabelas filhas (`notas`, `matriculas`, `turmas`) e por último as tabelas pais (`cursos`, `professores`, `alunos`).

---

## 5. Comandos de Inspeção de Estrutura no MySQL / DBeaver

Sempre que quiser conferir como uma tabela foi construída no servidor, execute:

```sql
-- Lista todas as tabelas do banco atual
SHOW TABLES;

-- Exibe as colunas, tipos, chaves e defaults da tabela turmas
DESCRIBE turmas;

-- Mostra o comando CREATE TABLE exato que o MySQL guardou no dicionário de dados
SHOW CREATE TABLE turmas;
```

---

## 6. Para Saber Mais

* **Script SQL da Aula:** Consulte o arquivo [`Aula04/schema_ddl.sql`](./schema_ddl.sql) com exemplos prontos para execução no DBeaver.
* **Leitura na Apostila:** Revise a [Unidade 4 da Apostila Completa](../apostila.md#unidade-4-linguagem-sql--definição-de-estruturas-ddl).
* **Próximo Passo Prático:** Siga para o [Laboratório da Aula 04](./laboratorio.md) para levantar o banco oficial `escola_db` e codificar em SQL o banco da Clínica Médica projetado na Aula 03.

