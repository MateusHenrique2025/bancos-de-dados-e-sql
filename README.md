# Curso: Introdução a Bancos de Dados e SQL — Turma ITEAM (Boa Vista 2026)

Bem-vindo ao repositório oficial do **Módulo 09: Bancos de Dados e SQL** da Capacitação em Desenvolvimento Full Stack do **ITEAM (Boa Vista/RR)**, ministrado pelo **Prof. Janei Vieira Pereira**.

Aqui você encontrará a apostila completa do módulo, o material teórico e os laboratórios práticos divididos aula a aula (`Aula01` a `Aula08`), as listas de exercícios sobre a base oficial `escola_db` e a estrutura de entrega do **Projeto Integrador**.

---

## Sumário

1. [Visão Geral do Curso](#1-visão-geral-do-curso)
2. [Ferramentas e Pré-requisitos](#2-ferramentas-e-pré-requisitos)
3. [Roteiro de Aulas e Cronograma (01 a 08)](#3-roteiro-de-aulas-e-cronograma-01-a-08)
4. [Material de Apoio, Apostila e Base de Dados](#4-material-de-apoio-apostila-e-base-de-dados)
5. [Projeto Integrador — Instruções e Entregas por Turno](#5-projeto-integrador--instruções-e-entregas-por-turno)
6. [Licença de Uso](#6-licença-de-uso)

---

## 1. Visão Geral do Curso

* **Instituição:** ITEAM — Boa Vista / Roraima
* **Curso:** Capacitação em Desenvolvimento Full Stack
* **Disciplina:** Módulo 09 — Bancos de Dados e SQL
* **Carga Horária Total:** 32 horas (8 encontros de 4 horas)
* **Professor:** Janei Vieira Pereira

O módulo capacita o estudante a compreender a arquitetura de Sistemas Gerenciadores de Banco de Dados (SGBDs), projetar modelos de dados relacionais íntegros e normalizados (1FN, 2FN e 3FN), elaborar Diagramas Entidade-Relacionamento (DER) e dominar a linguagem SQL desde a criação de estruturas (DDL) e manipulação CRUD (DML) até consultas analíticas avançadas (`GROUP BY`, `HAVING`, `JOINs`, subconsultas, `Views`, `Índices`, `Transações` e `Triggers`).

---

## 2. Ferramentas e Pré-requisitos

Para acompanhar os laboratórios práticos deste repositório, utilize:
* **SGBD Relacional:** MySQL 8.0+ ou MariaDB 10.6+ (local, Docker ou XAMPP/Laragon).
* **Cliente SQL e Modelagem Física:** [DBeaver Community Edition](https://dbeaver.io/).
* **Ferramentas de Modelagem DER:** [Draw.io / diagrams.net](https://app.diagrams.net/) ou [dbdiagram.io](https://dbdiagram.io/).
* **Controle de Versão:** Git e conta no GitHub para submissão das atividades e do Projeto Integrador via Pull Request.

---

## 3. Roteiro de Aulas e Cronograma (01 a 08)

O conteúdo do curso segue o Plano de Ensino oficial (`2026-2`). As pastas das aulas são liberadas progressivamente conforme o avanço da turma:

| Aula | Data | Tópicos Abordados | Material Teórico | Laboratório Prático | Status |
| :---: | :---: | :--- | :---: | :---: | :---: |
| **Aula 01** | `30/10/2026` | **Introdução a Bancos de Dados:** Dados, informação e conhecimento; Banco de Dados vs. SGBD; evolução histórica (arquivos planos, hierárquico, rede e relacional); comparativo SQL vs. NoSQL. | [Teoria Aula 01](./Aula01/README.md) | [Lab 01](./Aula01/laboratorio.md) | **[Disponível]** |
| **Aula 02** | `03/11/2026` | **Arquitetura de SGBD e Modelagem Conceitual:** Componentes internos do SGBD; comparativo MySQL, PostgreSQL, Oracle, SQL Server e SQLite; Entidades, Atributos e Relacionamentos (`1:1`, `1:N`, `N:N`). | [Teoria Aula 02](./Aula02/README.md) | [Lab 02](./Aula02/laboratorio.md) | **[Disponível]** |
| **Aula 03** | `04/11/2026` | **Chaves, Normalização e DER:** Chaves Primárias (`PK`) e Estrangeiras (`FK`); Integridade Referencial; Normalização passo a passo (`1FN`, `2FN`, `3FN`); Diagrama Entidade-Relacionamento (Chen, Pé de Galinha e UML). | [Teoria Aula 03](./Aula03/README.md) | [Lab 03](./Aula03/laboratorio.md) | **[Disponível]** |
| **Aula 04** | `05/11/2026` | **Linguagem SQL — Comandos DDL:** Subconjuntos do SQL; tipos de dados no MySQL; criação e alteração de estruturas (`CREATE DATABASE`, `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`) e Constraints. | [Teoria Aula 04](./Aula04/README.md) | [Lab 04](./Aula04/laboratorio.md) + [DDL SQL](./Aula04/schema_ddl.sql) | **[Disponível]** |
| **Aula 05** | `06/11/2026` | **Linguagem SQL — Comandos DML e Filtros:** Operações CRUD (`INSERT`, `SELECT`, `UPDATE`, `DELETE`); filtragem com `WHERE` (`AND`, `OR`, `IN`, `BETWEEN`, `LIKE`) e ordenação com `ORDER BY` e `LIMIT`. | `Aula05/README.md` | `Aula05/laboratorio.md` | *[Em breve]* |
| **Aula 06** | `09/11/2026` | **Agrupamentos e Funções Agregadas:** Estatísticas com `COUNT`, `SUM`, `AVG`, `MAX` e `MIN`; agrupamento dimensional com `GROUP BY`; filtragem de grupos com `HAVING` (`WHERE` vs. `HAVING`). | `Aula06/README.md` | `Aula06/laboratorio.md` | *[Em breve]* |
| **Aula 07** | `10/11/2026` | **Consultas Relacionais (`JOINs`) e Subconsultas:** Junções multi-tabelas (`INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`); subconsultas escalares, com `IN` e tabelas derivadas. | `Aula07/README.md` | `Aula07/laboratorio.md` | *[Em breve]* |
| **Aula 08** | `11/11/2026` | **Recursos Avançados de SQL e Revisão:** `Views` (Visões), `Índices` (`INDEX` e `EXPLAIN`), `Transações` ACID (`COMMIT`/`ROLLBACK`), `Stored Procedures`, `Funções`, `Triggers` e revisão geral. | `Aula08/README.md` | `Aula08/laboratorio.md` | *[Em breve]* |

---

## 4. Material de Apoio, Apostila e Base de Dados

* **[Apostila Completa do Módulo (`apostila.md`)](./apostila.md):** Texto integral de referência cobrindo todas as 8 unidades com exemplos comentados e diagramas.
* **[Glossário e Guia Rápido de Comandos (`docs/glossario-e-guia-de-estudo.md`)](./docs/glossario-e-guia-de-estudo.md):** Dicionário de termos técnicos de A a Z e mapa sintático de SQL.
* **[Base de Dados Oficial (`base/escola_db.sql`)](./base/escola_db.sql):** Script completo contendo a criação e carga inicial das 6 tabelas do sistema acadêmico (`alunos`, `professores`, `cursos`, `turmas`, `matriculas` e `notas`).
* **Listas de Atividades (`atividades/`):**
  * [Atividade Diagnóstica e de Nivelamento](./atividades/atividade_nivelamento.md)
  * [Lista de Exercícios: Consultas SQL Avançadas (30 Questões)](./atividades/consultas_sql_avancadas.sql.md) *(Nota: os gabaritos são liberados pelo professor somente após o encerramento das aulas práticas).*

---

## 5. Projeto Integrador — Instruções e Entregas por Turno

Além das aulas regulares, este repositório centraliza a entrega do **Projeto Integrador: Sistema Web de Gestão Acadêmica com Relatórios em Banco de Dados**.

### Documentos Obrigatórios do Projeto Integrador
* **[Especificação Completa do Product Owner (`docs/projeto-integrador.md`)](./docs/projeto-integrador.md)**
* **[Guia de Estrutura de Pastas (`docs/estrutura-do-repositorio.md`)](./docs/estrutura-do-repositorio.md)**

### Organização das Entregas por Turno
Os grupos estão separados por turno:
* **`entregas/noturno/`**: Grupos da turma do noturno (`grupo-01` a `grupo-05`).
* **`entregas/vespertino/`**: Grupos da turma do vespertino (`grupo-01` a `grupo-05`).

Cada grupo deve trabalhar **exclusivamente dentro da pasta correspondente ao seu turno e número de grupo**, organizando os entregáveis em:
* `app/`: Código da aplicação (front-end, back-end e `README.md` de execução).
* `sql/`: Script SQL utilizado, consultas analíticas, views e melhorias.
* `der/`: Diagrama Entidade-Relacionamento (DER) do banco em PNG, JPG ou PDF.
* `docs/`: Documento com integrantes, papéis da equipe e resumo do projeto.
* `infra/`: Evidências do deploy, link da aplicação publicada ou instruções de acesso.

### Fluxo Resumido de Entrega via GitHub (Pull Request)
1. Faça um **Fork** deste repositório para a conta responsável pelo grupo.
2. Clone o seu fork localmente:
   ```bash
   git clone https://github.com/SEU-USUARIO/bancos-de-dados-e-sql.git
   cd bancos-de-dados-e-sql
   ```
3. Crie uma branch identificada com o turno e o grupo:
   ```bash
   git checkout -b entrega-noturno-grupo-01
   ```
4. Adicione os arquivos apenas dentro da pasta do seu grupo (ex.: `entregas/noturno/grupo-01/`), faça commit, envie (`git push`) e abra um **Pull Request** para este repositório principal.

---

## 6. Licença de Uso

Este material didático está licenciado sob a **Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional (CC BY-NC-SA 4.0)**. Você pode compartilhar e adaptar o material para fins de estudo e ensino não comerciais, desde que atribua o crédito ao autor original (**Prof. Janei Vieira Pereira / ITEAM**).
