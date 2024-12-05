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
$tipoConsulta = trim($_GET['type']);

class Ranking {  }
    $ranking = new Ranking();
class Result { }
    $resultadosql = new Result();

$json_array = array();

if ($tipoConsulta == "compras"){
        $stmtCompra = $con->prepare("SELECT compraventa_id, (SELECT users_name FROM users WHERE users_id=compraventa_users_id_venta) as compraventa_username_venta, compraventa_entrega_tipo, compraventa_entrega_ud, compraventa_recibe_tipo, compraventa_recibe_ud, DATE_FORMAT(compraventa_updated, '%Y-%m-%d') AS compraventa_date, compraventa_puntos FROM compraventa WHERE compraventa_users_id_compra = (SELECT users_id FROM users WHERE users_name='".$username."') ORDER BY compraventa_updated DESC");

} else if ($tipoConsulta == "ventas") {
        $stmtCompra = $con->prepare("SELECT compraventa_id, compraventa_entrega_tipo, compraventa_entrega_ud, compraventa_recibe_tipo, compraventa_recibe_ud, DATE_FORMAT(compraventa_updated, '%Y-%m-%d') AS compraventa_date, compraventa_puntos FROM compraventa WHERE compraventa_users_id_venta = (SELECT users_id FROM users WHERE users_name='".$username."') ORDER BY compraventa_updated DESC");

}

$stmtCompra->execute();
$resultCompra = $stmtCompra->get_result();

if ($resultCompra->num_rows === 0) {

    if ($tipoConsulta == "compras"){
            $resultado->idC = "0";
            $resultado->fechaCambioC =  "";
            $resultado->ofreceTipoC =  "";
            $resultado->ofreceUnidadC =  "";
            $resultado->pideTipoC =  "";
            $resultado->pideUnidadC =  "";
            $resultado->usernameC =  "";
            $resultado->puntosC =  "";

            array_push($json_array, $resultado);
            unset($resultado);

    } else if ($tipoConsulta == "ventas") {
            $resultado->idV = "0";
            $resultado->fechaCambioV =  "";
            $resultado->ofreceTipoV =  "";
            $resultado->ofreceUnidadV =  "";
            $resultado->pideTipoV =  "";
            $resultado->pideUnidadV =  "";
            $resultado->usernameV =  "";
            $resultado->puntosV =  "";

            array_push($json_array, $resultado);
            unset($resultado);
    }

} else {

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


        if ($tipoConsulta == "compras") {
                                    while ($rowCompra = $resultCompra->fetch_assoc()) {
                                            
                                            $resultado->idC = strval($rowCompra['compraventa_id']);
                                            $resultado->fechaCambioC = strval($rowCompra['compraventa_date']);
                                            $resultado->ofreceTipoC = strval($rowCompra['compraventa_entrega_tipo']);
                                            $resultado->ofreceUnidadC = strval($rowCompra['compraventa_entrega_ud']);
                                            $resultado->pideTipoC = strval($rowCompra['compraventa_recibe_tipo']);
                                            $resultado->pideUnidadC = strval($rowCompra['compraventa_recibe_ud']);
                                            $resultado->usernameC = strval($rowCompra['compraventa_username_venta']);
                                            $resultado->puntosC = strval("+".$rowCompra['compraventa_puntos']);  

                                            array_push($json_array, $resultado);
                                            unset($resultado);
                                        }

        } else if ($tipoConsulta == "ventas") {
                                        while ($rowCompra = $resultCompra->fetch_assoc()) {
                                            
                                            $resultado->idV = strval($rowCompra['compraventa_id']);
                                            $resultado->fechaCambioV = strval($rowCompra['compraventa_date']);
                                            $resultado->ofreceTipoV = strval($rowCompra['compraventa_entrega_tipo']);
                                            $resultado->ofreceUnidadV = strval($rowCompra['compraventa_entrega_ud']);
                                            $resultado->pideTipoV = strval($rowCompra['compraventa_recibe_tipo']);
                                            $resultado->pideUnidadV = strval($rowCompra['compraventa_recibe_ud']);
                                            $resultado->usernameV = strval($rowCompra['compraventa_username_venta']);
                                            $resultado->puntosV = strval("+".$rowCompra['compraventa_recibe_ud']);  

                                            array_push($json_array, $resultado);
                                            unset($resultado);
                                        }
        }
}

$ranking->results = $json_array;
$jsonData = json_encode($ranking);

echo $jsonData."\n";

mysqli_close($con);
?>
