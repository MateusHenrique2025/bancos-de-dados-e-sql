# Laboratório Prático 03: Modelagem DER, Normalização (1FN a 3FN) e Revisão

**Aula de Referência:** [Aula 03 — Chaves, Integridade Referencial, Normalização e DER](./README.md)  
**Tempo Estimado:** 120 minutos  
**Ferramentas:** Draw.io (https://app.diagrams.net) ou dbdiagram.io + Editor Markdown  

---

## Objetivos do Laboratório

1. Projetar um **Diagrama Entidade-Relacionamento (DER)** completo na notação Pé de Galinha (*Crow's Foot*) a partir de um estudo de caso real.
2. Aplicar na prática as três formas normais (**1FN**, **2FN** e **3FN**) sobre uma planilha desnormalizada de biblioteca.
3. Fixar os conceitos das Aulas 01 a 03 por meio de um questionário técnico de revisão.

---

## Etapa 1: Construção de DER no Draw.io — Estudo de Caso "Clínica Médica Vida Boa Vista" (45 min)

Leia atentamente o levantamento de requisitos abaixo:

> **Requisitos da Clínica Médica:**
> 1. A clínica atende diversas **Especialidades Médicas** (código da especialidade, nome da especialidade e descrição).
> 2. Cada **Médico** possui código identificador, nome completo, número de CRM (único), telefone e atende em uma especialidade principal da clínica. Uma especialidade pode contar com vários médicos cadastrados.
> 3. Os **Pacientes** são cadastrados com código identificador, nome completo, CPF (único), data de nascimento, telefone e cidade.
> 4. Quando um paciente agenda um atendimento, registra-se uma **Consulta** contendo código da consulta, data e hora do atendimento, status (`Agendada`, `Realizada`, `Cancelada`) e observações clínicas.
> 5. Cada consulta envolve **um único paciente** e **um único médico**. Ao longo do tempo, um paciente pode realizar várias consultas e um médico atende várias consultas.

### Tarefa 1.1: Mapeamento e Desenho do DER
1. Abra o **Draw.io** (`https://app.diagrams.net`) e ative a biblioteca **Entity Relation ( Relações de Entidades )**.
2. Crie as **4 tabelas** do modelo (`especialidades`, `medicos`, `pacientes` e `consultas`).
3. Em cada tabela, indique claramente:
   * A **Chave Primária (`PK`)**.
   * As **Chaves Estrangeiras (`FK`)**.
   * Os tipos sugeridos para cada coluna (`INT`, `VARCHAR`, `CHAR`, `DATE`, `DATETIME`, `TEXT`).
4. Conecte as tabelas usando os conectores **Pé de Galinha (*Crow's Foot*)** indicando corretamente o lado `1` (`||`) e o lado `N` (`o<` ou `|<`).
5. Exporte o diagrama como imagem (`der_clinica_medica.png`) para utilizá-lo na Aula 04 quando formos criar essas tabelas em SQL!

---

## Etapa 2: Oficina de Normalização (1FN, 2FN e 3FN) — Sistema de Biblioteca (45 min)

Uma biblioteca comunitária controla seus empréstimos de livros na seguinte tabela única não normalizada (`Emprestimos_Brutos`):

| id_emprestimo | nome_aluno | cpf_aluno | id_curso | nome_curso | coordenador_curso | telefones_aluno | codigos_livros | titulos_livros | editoras_livros | cidades_editoras | data_emprestimo |
| :---: | :--- | :--- | :---: | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| 501 | Marcos Viana | 123.456.789-00 | 1 | Full Stack | Prof. Janei | `99111-1010, 99111-2020` | `L10, L25` | `Sistemas de BD, SQL Prático` | `Pearson, Novatec` | `São Paulo, São Paulo` | 2026-10-20 |
| 502 | Júlia Castro | 987.654.321-11 | 1 | Full Stack | Prof. Janei | `99222-3030` | `L10` | `Sistemas de BD` | `Pearson` | `São Paulo` | 2026-10-21 |

### Tarefa 2.1: Aplique as 3 Formas Normais Passo a Passo
No seu arquivo de resolução, documente a transformação dessa estrutura:

1. **Aplicando a 1FN (Primeira Forma Normal):**
   * Quais colunas possuem múltiplos valores na mesma célula (grupos repetitivos)?
   * Reescreva a estrutura separando os atributos multivalorados para garantir atomicidade.
2. **Aplicando a 2FN (Segunda Forma Normal):**
   * Na tabela de itens emprestados (cuja chave composta é `id_emprestimo + id_livro`), quais colunas dependem apenas do livro (`id_livro`) e quais dependem apenas do empréstimo (`id_emprestimo`)?
   * Separe em tabelas distintas eliminando todas as dependências parciais.
3. **Aplicando a 3FN (Terceira Forma Normal):**
   * Na tabela de alunos, `nome_curso` e `coordenador_curso` dependem diretamente do aluno ou dependem de `id_curso`?
   * Na tabela de livros, `cidade_editora` depende do livro ou depende da `editora`?
   * Escreva a lista final de tabelas na **3FN**, indicando `PK` e `FK` de cada uma.

---

## Etapa 3: Questionário Técnico de Revisão (30 min)

Responda às 10 questões de múltipla escolha abaixo para consolidar os conceitos de modelagem e chaves:

**Q1.** Qual é a função principal da **Chave Primária (`PRIMARY KEY`)** em uma tabela relacional?  
a) Permitir que uma coluna aceite valores repetidos para agrupar relatórios.  
b) Identificar cada registro da tabela de maneira única, não podendo conter valores nulos (`NULL`) nem duplicados.  
c) Conectar duas tabelas diferentes permitindo valores em branco.  
d) Ordenar alfabeticamente os nomes dos alunos.

