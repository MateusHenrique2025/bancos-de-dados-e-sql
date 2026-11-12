# Curso: Introdução a Bancos de Dados e SQL — Turma ITEAM (Boa Vista 2026)

Bem-vindo ao repositório oficial do **Módulo 09: Bancos de Dados e SQL** da Capacitação em Desenvolvimento Full Stack do **ITEAM (Boa Vista/RR)**, ministrado pelo **Prof. Janei Vieira Pereira**.

Aqui você encontra a apostila completa do módulo, o material teórico e os laboratórios práticos de todas as aulas (`Aula01` a `Aula08`), as listas de exercícios sobre a base oficial `escola_db`, os gabaritos liberados e as instruções de entrega do **Projeto Integrador**.

---

## Sumário

1. [Visão Geral do Curso](#1-visão-geral-do-curso)
2. [Ferramentas e Pré-requisitos](#2-ferramentas-e-pré-requisitos)
3. [Roteiro de Aulas e Cronograma (01 a 08)](#3-roteiro-de-aulas-e-cronograma-01-a-08)
4. [Material de Apoio, Apostila, Base de Dados e Gabaritos](#4-material-de-apoio-apostila-base-de-dados-e-gabaritos)
5. [Projeto Integrador: Entrega Individual via Pull Request](#5-projeto-integrador-entrega-individual-via-pull-request)
6. [Licença de Uso](#6-licença-de-uso)

---

## 1. Visão Geral do Curso

* **Instituição:** ITEAM (Boa Vista / Roraima)
* **Curso:** Capacitação em Desenvolvimento Full Stack
* **Disciplina:** Módulo 09: Bancos de Dados e SQL
* **Carga Horária Total:** 32 horas (8 encontros de 4 horas)
* **Professor:** Janei Vieira Pereira

O módulo aborda arquitetura de SGBDs, modelagem relacional e normalização (1FN, 2FN e 3FN), Diagramas Entidade-Relacionamento (DER), comandos DDL e DML, filtros, agrupamentos (`GROUP BY`, `HAVING`), junções (`JOINs`), subconsultas, `Views`, `Índices`, `Transações`, `Stored Procedures`, `Funções` e `Triggers`.

---

## 2. Ferramentas e Pré-requisitos

Para acompanhar os laboratórios práticos deste repositório, utilize:
* **SGBD Relacional:** MySQL 8.0+ ou MariaDB 10.6+ (local, Docker ou XAMPP/Laragon).
* **Cliente SQL e Modelagem Física:** [DBeaver Community Edition](https://dbeaver.io/).
* **Ferramentas de Modelagem DER:** [Draw.io / diagrams.net](https://app.diagrams.net/) ou [dbdiagram.io](https://dbdiagram.io/).
* **Controle de Versão:** Git e conta no GitHub para envio do Projeto Integrador via Fork e Pull Request.

---

## 3. Roteiro de Aulas e Cronograma (01 a 08)

O conteúdo do curso segue o Plano de Ensino oficial (`2026-2`). Todas as 8 aulas já estão disponíveis:

| Aula | Data | Tópicos Abordados | Material Teórico | Laboratório Prático | Status |
| :---: | :---: | :--- | :---: | :---: | :---: |
| **Aula 01** | `30/10/2026` | **Introdução a Bancos de Dados:** Dados, informação e conhecimento; Banco de Dados vs. SGBD; evolução histórica; comparativo SQL vs. NoSQL. | [Teoria Aula 01](./Aula01/README.md) | [Lab 01](./Aula01/laboratorio.md) | **[Disponível]** |
| **Aula 02** | `03/11/2026` | **Arquitetura de SGBD e Modelagem Conceitual:** Componentes internos do SGBD; comparativo de SGBDs; Entidades, Atributos e Relacionamentos (`1:1`, `1:N`, `N:N`). | [Teoria Aula 02](./Aula02/README.md) | [Lab 02](./Aula02/laboratorio.md) | **[Disponível]** |
| **Aula 03** | `04/11/2026` | **Chaves, Normalização e DER:** Chaves Primárias (`PK`) e Estrangeiras (`FK`); Integridade Referencial; Normalização (`1FN`, `2FN`, `3FN`); DER. | [Teoria Aula 03](./Aula03/README.md) | [Lab 03](./Aula03/laboratorio.md) | **[Disponível]** |
| **Aula 04** | `05/11/2026` | **Linguagem SQL (Comandos DDL):** Subconjuntos do SQL; tipos de dados no MySQL; `CREATE DATABASE`, `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE` e Constraints. | [Teoria Aula 04](./Aula04/README.md) | [Lab 04](./Aula04/laboratorio.md) + [DDL SQL](./Aula04/schema_ddl.sql) | **[Disponível]** |
| **Aula 05** | `06/11/2026` | **Linguagem SQL (DML e Filtros):** Operações CRUD (`INSERT`, `SELECT`, `UPDATE`, `DELETE`); filtragem com `WHERE` (`AND`, `OR`, `IN`, `BETWEEN`, `LIKE`), `ORDER BY` e `LIMIT`. | [Teoria Aula 05](./Aula05/README.md) | [Lab 05](./Aula05/laboratorio.md) + [DML SQL](./Aula05/pratica_dml.sql) | **[Disponível]** |
| **Aula 06** | `09/11/2026` | **Agrupamentos e Funções Agregadas:** Estatísticas com `COUNT`, `SUM`, `AVG`, `MAX` e `MIN`; agrupamento com `GROUP BY`; filtragem com `HAVING` (`WHERE` vs. `HAVING`). | [Teoria Aula 06](./Aula06/README.md) | [Lab 06](./Aula06/laboratorio.md) + [SQL](./Aula06/relatorios_agregados.sql) | **[Disponível]** |
| **Aula 07** | `10/11/2026` | **Consultas Relacionais (`JOINs`) e Subconsultas:** Junções multi-tabelas (`INNER`, `LEFT`, `RIGHT`, `FULL OUTER`); subconsultas escalares, com `IN` e tabelas derivadas. | [Teoria Aula 07](./Aula07/README.md) | [Lab 07](./Aula07/laboratorio.md) + [SQL](./Aula07/joins_subconsultas.sql) | **[Disponível]** |
| **Aula 08** | `11/11/2026` | **Recursos Avançados de SQL e Revisão:** `Views`, `Índices` (`INDEX` e `EXPLAIN`), `Transações` ACID (`COMMIT`/`ROLLBACK`), `Stored Procedures`, `Funções`, `Triggers` e revisão geral. | [Teoria Aula 08](./Aula08/README.md) | [Lab 08](./Aula08/laboratorio.md) + [SQL](./Aula08/recursos_avancados.sql) | **[Disponível]** |

---

## 4. Material de Apoio, Apostila, Base de Dados e Gabaritos

* **[Apostila Completa do Módulo (`apostila.md`)](./apostila.md):** Texto integral cobrindo todas as 8 unidades com exemplos comentados e diagramas.
* **[Glossário e Guia Rápido de Comandos (`docs/glossario-e-guia-de-estudo.md`)](./docs/glossario-e-guia-de-estudo.md):** Dicionário de termos técnicos e mapa sintático de SQL.
* **[Base de Dados Oficial (`base/escola_db.sql`)](./base/escola_db.sql):** Script com criação e carga inicial das 6 tabelas do sistema acadêmico (`alunos`, `professores`, `cursos`, `turmas`, `matriculas` e `notas`).
* **Listas de Atividades (`atividades/`):**
  * [Atividade Diagnóstica e de Nivelamento](./atividades/atividade_nivelamento.md)
  * [Lista de Exercícios: Consultas SQL Avançadas (30 Questões)](./atividades/consultas_sql_avancadas.sql.md)
* **Gabaritos Liberados (`gabaritos/`):**
  * [Gabarito do Nivelamento](./gabaritos/gabarito_nivelamento.md)
  * [Gabarito das 30 Consultas SQL Avançadas](./gabaritos/gabarito_consultas_sql_avancadas.md)
  * Gabaritos por aula: [Aula 01](./gabaritos/Aula01/README.md), [Aula 02](./gabaritos/Aula02/README.md), [Aula 03](./gabaritos/Aula03/README.md), [Aula 04](./gabaritos/Aula04/README.md), [Aula 05](./gabaritos/Aula05/README.md), [Aula 06](./gabaritos/Aula06/README.md), [Aula 07](./gabaritos/Aula07/README.md) e [Aula 08](./gabaritos/Aula08/README.md).

---

## 5. Projeto Integrador: Entrega Individual via Pull Request

O **Projeto Integrador** agora é **individual**, **sem apresentação oral**, com entrega pelo GitHub (Fork + Pull Request) até **domingo, 15/11/2026 às 23:59**.

### Documentos do Projeto Integrador
* **[Especificação Simplificada (`docs/projeto-integrador.md`)](./docs/projeto-integrador.md)**
* **[Guia de Estrutura de Pastas (`docs/estrutura-do-repositorio.md`)](./docs/estrutura-do-repositorio.md)**
* **[Modelo de Pasta Individual (`entregas/_modelo-individual/`)](./entregas/_modelo-individual/)**

### Onde colocar seus arquivos
Crie uma pasta com seu nome (minúsculas, sem acentos ou espaços) dentro do seu turno:
* **`entregas/noturno/nome-sobrenome/`**
* **`entregas/vespertino/nome-sobrenome/`**

Estrutura esperada dentro da sua pasta:
* `README.md`: seu nome completo, turno e instruções para rodar o projeto.
* `app/`: código-fonte da aplicação web.
* `sql/`: consultas SQL (ou views) usadas pela aplicação.
* `der/`: imagem ou PDF do DER (PNG, JPG ou PDF).

### Fluxo resumido de entrega (Fork + Pull Request)
1. Faça um **Fork** deste repositório no GitHub.
2. Clone o seu fork:
   ```bash
   git clone https://github.com/SEU-USUARIO/bancos-de-dados-e-sql.git
   cd bancos-de-dados-e-sql
   ```
3. Crie sua branch:
   ```bash
   git checkout -b entrega-noturno-nome-sobrenome
   ```
4. Coloque os arquivos apenas dentro de `entregas/<turno>/<nome-sobrenome>/` (sem `node_modules/`, `.venv/` ou `.env` com senhas), faça commit, `git push` e abra o **Pull Request** para este repositório até **15/11/2026 às 23:59**.

---

## 6. Licença de Uso

Este material didático está licenciado sob a **Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional (CC BY-NC-SA 4.0)**. Você pode compartilhar e adaptar o material para fins de estudo e ensino não comerciais, desde que atribua o crédito ao autor original (**Prof. Janei Vieira Pereira / ITEAM**).
