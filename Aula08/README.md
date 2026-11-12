# Aula 08: Recursos Avançados de SQL (`Views`, `Índices`, `Transações`, `Stored Procedures`, `Funções` e `Triggers`) e Revisão Geral

**Data Oficial:** `11/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Criar e gerenciar **Views (Visões)** para simplificar consultas multi-tabelas e proteger dados sensíveis.
2. Projetar **Índices (`INDEX`)** e analisar planos de execução com `EXPLAIN` para evitar leituras sequenciais lentas (*Full Table Scan*).
3. Controlar **Transações ACID** com `START TRANSACTION`, `COMMIT` e `ROLLBACK`.
4. Automatizar regras de negócio dentro do SGBD utilizando **Stored Procedures**, **Funções (`FUNCTION`)** e **Triggers (Gatilhos)**.
5. Consolidar a arquitetura de dados exigida pelo **Projeto Integrador** do módulo.

---

## 1. Views (Visões): Tabelas Virtuais Inteligentes

Na Aula 07 vimos que exibir o boletim completo de um aluno exige juntar 5 ou 6 tabelas (`alunos`, `matriculas`, `turmas`, `cursos`, `professores` e `notas`). Seria improdutivo repetir um `SELECT` de 20 linhas em todas as telas da sua aplicação web.

Uma **`VIEW` (Visão)** salva essa consulta no dicionário de dados do SGBD com um nome próprio. Para quem consulta, a `VIEW` se comporta exatamente como uma tabela pronta!

```text
+-----------------------------------------------------------------------+
|  Tabelas Físicas: [alunos] + [matriculas] + [turmas] + [cursos] + [notas] |
+-----------------------------------------------------------------------+
                                    |
                                    v  (JOIN salvo no SGBD)
+-----------------------------------------------------------------------+
|  Tabela Virtual (VIEW): vw_boletim_escolar                            |
|  -> A aplicação faz apenas: SELECT * FROM vw_boletim_escolar;         |
+-----------------------------------------------------------------------+
```

### Três Motivos para Usar Views no seu Projeto Integrador
1. **Reaproveitamento e Simplicidade:** Sua API Node.js faz um simples `SELECT * FROM vw_boletim_escolar WHERE id_aluno = 1` sem precisar montar 5 `JOINs` no código JavaScript.
2. **Segurança e Privacidade (LGPD):** Você pode criar uma `vw_alunos_publico` expondo apenas `id_aluno`, `nome` e `cidade`, ocultando colunas sensíveis como `cpf`, `telefone` e `data_nascimento`.
3. **Desacoplamento:** Se uma tabela interna mudar, você ajusta a definição da `VIEW` mantendo o contrato de colunas para o front-end.

```sql
CREATE OR REPLACE VIEW vw_boletim_escolar AS
SELECT a.id_aluno,
       a.nome AS aluno,
       c.nome AS curso,
       t.nome_turma,
       t.periodo,
       t.turno,
       p.nome AS professor,
       m.status AS status_matricula,
       n.nota1,
       n.nota2,
       n.nota3,
       n.media,
       CASE
           WHEN n.media >= 7.00 THEN 'Aprovado'
           WHEN n.media >= 5.00 THEN 'Recuperação'
           ELSE 'Reprovado'
       END AS situacao_final
FROM matriculas m
INNER JOIN alunos a      ON m.id_aluno = a.id_aluno
INNER JOIN turmas t      ON m.id_turma = t.id_turma
INNER JOIN cursos c      ON t.id_curso = c.id_curso
INNER JOIN professores p ON t.id_professor = p.id_professor
LEFT JOIN  notas n       ON m.id_matricula = n.id_matricula;

