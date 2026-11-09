# Aula 01: Introdução a Bancos de Dados, Evolução Histórica e Panorama SQL vs. NoSQL

**Data Oficial:** `30/10/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Diferenciar tecnicamente **Dado**, **Informação** e **Conhecimento** em sistemas computacionais.
2. Explicar o papel de um **Banco de Dados (BD)** e de um **Sistema Gerenciador de Banco de Dados (SGBD)**.
3. Compreender os problemas dos **Arquivos Planos (Flat Files)** e a evolução histórica dos modelos Hierárquico, em Rede e Relacional.
4. Comparar bancos de dados **Relacionais (SQL)** e **Não Relacionais (NoSQL)**, identificando quando aplicar cada abordagem.

---

## 1. Dados, Informação e Conhecimento

Toda aplicação que você constrói no curso Full Stack (seja um portal acadêmico, um aplicativo de entregas ou um sistema financeiro) existe para coletar, processar e apresentar dados. Para projetar bancos de dados sólidos, precisamos separar três conceitos fundamentais:

```text
+-----------------------+      Contextualização      +-------------------------+      Análise / Decisão      +-----------------------+
|         DADO          |  ----------------------->  |       INFORMAÇÃO        |  ------------------------>  |     CONHECIMENTO      |
|  Fato bruto isolado   |   (Regras e Relacionam.)   | Dado com significado    |   (Padrões e Indicadores)   |  Ação estratégica     |
+-----------------------+                            +-------------------------+                             +-----------------------+
| Ex.: "8.5", "104",    |                            | Ex.: "O aluno #104      |                             | Ex.: "A turma noturna |
| "Boa Vista", "Ativo"  |                            |  obteve média 8,5 na    |                             |  superou a meta de    |
|                       |                            |  turma de SQL"          |                             |  aprovação do semestre"|
+-----------------------+                            +-------------------------+                             +-----------------------+
```

* **Dado:** É a matéria-prima bruta armazenada nas colunas de uma tabela (um número, um texto, uma data). Sozinho, o valor `8.5` não diz se é o preço de um produto, a nota de uma prova ou a hora de início de um turno.
* **Informação:** Surge quando relacionamos e contextualizamos os dados. Ao cruzar o registro do aluno, a turma e as notas, o sistema gera um boletim escolar compreensível.
* **Conhecimento:** É a aplicação prática da informação para orientar decisões (por exemplo, identificar quais módulos precisam de monitoria extra a partir do histórico de médias).

---

## 2. Banco de Dados vs. SGBD: Uma Analogia Prática

É comum ouvir desenvolvedores dizendo *"subi o banco MySQL"*, mas tecnicamente existem dois elementos distintos trabalhando juntos:

* **Banco de Dados (BD):** É o acervo organizado de dados propriamente dito (as tabelas `alunos`, `cursos`, `turmas`, `matriculas` e `notas` do nosso projeto `escola_db`).
* **SGBD (Sistema Gerenciador de Banco de Dados):** É o software servidor que protege, lê, grava e organiza esse acervo (como **MySQL**, **PostgreSQL**, **Oracle** ou **SQL Server**).

> **Analogia da Biblioteca Universitária:**
> Imagine a biblioteca central em Boa Vista:
> * O **acervo de livros organizados nas estantes por código catalográfico** é o **Banco de Dados**.
> * O **sistema da bibliotecária e a equipe de segurança** (que verifica sua carteirinha, impede que duas pessoas levem o mesmo exemplar ao mesmo tempo, registra o empréstimo e guarda cópias de segurança) é o **SGBD**.
> * O **formulário de pedido** em que você escreve *"Quero todos os livros de Banco de Dados publicados após 2020"* é a linguagem **SQL**.

### Por que não guardar tudo em planilhas ou arquivos `.txt` / `.csv`?

No início da computação (e ainda hoje em pequenos negócios), usavam-se **Arquivos Planos (Flat Files)** ou planilhas eletrônicas. À medida que o sistema cresce, surgem cinco problemas clássicos que o SGBD resolve:

| Problema nos Arquivos Planos / Planilhas | Como o SGBD Resolve |
| :--- | :--- |
| **1. Redundância e Inconsistência:** O endereço e o telefone do aluno são repetidos em dezenas de linhas; se ele mudar de número, metade das linhas fica desatualizada. | **Normalização e Relacionamentos:** O telefone fica gravado em um único lugar e referenciado por código (`id_aluno`). |
| **2. Anomalias de Concorrência:** Dois funcionários salvam a planilha ao mesmo tempo e um apaga o trabalho do outro. | **Controle de Concorrência (Locks e MVCC):** Milhares de usuários podem ler e gravar simultaneamente sem corromper registros. |
| **3. Falta de Atomicidade em Falhas:** Se o computador desligar no meio da gravação de um arquivo `.csv`, o arquivo inteiro pode ficar corrompido. | **Transações ACID e Logs (WAL/Redo):** Ou a operação inteira é concluída com sucesso (`COMMIT`), ou o banco volta ao estado íntegro anterior (`ROLLBACK`). |
| **4. Ausência de Integridade:** Alguém digita `"dez"` no campo de nota numérica ou cadastra uma matrícula para um curso que não existe. | **Tipagem Forte e Constraints:** O SGBD rejeita imediatamente tipos inválidos (`DECIMAL(5,2)`) e chaves estrangeiras inexistentes (`FOREIGN KEY`). |
| **5. Segurança Tudo-ou-Nada:** Quem tem a senha da planilha vê e altera todas as abas. | **Controle de Acesso Granular:** Cada usuário ou microsserviço recebe permissão apenas para as tabelas e operações que lhe cabem. |

---

## 3. Evolução Histórica dos Modelos de Dados

A forma como estruturamos bancos de dados evoluiu ao longo de sete décadas para resolver limitações reais de hardware e negócios:

```text
[1950-1960: Arquivos Planos] ---> [1960: Modelo Hierárquico] ---> [Fim 1960: Modelo em Rede] ---> [1970: Modelo Relacional] ---> [2000+: NoSQL & NewSQL]
 (Fitas magnéticas, .txt)          (Árvore rígida Pai -> Filho)    (Grafos com ponteiros)          (Tabelas, PK/FK e SQL)         (Documentos, Chave-Valor)
