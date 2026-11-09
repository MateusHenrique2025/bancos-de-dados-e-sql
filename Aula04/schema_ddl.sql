-- ============================================================================
-- ITEAM - Módulo 09: Bancos de Dados e SQL
-- Aula 04 (05/11/2026): Comandos DDL (CREATE, ALTER, DROP) e Constraints
-- Professor: Janei Vieira Pereira
-- ============================================================================

-- 1. Criação do banco de dados de demonstração DDL
CREATE DATABASE IF NOT EXISTS aula04_ddl_demo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE aula04_ddl_demo;

-- 2. Limpeza segura respeitando a ordem inversa das chaves estrangeiras (Filhas -> Pais)
DROP TABLE IF EXISTS matriculas_demo;
DROP TABLE IF EXISTS turmas_demo;
DROP TABLE IF EXISTS cursos_demo;
DROP TABLE IF EXISTS alunos_demo;

-- 3. Criação das tabelas independentes (Tabelas Pai)
CREATE TABLE alunos_demo (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(120) UNIQUE,
    data_nascimento DATE NOT NULL,
    cidade VARCHAR(80) NOT NULL DEFAULT 'Boa Vista',
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE cursos_demo (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    area VARCHAR(80) NOT NULL,
    carga_horaria INT NOT NULL,
    CONSTRAINT chk_carga_positiva CHECK (carga_horaria >= 8)
);

-- 4. Criação das tabelas dependentes (Tabelas Filhas com FOREIGN KEY)
CREATE TABLE turmas_demo (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    nome_turma VARCHAR(50) NOT NULL,
    periodo VARCHAR(20) NOT NULL DEFAULT '2026.2',
    turno VARCHAR(20) NOT NULL,
    CONSTRAINT fk_turma_curso_demo
        FOREIGN KEY (id_curso) REFERENCES cursos_demo(id_curso)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE matriculas_demo (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_matricula DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Ativo',
    CONSTRAINT uq_aluno_turma UNIQUE (id_aluno, id_turma),
    CONSTRAINT fk_mat_aluno_demo
        FOREIGN KEY (id_aluno) REFERENCES alunos_demo(id_aluno),
    CONSTRAINT fk_mat_turma_demo
        FOREIGN KEY (id_turma) REFERENCES turmas_demo(id_turma)
);

-- 5. Exemplos de evolução estrutural com ALTER TABLE
ALTER TABLE alunos_demo
ADD COLUMN telefone VARCHAR(25) AFTER email;

ALTER TABLE cursos_demo
ADD COLUMN modalidade VARCHAR(30) NOT NULL DEFAULT 'Presencial';

-- 6. Inspeção do dicionário de dados
SHOW TABLES;
DESCRIBE alunos_demo;
DESCRIBE matriculas_demo;