-- Agora basta consultar a View:
SELECT aluno, curso, media, situacao_final
FROM vw_boletim_escolar
WHERE turno = 'Noturno'
ORDER BY media DESC;
```

---

## 2. Índices (`INDEX`): Otimização de Performance

Imagine procurar o capítulo sobre *"Transações"* em um livro de 800 páginas que **não tem sumário nem índice remissivo**: você teria de folhear página por página desde a página 1 (**Full Table Scan**). Com o índice no final do livro, você vai direto para a página certa em segundos!

No banco de dados, um **Índice (`INDEX`)** cria uma estrutura de árvore balanceada (**B-Tree**) ordenada pelos valores da coluna escolhida:

```text
Sem Índice (Full Table Scan - O(N)):
Lê linha 1 -> Lê linha 2 -> Lê linha 3 -> ... -> Lê linha 1.000.000

Com Índice B-Tree (Index Seek - O(log N)):
             [ M ]
           /       \
       [ F ]       [ S ]
      /     \     /     \
   [Boa Vista]             --> Vai direto aos registros de 'Boa Vista' em ~3 saltos!
```

### Boas Práticas de Indexação
* **Já possuem índice automático no MySQL:** Toda coluna declarada como `PRIMARY KEY`, `UNIQUE` ou `FOREIGN KEY` já ganha um índice automaticamente.
* **Onde você deve criar índices manualmente (`CREATE INDEX`):**
  1. Colunas muito usadas em filtros `WHERE` (ex.: `cidade`, `status`, `data_matricula`).
  2. Colunas de busca textual por prefixo (`nome LIKE 'Ana%'`).
  3. Colunas muito usadas em ordenação (`ORDER BY`) e agrupamento (`GROUP BY`).
* **Quando NÃO criar índices em excesso:** Tabelas muito pequenas ou colunas que sofrem `UPDATE` a cada segundo e quase nunca são usadas em filtros `WHERE` (pois cada índice criado adiciona um pequeno trabalho extra na hora do `INSERT`/`UPDATE`/`DELETE`).

```sql
-- Criando um índice na coluna cidade da tabela alunos
CREATE INDEX idx_alunos_cidade ON alunos(cidade);

-- Criando um índice composto (cidade + nome)
CREATE INDEX idx_alunos_cidade_nome ON alunos(cidade, nome);

-- Listando todos os índices de uma tabela
SHOW INDEX FROM alunos;

-- Inspecionando se o otimizador do MySQL está usando o índice (coluna 'key' e 'rows')
EXPLAIN SELECT * FROM alunos WHERE cidade = 'Boa Vista';
```

---

## 3. Transações e as Propriedades ACID

Em sistemas reais, muitas operações de negócio exigem alterar **duas ou mais tabelas ao mesmo tempo**.
Por exemplo, ao matricular um aluno em uma turma com vagas limitadas ou ao lançar a matrícula junto com o registro inicial de notas: e se a primeira instrução `INSERT` funcionar, mas a energia acabar ou ocorrer um erro antes da segunda instrução? O banco ficaria pela metade!

Uma **Transação** agrupa vários comandos SQL em uma única caixa indivisível:

```text
START TRANSACTION
   ├── Passo 1: INSERT INTO matriculas ... (OK)
   ├── Passo 2: INSERT INTO notas ...      (OK)
   └── Tudo deu certo?
         ├── SIM ---> COMMIT   (Grava tudo definitivamente no disco)
         └── NÃO ---> ROLLBACK (Desfaz o Passo 1 e volta o banco ao estado original)
