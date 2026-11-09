# Aula 02: Arquitetura de SGBD, Tipos de SGBD e Modelagem Conceitual (Entidades, Atributos e Relacionamentos)

**Data Oficial:** `03/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Compreender a **arquitetura interna de um SGBD** e o ciclo de vida de uma consulta SQL desde o cliente até o disco.
2. Comparar os principais SGBDs do mercado (**MySQL**, **PostgreSQL**, **Oracle**, **SQL Server** e **SQLite**).
3. Identificar **Entidades**, **Atributos** (simples, compostos, multivalorados, derivados e identificadores) e **Relacionamentos** em um domínio de negócio.
4. Determinar corretamente as **cardinalidades** (`1:1`, `1:N` e `N:N`) e compreender como cada uma se comporta no Modelo Relacional.

---

## 1. Arquitetura Interna de um SGBD

Na Aula 01 vimos que o SGBD é o software responsável por gerenciar o banco de dados. Mas o que acontece "por baixo do capô" quando você clica em **Executar** no DBeaver ou quando sua API Node.js envia uma consulta?

```text
+-------------------------------------------------------------------------+
|                   CLIENTE (DBeaver / Aplicação Web)                     |
+-------------------------------------------------------------------------+
                                    |
                                    | 1. Conexão TCP/IP (Porta 3306 MySQL)
                                    v
+-------------------------------------------------------------------------+
|                          SERVIDOR DO SGBD                               |
|                                                                         |
|  [A] Gerenciador de Conexões e Segurança                                |
|      -> Valida usuário, senha e permissões de acesso à tabela.          |
|                                    |                                    |
|                                    v                                    |
|  [B] Processador de Consultas (Query Processor)                         |
|      ├── 1. Parser: Verifica se a sintaxe do SQL está correta e se as   |
|      |              tabelas/colunas existem no Dicionário de Dados.     |
|      ├── 2. Otimizador: Analisa estatísticas e índices para escolher    |
|      |                  o caminho mais rápido (Plano de Execução).      |
|      └── 3. Executor: Executa as etapas do plano escolhido.             |
|                                    |                                    |
|                                    v                                    |
|  [C] Gerenciador de Transações e Concorrência                           |
|      -> Controla bloqueios (locks), isolamento entre usuários e logs.   |
|                                    |                                    |
|                                    v                                    |
|  [D] Gerenciador de Armazenamento e Buffer Pool (Memória RAM)           |
|      -> Busca páginas de dados no cache em RAM ou solicita ao disco.    |
+-------------------------------------------------------------------------+
                                    |
                                    v
