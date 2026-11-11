# Aula 06: Funções Agregadas (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`), Agrupamentos (`GROUP BY`) e `HAVING`

**Data Oficial:** `09/11/2026`  
**Carga Horária:** 4 horas  
**Módulo:** 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  

---

## Objetivos de Aprendizagem

Ao final desta aula, você será capaz de:
1. Utilizar as 5 funções de agregação do SQL (`COUNT`, `SUM`, `AVG`, `MAX` e `MIN`) para extrair indicadores estatísticos.
2. Agrupar linhas por uma ou mais dimensões utilizando a cláusula `GROUP BY`.
3. Compreender a **ordem lógica de execução de uma query SQL** e diferenciar com precisão `WHERE` (filtro de linhas) e `HAVING` (filtro de grupos).
4. Construir relatórios gerenciais e acadêmicos sobre a base `escola_db`.

---

## 1. O que são Funções de Agregação?

Até a Aula 05, nossas consultas retornavam linhas individuais (uma linha para cada aluno ou para cada turma). Porém, gestores e dashboards precisam de **resumos consolidados**:
* *"Quantos alunos temos matriculados no total?"*
* *"Qual é a média geral de notas de cada turma?"*
* *"Qual cidade possui mais alunos ativos?"*

As **Funções Agregadas** recebem um conjunto de linhas como entrada e devolvem **um único valor resumido** por grupo:

```text
Linhas Individuais (Tabela NOTAS)          Função Agregada AVG(media)
+--------------+-------+                   +------------------------+
| id_matricula | media |                   |      media_geral       |
+--------------+-------+       ====>       +------------------------+
|      1       |  8.00 |                   |          8.50          |
|      2       |  9.00 |                   +------------------------+
|      3       |  8.50 |
+--------------+-------+
```

### Tabela de Referência das 5 Funções Agregadas

| Função | O que faz? | Comportamento com `NULL` | Exemplo Prático |
| :--- | :--- | :--- | :--- |
| **`COUNT(*)`** | Conta o total de linhas retornadas | Conta todas as linhas (mesmo com colunas `NULL`) | `SELECT COUNT(*) FROM alunos;` |
| **`COUNT(coluna)`** | Conta quantos valores preenchidos existem na coluna | Ignora valores `NULL` | `SELECT COUNT(telefone) FROM alunos;` |
| **`COUNT(DISTINCT col)`** | Conta quantos valores únicos diferentes existem | Ignora duplicatas e `NULL` | `SELECT COUNT(DISTINCT cidade) FROM alunos;` |
| **`SUM(coluna)`** | Soma todos os valores numéricos da coluna | Ignora `NULL` | `SELECT SUM(carga_horaria) FROM cursos;` |
| **`AVG(coluna)`** | Calcula a média aritmética dos valores | Ignora `NULL` | `SELECT ROUND(AVG(media), 2) FROM notas;` |
| **`MAX(coluna)`** | Encontra o maior valor (numérico, data ou texto) | Ignora `NULL` | `SELECT MAX(media) FROM notas;` |
| **`MIN(coluna)`** | Encontra o menor valor (numérico, data ou texto) | Ignora `NULL` | `SELECT MIN(media) FROM notas;` |

> **Dica de Formatação (`ROUND`):** A função `AVG()` costuma retornar muitas casas decimais (ex.: `7.833333`). Envolva com `ROUND(AVG(media), 2)` para arredondar para 2 casas decimais!

---

## 2. Agrupando Dados com `GROUP BY`

Se executarmos `SELECT COUNT(*) FROM alunos;`, obtemos um único número para a escola inteira. Mas e se quisermos saber **quantos alunos existem em cada cidade**?

Para isso usamos a cláusula `GROUP BY`. Ela separa os registros em "baldes" (grupos) que possuem o mesmo valor na coluna indicada e aplica a função agregada dentro de cada balde:

```text
Tabela ALUNOS                         GROUP BY cidade                  Resultado Agrupado
+----------+---------------+          +-------------------+            +---------------+--------------+
| nome     | cidade        |          | Balde: Boa Vista  | (3 alunos) | cidade        | total_alunos |
+----------+---------------+   ===>   +-------------------+    ===>    +---------------+--------------+
| Ana      | Boa Vista     |          | Balde: Pacaraima  | (2 alunos) | Boa Vista     |      3       |
| Bruno    | Pacaraima     |          +-------------------+            | Pacaraima     |      2       |
| Carla    | Boa Vista     |          | Balde: Cantá      | (1 aluno)  | Cantá         |      1       |
| Diego    | Boa Vista     |          +-------------------+            +---------------+--------------+
| Elena    | Pacaraima     |
| Fábio    | Cantá         |
+----------+---------------+
```

