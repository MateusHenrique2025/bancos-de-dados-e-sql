# Projeto Integrador: Consulta de Alunos Matriculados (`escola_db`)

**Curso:** Capacitação em Desenvolvimento Full Stack (Módulo 09: Banco de Dados e SQL)  
**Instituição:** ITEAM (Boa Vista / RR)  
**Professor:** Janei Vieira Pereira  
**Formato:** Individual (sem apresentação oral)  
**Prazo de entrega:** Domingo, **15/11/2026 até as 23:59**  
**Forma de entrega:** Fork deste repositório + Pull Request no GitHub

---

## 1. Objetivo do trabalho

Consolidar o conteúdo visto no módulo (modelagem relacional, consultas SQL, filtros, agrupamentos, `JOINs`, subconsultas e views) em uma aplicação web simples e funcional conectada ao banco de dados oficial **`escola_db`** (`base/escola_db.sql`).

O trabalho é **individual**, focado no funcionamento da consulta ao banco e na exibição clara dos dados. Não haverá apresentação por equipe.

---

## 2. O que a aplicação precisa fazer

Uma coordenação acadêmica precisa visualizar, em uma tela simples, os alunos já matriculados na base `escola_db`. Não é necessário criar telas de cadastro, edição ou exclusão.

### Dados mínimos exibidos na tela
* Nome do aluno
* E-mail
* Turma à qual pertence
* Data da matrícula
* Notas do aluno
* Média final

### Filtros mínimos
* Filtrar alunos por **turma**
* Pesquisar aluno por **nome**

### Extras opcionais (não obrigatórios)
* Busca por e-mail ou matrícula
* Destaque visual para alunos aprovados e abaixo da média
* Ordenação das colunas
* Layout responsivo ou publicação online

Você pode usar qualquer linguagem ou stack de sua preferência (HTML/CSS/JS com Node.js, Python, PHP, Java, C#, etc.), conectando ao MySQL ou MariaDB com a base `escola_db`.

---

## 3. O que você deve entregar

Crie sua pasta individual dentro de `entregas/` usando o seu turno e o seu nome (em minúsculas, sem acentos nem espaços):

* Turno noturno: `entregas/noturno/nome-sobrenome/`
* Turno vespertino: `entregas/vespertino/nome-sobrenome/`

*(Você pode usar [`entregas/_modelo-individual/`](../entregas/_modelo-individual/) como base.)*

Dentro da sua pasta, coloque:

```text
nome-sobrenome/
├── README.md        # Seu nome completo, turno, stack usada e como rodar o projeto
├── app/             # Código-fonte da aplicação web
├── sql/             # Consultas SQL usadas (ou views criadas no escola_db)
└── der/             # Imagem ou PDF do DER da base (PNG, JPG ou PDF)
```

> **Dica:** A pasta `Aula08/` e a pasta `gabaritos/` já estão liberadas no repositório. A view `vw_boletim_escolar` da Aula 08 serve diretamente como base para a consulta principal da aplicação.

---

## 4. Passo a passo para entregar via Fork e Pull Request

1. **Faça um Fork** deste repositório no GitHub clicando no botão **Fork** (canto superior direito da página do repositório `oMaestro174/bancos-de-dados-e-sql`).
2. **Clone o seu fork** para a sua máquina:
   ```bash
   git clone https://github.com/SEU-USUARIO/bancos-de-dados-e-sql.git
   cd bancos-de-dados-e-sql
   ```
3. **Crie uma branch** com seu turno e nome:
   ```bash
   git checkout -b entrega-noturno-nome-sobrenome
   ```
4. **Adicione seus arquivos** apenas dentro da sua pasta (`entregas/noturno/nome-sobrenome/` ou `entregas/vespertino/nome-sobrenome/`). Nunca altere arquivos das pastas de outros colegas ou da raiz do curso.
5. **Faça o commit e envie para o seu fork:**
   ```bash
   git add entregas/
   git commit -m "feat(entrega): projeto integrador - Nome Sobrenome"
   git push -u origin entrega-noturno-nome-sobrenome
   ```
6. **Abra o Pull Request (PR):**
   * Acesse o seu fork no GitHub; aparecerá o botão **Compare & pull request**.
   * Confirme que o destino é o repositório original (`oMaestro174/bancos-de-dados-e-sql`, branch `main`).
   * Coloque no título: `Entrega Projeto Integrador - Nome Completo (Turno)` e envie até **domingo, 15/11/2026 às 23:59**.

*(Atenção: não inclua arquivos `.env` com senhas reais nem pastas `node_modules/` ou `.venv/` no commit. Se usar `.env`, envie apenas um `.env.example`.)*

---

## 5. Critérios de avaliação

1. **Funcionamento da consulta:** a aplicação exibe alunos, turmas, notas e média final direto da base `escola_db`, com filtro por turma e busca por nome.
2. **SQL e DER:** consultas corretas (`JOIN`, cálculo/exibição de média) e DER coerente com o banco usado.
3. **Clareza para rodar:** `README.md` objetivo explicando como subir o banco e iniciar a aplicação.
4. **Entrega correta no GitHub:** arquivos organizados na pasta individual, sem segredos commitados e Pull Request aberto dentro do prazo (**15/11/2026 às 23:59**).
