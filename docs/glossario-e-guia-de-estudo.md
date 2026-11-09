# Glossário de Termos-Chave e Guia de Estudo Rápido

Este documento reúne os conceitos técnicos cobrindo as 8 aulas do **Módulo 09: Bancos de Dados e SQL** para consulta rápida durante os laboratórios e o desenvolvimento do Projeto Integrador.

---

## 1. Glossário Técnico de A a Z

| Termo | Definição Objetiva | Aula de Referência |
| :--- | :--- | :---: |
| **ACID** | Acrônimo para Atomicidade, Consistência, Isolamento e Durabilidade; propriedades que garantem transações seguras em um SGBD relacional. | Aula 08 |
| **Atributo** | Propriedade ou característica que descreve uma entidade. No modelo físico, corresponde a uma **coluna** da tabela. | Aula 02 |
| **Cardinalidade** | Quantidade mínima e máxima de ocorrências de uma entidade que se associam a outra em um relacionamento (`1:1`, `1:N`, `N:N`). | Aula 02 |
| **Chave Composta** | Chave primária formada pela combinação de duas ou mais colunas. | Aula 03 |
| **Chave Estrangeira (`FK`)** | Coluna de uma tabela que referencia a chave primária (`PK`) de outra tabela, materializando relacionamentos e garantindo integridade referencial. | Aula 03 / Aula 04 |
| **Chave Primária (`PK`)** | Identificador único e obrigatório (`NOT NULL` e `UNIQUE`) de cada registro em uma tabela. | Aula 03 / Aula 04 |
| **Constraint (Restrição)** | Regra aplicada às colunas de uma tabela (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`) para proteger a validade dos dados. | Aula 04 |
| **DDL** | *Data Definition Language*: subconjunto do SQL voltado à criação e alteração da estrutura física (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`). | Aula 04 |
| **DER** | *Diagrama Entidade-Relacionamento*: representação gráfica das entidades, atributos e relacionamentos de um banco de dados. | Aula 03 |
| **DML** | *Data Manipulation Language*: subconjunto do SQL voltado à manipulação dos registros (`INSERT`, `UPDATE`, `DELETE`, `SELECT`). | Aula 05 |
| **Entidade** | Objeto concreto ou abstrato do mundo real sobre o qual armazenamos dados. No modelo físico, torna-se uma **tabela**. | Aula 02 |
| **Full Table Scan** | Leitura sequencial de todas as linhas de uma tabela quando o SGBD não possui um índice adequado para atender ao filtro da consulta. | Aula 08 |
| **GROUP BY** | Cláusula SQL que agrupa linhas com valores iguais em colunas especificadas para aplicação de funções agregadas (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`). | Aula 06 |
| **HAVING** | Cláusula SQL que filtra grupos gerados pelo `GROUP BY` com base no resultado de funções agregadas. | Aula 06 |
| **Índice (`INDEX`)** | Estrutura de acesso rápido (geralmente árvore B-Tree) criada sobre uma ou mais colunas para acelerar filtros `WHERE`, `JOIN` e `ORDER BY`. | Aula 08 |
| **Integridade Referencial** | Garantia assegurada pelo SGBD de que toda chave estrangeira aponta para uma chave primária existente na tabela pai. | Aula 03 |
| **JOIN** | Operação relacional que combina colunas de duas ou mais tabelas com base em uma condição de correspondência entre chaves (`INNER`, `LEFT`, `RIGHT`, `FULL`). | Aula 07 |
| **Normalização** | Processo de organização de tabelas (1FN, 2FN, 3FN) para eliminar redundâncias e anomalias de atualização. | Aula 03 |
| **SGBD** | *Sistema Gerenciador de Banco de Dados*: software responsável por gerenciar o armazenamento, segurança, concorrência e consultas ao banco (ex.: MySQL, PostgreSQL). | Aula 01 / Aula 02 |
| **Subconsulta (Subquery)** | Instrução `SELECT` aninhada dentro de outra instrução SQL principal. | Aula 07 |
| **Tabela Associativa** | Tabela intermediária criada para decompor um relacionamento `N:N` em dois relacionamentos `1:N` (ex.: `matriculas` entre `alunos` e `turmas`). | Aula 02 / Aula 03 |
| **Transação** | Conjunto de operações SQL executado de forma atômica: ou todas as alterações são confirmadas (`COMMIT`), ou todas são desfeitas (`ROLLBACK`). | Aula 08 |
| **Trigger (Gatilho)** | Rotina disparada automaticamente pelo SGBD antes ou depois de um `INSERT`, `UPDATE` ou `DELETE` em uma tabela. | Aula 08 |
| **Tupla** | Linha ou registro individual de uma tabela no modelo relacional. | Aula 02 |
| **View (Visão)** | Tabela virtual definida por uma consulta `SELECT` armazenada no banco para simplificar relatórios e reforçar a segurança de acesso. | Aula 08 |

---

## 2. Mapa de Comandos SQL do Módulo

```sql
-- DDL (Aula 04)
CREATE DATABASE nome_banco;
CREATE TABLE nome_tabela (...);
ALTER TABLE nome_tabela ADD COLUMN ...;
DROP TABLE IF EXISTS nome_tabela;

-- DML e Filtros (Aula 05)
INSERT INTO nome_tabela (col1, col2) VALUES (val1, val2);
UPDATE nome_tabela SET col1 = novo_valor WHERE id = 1;
DELETE FROM nome_tabela WHERE id = 1;
SELECT col1, col2 FROM nome_tabela WHERE condicao ORDER BY col1 ASC;

-- Agregação e Grupos (Aula 06)
SELECT col_grupo, COUNT(*), AVG(valor)
FROM nome_tabela
WHERE filtro_linha
GROUP BY col_grupo
HAVING COUNT(*) > 5;

-- Junções e Subconsultas (Aula 07)
SELECT a.nome, t.nome_turma
FROM matriculas m
INNER JOIN alunos a ON m.id_aluno = a.id_aluno
INNER JOIN turmas t ON m.id_turma = t.id_turma;

-- Recursos Avançados (Aula 08)
CREATE VIEW vw_resumo AS SELECT ...;
CREATE INDEX idx_nome ON alunos(nome);
START TRANSACTION; ... COMMIT; -- ou ROLLBACK;
```

