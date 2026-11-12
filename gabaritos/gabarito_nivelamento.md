# Gabarito: Atividade de Nivelamento e Diagnóstico (Aulas 01 e 02)

> **Gabarito Liberado:** Respostas comentadas para conferência da atividade diagnóstica de nivelamento aplicada no início do Módulo 09.

---

## Respostas Comentadas

### 1. Diferença entre Dado e Informação
* **Dado:** Registro bruto e isolado, sem contexto interpretativo (ex.: `38.5`, `'Boa Vista'`, `2026-10-30`).
* **Informação:** Dado processado, contextualizado e dotado de significado útil para tomada de decisão (ex.: *"A temperatura máxima registrada em Boa Vista em 30/10/2026 foi de 38,5 °C"*).

### 2. Diferença entre Banco de Dados e SGBD
* **Banco de Dados (BD):** Conjunto organizado de dados inter-relacionados que representam aspectos de um domínio real (ex.: o acervo de tabelas do sistema acadêmico `escola_db`).
* **Sistema Gerenciador de Banco de Dados (SGBD):** Software responsável por armazenar, proteger, recuperar e controlar o acesso concorrente ao banco de dados (ex.: MySQL, PostgreSQL, Oracle, SQL Server).

### 3. Limitações dos Arquivos Planos (Planilhas e `.txt`/`.csv`)
1. **Redundância e inconsistência:** O mesmo dado (como endereço ou telefone de um cliente) se repete em várias linhas ou arquivos; se mudar em um lugar e não em outro, gera inconsistência.
2. **Falta de controle de concorrência:** Dois usuários editando a mesma planilha simultaneamente podem sobrescrever alterações.
3. **Ausência de integridade referencial:** Nada impede apagar um curso mantendo matrículas órfãs apontando para ele.
4. **Segurança granular limitada:** Dificuldade para restringir leitura/escrita por coluna ou tabela.

### 4. Comparativo SQL (Relacional) vs. NoSQL (Não Relacional)
* **Bancos Relacionais (SQL):** Estruturados em tabelas (linhas e colunas), esquema rígido pré-definido, garantia transacional ACID e linguagem padronizada SQL. Indicados para sistemas financeiros, ERPs, sistemas acadêmicos e faturamento.
* **Bancos Não Relacionais (NoSQL):** Esquema flexível (documentos JSON, chave-valor, colunar ou grafos), escalabilidade horizontal simplificada. Indicados para logs em alta velocidade, catálogos variáveis, cache de sessão (Redis) ou documentos sem estrutura fixa (MongoDB).

### 5. Identificação de Cardinalidades no Cenário Acadêmico
* **Professor ➔ Turma (`1:N`):** Um professor pode lecionar em várias turmas, mas cada turma tem um professor titular responsável.
* **Curso ➔ Turma (`1:N`):** Um curso oferece diversas turmas ao longo dos semestres; cada turma pertence a um único curso.
* **Aluno ➔ Turma (`N:N`, resolvida via `matriculas`):** Um aluno pode se matricular em várias turmas (de cursos diferentes) e uma turma possui vários alunos matriculados. A tabela `matriculas` decompõe o relacionamento `N:N` em dois relacionamentos `1:N`.

