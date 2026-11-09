# Laboratório Prático 04: Construção Física de Bancos de Dados com SQL DDL

**Aula de Referência:** [Aula 04 — Linguagem SQL: Comandos DDL e Constraints](./README.md)  
**Tempo Estimado:** 120 minutos  
**Ferramentas:** MySQL / MariaDB + DBeaver Community  
**Script de Apoio:** [`schema_ddl.sql`](./schema_ddl.sql)  

---

## Objetivos do Laboratório

1. Conectar o **DBeaver** ao servidor MySQL local e importar a base oficial [`base/escola_db.sql`](../base/escola_db.sql).
2. Inspecionar chaves primárias, chaves estrangeiras e o diagrama ER gerado pelo próprio SGBD.
3. Escrever do zero o script DDL (`CREATE DATABASE`, `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`) para o estudo de caso da **Clínica Médica**.
4. Praticar evoluções de esquema com `ALTER TABLE`.

---

## Etapa 1: Subindo e Inspecionando o Banco Oficial `escola_db` (30 min)

1. Abra o **DBeaver** e conecte-se à sua instância MySQL/MariaDB.
2. Abra o arquivo [`base/escola_db.sql`](../base/escola_db.sql) do nosso repositório (`File -> Open File...`) ou copie seu conteúdo para um novo **Editor SQL** (`Alt + ]`).
3. Execute o script completo (`Alt + X`).
4. No painel esquerdo (**Database Navigator**), clique com o botão direito em **Databases -> Refresh (F5)** e expanda o banco **`escola_db`**.

### Tarefa 1.1: Comandos de Verificação Estrutural
Abra uma nova aba SQL conectada ao banco `escola_db` e execute os comandos abaixo, anotando o que cada um retorna:

```sql
USE escola_db;

-- 1. Verifique as 6 tabelas criadas
SHOW TABLES;

-- 2. Inspecione a estrutura das tabelas matriculas e notas
DESCRIBE matriculas;
DESCRIBE notas;

-- 3. Veja as constraints de chave estrangeira geradas na tabela turmas
SHOW CREATE TABLE turmas;
```

> **Dica Visual no DBeaver:** Dê um duplo clique sobre o banco `escola_db` no navegador lateral e clique na aba **ER Diagram**. Compare o diagrama gerado automaticamente pelo DBeaver com o DER da nossa apostila!

---

## Etapa 2: Mão na Massa DDL — Codificando o Banco `clinica_medica` (45 min)

Na Aula 03 você desenhou o DER da **Clínica Médica Vida Boa Vista**. Agora é hora de transformá-lo em código SQL real!

### Tarefa 2.1: Escreva e Execute o Script DDL
Crie um novo script no DBeaver e implemente o banco `clinica_medica` obedecendo rigorosamente às seguintes regras:

1. Crie o banco `clinica_medica` e selecione-o com `USE clinica_medica;`.
2. **Tabela `especialidades`:**
   * `id_especialidade`: inteiro, auto incremento, chave primária.
   * `nome`: texto até 80 caracteres, preenchimento obrigatório (`NOT NULL`) e único (`UNIQUE`).
   * `descricao`: texto até 200 caracteres.
3. **Tabela `medicos`:**
   * `id_medico`: inteiro, auto incremento, chave primária.
   * `nome`: texto até 120 caracteres, obrigatório.
   * `crm`: texto até 20 caracteres, obrigatório e único (`UNIQUE`).
   * `telefone`: texto até 20 caracteres.
   * `id_especialidade`: inteiro, obrigatório, **Chave Estrangeira** apontando para `especialidades(id_especialidade)`.
4. **Tabela `pacientes`:**
   * `id_paciente`: inteiro, auto incremento, chave primária.
   * `nome`: texto até 120 caracteres, obrigatório.
   * `cpf`: texto fixo de 11 caracteres (`CHAR(11)`), obrigatório e único (`UNIQUE`).
   * `data_nascimento`: data (`DATE`), obrigatório.
   * `telefone`: texto até 20 caracteres.
   * `cidade`: texto até 80 caracteres, valor padrão (`DEFAULT`) `'Boa Vista'`.
5. **Tabela `consultas`:**
   * `id_consulta`: inteiro, auto incremento, chave primária.
   * `id_paciente`: inteiro, obrigatório, **Chave Estrangeira** apontando para `pacientes(id_paciente)`.
   * `id_medico`: inteiro, obrigatório, **Chave Estrangeira** apontando para `medicos(id_medico)`.
   * `data_consulta`: data e hora (`DATETIME`), obrigatório.
   * `status`: texto até 20 caracteres, obrigatório, valor padrão `'Agendada'`.
   * `observacoes`: texto longo (`TEXT`).

---

## Etapa 3: Evoluindo o Esquema com `ALTER TABLE` (25 min)

Depois que o banco `clinica_medica` entrou em testes, o diretor da clínica solicitou três ajustes na estrutura das tabelas:

### Tarefa 3.1: Execute as Alterações Estruturais
Escreva os comandos `ALTER TABLE` para atender aos três pedidos abaixo sem apagar as tabelas:

1. Adicionar a coluna `email VARCHAR(120) UNIQUE` na tabela `pacientes`.
2. Adicionar a coluna `valor_consulta DECIMAL(10,2) DEFAULT 150.00` na tabela `consultas`.
3. Adicionar a coluna `convenio VARCHAR(60) DEFAULT 'Particular'` na tabela `pacientes` e, em seguida, confirmar com `DESCRIBE pacientes;` se as novas colunas aparecem na estrutura.

---

## Etapa 4: Teste de Ordem de Exclusão e Integridade (20 min)

No banco `clinica_medica`, tente executar mentalmente (ou em uma tabela de teste):
1. O que acontece se você tentar rodar `DROP TABLE especialidades;` enquanto a tabela `medicos` ainda existir apontando para ela?
2. Qual é a ordem exata em que as 4 tabelas da clínica precisariam ser removidas caso você quisesse recriar o banco do zero?

---

## Desafio Extra

No banco `escola_db`, crie uma tabela extra chamada `laboratorios_informatica` para controlar as salas práticas do ITEAM:
* `id_laboratorio` (`INT AUTO_INCREMENT PRIMARY KEY`)
* `nome_sala` (`VARCHAR(50) NOT NULL UNIQUE`)
* `capacidade_maquinas` (`INT NOT NULL CHECK (capacidade_maquinas >= 10)`)
* `possui_projetor` (`BOOLEAN DEFAULT TRUE`)

Em seguida, use `ALTER TABLE turmas` para adicionar uma coluna opcional `id_laboratorio INT NULL` que seja chave estrangeira referenciando `laboratorios_informatica(id_laboratorio)`.

