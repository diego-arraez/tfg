<?php 

//Para no subir los datos de acceso a GitHub:
$con=mysqli_connect(host,usuario,password,basedatos);

mysqli_set_charset($con,"utf8");
 
// Check connection
if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
} 

$username = trim($_GET['u']);

$stmt_cobre = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'cobre' ORDER BY values_updated DESC LIMIT 1");
$stmt_plata = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'plata' ORDER BY values_updated DESC LIMIT 1");
$stmt_oro = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'oro' ORDER BY values_updated DESC LIMIT 1");
$stmt_diamante = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'diamante' ORDER BY values_updated DESC LIMIT 1");

        $stmt_cobre->execute();
        $result_cobre = $stmt_cobre->get_result();
        $row_cobre = $result_cobre->fetch_assoc();
        $valor_cobre = $row_cobre['values_valor'];
      
        $stmt_plata->execute();
        $result_plata = $stmt_plata->get_result();
        $row_plata = $result_plata->fetch_assoc();
        $valor_plata = $row_plata['values_valor'];

        $stmt_oro->execute();
        $result_oro = $stmt_oro->get_result();
        $row_oro = $result_oro->fetch_assoc();
        $valor_oro = $row_oro['values_valor'];

        $stmt_diamante->execute();
        $result_diamante = $stmt_diamante->get_result();   
        $row_diamante = $result_diamante->fetch_assoc();
        $valor_diamante = $row_diamante['values_valor'];

$stmt = $con->prepare("SELECT ranking_cobre, ranking_plata, ranking_oro, ranking_diamante, (ranking_cobre * ".$valor_cobre.") + (ranking_plata * ".$valor_plata.") + (ranking_oro * ".$valor_oro.") + (ranking_diamante * ".$valor_diamante.") AS ranking_points FROM ranking WHERE ranking_users_id = (SELECT users_id FROM users WHERE users_name = '".$username."')");

class Ranking {  }
    $ranking = new Ranking();
class Result { }
    $resultadosql = new Result();

        $stmt->execute();
        $result = $stmt->get_result();

            while ($row = $result->fetch_assoc()){
                    $resultadoUser->cobre = strval($row['ranking_cobre']);
                    $resultadoUser->plata = strval($row['ranking_plata']);
                    $resultadoUser->oro = strval($row['ranking_oro']);
                    $resultadoUser->diamante = strval($row['ranking_diamante']);
                    $resultadoUser->points = strval($row['ranking_points']);

            }

                $json_array = array($resultadoUser);
                $ranking->results = $json_array;
                $jsonData = json_encode($ranking);

            echo $jsonData."\n";

mysqli_close($con);
?>
