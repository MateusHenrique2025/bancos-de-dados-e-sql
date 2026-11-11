# Laboratório Prático 05: Operações CRUD (DML), Filtros com `WHERE` e Ordenação (`ORDER BY`)

**Aula de Referência:** [Aula 05 — Linguagem SQL: Comandos DML, `WHERE` e `ORDER BY`](./README.md)  
**Tempo Estimado:** 120 minutos  
**Base de Dados:** `escola_db` ([`base/escola_db.sql`](../base/escola_db.sql))  
**Script de Apoio:** [`pratica_dml.sql`](./pratica_dml.sql)  

---

## Objetivos do Laboratório

1. Executar inserções (`INSERT`), atualizações seguras (`UPDATE`) e exclusões (`DELETE`) na base `escola_db`.
2. Dominar filtros combinados (`WHERE`, `AND`, `OR`, `IN`, `BETWEEN`, `LIKE`).
3. Resolver a **Parte 1 (`WHERE` e `ORDER BY`)** da lista de exercícios de consultas SQL do repositório.

---

## Etapa 1: Prática de Escrita Segura (`INSERT`, `UPDATE`, `DELETE`) (40 min)

Certifique-se de que o banco `escola_db` está selecionado no DBeaver (`USE escola_db;`) e realize as seguintes tarefas:

### Tarefa 1.1: Cadastrando Novos Registros (`INSERT`)
1. Cadastre você mesmo(a) e um colega da dupla na tabela `alunos` informando `nome`, `cpf`, `email`, `telefone`, `data_nascimento`, `cidade` e `data_cadastro` (`CURDATE()`).
2. Confira o `id_aluno` gerado para você usando:
   ```sql
   SELECT * FROM alunos ORDER BY id_aluno DESC LIMIT 5;
   ```
3. Cadastre uma nova matrícula na tabela `matriculas` vinculando o seu `id_aluno` à turma de código `id_turma = 1` com `status = 'Ativo'`.

### Tarefa 1.2: Atualização Segura em 2 Passos (`UPDATE`)
1. Primeiro, faça um `SELECT` filtrando pelo seu `id_aluno` recém-criado.
2. Em seguida, escreva um comando `UPDATE` para atualizar o seu `telefone` e `email` filtrando estritamente por `WHERE id_aluno = <seu_id>`.

### Tarefa 1.3: Exclusão de Teste (`DELETE`)
1. Tente executar `DELETE FROM alunos WHERE id_aluno = <seu_id>;` enquanto sua matrícula existir na tabela `matriculas`. Anote a mensagem de erro que o MySQL retornou e explique por que ele protegeu o registro.
2. Agora remova primeiro a matrícula que você criou no teste (`DELETE FROM matriculas WHERE id_matricula = <id_da_matricula_teste>;`) e verifique que a integridade foi respeitada.

---

## Etapa 2: Lista Oficial de Exercícios — Parte 1 (`WHERE` e `ORDER BY`) (40 min)

Abra o arquivo [`atividades/consultas_sql_avancadas.sql.md`](../atividades/consultas_sql_avancadas.sql.md) e escreva as consultas SQL no DBeaver para responder às **5 questões da Parte 1**:

1. **Questão 1:** Liste todos os alunos cadastrados em ordem alfabética pelo nome (`ASC`).
2. **Questão 2:** Liste apenas os alunos da cidade de `'Boa Vista'`, ordenados pelo nome.
3. **Questão 3:** Liste as turmas do período `'2026.1'`, ordenadas pelo turno.
4. **Questão 4:** Liste os cursos da área de `'Desenvolvimento Web'`, ordenados pelo nome.
5. **Questão 5:** Liste os professores cuja área de atuação é `'Banco de Dados'`.

---

## Etapa 3: Filtros Avançados de Investigação no `escola_db` (40 min)

Elabore consultas SQL para responder às seguintes perguntas da secretaria acadêmica:

1. **Busca por Padrão (`LIKE`):** Liste o `id_aluno`, `nome` e `email` de todos os alunos cujo nome começa com a letra `'M'` ou contém o sobrenome `'Silva'`.
2. **Filtro por Lista (`IN`):** Liste o `nome` e a `cidade` dos alunos que moram no interior do estado (`'Rorainópolis'`, `'Caracaraí'`, `'Mucajaí'` ou `'Pacaraima'`).
3. **Filtro por Intervalo (`BETWEEN`):** Liste todas as avaliações da tabela `notas` cuja `media` esteja entre `8.00` e `10.00`, ordenando da maior média para a menor (`DESC`).
4. **Ranking Paginado (`LIMIT`):** Exiba os 10 alunos mais jovens da escola (dica: ordene pela coluna `data_nascimento DESC` e aplique `LIMIT 10`).

---

## Desafio Extra

Escreva uma única consulta SQL na tabela `notas` que exiba o `id_matricula`, `nota1`, `nota2`, `nota3`, `media` e uma coluna calculada chamada `pontos_para_dez` (`10.00 - media`) apenas para os registros que tiveram pelo menos uma das três notas igual a `10.00` ou cuja média ficou abaixo de `6.00`.

