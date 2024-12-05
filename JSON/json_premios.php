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
$tipo = trim($_GET['tp']);
$premio = trim($_GET['pc']);
$newPremiosDisponibles = "";
$newPremiosCanjeados = "";

//tipo=c: canjear

$stmt = $con->prepare("SELECT users_id, users_premiodisp, users_premiocanj FROM users WHERE users_name = '".$username."'");
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()){
                $premiosDisponibles = $row['users_premiodisp'];
                $premiosCanjeados = $row['users_premiocanj'];
                $usersId = $row['users_id'];
        }

if ($tipo == "c"){ //CANJEAR

        $mapeo = [
    'A' => ['premioCobre' => 2, 'premioPlata' => 2, 'premioOro' => 1, 'premioDiamante' => 1],
    'B' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 0, 'premioDiamante' => 1],
    'C' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 0, 'premioDiamante' => 1],
    'D' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 1, 'premioDiamante' => 0],
    'E' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 2, 'premioDiamante' => 0],
    'F' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 2, 'premioDiamante' => 1],
    'G' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 1, 'premioDiamante' => 0],
    'H' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 2, 'premioDiamante' => 0],
    'I' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 2, 'premioDiamante' => 1],
    'J' => ['premioCobre' => 0, 'premioPlata' => 2, 'premioOro' => 0, 'premioDiamante' => 0],
    'K' => ['premioCobre' => 0, 'premioPlata' => 2, 'premioOro' => 1, 'premioDiamante' => 0],
    'L' => ['premioCobre' => 0, 'premioPlata' => 2, 'premioOro' => 2, 'premioDiamante' => 0],
    'M' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 2, 'premioDiamante' => 0],
    'N' => ['premioCobre' => 2, 'premioPlata' => 0, 'premioOro' => 2, 'premioDiamante' => 0],
    'O' => ['premioCobre' => 2, 'premioPlata' => 0, 'premioOro' => 2, 'premioDiamante' => 1],
    'P' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 0, 'premioDiamante' => 1],
    'Q' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 0, 'premioDiamante' => 1],
    'R' => ['premioCobre' => 1, 'premioPlata' => 1, 'premioOro' => 0, 'premioDiamante' => 1],
    'S' => ['premioCobre' => 1, 'premioPlata' => 1, 'premioOro' => 1, 'premioDiamante' => 0],
    'T' => ['premioCobre' => 1, 'premioPlata' => 1, 'premioOro' => 1, 'premioDiamante' => 1],
    'U' => ['premioCobre' => 2, 'premioPlata' => 2, 'premioOro' => 2, 'premioDiamante' => 2],
    'V' => ['premioCobre' => 1, 'premioPlata' => 0, 'premioOro' => 0, 'premioDiamante' => 0],
    'W' => ['premioCobre' => 0, 'premioPlata' => 1, 'premioOro' => 0, 'premioDiamante' => 0],
    'X' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 1, 'premioDiamante' => 0],
    'Y' => ['premioCobre' => 0, 'premioPlata' => 0, 'premioOro' => 0, 'premioDiamante' => 1],
    'Z' => ['premioCobre' => 1, 'premioPlata' => 2, 'premioOro' => 3, 'premioDiamante' => 4],
];

if (isset($mapeo[$premio])) {
    $premioCobre = $mapeo[$premio]['premioCobre'];
    $premioPlata = $mapeo[$premio]['premioPlata'];
    $premioOro = $mapeo[$premio]['premioOro'];
    $premioDiamante = $mapeo[$premio]['premioDiamante'];
} 


        $newPremiosDisponibles = str_replace($premio, "", $premiosDisponibles);
        $premiosCanjeados = $premiosCanjeados . $premio;

    $stmt3 = $con->prepare("UPDATE users SET users_premiodisp = '".$newPremiosDisponibles."', users_premiocanj = '".$premiosCanjeados."' WHERE users_name = '".$username."'");
            $stmt3->execute();  

     $stmtRanking = $con->prepare("UPDATE ranking SET ranking_cobre = ranking_cobre + ".$premioCobre.", ranking_plata = ranking_plata + ".$premioPlata.", ranking_oro = ranking_oro + ".$premioOro.", ranking_diamante = ranking_diamante + ".$premioDiamante." WHERE ranking_users_id = ".$usersId."");
     $stmtRanking->execute();  

}

//VER Y ACTUALIZAR

$stmt = $con->prepare("SELECT ranking_cobre, ranking_plata, ranking_oro, ranking_diamante FROM ranking WHERE ranking_users_id = (SELECT users_id FROM users WHERE users_name = '".$username."')");
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()){

                $ranking_cobre = $row['ranking_cobre'];
                    if ($ranking_cobre >= 10) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "J";
                    }
                    if ($ranking_cobre >= 20) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "K";
                    }
                    if ($ranking_cobre >= 30) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "L";
                    }

                $ranking_plata = $row['ranking_plata'];
                    if ($ranking_plata >= 10) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "M";
                    }
                    if ($ranking_plata >= 20) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "N";
                    }
                    if ($ranking_plata >= 30) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "O";
                    }

                $ranking_oro = $row['ranking_oro'];
                    if ($ranking_oro >= 10) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "P";
                    }
                    if ($ranking_oro >= 20) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "Q";
                    }
                    if ($ranking_oro >= 30) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "R";
                    }

                $ranking_diamante = $row['ranking_diamante'];
                    if ($ranking_diamante >= 10) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "S";
                    }
                    if ($ranking_diamante >= 20) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "T";
                    }
                    if ($ranking_diamante >= 30) {
                        $newPremiosDisponibles = $newPremiosDisponibles . "U";
                    }
			
			if (($ranking_cobre + $ranking_plata + $ranking_oro + $ranking_diamante) == 0  AND strpos($newPremiosCanjeados, "A") === false) {

                    $newPremiosDisponibles = $newPremiosDisponibles . "A";

			}
                
        }

