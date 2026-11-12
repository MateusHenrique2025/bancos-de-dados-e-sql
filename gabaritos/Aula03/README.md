# Gabarito - Aula 03: Chaves, Normalização (1FN, 2FN, 3FN) e Modelo Lógico

## Objetivo
Validar a transição do modelo conceitual para o lógico, a aplicação rigorosa das três primeiras formas normais para eliminação de redundâncias e a resolução do questionário de revisão.

## Checklist de Verificação
- [ ] O DER no Draw.io da Clínica Médica contém as 4 tabelas conectadas com Crow's Foot (`1:N`)?
- [ ] Na 1FN, os telefones e códigos de livros foram atomizados em novas tabelas?
- [ ] Na 2FN, a dependência parcial da chave composta foi eliminada com a criação da tabela `livros`?
- [ ] Na 3FN, a dependência transitiva do coordenador e da cidade da editora foi sanada?
- [ ] O questionário de revisão (Q1 a Q8) foi corrigido com base na tabela oficial?

---

## Solução do Laboratório

### Etapa 1: DER da Clínica Médica (Modelo Lógico)
* **`especialidades`** (`id_especialidade [PK]`, `nome [VARCHAR UNIQUE]`, `descricao [VARCHAR]`)
* **`medicos`** (`id_medico [PK]`, `nome [VARCHAR]`, `crm [VARCHAR UNIQUE]`, `telefone [VARCHAR]`, `id_especialidade [FK]`)
* **`pacientes`** (`id_paciente [PK]`, `nome [VARCHAR]`, `cpf [CHAR(11) UNIQUE]`, `data_nascimento [DATE]`, `telefone [VARCHAR]`, `cidade [VARCHAR]`)
* **`consultas`** (`id_consulta [PK]`, `id_paciente [FK]`, `id_medico [FK]`, `data_consulta [DATETIME]`, `status [VARCHAR]`, `observacoes [TEXT]`)

### Etapa 2: Normalização do Sistema de Biblioteca

#### 1. Primeira Forma Normal (1FN)
* **Problema:** Múltiplos telefones (`99111-1010, 99111-2020`) e listas de livros em uma única célula.
* **Solução:** Criar `aluno_telefones(id_aluno, telefone)` e `itens_emprestimo(id_emprestimo, id_livro)`.

#### 2. Segunda Forma Normal (2FN)
* **Problema:** Em `(id_emprestimo, id_livro)`, o título e a editora dependem unicamente de `id_livro` (dependência parcial).
* **Solução:** Isolar os dados da obra na tabela `livros(id_livro [PK], titulo, id_editora [FK])`.

#### 3. Terceira Forma Normal (3FN)
* **Problema:** Dependências transitivas:
  * `coordenador_curso` depende de `id_curso`, que depende de `id_aluno`.
  * `cidade_editora` depende de `id_editora`, que depende de `id_livro`.
* **Solução Final Normalizada (3FN):**
  1. `cursos (id_curso PK, nome_curso, coordenador)`
  2. `alunos (id_aluno PK, nome, cpf, id_curso FK)`
  3. `aluno_telefones (id_aluno FK, telefone, PK(id_aluno, telefone))`
  4. `editoras (id_editora PK, nome_editora, cidade)`
  5. `livros (id_livro PK, titulo, id_editora FK)`
  6. `emprestimos (id_emprestimo PK, id_aluno FK, data_emprestimo)`
  7. `itens_emprestimo (id_emprestimo FK, id_livro FK, PK(id_emprestimo, id_livro))`

---

### Etapa 3: Questionário de Revisão (Q1 a Q8)

| Questão | Resposta Correta | Justificativa |
| :---: | :---: | :--- |
| **Q1** | **B** | A `PRIMARY KEY` garante unicidade e impede valores nulos (`NOT NULL`). |
| **Q2** | **C** | Relações N:N exigem tabela associativa intermediária com chaves compostas. |
| **Q3** | **A** | A 1FN exige atributos com valores atômicos e indivisíveis. |
| **Q4** | **D** | A 2FN elimina a dependência parcial de atributos não-chave em chaves compostas. |
| **Q5** | **B** | A 3FN elimina dependências transitivas entre atributos não-chave. |
| **Q6** | **C** | Chaves estrangeiras garantem a integridade referencial contra registros órfãos. |
| **Q7** | **A** | `DROP` é DDL e exclui tabela/dados; `DELETE` é DML com filtro `WHERE`. |
| **Q8** | **D** | `ALTER TABLE` altera a estrutura física de uma tabela já existente. |

---

## Pontos Comuns de Dificuldade
* **Diferença entre 2FN e 3FN:** Lembre os alunos de que a 2FN só é violada quando há chave primária composta. A 3FN pode ocorrer mesmo com chave primária simples.
