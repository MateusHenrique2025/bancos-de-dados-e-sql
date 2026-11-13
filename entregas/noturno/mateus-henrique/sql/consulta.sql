SELECT a.nome, a.email, t.nome_turma AS turma, m.data_matricula, n.media AS media_final
FROM alunos a
JOIN matriculas m ON a.id_aluno = m.id_aluno
JOIN turmas t ON m.id_turma = t.id_turma
LEFT JOIN notas n ON m.id_matricula = n.id_matricula;