```sql
SELECT cidade,
       COUNT(*) AS total_alunos
FROM alunos
GROUP BY cidade
ORDER BY total_alunos DESC;
```

> **Regra Sintática Obrigatória do `GROUP BY`:**
> Toda coluna comum (não envolvida por `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) que aparecer no `SELECT` **deve obrigatoriamente aparecer no `GROUP BY`**.

### Agrupamento por Múltiplas Colunas
Você também pode agrupar por duas ou mais colunas simultaneamente (ex.: contar quantas turmas existem por `periodo` e por `turno`):

```sql
SELECT periodo,
       turno,
       COUNT(*) AS quantidade_turmas
FROM turmas
GROUP BY periodo, turno
ORDER BY periodo ASC, turno ASC;
```

---

## 3. Filtrando Grupos com `HAVING`: A Diferença Crucial para o `WHERE`

Uma das dúvidas mais comuns em provas e entrevistas técnicas de SQL é: *"Quando uso `WHERE` e quando uso `HAVING`?"*

A resposta fica cristalina quando entendemos a **Ordem Lógica de Execução** que o processador de consultas do SGBD segue:

```text
+-------------------------------------------------------------------------+
|               ORDEM LÓGICA DE EXECUÇÃO DE UMA CONSULTA SQL              |
+-------------------------------------------------------------------------+
|  1º -> FROM / JOIN   : Carrega as tabelas envolvidas.                   |
|  2º -> WHERE         : Filtra LINHAS INDIVIDUAIS (antes de agrupar!).   |
|  3º -> GROUP BY      : Junta as linhas restantes nos grupos ("baldes"). |
|  4º -> HAVING        : Filtra os GRUPOS já calculados (COUNT, AVG...).  |
|  5º -> SELECT        : Exibe as colunas escolhidas.                     |
|  6º -> ORDER BY      : Ordena o resultado final.                        |
|  7º -> LIMIT         : Corta a quantidade de linhas exibidas.           |
+-------------------------------------------------------------------------+
```

### Comparativo Direto: `WHERE` vs. `HAVING`

| Característica | Cláusula `WHERE` | Cláusula `HAVING` |
| :--- | :--- | :--- |
| **Momento de execução** | **Antes** do `GROUP BY` | **Depois** do `GROUP BY` |
| **O que ela filtra?** | Filtra **linhas individuais** da tabela | Filtra **grupos inteiros** gerados pelo `GROUP BY` |
| **Aceita funções agregadas (`COUNT`, `AVG`)?** | **NÃO!** (`WHERE COUNT(*) > 5` gera erro de sintaxe) | **SIM!** (`HAVING COUNT(*) > 5` ou `HAVING AVG(media) >= 7`) |

### Exemplo Combinando `WHERE` e `HAVING` na Mesma Consulta

Imagine que o coordenador pediu:
*"Considerando **apenas matrículas com status `'Ativo'`** (filtro de linha -> `WHERE`), mostre quais turmas possuem **4 ou mais alunos matriculados** (filtro de grupo -> `HAVING`)."*

```sql
SELECT id_turma,
       COUNT(*) AS total_matriculas_ativas
FROM matriculas
WHERE status = 'Ativo'          -- 1. Filtra linhas individuais antes de agrupar
GROUP BY id_turma               -- 2. Agrupa por turma
HAVING COUNT(*) >= 4            -- 3. Mantém apenas os grupos com 4 ou mais alunos
ORDER BY total_matriculas_ativas DESC;
```

---

## 4. Para Saber Mais

* **Script de Apoio da Aula:** Consulte [`Aula06/relatorios_agregados.sql`](./relatorios_agregados.sql) com consultas prontas para execução no DBeaver.
* **Leitura na Apostila:** Revise a [Unidade 6 da Apostila Completa](../apostila.md#unidade-6-funções-agregadas-agrupamento-group-by-e-having).
* **Próximo Passo Prático:** Siga para o [Laboratório da Aula 06](./laboratorio.md) para resolver as Partes 2 e 3 da lista oficial de consultas SQL.

