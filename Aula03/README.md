# Aula 03: Chaves (PK/FK), Integridade Referencial, Normalização de Dados (1FN, 2FN, 3FN) e DER

**Data Oficial:** `04/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Diferenciar **Chave Candidata**, **Chave Primária (`PK`)**, **Chave Estrangeira (`FK`)** e **Chave Composta**.
2. Explicar o mecanismo de **Integridade Referencial** e como o SGBD protege o banco contra registros órfãos.
3. Aplicar passo a passo a **Primeira (1FN)**, **Segunda (2FN)** e **Terceira Forma Normal (3FN)** para eliminar redundâncias e anomalias.
4. Construir e ler **Diagramas Entidade-Relacionamento (DER)** nas notações de **Peter Chen**, **Pé de Galinha (Crow's Foot)** e **UML** usando Draw.io ou dbdiagram.io.

---

## 1. Chaves no Modelo Relacional

Para que o SGBD consiga localizar uma linha específica entre milhões de registros e conectar tabelas sem ambiguidade, utilizamos **chaves**:

### 1.1. Tipos de Chaves
* **Chave Candidata:** Qualquer coluna (ou combinação mínima de colunas) cujo valor é único para cada registro da tabela. Na tabela `alunos`, tanto `id_aluno` quanto `cpf` e `email` são chaves candidatas.
* **Chave Primária (`PRIMARY KEY` - PK):** É a chave candidata escolhida pelo projetista como identificador principal da tabela.
  * **Regras obrigatórias da PK:** Nunca se repete (`UNIQUE`), nunca fica vazia (`NOT NULL`) e seu valor não deve mudar ao longo do tempo.
  * **Dica de Engenharia (Chave Substituta / Surrogate Key):** Prefira usar um inteiro sequencial (`id_aluno INT AUTO_INCREMENT PRIMARY KEY`) como chave primária e mantenha o `cpf` como `UNIQUE`. Assim, se houver erro de digitação no CPF, basta corrigir a coluna `cpf` sem precisar atualizar tabelas filhas.
* **Chave Estrangeira (`FOREIGN KEY` - FK):** É uma coluna em uma tabela filha que armazena o valor da `PRIMARY KEY` de uma tabela pai, estabelecendo o relacionamento lógico entre ambas.
* **Chave Composta:** Chave primária formada pela união de duas ou mais colunas (muito comum em tabelas associativas, como `(id_emprestimo, id_livro)`).

```text
Tabela Pai: CURSOS                              Tabela Filha: TURMAS
+----------+----------------------+             +----------+----------+----------+-----------------+
| id_curso | nome                 |             | id_turma | id_curso | periodo  | nome_turma      |
|   [PK]   |                      |             |   [PK]   |   [FK]   |          |                 |
+----------+----------------------+             +----------+----------+----------+-----------------+
|    1     | Banco de Dados e SQL | <---------- |    10    |    1     | 2026.1   | Turma BD Noturno|
|    2     | Node.js e Express    | <---------- |    11    |    2     | 2026.1   | Turma Node Vesp.|
+----------+----------------------+             +----------+----------+----------+-----------------+
```

---

## 2. Integridade Referencial

A **Integridade Referencial** é a regra imposta pelo SGBD sobre as Chaves Estrangeiras (`FOREIGN KEY`) que garante que **todo vínculo entre tabelas seja válido**.

Na prática, quando declaramos `FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)` na tabela `turmas`, o SGBD passa a vigiar duas situações críticas:

1. **Bloqueio de Inserção/Atualização Órfã:**
   * Se alguém tentar cadastrar uma turma informando `id_curso = 99` e não existir o curso `99` na tabela `cursos`, o SGBD aborta o comando com erro de violação de chave estrangeira.
2. **Controle de Exclusão na Tabela Pai (`ON DELETE`):**
   * **`RESTRICT` / `NO ACTION` (Padrão seguro):** Impede que um curso seja apagado da tabela `cursos` enquanto houver turmas vinculadas a ele em `turmas`.
   * **`CASCADE`:** Se o registro pai for apagado, apaga automaticamente todos os registros filhos (use com extrema cautela!).
   * **`SET NULL`:** Se o registro pai for apagado, define a coluna `FK` nos filhos como `NULL` (quando o vínculo for opcional).

---

## 3. Normalização de Dados (1FN, 2FN e 3FN)

A **Normalização** é uma técnica em etapas progressivas que analisa as colunas de uma tabela para eliminar **redundâncias** e evitar três anomalias:
* **Anomalia de Inserção:** Não conseguir cadastrar um curso novo porque ainda não há alunos matriculados nele.
* **Anomalia de Atualização:** Ter de alterar o e-mail de um professor em 50 linhas diferentes e esquecer uma delas.
* **Anomalia de Exclusão:** Ao cancelar a matrícula do único aluno de uma turma, perder acidentalmente os dados cadastrais do curso.

Vamos acompanhar passo a passo o exemplo completo da nossa Apostila:

### Ponto de Partida: Tabela Não Normalizada (`0FN`)

Observe a ficha de matrículas mantida sem normalização:

| id_aluno | nome_aluno | telefones | id_curso | nome_curso | id_prof | nome_prof | email_prof | nota_final |
| :---: | :--- | :--- | :---: | :--- | :---: | :--- | :--- | :---: |
| 1 | Ana Souza | `99111-1111, 99111-2222` | `10, 20` | `SQL, Node.js` | `5, 8` | `Janei, Marcos` | `janei@iteam.br, marcos@iteam.br` | `9.5, 8.0` |
| 2 | Bruno Lima | `99222-3333` | `10` | `SQL` | `5` | `Janei` | `janei@iteam.br` | `7.5` |

---

### Passo 1: Primeira Forma Normal (`1FN`) — Atomicidade

> **Regra da 1FN:** Uma tabela está na **1FN** quando todos os seus atributos contêm apenas **valores atômicos (indivisíveis)** e não existem grupos repetitivos ou listas de valores na mesma célula.

**Como aplicar a 1FN no nosso exemplo:**
1. Retiramos o atributo multivalorado `telefones` para uma tabela própria `aluno_telefones`.
2. Quebramos as listas de cursos/notas para que cada linha represente um único par `(id_aluno, id_curso)`:

**Tabela `aluno_telefones` (em 1FN):**
| id_telefone (PK) | id_aluno (FK) | numero_telefone |
| :---: | :---: | :--- |
| 1 | 1 | `99111-1111` |
| 2 | 1 | `99111-2222` |
| 3 | 2 | `99222-3333` |

**Tabela `matriculas_brutas` (em 1FN — Chave Primária Composta: `id_aluno + id_curso`):**
| id_aluno (PK) | id_curso (PK) | nome_aluno | nome_curso | id_prof | nome_prof | email_prof | nota_final |
| :---: | :---: | :--- | :--- | :---: | :--- | :--- | :---: |
| 1 | 10 | Ana Souza | SQL | 5 | Janei | janei@iteam.br | 9.5 |
| 1 | 20 | Ana Souza | Node.js | 8 | Marcos | marcos@iteam.br | 8.0 |
| 2 | 10 | Bruno Lima | SQL | 5 | Janei | janei@iteam.br | 7.5 |

---

### Passo 2: Segunda Forma Normal (`2FN`) — Fim da Dependência Parcial

> **Regra da 2FN:** Uma tabela está na **2FN** quando:
> 1. Já está na **1FN**; e
> 2. Todo atributo não-chave depende funcionalmente **da chave primária inteira**, e não apenas de um pedaço dela (elimina **dependências parciais** em tabelas com chave composta).

**Diagnóstico na tabela `matriculas_brutas` (Chave Composta: `id_aluno + id_curso`):**
* `nota_final` depende do aluno **E** do curso (`id_aluno + id_curso`)? **Sim!**
* `nome_aluno` depende do curso? **Não!** Depende apenas de `id_aluno` (*dependência parcial*).
* `nome_curso`, `id_prof`, `nome_prof`, `email_prof` dependem do aluno? **Não!** Dependem apenas de `id_curso` (*dependência parcial*).

**Como aplicar a 2FN:** Separamos os dados que dependem só do aluno e os dados que dependem só do curso:

1. **`alunos`** `(id_aluno [PK], nome_aluno)`
2. **`matriculas`** `(id_aluno [PK, FK], id_curso [PK, FK], nota_final)`
3. **`cursos_prof`** `(id_curso [PK], nome_curso, id_prof, nome_prof, email_prof)`

---

### Passo 3: Terceira Forma Normal (`3FN`) — Fim da Dependência Transitiva

> **Regra da 3FN:** Uma tabela está na **3FN** quando:
> 1. Já está na **2FN**; e
> 2. Nenhum atributo não-chave depende de outro atributo não-chave (elimina **dependências transitivas**).

**Diagnóstico na tabela `cursos_prof`:**
* A chave primária é `id_curso`.
* Porém, `nome_prof` e `email_prof` dependem de `id_prof`, que não é a chave primária da tabela `cursos_prof` (`id_curso -> id_prof -> nome_prof, email_prof`). Se o professor Janei lecionar 5 cursos, o nome e o e-mail dele ficarão repetidos 5 vezes!

**Como aplicar a 3FN:** Extraímos os atributos do professor para a tabela `professores` e deixamos apenas a chave estrangeira `id_prof` em `cursos`:

1. **`professores`** `(id_prof [PK], nome_prof, email_prof)`
2. **`cursos`** `(id_curso [PK], nome_curso, id_prof [FK])`
3. **`alunos`** `(id_aluno [PK], nome_aluno)`
4. **`aluno_telefones`** `(id_telefone [PK], id_aluno [FK], numero_telefone)`
5. **`matriculas`** `(id_aluno [PK, FK], id_curso [PK, FK], nota_final)`

```text
Resumo Mental Rápido das Formas Normais:
- 1FN: "Um valor por célula" (Sem listas ou colunas repetitivas: telefone1, telefone2).
- 2FN: "Depende da chave inteira" (Em chaves compostas A+B, nada pode depender só de A ou só de B).
- 3FN: "Depende somente da chave" (Nenhuma coluna comum pode depender de outra coluna comum).
```

---

## 4. Diagrama Entidade-Relacionamento (DER) e Notações

O **DER** é a planta baixa do banco de dados. Assim como um engenheiro civil não constrói um prédio sem planta, um desenvolvedor não cria tabelas sem o DER.

### Comparativo das 3 Notações Mais Usadas

| Elemento | 1. Notação de Peter Chen (Conceitual) | 2. Pé de Galinha / Crow's Foot (Lógica) | 3. UML (Classes/Dados) |
| :--- | :--- | :--- | :--- |
| **Entidade / Tabela** | Retângulo com o nome da entidade | Caixa dividida em cabeçalho (nome) e lista de colunas | Caixa com estereótipo `<<table >>` e colunas tipadas |
| **Atributos** | Elipses ligadas ao retângulo | Linhas internas da caixa com `PK`, `FK` e tipo (`VARCHAR`, `INT`) | Atributos listados dentro da classe |
| **Relacionamento** | Losango no meio da linha com verbo (`possui`, `realiza`) | Linha direta conectando a `PK` à `FK` | Linha de associação com multiplicidades nas pontas |
| **Cardinalidade** | Números `(1, 1)` e `(1, N)` ao lado dos retângulos | Símbolos gráficos nas pontas: `||` (`1`), `o|` (`0..1`), `|<` (`1..N`), `o<` (`0..N`) | Notação textual nas pontas: `1`, `0..1`, `1..*`, `0..*` |

### Ferramentas Recomendadas para Desenhar seu DER
1. **Draw.io / diagrams.net** (https://app.diagrams.net): Gratuito, roda no navegador, possui bibliotecas completas de **Entity Relation (Crow's Foot e Chen)** e exporta para PNG/PDF.
2. **dbdiagram.io** (https://dbdiagram.io): Permite descrever as tabelas em texto simples (DBML) e gera o diagrama interativo automaticamente.
3. **DBeaver (Aba ER Diagram):** Gera automaticamente o DER a partir de um banco de dados já criado no MySQL/PostgreSQL.

---

## 5. Para Saber Mais

* **Referência na Apostila:** Veja os diagramas e tabelas da [Unidade 3 da Apostila Completa](../apostila.md#unidade-3-chaves-normalização-e-diagrama-entidade-relacionamento-der).
* **Próximo Passo Prático:** Siga para o [Laboratório da Aula 03](./laboratorio.md) para desenhar o DER de uma Clínica Médica, normalizar o banco de uma Biblioteca até a 3FN e responder ao questionário de revisão.

