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
$gasto = trim($_GET['gasto']);
$tipo = trim($_GET['tipo']);
$incremento = trim($_GET['cantidad']);

    $stmt_userid = $con->prepare("SELECT ranking_".$tipo." FROM ranking WHERE ranking_users_id = (SELECT users_id FROM users WHERE users_name = '$username')");
    $stmt_userid->execute();
    $result_userid = $stmt_userid->get_result();
    $row_userid = $result_userid->fetch_row();


    if ($row_userid[0] < $gasto) {
            $respuesta->respuesta = "NOK";    
    } else {

                $stmt = $con->prepare("SELECT * FROM `values` WHERE values_tipo = '".$tipo."' ORDER BY values_updated DESC LIMIT 1");

                $stmt->execute();
                $result = $stmt->get_result();
                $row = $result->fetch_assoc();
                $valor = $row['values_valor'];

                $puntos = $valor * $gasto;

               $stmt3 = $con->prepare("UPDATE ranking SET ranking_".$tipo." = (ranking_".$tipo." - ".$gasto."), ranking_coins = (ranking_coins + ".$incremento.") WHERE ranking_users_id = (SELECT users_id FROM users WHERE users_name='".$username."')");

               $stmt3->execute();  
               $respuesta->respuesta = "OK";    

               //SE AÑADE AL HISTORIAL
                $stmt10 = $con->prepare("INSERT INTO compraventa (compraventa_users_id_venta, compraventa_users_id_compra, compraventa_entrega_ud, compraventa_entrega_tipo, compraventa_recibe_ud, compraventa_recibe_tipo, compraventa_puntos) VALUES ((SELECT users_id FROM users WHERE users_name='".$username."'),0,".$gasto.",'".$tipo."',".$incremento.",'coins',".$puntos.")");
                $stmt10->execute(); 
                
    }

         $json_array = array($respuesta);
         $ranking->results = $json_array;
         $jsonData = json_encode($ranking);

            echo $jsonData."\n";

mysqli_close($con);
?>
