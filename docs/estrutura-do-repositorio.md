# Estrutura do Repositório — Bancos de Dados e SQL (ITEAM 2026)

Este repositório reúne todas as **8 aulas teóricas e práticas** do módulo, os **gabaritos liberados** e a área de entrega individual do **Projeto Integrador** das turmas do Vespertino e do Noturno.

---

## 1. Visão Geral das Pastas

```text
bancos-de-dados-e-sql/
├── README.md                          # Portal principal do curso, cronograma e guia de entrega
├── apostila.md                        # Apostila completa do Módulo 09 (Unidades 1 a 8)
├── Aula01/ ... Aula08/                # Teoria (README.md), prática (laboratorio.md) e scripts SQL
├── atividades/                        # Listas de exercícios e nivelamento
│   ├── atividade_nivelamento.md
│   └── consultas_sql_avancadas.sql.md
├── base/                              # Base de dados oficial do curso e do Projeto Integrador
│   └── escola_db.sql
├── docs/                              # Documentação de apoio, glossário e Projeto Integrador
│   ├── estrutura-do-repositorio.md
│   ├── glossario-e-guia-de-estudo.md
│   └── projeto-integrador.md
├── gabaritos/                         # Gabaritos das listas e das Aulas 01 a 08 (liberados)
│   ├── gabarito_nivelamento.md
│   ├── gabarito_consultas_sql_avancadas.md
│   └── Aula01/ ... Aula08/
└── entregas/                          # Entregas individuais do Projeto Integrador (até 15/11/2026 23:59)
    ├── _modelo-individual/            # Pasta modelo para copiar
    ├── noturno/
    │   └── nome-sobrenome/
    └── vespertino/
        └── nome-sobrenome/
```

---

## 2. Organização da Entrega Individual (`entregas/`)

Cada aluno deve criar uma pasta com seu nome dentro do seu turno (`entregas/noturno/nome-sobrenome/` ou `entregas/vespertino/nome-sobrenome/`) seguindo este modelo:

```text
nome-sobrenome/
├── README.md
├── app/
├── sql/
└── der/
```

### Conteúdo esperado
* **`README.md`**: nome completo, turno, stack escolhida e passo a passo para rodar o projeto.
* **`app/`**: código-fonte da aplicação web (front-end e back-end, sem `node_modules/`, `.venv/` ou `.env` real).
* **`sql/`**: consultas SQL, views ou ajustes realizados sobre o `escola_db`.
* **`der/`**: Diagrama Entidade-Relacionamento (DER) exportado em PNG, JPG ou PDF.