```

### As 4 Propriedades ACID
* **A — Atomicidade:** A transação é "tudo ou nada".
* **C — Consistência:** Nenhuma regra de integridade (`PK`, `FK`, `NOT NULL`, `CHECK`) pode ser quebrada ao final da transação.
* **I — Isolamento:** Transações simultâneas de dois usuários não enxergam dados inacabados uma da outra.
* **D — Durabilidade:** Uma vez executado o `COMMIT`, os dados estão salvos de forma permanente no log de disco do SGBD.

---

## 4. Stored Procedures, Funções e Triggers

Além de guardar dados, o SGBD permite programar rotinas que rodam diretamente dentro do servidor de banco de dados:

| Recurso | Como é acionado? | Principal Utilidade |
| :--- | :--- | :--- |
| **Stored Procedure** | Chamada explicitamente com `CALL nome_proc(...)` | Executar rotinas de negócio com múltiplos passos, parâmetros de entrada/saída e transações. |
| **Function (Função)** | Usada dentro de um `SELECT` (ex.: `SELECT fn_situacao(media)`) | Calcular e retornar um valor único reutilizável em consultas. |
| **Trigger (Gatilho)** | Disparado **automaticamente** pelo SGBD em um `INSERT`, `UPDATE` ou `DELETE` | Calcular colunas derivadas automaticamente (ex.: recalcular `media`) ou gravar tabelas de auditoria (log de quem alterou uma nota). |

### Exemplo 1: Stored Procedure para Matricular Aluno
```sql
DELIMITER $$
CREATE PROCEDURE sp_matricular_aluno(
    IN p_id_aluno INT,
    IN p_id_turma INT
)
BEGIN
    INSERT INTO matriculas (id_aluno, id_turma, data_matricula, status)
    VALUES (p_id_aluno, p_id_turma, CURDATE(), 'Ativo');
END$$
DELIMITER ;

-- Executando a Procedure:
-- CALL sp_matricular_aluno(1, 2);
```

### Exemplo 2: Trigger para Calcular a Média Automaticamente e Auditar Alterações
```sql
DELIMITER $$
CREATE TRIGGER trg_atualiza_media_before_update
BEFORE UPDATE ON notas
FOR EACH ROW
BEGIN
    SET NEW.media = ROUND((NEW.nota1 + NEW.nota2 + NEW.nota3) / 3, 2);
END$$
DELIMITER ;
```

---

## 5. Revisão Geral do Módulo (Aulas 01 a 08) e Conexão com o Projeto Integrador

Ao longo das 8 aulas percorremos todo o ciclo de engenharia de dados de uma aplicação Full Stack:

```text
[Aulas 01-02] Conceitos, SGBD, Entidades e Cardinalidades (1:1, 1:N, N:N)
      |
      v
[Aula 03]     Chaves (PK/FK), Normalização (1FN, 2FN, 3FN) e Desenho do DER
      |
      v
[Aula 04]     Construção Física em SQL (DDL: CREATE, ALTER, DROP e Constraints)
      |
      v
[Aula 05]     Manipulação CRUD (DML: INSERT, UPDATE, DELETE, WHERE, ORDER BY)
      |
      v
[Aula 06]     Relatórios Estatísticos (COUNT, SUM, AVG, MAX, MIN, GROUP BY, HAVING)
      |
      v
[Aula 07]     Cruzamento Relacional (INNER/LEFT/RIGHT JOIN e Subconsultas)
      |
      v
[Aula 08]     Performance, Segurança e Automação (Views, Índices, ACID, Triggers)
```

No **Projeto Integrador** ([`docs/projeto-integrador.md`](../docs/projeto-integrador.md)), sua equipe aplicará exatamente essa trilha sobre a base `escola_db`:
1. Entregar o **DER** atualizado na pasta `der/`.
2. Entregar os scripts SQL, consultas analíticas, views e melhorias na pasta `sql/`.
3. Conectar a aplicação (`app/`) exibindo os indicadores e listagens no ar (`infra/`).

---

## 6. Para Saber Mais

* **Script Completo da Aula 08:** Abra [`Aula08/recursos_avancados.sql`](./recursos_avancados.sql) no DBeaver.
* **Leitura na Apostila:** Revise a [Unidade 8 da Apostila Completa](../apostila.md#unidade-8-recursos-avançados-views-índices-transações-procedures-e-triggers).
* **Próximo Passo Prático:** Siga para o [Laboratório da Aula 08](./laboratorio.md) para criar Views, Índices, Transações e Triggers na base `escola_db`.

