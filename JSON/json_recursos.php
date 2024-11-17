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


    $stmt_userid = $con->prepare("SELECT ranking_coins FROM ranking WHERE ranking_users_id = (SELECT users_id FROM users WHERE users_name = '$username')");
    $stmt_userid->execute();
    $result_userid = $stmt_userid->get_result();
    $row_userid = $result_userid->fetch_assoc();

    $coins = $row_userid['ranking_coins'];

$stmt_cobre = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'cobre' ORDER BY values_updated DESC LIMIT 6");
$stmt_plata = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'plata' ORDER BY values_updated DESC LIMIT 6");
$stmt_oro = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'oro' ORDER BY values_updated DESC LIMIT 6");
$stmt_diamante = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'diamante' ORDER BY values_updated DESC LIMIT 6");

class Chart {  }
    $chart = new Chart();
class Result { }
    $resultadosql = new Result();
        $json_array=array();

        $stmt_cobre->execute();
        $result_cobre = $stmt_cobre->get_result();
   
        while ($row = $result_cobre->fetch_assoc())
        {

                $resultado->fecha = strval($row['values_updated']);
                $resultado->id = strval($row['values_id']);
                $resultado->tipo = strval($row['values_tipo']);
                $resultado->valor = strval($row['values_valor']);
                $resultado->coins = strval($coins);

                array_push($json_array,$resultado);

                unset($resultado);

        }

        $stmt_plata->execute();
        $result_plata = $stmt_plata->get_result();
        
        while ($row = $result_plata->fetch_assoc())
        {

                $resultado->fecha = strval($row['values_updated']);
                $resultado->id = strval($row['values_id']);
                $resultado->tipo = strval($row['values_tipo']);
                $resultado->valor = strval($row['values_valor']);
                $resultado->coins = strval($coins);

                array_push($json_array,$resultado);

                unset($resultado);

        }

        $stmt_oro->execute();
        $result_oro = $stmt_oro->get_result();

        while ($row = $result_oro->fetch_assoc())
        {

                $resultado->fecha = strval($row['values_updated']);
                $resultado->id = strval($row['values_id']);
                $resultado->tipo = strval($row['values_tipo']);
                $resultado->valor = strval($row['values_valor']);
                $resultado->coins = strval($coins);

                array_push($json_array,$resultado);

                unset($resultado);

        }

        $stmt_diamante->execute();
        $result_diamante = $stmt_diamante->get_result();   

        while ($row = $result_diamante->fetch_assoc())
        {

                $resultado->fecha = strval($row['values_updated']);
                $resultado->id = strval($row['values_id']);
                $resultado->tipo = strval($row['values_tipo']);
                $resultado->valor = strval($row['values_valor']);
                $resultado->coins = strval($coins);

                array_push($json_array,$resultado);

                unset($resultado);

        }

                $json_array = array_reverse($json_array);
                $chart->results = $json_array;
                $jsonData = json_encode($chart);

            echo $jsonData."\n";
    
mysqli_close($con);
?>


