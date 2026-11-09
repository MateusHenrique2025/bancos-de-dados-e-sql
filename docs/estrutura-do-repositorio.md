# Estrutura do Repositório — Bancos de Dados e SQL (ITEAM 2026)

Este repositório organiza tanto as **8 aulas teóricas e práticas** do módulo quanto a estrutura oficial de entrega do **Projeto Integrador** das turmas do Vespertino e do Noturno.

---

## 1. Visão Geral das Pastas

```text
bancos-de-dados-e-sql/
├── README.md                          # Portal principal do curso, cronograma de aulas e guia do Projeto Integrador
├── apostila.md                        # Apostila completa unificada do Módulo 09 (Unidades 1 a 8)
├── Aula01/                            # [Disponível] 30/10/2026 - Introdução a BD, SGBD, Histórico e SQL vs. NoSQL
│   ├── README.md
│   └── laboratorio.md
├── Aula02/                            # [Disponível] 03/11/2026 - Arquitetura de SGBD, Entidades, Atributos e Cardinalidades
│   ├── README.md
│   └── laboratorio.md
├── Aula03/                            # [Disponível] 04/11/2026 - Chaves (PK/FK), Normalização (1FN a 3FN) e DER
│   ├── README.md
│   └── laboratorio.md
├── Aula04/                            # [Disponível] 05/11/2026 - Linguagem SQL: Comandos DDL e Constraints
│   ├── README.md
│   ├── laboratorio.md
│   └── schema_ddl.sql
├── atividades/                        # Listas de exercícios e atividades de nivelamento (sem gabarito público)
│   ├── atividade_nivelamento.md
│   └── consultas_sql_avancadas.sql.md
├── base/                              # Base de dados oficial do curso e do Projeto Integrador
│   └── escola_db.sql
├── docs/                              # Documentação de apoio, glossário e especificação do Projeto Integrador
│   ├── estrutura-do-repositorio.md
│   ├── glossario-e-guia-de-estudo.md
│   └── projeto-integrador.md
└── entregas/                          # Diretórios de entrega dos grupos do Projeto Integrador
    ├── noturno/
    │   ├── grupo-01/
    │   └── ...
    └── vespertino/
        ├── grupo-01/
        └── ...
```

*(Nota: As pastas `Aula05/` a `Aula08/` são liberadas progressivamente pelo professor conforme o avanço do cronograma em sala de aula.)*

---

## 2. Modelo de Organização por Grupo no Projeto Integrador (`entregas/`)

Cada grupo deve organizar sua respectiva pasta (`entregas/noturno/grupo-XX` ou `entregas/vespertino/grupo-XX`) seguindo esta estrutura:

```text
grupo-01/
├── app/
├── sql/
├── der/
├── docs/
└── infra/
```

### Conteúdo Esperado por Subpasta
* **`app/`**: Código-fonte da aplicação (front-end, back-end) e instruções claras de execução.
* **`sql/`**: Script do banco de dados, consultas principais, views, índices e ajustes realizados pelo grupo.
* **`der/`**: Diagrama Entidade-Relacionamento (DER) exportado em PNG, JPG ou PDF.
* **`docs/`**: Documento da equipe, lista de integrantes e divisão de papéis.
* **`infra/`**: Link de publicação, capturas de tela da implantação e instruções de deploy.