+-------------------------------------------------------------------------+
|       DISCO FÍSICO: Arquivos de Tabelas, Índices (B-Tree) e Logs        |
+-------------------------------------------------------------------------+
```

### Componentes Essenciais que Todo Desenvolvedor Precisa Conhecer
1. **Dicionário de Dados (Catálogo do Sistema):** É um "banco de dados sobre o banco de dados" (metadados). Nele o SGBD guarda quais tabelas existem, o tipo de cada coluna, quais são as chaves e quais índices foram criados.
2. **Otimizador de Consultas (Query Optimizer):** Como o SQL é uma linguagem declarativa (você diz *o que* quer, não *como* buscar), o otimizador calcula o custo de diferentes caminhos e decide se vale a pena usar um índice ou ler a tabela inteira.
3. **Buffer Pool (Cache em Memória RAM):** Ler dados do disco SSD/HD é milhares de vezes mais lento do que ler da memória RAM. Por isso, o SGBD mantém as páginas de tabelas e índices mais acessadas na RAM.

---

## 2. Panorama dos Principais SGBDs Relacionais

Embora todos falem a linguagem SQL (padronizada pela ANSI/ISO), cada SGBD possui características próprias de arquitetura e licenciamento:

| SGBD | Licença Principal | Porta Padrão | Pontos Fortes e Casos de Uso |
| :--- | :--- | :---: | :--- |
| **MySQL / MariaDB** | Open Source (GPL) / Comercial | `3306` | Leve, rápido e simples de operar; motor padrão (`InnoDB`) com suporte transacional ACID. É o SGBD que utilizamos na base `escola_db`. |
| **PostgreSQL** | Open Source (Licença PostgreSQL/MIT-like) | `5432` | Altíssima conformidade ANSI SQL, consultas analíticas complexas, suporte nativo avançado a `JSONB` e dados geográficos (`PostGIS`). |
| **Oracle Database** | Proprietário / Comercial | `1521` | Robustez corporativa para grandes volumes transacionais (bancos, governos, telecom), recursos de cluster (`Oracle RAC`) e linguagem `PL/SQL`. |
| **SQL Server** | Proprietário / Comercial (Microsoft) | `1433` | Integração nativa com ecossistema Microsoft (`.NET`, Azure, Active Directory, Power BI) e linguagem procedural `T-SQL`. |
| **SQLite** | Domínio Público | *(Arquivo local)* | Não usa servidor de rede: o banco inteiro é um único arquivo no disco. Padrão em apps Android/iOS, navegadores e testes automatizados. |

---

## 3. Modelagem de Dados: Os 3 Níveis de Abstração

Antes de sair digitando `CREATE TABLE` no banco, a engenharia de software divide o projeto de um banco de dados em **três etapas progressivas**:

```text
+-------------------------------+       +-------------------------------+       +-------------------------------+
|    1. MODELO CONCEITUAL       |       |       2. MODELO LÓGICO        |       |       3. MODELO FÍSICO        |
|-------------------------------|       |-------------------------------|       |-------------------------------|
| Visão de negócio, independente|  -->  | Estrutura em tabelas, colunas,|  -->  | Código SQL real (DDL)         |
| de tecnologia ou SGBD.        |       | Chaves Primárias (PK) e       |       | específico para o SGBD        |
| Entidades, Atributos e        |       | Chaves Estrangeiras (FK).     |       | escolhido (MySQL, Postgres).  |
| Relacionamentos (DER Chen).   |       | (DER Pé de Galinha / Tabular) |       | Tipos físicos e índices.      |
+-------------------------------+       +-------------------------------+       +-------------------------------+
```

---

## 4. Elementos do Modelo Conceitual

### 4.1. Entidades
Uma **Entidade** é qualquer elemento do mundo real (pessoa, objeto, evento ou conceito abstrato) sobre o qual a organização precisa guardar dados.
No nosso sistema acadêmico `escola_db`, temos 6 entidades centrais:
* **`Aluno`** (quem estuda)
* **`Professor`** (quem leciona)
* **`Curso`** (o programa pedagógico, ex.: *Banco de Dados e SQL*)
* **`Turma`** (a oferta concreta de um curso em um período e turno, ex.: *Turma BD 2026.1 Noturno*)
* **`Matrícula`** (o vínculo formal do aluno em uma turma)
* **`Nota`** (o registro de avaliações da matrícula)

> **Terminologia Equivalente:**
> * No **Modelo Conceitual**: falamos em **Entidade**, **Ocorrência da Entidade** e **Atributo**.
> * No **Modelo Relacional (Teórico)**: falamos em **Relação**, **Tupla** e **Atributo**.
> * No **Modelo Físico (SQL)**: falamos em **Tabela**, **Linha (Registro)** e **Coluna (Campo)**.

### 4.2. Atributos e suas Classificações
Os **Atributos** são as características que descrevem uma entidade. Eles se dividem em cinco categorias:

| Tipo de Atributo | Definição | Exemplo Prático | Como tratar no Banco Relacional? |
| :--- | :--- | :--- | :--- |
| **1. Simples (Atômico)** | Não precisa nem pode ser subdividido em partes menores. | `cpf`, `turno`, `carga_horaria` | Vira uma coluna direta na tabela (`VARCHAR`, `INT`). |
| **2. Composto** | Pode ser decomposto em sub-atributos independentes. | `endereco` (composto por `rua`, `numero`, `bairro`, `cidade`, `cep`) | Decompõe-se em colunas separadas na tabela para permitir filtros por `cidade` ou `bairro`. |
| **3. Multivalorado** | Pode ter zero, um ou vários valores simultâneos para o mesmo registro. | `telefones` de um aluno (celular, residencial, recado) | Cria-se uma tabela auxiliar separada (`aluno_telefones`) ligada ao aluno. |
| **4. Derivado** | Seu valor é calculado a partir de outros atributos já existentes. | `idade` (calculada pela `data_nascimento`), `media` (calculada por `nota1, nota2, nota3`) | Pode ser calculado dinamicamente na consulta SQL ou mantido via *Trigger* / coluna gerada. |
| **5. Identificador (Chave)** | Identifica de forma única e exclusiva cada indivíduo na entidade. | `id_aluno`, `id_curso` | Torna-se a **Chave Primária (`PRIMARY KEY`)** da tabela. |

---

## 5. Relacionamentos e Cardinalidades (`1:1`, `1:N` e `N:N`)

Um **Relacionamento** descreve como duas entidades se associam no mundo real. A **Cardinalidade** define quantas ocorrências de uma entidade podem se ligar a ocorrências da outra.

### 5.1. Relacionamento Um para Um (`1:1`)
Cada ocorrência da Entidade A se associa a, no máximo, uma ocorrência da Entidade B, e vice-versa.
* **Exemplo:** Cada **Aluno** possui um único **Prontuário Médico Escolar**, e cada prontuário pertence a um único aluno.
```text
[ ALUNO ] (1) ---------- possui ---------- (1) [ PRONTUARIO_MEDICO ]
```

### 5.2. Relacionamento Um para Muitos (`1:N`)
É o relacionamento mais comum em bancos de dados relacionais. Uma ocorrência da Entidade A pode se associar a **várias (`N`)** ocorrências da Entidade B, mas cada ocorrência de B pertence a **apenas uma (`1`)** ocorrência de A.
* **Exemplo 1 (`escola_db`):** Um **Curso** possui várias **Turmas** abertas (`1:N`), mas cada **Turma** refere-se a um único **Curso**.
* **Exemplo 2 (`escola_db`):** Um **Professor** ministra aulas em várias **Turmas** (`1:N`), mas cada **Turma** tem um único **Professor** titular.

```text
[ CURSO ]     (1) ---------- oferece ----------> (N) [ TURMA ]
[ PROFESSOR ] (1) ---------- leciona em -------> (N) [ TURMA ]
```
> **Como funciona na prática:** Na tabela do lado `N` (`turmas`), colocamos uma coluna que guarda o código do lado `1` (`id_curso` e `id_professor`).

### 5.3. Relacionamento Muitos para Muitos (`N:N`)
Uma ocorrência da Entidade A pode se associar a várias ocorrências da Entidade B, e uma ocorrência de B também pode se associar a várias de A.
* **Exemplo (`escola_db`):** Um **Aluno** pode se inscrever em várias **Turmas** ao longo do ano, e uma **Turma** possui vários **Alunos** inscritos.

```text
Visão Conceitual (N:N):
[ ALUNO ] (N) <---------- cursa ----------> (N) [ TURMA ]

Decomposição Relacional com Tabela Associativa (dois vínculos 1:N):
[ ALUNO ] (1) -----> (N) [ MATRICULA ] (N) <----- (1) [ TURMA ]
```
> **Regra Fundamental do Modelo Relacional:** Duas tabelas nunca se ligam diretamente em `N:N`. Sempre que existir um relacionamento `N:N`, criamos uma **tabela associativa intermediária** (no nosso caso, a tabela `matriculas`), que recebe o `id_aluno` e o `id_turma`, além de guardar atributos próprios do vínculo (como `data_matricula` e `status`).

---

## 6. Para Saber Mais

* **Ferramenta Cliente SQL:** Baixe ou abra o **DBeaver Community Edition** (https://dbeaver.io/) para explorar conexões com SGBDs.
* **Leitura na Apostila:** Revise a [Unidade 2 da Apostila Completa](../apostila.md#unidade-2-arquitetura-de-sgbd-e-modelagem-conceitual).
* **Próximo Passo Prático:** Vá para o [Laboratório da Aula 02](./laboratorio.md) para exercitar a classificação de atributos, cardinalidades e o primeiro contato com o esquema do `escola_db`.

