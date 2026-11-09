# Atividade Diagnóstica e de Nivelamento: Fundamentos de Bancos de Dados

**Disciplina:** Módulo 09 — Bancos de Dados e SQL (ITEAM)  
**Professor:** Janei Vieira Pereira  
**Momento de Aplicação:** Aulas 01 e 02  

---

## Objetivo da Atividade
Avaliar a compreensão inicial sobre o papel dos dados em sistemas de informação, as limitações do controle manual em planilhas e os conceitos fundamentais de SGBDs e modelagem conceitual.

---

## Questões Discursivas e Práticas

### Questão 1: Dado vs. Informação no Cotidiano
Considere os seguintes elementos isolados anotados em um caderno de uma clínica em Boa Vista:
* `'14:30'`
* `'Dr. Roberto Mendes'`
* `'Cardiologia'`
* `'Maria Helena Costa'`

a) Por que esses elementos isolados são classificados como **dados**?  
b) Redija uma frase ou estruture um registro que transforme esses dados em uma **informação** útil para a recepção da clínica.

---

### Questão 2: Banco de Dados vs. SGBD
Muitas vezes, no dia a dia, os termos "Banco de Dados" e "SGBD" são usados como sinônimos, mas possuem papéis distintos na engenharia de software.
Explique com suas palavras a diferença entre o **Banco de Dados** e o **Sistema Gerenciador de Banco de Dados (SGBD)**, citando pelo menos **três exemplos** de SGBDs utilizados no mercado.

---

### Questão 3: Da Planilha para o Banco de Dados
Uma escola profissionalizante controla todas as matrículas de seus 800 alunos em uma única planilha compartilhada na rede local. Nas últimas semanas, a secretaria relatou três problemas:
1. Dois atendentes abriram a planilha ao mesmo tempo e um sobrescreveu o cadastro feito pelo outro.
2. O nome do curso `"Desenvolvimento Web"` foi digitado de quatro formas diferentes (`"Desenv. Web"`, `"Dev Web"`, `"Desenvolvimento Web"`, `"Desenvolvimento  Web"`), impedindo a contagem correta de alunos por curso.
3. Um funcionário apagou a linha de um professor e perdeu todo o histórico de quais turmas ele havia lecionado.

Explique como a adoção de um **SGBD Relacional** resolve cada um desses três problemas.

---

### Questão 4: SQL vs. NoSQL
Para cada um dos cenários abaixo, indique se a escolha mais adequada é um **Banco de Dados Relacional (SQL)** ou um **Banco de Dados Não Relacional (NoSQL)** e justifique sua resposta:
* **Cenário A:** Sistema de controle acadêmico e emissão de histórico escolar com notas, matrículas, cursos e cálculo de aprovação.
* **Cenário B:** Coleta em tempo real de leituras de temperatura enviadas a cada segundo por 50 mil sensores espalhados pela rede elétrica, onde o formato dos pacotes varia conforme o fabricante do sensor.

---

### Questão 5: Mapeamento Inicial de Entidades e Cardinalidades
Analise as regras de negócio do sistema acadêmico `escola_db`:
* Um **Curso** pode abrir várias **Turmas**, mas cada **Turma** refere-se a apenas um **Curso**.
* Um **Professor** pode ministrar aulas em várias **Turmas**, mas cada **Turma** possui um único **Professor** titular.
* Um **Aluno** pode se matricular em várias **Turmas**, e uma **Turma** recebe vários **Alunos**.

Identifique a cardinalidade (`1:1`, `1:N` ou `N:N`) de cada um dos três relacionamentos acima e explique o que acontece no banco de dados relacional para resolver o relacionamento entre **Aluno** e **Turma**.

