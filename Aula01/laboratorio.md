# Laboratório Prático 01: Do Caos das Planilhas à Estrutura de um Banco de Dados

**Aula de Referência:** [Aula 01 — Introdução a Bancos de Dados](./README.md)  
**Tempo Estimado:** 90 minutos  
**Modalidade:** Individual ou em dupla  

---

## Objetivos do Laboratório

1. Transformar registros brutos (**dados**) em relatórios contextualizados (**informações**).
2. Diagnosticar falhas reais de redundância, inconsistência e integridade em uma planilha de controle escolar.
3. Propor a separação inicial das informações em **entidades (tabelas)** independentes.
4. Decidir tecnicamente entre arquiteturas **SQL** e **NoSQL** para módulos de um sistema real.

---

## Etapa 1: Auditoria da "Planilha do Caos" (30 min)

Antes de contratarem a sua equipe de desenvolvimento, a coordenação de uma escola técnica em Boa Vista controlava todas as matrículas e notas em uma única aba de planilha chamada `Controle_Geral_2026.xlsx`:

| Linha | Aluno | CPF | Cidade | Curso | Carga Horária | Professor | Email Professor | Nota Final |
| :---: | :--- | :--- | :--- | :--- | :---: | :--- | :--- | :---: |
| 1 | Lucas Andrade | 111.222.333-44 | Boa Vista | Banco de Dados e SQL | 32h | Janei Pereira | janei@iteam.br | 9.0 |
| 2 | Lucas Andrade | 111.222.333-44 | B. Vista | Node.js e Express | 40h | Janei Pereira | janei.pereira@iteam.br | 8.5 |
| 3 | Camila Moura | 555.666.777-88 | Rorainópolis | Banco de Dados | 32 horas | Prof. Janei | janei@iteam.br | Dez |
| 4 | Pedro Santos | 111.222.333-44 | Boa Vista | Front-End React | - | Ana Paula Souza | ana@iteam.br | 7.5 |
| 5 | *(vazio)* | *(vazio)* | *(vazio)* | Python para Dados | 36h | Carlos Eduardo | carlos@iteam.br | *(vazio)* |

### Tarefa 1.1: Identificando Problemas Reais
Analise as 5 linhas da planilha acima e responda no seu caderno ou arquivo de notas:

1. **Redundância e Inconsistência de Cadastro:**
   * Observe o aluno `Lucas Andrade` nas linhas 1 e 2, e o professor `Janei Pereira` nas linhas 1, 2 e 3. Quais dados estão escritos de formas diferentes para a mesma pessoa ou mesmo curso?
   * Que problema isso causará se o diretor pedir um filtro na planilha por `"Boa Vista"` ou pelo curso `"Banco de Dados e SQL"`?
2. **Violação de Unicidade (Identificação):**
   * Compare o CPF de `Lucas Andrade` (linha 1) com o CPF de `Pedro Santos` (linha 4). O que aconteceu ali e por que a planilha aceitou esse erro silenciosamente?
3. **Violação de Domínio / Tipo de Dado:**
   * Observe a coluna `Nota Final` e `Carga Horária` na linha 3. Se você tentar calcular a média aritmética da coluna `Nota Final`, o que acontecerá por causa do valor `"Dez"`?
4. **Anomalia de Exclusão:**
   * Na linha 5, o curso `Python para Dados` do professor `Carlos Eduardo` ainda não teve alunos matriculados. Se alguém limpar as linhas "sem aluno", que informação importante da escola será perdida junto?

---

## Etapa 2: Separando as Entidades (30 min)

Para eliminar a repetição e as anomalias da planilha acima, vamos dividir aquela tabela única em cadastros separados.

### Tarefa 2.1: Projetando os Cadastros Separados
Desenhe (no papel, Markdown ou editor de texto) **4 tabelas separadas** chamadas `Alunos`, `Professores`, `Cursos` e `Matriculas`, distribuindo as colunas da planilha original para que:
* O nome, CPF e cidade do aluno sejam cadastrados **apenas uma vez**.
* O nome e e-mail do professor sejam cadastrados **apenas uma vez**.
* O nome e a carga horária do curso sejam cadastrados **apenas uma vez**.
* Cada registro tenha um código numérico único (`id_aluno`, `id_professor`, `id_curso`, `id_matricula`).

---

## Etapa 3: Decisão de Arquitetura SQL vs. NoSQL (20 min)

Você foi convidado para especificar o banco de dados de uma plataforma educacional em Roraima que terá três módulos distintos:

* **Módulo A — Secretaria Acadêmica e Financeiro:** Controla matrículas, emissão de boletos, pagamentos, notas oficiais e certificados. Não pode haver divergência de centavos nem notas duplicadas.
* **Módulo B — Sessões de Login e Cache de Perfil:** Precisa verificar em menos de 2 milissegundos se o token de autenticação do aluno está ativo a cada clique na plataforma.
* **Módulo C — Diário de Atividades e Telemetria de Vídeo:** Registra eventos de clique (*play, pause, velocidade 1.5x, mudança de resolução*) gerados pelo player de vídeo de milhares de alunos assistindo às aulas simultaneamente.

### Tarefa 3.1: Recomendação Justificada
Para cada módulo (`A`, `B` e `C`), responda:
1. Você escolheria um banco **Relacional (SQL)** ou **Não Relacional (NoSQL)**?
2. Qual tecnologia específica de mercado você recomendaria (ex.: MySQL/PostgreSQL, Redis, MongoDB/Cassandra)?
3. Qual característica técnica justifica sua escolha?

---

## Etapa 4: Atividade Diagnóstica de Nivelamento (10 min)

Conclua o laboratório respondendo às questões da [Atividade Diagnóstica e de Nivelamento](../atividades/atividade_nivelamento.md) para consolidar os conceitos da Aula 01.

---

## Desafio Extra

Abra a pasta [`base/escola_db.sql`](../base/escola_db.sql) do nosso repositório em um editor de texto (VS Code ou bloco de notas) apenas para leitura exploratória:
1. Quantos comandos `CREATE TABLE` existem dentro desse arquivo?
2. Liste os nomes das 6 tabelas que compõem o banco de dados oficial que usaremos ao longo do curso.

