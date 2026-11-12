# Gabarito - Aula 04: Linguagem SQL: Comandos DDL e Constraints

## Objetivo
Avaliar a escrita correta de scripts DDL no MySQL/DBeaver, respeitando a ordem correta de criação (tabelas pais antes de tabelas filhas), aplicação de constraints (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `DEFAULT`) e comandos de alteração (`ALTER TABLE`).

## Checklist de Verificação
- [ ] A base `escola_db.sql` foi executada e o DBeaver gerou o diagrama ER com sucesso?
- [ ] O script da Clínica Médica respeitou a ordem de dependências (primeiro `especialidades` e `pacientes`, depois `medicos`, e por último `consultas`)?
- [ ] Todas as chaves estrangeiras possuem a cláusula `FOREIGN KEY (...) REFERENCES ...` correta?
- [ ] Os comandos `ALTER TABLE` foram executados com a sintaxe apropriada?

---

## Solução do Laboratório

### Etapa 2: Script DDL Completo (`clinica_medica.sql`)

```sql
CREATE DATABASE IF NOT EXISTS clinica_medica;
USE clinica_medica;

-- 1. Tabela Especialidades (Tabela Pai de Médicos)
CREATE TABLE especialidades (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE,
    descricao VARCHAR(200)
);

-- 2. Tabela Médicos (Depende de Especialidades)
CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    id_especialidade INT NOT NULL,
    CONSTRAINT fk_medico_especialidade
        FOREIGN KEY (id_especialidade) REFERENCES especialidades(id_especialidade)
);

-- 3. Tabela Pacientes (Independente)
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(80) DEFAULT 'Boa Vista'
);

-- 4. Tabela Consultas (Depende de Pacientes e Médicos)
CREATE TABLE consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    observacoes TEXT,
    CONSTRAINT fk_consulta_paciente
        FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    CONSTRAINT fk_consulta_medico
        FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);
```

### Etapa 3: Evolução de Esquema (`ALTER TABLE`)
```sql
-- Adicionar coluna valor da consulta:
ALTER TABLE consultas ADD COLUMN valor DECIMAL(10,2) DEFAULT 0.00 AFTER status;

-- Adicionar índice para acelerar busca por CRM:
CREATE INDEX idx_medicos_crm ON medicos(crm);
```

---

## Pontos Comuns de Dificuldade
* **Erro de criação de FK (Error 1215 / 1005):** Ocorre se o aluno tentar criar a tabela `medicos` antes de `especialidades`, ou se os tipos de dados das colunas referenciadas não forem rigorosamente idênticos (`INT` com `INT`).