```

1. **Arquivos Planos (Anos 1950–1960):**
   * Dados gravados sequencialmente em fitas ou cartões perfurados. Para achar um cliente, o programa lia do início ao fim. Se uma coluna nova fosse adicionada, todos os programas em COBOL/Fortran precisavam ser reescritos.
2. **Modelo Hierárquico (Anos 1960 — ex.: IBM IMS):**
   * Criado durante o projeto Apollo da NASA para controlar milhões de peças do foguete Saturno V.
   * Organizava os registros como uma **árvore invertida** (`1 Pai : N Filhos`). Muito rápido para estruturas fixas, mas incapaz de representar relações onde um filho pertence a dois pais (como um aluno matriculado em vários cursos) sem duplicar dados.
3. **Modelo em Rede (Fim dos Anos 1960 — Padrão CODASYL):**
   * Permitiu que um registro filho tivesse múltiplos pais (`N:N`) por meio de **ponteiros físicos de disco** (listas encadeadas). Porém, o programador precisava conhecer o caminho físico exato dos ponteiros para fazer qualquer consulta.
4. **Modelo Relacional (1970 — Edgar Frank Codd):**
   * Pesquisador da IBM, **E. F. Codd** publicou o artigo histórico *"A Relational Model of Data for Large Shared Data Banks"*.
   * Sua proposta separou totalmente a **estrutura lógica** (tabelas com linhas e colunas) do **armazenamento físico em disco**. O desenvolvedor passou a declarar **o que** deseja buscar usando **SQL**, deixando para o SGBD descobrir **como** buscar da forma mais rápida.
5. **Bancos Não Relacionais — NoSQL (Anos 2000 em diante):**
   * Com a explosão da internet em escala global (Google, Amazon, redes sociais), surgiram bancos projetados para dados sem esquema fixo e distribuição horizontal em centenas de servidores.

---

## 4. Panorama: Bancos Relacionais (SQL) vs. Não Relacionais (NoSQL)

Na carreira de desenvolvedor Full Stack, você trabalhará com ambos os mundos. Eles não são inimigos: são ferramentas complementares para problemas diferentes.

### 4.1. As 4 Famílias Principais do NoSQL
* **Orientados a Documentos (ex.: MongoDB, CouchDB):** Armazenam dados em documentos estruturados no formato JSON/BSON. Cada documento pode ter campos diferentes.
* **Chave-Valor (ex.: Redis, Amazon DynamoDB):** Funcionam como um grande dicionário em memória de altíssima velocidade (`chave -> valor`), ideais para cache, carrinhos de compras temporários e sessões de login.
* **Colunares / Wide-Column (ex.: Apache Cassandra, HBase):** Otimizados para escrita e leitura massiva de séries temporais e telemetria.
* **Orientados a Grafos (ex.: Neo4j):** Armazenam nós e arestas, ideais para redes sociais, detecção de fraude bancária e sistemas de recomendação.

### 4.2. Quando escolher SQL e quando escolher NoSQL?

| Critério de Decisão | Escolha Banco Relacional (SQL) | Escolha Banco Não Relacional (NoSQL) |
| :--- | :--- | :--- |
| **Estrutura dos Dados** | Dados bem estruturados, previsíveis e com regras claras (alunos, matrículas, notas, faturas). | Dados semiestruturados ou polimórficos (catálogo de e-commerce onde cada produto tem atributos únicos). |
| **Relacionamentos** | Forte presença de vínculos entre entidades (`JOINs` frequentes entre 3 ou mais tabelas). | Dados lidos de forma agregada em um único documento ou por chave direta. |
| **Integridade e Transações** | Exigência rigorosa de consistência imediata (financeiro, estoque, matrículas acadêmicas). | Alta taxa de ingestão onde consistência eventual é aceitável (logs de cliques, IoT, métricas). |
| **Linguagem de Consulta** | Padronizada universalmente (**SQL**). | APIs e linguagens próprias de cada fabricante (MQL no MongoDB, Cypher no Neo4j). |

---

## 5. Para Saber Mais

* **Artigo Clássico:** E. F. Codd (1970), *"A Relational Model of Data for Large Shared Data Banks"* (Communications of the ACM).
* **Leitura Complementar na Apostila:** Consulte a [Unidade 1 da Apostila Completa](../apostila.md#unidade-1-fundamentos-de-bancos-de-dados-e-sgbds) e o [Glossário do Módulo](../docs/glossario-e-guia-de-estudo.md).
* **Próximo Passo Prático:** Siga agora para o [Laboratório da Aula 01](./laboratorio.md) para colocar os conceitos em prática.