**Q2.** Como um relacionamento **Muitos para Muitos (`N:N`)** entre `Alunos` e `Turmas` deve ser implementado fisicamente em um banco de dados relacional?  
a) Colocando várias colunas `id_turma1`, `id_turma2`, `id_turma3` dentro da tabela `Alunos`.  
b) Colocando uma lista de nomes de alunos separados por vírgula dentro da tabela `Turmas`.  
c) Criando uma tabela associativa intermediária (ex.: `Matriculas`) contendo chaves estrangeiras para `Alunos` e `Turmas`.  
d) Não é possível representar relacionamentos `N:N` em bancos SQL.

**Q3.** Uma tabela encontra-se na **Primeira Forma Normal (1FN)** quando:  
a) Todos os seus atributos contêm apenas valores atômicos (indivisíveis) e não há grupos repetitivos.  
b) Possui pelo menos três chaves estrangeiras.  
c) Não possui chave primária definida.  
d) Todos os seus campos são do tipo `VARCHAR`.

**Q4.** A **Segunda Forma Normal (2FN)** tem como foco principal:  
a) Transformar todas as tabelas do banco em uma única planilha.  
b) Apagar colunas de texto longo.  
c) Criar índices de busca automática.  
d) Garantir que a tabela esteja na 1FN e eliminar dependências funcionais parciais (quando um atributo não-chave depende apenas de parte de uma chave primária composta).

**Q5.** Quando um atributo não-chave depende de outro atributo não-chave (ex.: `cidade_editora` dependendo de `nome_editora` dentro da tabela `livros`), temos uma violação de qual Forma Normal?  
a) Forma Normal Zero (0FN).  
b) Terceira Forma Normal (3FN — dependência transitiva).  
c) Primeira Forma Normal (1FN).  
d) Nenhuma, pois isso é recomendado para economizar tabelas.

**Q6.** O que garante a propriedade de **Integridade Referencial** associada a uma `FOREIGN KEY`?  
a) Que a senha do banco de dados tenha pelo menos 8 caracteres.  
b) Que o banco faça backup automático a cada hora.  
c) Que nenhum valor de chave estrangeira aponte para um registro inexistente na tabela pai referenciada.  
d) Que os números decimais sejam arredondados automaticamente.

**Q7.** Na notação **Pé de Galinha (*Crow's Foot*)**, o que representa o símbolo de três pontas (`|<` ou `o<`) conectado a uma tabela?  
a) Que a tabela foi excluída do banco.  
b) O lado **"Muitos" (`N`)** do relacionamento.  
c) O lado **"Apenas Um" (`1`)** do relacionamento.  
d) Que a tabela não possui chave primária.

**Q8.** Em relação às restrições `PRIMARY KEY` e `UNIQUE` em uma tabela SQL, assinale a alternativa correta:  
a) Uma tabela pode ter várias `PRIMARY KEY`, mas apenas uma coluna `UNIQUE`.  
b) Ambas permitem cadastrar vários registros repetidos.  
c) Uma tabela pode ter apenas uma `PRIMARY KEY` (simples ou composta), mas pode ter várias colunas com a restrição `UNIQUE` (como `cpf` e `email`).  
d) Nenhuma das duas pode ser usada em colunas do tipo `VARCHAR`.

---

## Desafio Extra

Acesse a ferramenta gratuita **dbdiagram.io** (https://dbdiagram.io/d) e cole o bloco abaixo para ver o DER do nosso banco `escola_db` nascer automaticamente na tela:

```dbml
Table cursos {
  id_curso int [pk, increment]
  nome varchar(120)
  area varchar(80)
  carga_horaria int
}

Table professores {
  id_professor int [pk, increment]
  nome varchar(120)
  email varchar(120)
  area varchar(80)
}

Table turmas {
  id_turma int [pk, increment]
  id_curso int [ref: > cursos.id_curso]
  id_professor int [ref: > professores.id_professor]
  nome_turma varchar(50)
  periodo varchar(20)
  turno varchar(20)
}
```
Adicione ao código acima as tabelas `alunos`, `matriculas` e `notas` com suas respectivas referências `[ref: > ...]`.

