# Laboratório Prático 02: Mapeamento de Entidades, Atributos e Cardinalidades

**Aula de Referência:** [Aula 02 — Arquitetura de SGBD e Modelagem Conceitual](./README.md)  
**Tempo Estimado:** 90 minutos  
**Ferramentas:** Caderno/Markdown e DBeaver (ou editor SQL)  

---

## Objetivos do Laboratório

1. Classificar atributos reais em **simples**, **compostos**, **multivalorados**, **derivados** e **identificadores**.
2. Levantar entidades e determinar cardinalidades (`1:1`, `1:N` e `N:N`) a partir de requisitos de negócio.
3. Decompor relacionamentos `N:N` em tabelas associativas.
4. Inspecionar a estrutura das tabelas da base oficial [`base/escola_db.sql`](../base/escola_db.sql).

---

## Etapa 1: Classificação de Atributos (20 min)

Uma secretaria escolar levantou a seguinte ficha cadastral para os alunos do ITEAM:
* `id_aluno` (código numérico gerado pelo sistema)
* `cpf`
* `nome_completo`
* `data_nascimento`
* `idade_atual`
* `endereco_residencial` (contendo rua, número, bairro, cidade e CEP)
* `telefones_contato` (podendo informar até 3 números de telefone)
* `email_institucional`

### Tarefa 1.1: Preencha a Matriz de Classificação
Para cada atributo da ficha acima, indique:
1. Qual a sua classificação (**Identificador**, **Simples**, **Composto**, **Multivalorado** ou **Derivado**)?
2. Como você o representaria em uma tabela relacional (manteria como uma coluna única, dividiria em várias colunas, criaria outra tabela ou calcularia na hora da consulta)?

---

## Etapa 2: Modelagem Conceitual de Cenários Reais (40 min)

Para cada um dos dois cenários abaixo, identifique:
* As **Entidades** principais.
* Os **Atributos** de cada entidade (destacando o atributo identificador com `[PK]`).
* Os **Relacionamentos** e suas **Cardinalidades** (`1:1`, `1:N` ou `N:N`).

### Cenário A: Sistema de E-Commerce Regional ("Roraima Shop")
> *"A loja virtual vende produtos organizados por categorias. Cada categoria (ex.: Informática, Livros, Eletrodomésticos) possui um código e um nome. Cada produto possui código, nome, preço unitário, quantidade em estoque e pertence a uma única categoria. Os clientes cadastram código, nome, CPF, e-mail e cidade. Um cliente pode realizar vários pedidos de compra ao longo do tempo, mas cada pedido pertence a um único cliente. Além disso, um pedido pode conter vários produtos diferentes, e um mesmo produto pode aparecer em vários pedidos diferentes, registrando-se a quantidade comprada e o preço praticado naquele pedido."*

**Perguntas orientadoras do Cenário A:**
1. Qual é a cardinalidade entre `Categoria` e `Produto`?
2. Qual é a cardinalidade entre `Cliente` e `Pedido`?
3. Qual é a cardinalidade entre `Pedido` e `Produto`? Que tabela associativa precisa nascer entre eles e quais colunas ela terá?

---

### Cenário B: Sistema de Gestão de Eventos e Oficinas ("TechRR")
> *"O evento tecnológico oferece diversas oficinas práticas (código, título, carga horária e sala). Cada oficina é ministrada por um único instrutor (código, nome, especialidade), sendo que um instrutor pode ministrar várias oficinas em horários diferentes. Os participantes (código, nome, CPF, instituição) podem se inscrever em várias oficinas, e cada oficina recebe até 30 participantes. Para cada inscrição, o sistema precisa registrar a data/hora da inscrição e se o participante esteve presente (`presenca`: Sim/Não)."*

**Perguntas orientadoras do Cenário B:**
1. Liste as 4 tabelas que resultarão desse modelo após resolver o relacionamento `N:N`.
2. Onde ficará guardado o atributo `presenca`: na tabela de participantes, na tabela de oficinas ou na tabela associativa de inscrições? Por quê?

---

## Etapa 3: Inspeção Guiada do `escola_db.sql` no DBeaver (30 min)

Abra o arquivo [`base/escola_db.sql`](../base/escola_db.sql) e observe as linhas 1 a 65 (onde estão os comandos `CREATE TABLE`):

```sql
CREATE TABLE turmas (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    id_professor INT NOT NULL,
    nome_turma VARCHAR(50) NOT NULL,
    periodo VARCHAR(20) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);
```

### Tarefa 3.1: Engenharia Reversa do Esquema
Responda com base no código SQL do arquivo `base/escola_db.sql`:
1. Na tabela `turmas`, quais colunas apontam para outras tabelas (`FOREIGN KEY`)?
2. Como o arquivo `escola_db.sql` resolveu o relacionamento `N:N` entre `alunos` e `turmas`? Qual é o nome da tabela intermediária?
3. Observe a tabela `notas`: ela se liga diretamente à tabela `alunos` ou à tabela `matriculas`? Explique por que ligar `notas` a `matriculas` é uma decisão de modelagem mais inteligente do que ligar diretamente ao `id_aluno`.

---

## Desafio Extra

Um aluno sugeriu adicionar a coluna `nome_professor` diretamente dentro da tabela `turmas` (além do `id_professor`), alegando que assim seria mais fácil saber o nome do professor sem consultar a tabela `professores`.
Com base no que aprendemos nas Aulas 01 e 02, explique qual anomalia acontecerá no banco de dados se a professora `"Ana Paula Souza"` alterar seu nome de casada e ela for responsável por 12 turmas diferentes.

