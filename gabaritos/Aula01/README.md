# Gabarito - Aula 01: Do Caos das Planilhas à Estrutura de um Banco de Dados

## Objetivo
Orientar o professor na validação da capacidade do aluno de diferenciar dado de informação, diagnosticar anomalias clássicas de planilhas desnormalizadas (redundância, inconsistência, violação de integridade) e propor a separação em entidades relacionais básicas.

## Checklist de Verificação
- [ ] O aluno identificou a inconsistência na grafia de "Boa Vista" / "B. Vista" e do nome do professor?
- [ ] O aluno apontou a duplicação indevida de CPF entre alunos distintos?
- [ ] O aluno explicou por que a palavra "Dez" quebra o cálculo de agregação numérica?
- [ ] O aluno explicou o risco de apagar o curso sem alunos (anomalia de exclusão)?
- [ ] O aluno desenhou as 4 tabelas separadas com identificadores (`id`) próprios?
- [ ] O aluno justificou tecnicamente a escolha entre SQL e NoSQL para os módulos propostos?

---

## Solução do Laboratório

### Etapa 1: Auditoria da "Planilha do Caos"

#### Tarefa 1.1: Identificando Problemas Reais
1. **Redundância e Inconsistência:**
   * Aluno `Lucas Andrade` aparece com cidade `"Boa Vista"` na linha 1 e `"B. Vista"` na linha 2. O professor aparece como `"Janei Pereira"` com dois e-mails diferentes (`janei@iteam.br` e `janei.pereira@iteam.br`), e na linha 3 como `"Prof. Janei"`.
   * **Consequência:** Um filtro por `"Boa Vista"` excluirá a linha 2. Uma contagem de cursos por professor considerará "Janei Pereira" e "Prof. Janei" como duas pessoas diferentes.
2. **Violação de Unicidade:**
   * `Lucas Andrade` e `Pedro Santos` compartilham o mesmo CPF (`111.222.333-44`). Planilhas não possuem restrições (`UNIQUE`), permitindo cadastros fraudulentos ou erros de digitação silenciosos.
3. **Violação de Domínio / Tipo de Dado:**
   * O valor textual `"Dez"` na coluna `Nota Final` gera erro de tipo (`#VALOR!`) ao executar funções matemáticas como `MÉDIA()`. Em um SGBD, o tipo `DECIMAL(4,2)` rejeitaria essa inserção.
4. **Anomalia de Exclusão:**
   * Se a linha 5 for removida por "não conter aluno matriculado", os dados do curso `Python para Dados` e do professor `Carlos Eduardo` desaparecem completamente da base da escola.

---

### Etapa 2: Separando as Entidades

#### Tarefa 2.1: Estrutura Proposta das 4 Tabelas
* **`Alunos`:** `id_aluno (PK)`, `nome`, `cpf`, `cidade`
* **`Professores`:** `id_professor (PK)`, `nome`, `email`
* **`Cursos`:** `id_curso (PK)`, `nome`, `carga_horaria`
* **`Matriculas`:** `id_matricula (PK)`, `id_aluno (FK)`, `id_curso (FK)`, `id_professor (FK)`, `nota_final`

---

### Etapa 3: Decisão Arquitetural (SQL vs. NoSQL)
1. **Módulo Financeiro e Cobrança:** **SQL (Relacional)** — Exige integridade transacional estrita (ACID) para evitar duplicidade de pagamentos e inconsistência contábil.
2. **Catálogo de E-books com Atributos Heterogêneos:** **NoSQL (Documentos / MongoDB)** — Livros podem ter estruturas variadas (alguns com ISBN, outros com DOI, número de páginas, formatos de arquivo flexíveis).
3. **Chat e Registro de Presença em Tempo Real:** **NoSQL (Chave-Valor / Redis ou Colunar / Cassandra)** — Prioridade em latência ultrabaixa para gravação massiva de eventos voláteis.

---

## Pontos Comuns de Dificuldade
* **Confundir dados com metadados:** Alguns alunos tentam colocar o nome do curso dentro da tabela `Alunos`. Reforce que o aluno existe independentemente de estar matriculado em um curso específico.