$stmt3 = $con->prepare("SELECT compraventa_users_id_venta FROM compraventa WHERE compraventa_users_id_compra = (SELECT users_id FROM users WHERE users_name = '".$username."')");
        $stmt3->execute();
        $result3 = $stmt3->get_result();

        $contadorComprasMercado = 0;

        while ($row3 = $result3->fetch_assoc()){

                $idUsuarioVenta = $row3['history_users_id_venta'];

                if ($idUsuarioVenta == 0) { //mercado de valores
                                $contadorComprasMercado = $contadorComprasMercado + 1;
                } 

        }

                if ($contadorComprasMercado >= 1) {//B: 1 compra mercado
                    $newPremiosDisponibles = $newPremiosDisponibles . "B";
                }
                if ($contadorComprasMercado >= 10) {//D: 10 compra mercado
                    $newPremiosDisponibles = $newPremiosDisponibles . "D";
                }
                if ($contadorComprasMercado >= 20) {//E: 20 compra mercado
                    $newPremiosDisponibles = $newPremiosDisponibles . "E";
                }
                if ($contadorComprasMercado >= 30) {//F: 30 compra mercado
                    $newPremiosDisponibles = $newPremiosDisponibles . "F";
                }

$stmt4 = $con->prepare("SELECT COUNT(compraventa_id) as compraventa_ventas_count FROM compraventa WHERE compraventa_users_id_venta = (SELECT users_id FROM users WHERE users_name = '".$username."')");
        $stmt4->execute();
        $result4 = $stmt4->get_result();
        while ($row4 = $result4->fetch_assoc()){

                $contadorVentas = $row4['history_ventas_count'];

                if ($contadorVentas >= 1) {//C: 1 venta
                    $newPremiosDisponibles = $newPremiosDisponibles . "C";
                }
                if ($contadorVentas >= 10) {//G: 10 ventas
                    $newPremiosDisponibles = $newPremiosDisponibles . "G";
                }
                if ($contadorVentas >= 20) {//H: 20 ventas
                    $newPremiosDisponibles = $newPremiosDisponibles . "H";
                }
                if ($contadorVentas >= 30) {//I: 30 ventas
                    $newPremiosDisponibles = $newPremiosDisponibles . "I";
                }

        }

$stmt5 = $con->prepare("SELECT users_premiocanj FROM users WHERE users_name = '".$username."'");
        $stmt5->execute();
        $result5 = $stmt5->get_result();
        while ($row5 = $result5->fetch_assoc()){

                $newPremiosCanjeados = $row5['users_premiocanj'];

                if (strlen($newPremiosCanjeados) >= 5) {//V: 5 premios
                    $newPremiosDisponibles = $newPremiosDisponibles . "V";
                }
                if (strlen($newPremiosCanjeados) >= 10) {//W: 10 premios
                    $newPremiosDisponibles = $newPremiosDisponibles . "W";
                }
                if (strlen($newPremiosCanjeados) >= 20) {//X: 20 premios
                    $newPremiosDisponibles = $newPremiosDisponibles . "X";
                }
                if (strlen($newPremiosCanjeados) >= 30) {//Y: 30 premios
                    $newPremiosDisponibles = $newPremiosDisponibles . "Y";
                }
                if (strlen($newPremiosCanjeados) >= 34) { //Z: TODOS
                    $newPremiosDisponibles = $newPremiosDisponibles . "Z";
                }
        }


        // miro cada carácter de $newPremiosCanjeados
        for ($i = 0; $i < strlen($newPremiosCanjeados); $i++) {
            $caracter = $newPremiosCanjeados[$i];

            // elimino todas la veces de $caracter en $newPremiosDisponibles
            $newPremiosDisponibles = str_replace($caracter, "", $newPremiosDisponibles);
        }

$stmt6 = $con->prepare("UPDATE users SET users_premiodisp = '".$newPremiosDisponibles."' WHERE users_name = '".$username."'");
            $stmt6->execute();  



class Ranking {  }
    $ranking = new Ranking();
class Result { }
    $resultadosql = new Result();


                 $resultadoUser->premiosDisponibles = $newPremiosDisponibles;
                 $resultadoUser->premiosCanjeados = $premiosCanjeados;
  
                $json_array = array($resultadoUser);
                $ranking->results = $json_array;
                $jsonData = json_encode($ranking);

            echo $jsonData."\n";

mysqli_close($con);
?>
