<?php 

//PAGINA PHP PARA ACTUALIZAR LOS VALORES A LAS 15:00 en cron-job.org

//Para no subir los datos de acceso a GitHub:
$con=mysqli_connect(host,usuario,password,basedatos);

mysqli_set_charset($con,"utf8");

// Check connection
if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
} 

		$cobre_ant = 0;
		$cobre_last = 0;
		$plata_ant = 0;
		$plata_last = 0;
		$oro_ant = 0;
		$oro_last = 0;
		$diamante_ant = 0;
		$diamante_last = 0;
		
		function calcularSaldo($con, $recurso) {
			$stmt = $con->prepare("
				SELECT 
					SUM(CASE WHEN compraventa_users_id_venta = 0 THEN compraventa_recibe_ud ELSE 0 END) AS total_compras,
					SUM(CASE WHEN compraventa_users_id_compra = 0 THEN compraventa_entrega_ud ELSE 0 END) AS total_ventas
				FROM compraventa
				WHERE (compraventa_entrega_tipo = ".$recurso." OR compraventa_recibe_tipo = ".$recurso.") AND fecha >= NOW() - INTERVAL 1 DAY
			");
			$stmt->execute();
			$result = $stmt->get_result();
			$row = $result->fetch_assoc();
			
			$compras = $row['total_compras'] ?? 0;
			$ventas = $row['total_ventas'] ?? 0;

			return $compras - $ventas; // Devuelve el saldo neto: positivo para más compras, negativo para más ventas
		}
		
		function ajustarValor($valor_actual, $saldo) {
			// Determina el cambio basado en el saldo neto
			if ($saldo > 0) {
				$cambio = min(ceil($saldo / 5), 3); // Máximo cambio: +3
			} elseif ($saldo < 0) {
				$cambio = max(floor($saldo / 5), -3); // Máximo cambio: -3
			} else {
				$cambio = 0; // Sin cambios si el saldo es 0
			}
			
			// Calcula el nuevo valor dentro de los límites
			$nuevo_valor = max(0, min(15, $valor_actual + $cambio));
			
			return $nuevo_valor;
		}



		function generarNumeroAleatorio($valor_ant, $valor_last) {
		    do {
		        if ($valor_last < $valor_ant) {
		            // last < ant
		            $opciones = [$valor_last, $valor_last, $valor_last, $valor_last - 1, $valor_last - 1, $valor_last - 2, $valor_last + 1];
		        } elseif ($valor_last == $valor_ant) {
		            // last = ant
		            $opciones = [$valor_last, $valor_last, $valor_last, $valor_last - 1, $valor_last - 1, $valor_last + 1, $valor_last + 1];
		        } elseif ($valor_last > $valor_ant) {
		            // last > ant
		            $opciones = [$valor_last, $valor_last, $valor_last, $valor_last + 1, $valor_last + 1, $valor_last + 2, $valor_last - 1];
		        }

		        // Selecciona un valor aleatorio de las opciones disponibles
		        $numero_aleatorio = $opciones[array_rand($opciones)];
		    } while ($numero_aleatorio <= 0 || $numero_aleatorio >= 15); // Repetir mientras el número sea menor o igual a 0 y 15 o mayor

		    return $numero_aleatorio;
		}


		$stmt_cobre = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'cobre' ORDER BY values_updated DESC LIMIT 2");
		$stmt_plata = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'plata' ORDER BY values_updated DESC LIMIT 2");
		$stmt_oro = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'oro' ORDER BY values_updated DESC LIMIT 2");
		$stmt_diamante = $con->prepare("SELECT * FROM `values` WHERE values_tipo = 'diamante' ORDER BY values_updated DESC LIMIT 2");

		        $stmt_cobre->execute();
		        $result_cobre = $stmt_cobre->get_result();
				while ($row_cobre = $result_cobre->fetch_assoc())
		        {
					if ($cobre_last == 0) {
						$cobre_last = $row_cobre['values_valor'];
					} else {
						$cobre_ant = $row_cobre['values_valor'];
					}
				}
				//$cobre = generarNumeroAleatorio($cobre_ant, $cobre_last);
				$cobre_saldo = calcularSaldo($con, 'cobre');
				$cobre = ajustarValor($cobre_last, $cobre_saldo);
					
		        $stmt_plata->execute();
		        $result_plata = $stmt_plata->get_result();
		        while ($row_plata = $result_plata->fetch_assoc())
		        {
					if ($plata_last == 0) {
						$plata_last = $row_plata['values_valor'];
					} else {
						$plata_ant = $row_plata['values_valor'];
					}
				}
				//$plata = generarNumeroAleatorio($plata_ant, $plata_last);
				$plata_saldo = calcularSaldo($con, 'plata');
				$plata = ajustarValor($plata_last, $plata_saldo);

		        $stmt_oro->execute();
		        $result_oro = $stmt_oro->get_result();
		        while ($row_oro = $result_oro->fetch_assoc())
		        {
					if ($oro_last == 0) {
						$oro_last = $row_oro['values_valor'];
					} else {
						$oro_ant = $row_oro['values_valor'];
					}
				}
				//$oro = generarNumeroAleatorio($oro_ant, $oro_last);
				$oro_saldo = calcularSaldo($con, 'oro');
				$oro = ajustarValor($oro_last, $oro_saldo);
				
		        $stmt_diamante->execute();
		        $result_diamante = $stmt_diamante->get_result();   
		        while ($row_diamante = $result_diamante->fetch_assoc())
		        {
					if ($diamante_last == 0) {
						$diamante_last = $row_diamante['values_valor'];
					} else {
						$diamante_ant = $row_diamante['values_valor'];
					}
				}
				//$diamante = generarNumeroAleatorio($diamante_ant, $diamante_last);
				$diamante_saldo = calcularSaldo($con, 'diamante');
				$diamante = ajustarValor($diamante_last, $diamante_saldo);


		 $stmt_cobre = $con->prepare("INSERT INTO `values` (values_tipo, values_valor) VALUES ('cobre',".$cobre.")");
			$stmt_cobre->execute();
		 $stmt_plata = $con->prepare("INSERT INTO `values` (values_tipo, values_valor) VALUES ('plata',".$plata.")");
			$stmt_plata->execute();
		 $stmt_oro = $con->prepare("INSERT INTO `values` (values_tipo, values_valor) VALUES ('oro',".$oro.")");
			$stmt_oro->execute();
		 $stmt_diamante = $con->prepare("INSERT INTO `values` (values_tipo, values_valor) VALUES ('diamante',".$diamante.")");
			$stmt_diamante->execute();

		//borro valores anteriores a 7 días que ya no se usan para evitar llenar la bd
		$stmt_borrar = $con->prepare("DELETE FROM `values` WHERE values_updated <= NOW() - INTERVAL 7 DAY;");
		$stmt_borrar->execute();

		 
		 echo "Cobre: " .$cobre;
		 echo " --- ";
		 
		 echo "Plata: " .$plata;
		 echo " --- ";
		 
		 echo "Oro: " .$oro;
		 echo " --- ";
		 
		 echo "Diamante: " .$diamante;


 
mysqli_close($con);
?>
