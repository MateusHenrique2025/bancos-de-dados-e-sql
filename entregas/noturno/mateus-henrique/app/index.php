<?php
// Conecta ao banco escola_db no HeidiSQL
$conn = new mysqli("localhost", "root", "2026", "escola_db");

if ($conn->connect_error) {
    die("Erro de conexão: " . $conn->connect_error);
}

// Pega os filtros da tela
$turma_filtro = isset($_GET['turma']) ? $_GET['turma'] : '';
$nome_filtro = isset($_GET['nome']) ? $_GET['nome'] : '';

// Monta a busca SQL juntando as tabelas corretas
$sql = "SELECT a.nome, a.email, t.nome_turma AS turma, m.data_matricula, n.media AS media_final
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        JOIN turmas t ON m.id_turma = t.id_turma
        LEFT JOIN notas n ON m.id_matricula = n.id_matricula
        WHERE 1=1";

if ($turma_filtro != '') { $sql .= " AND t.nome_turma LIKE '%$turma_filtro%'"; }
if ($nome_filtro != '') { $sql .= " AND a.nome LIKE '%$nome_filtro%'"; }

$resultado = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Consulta de Alunos - ITEAM</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .aprovado { background-color: #d4edda; color: green; }
        .reprovado { background-color: #f8d7da; color: red; }
    </style>
</head>
<body>
    <h2>Alunos Matriculados</h2>

    <form method="GET">
        <label>Turma:</label>
        <input type="text" name="turma" value="<?php echo $turma_filtro; ?>">
        
        <label>Nome:</label>
        <input type="text" name="nome" value="<?php echo $nome_filtro; ?>">
        
        <button type="submit">Filtrar</button>
        <a href="index.php">Limpar</a>
    </form>

    <table>
        <tr>
            <th>Nome</th>
            <th>E-mail</th>
            <th>Turma</th>
            <th>Data Matrícula</th>
            <th>Média Final</th>
        </tr>
        <?php
        if ($resultado && $resultado->num_rows > 0) {
            while($aluno = $resultado->fetch_assoc()) {
                // Se a média for maior ou igual a 7, fica verde
                $media = $aluno['media_final'] ? $aluno['media_final'] : 0;
                $classe = ($media >= 7) ? 'aprovado' : 'reprovado';
                
                echo "<tr class='$classe'>";
                echo "<td>" . $aluno['nome'] . "</td>";
                echo "<td>" . $aluno['email'] . "</td>";
                echo "<td>" . ($aluno['turma'] ? $aluno['turma'] : 'Sem turma') . "</td>";
                echo "<td>" . ($aluno['data_matricula'] ? $aluno['data_matricula'] : '-') . "</td>";
                echo "<td>" . number_format($media, 2, ',', '.') . "</td>";
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='5'>Nenhum aluno encontrado ou erro na consulta.</td></tr>";
        }
        ?>
    </table>
</body>
</html>