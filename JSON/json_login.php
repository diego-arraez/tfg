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
$password = trim($_GET['p']);
$pass_insert = password_hash($password, PASSWORD_BCRYPT);

$stmt = $con->prepare("SELECT users_id, users_name, users_password, users_premiocanj FROM users WHERE users_name = '".$username."'");

        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
		
	//si existe el usuario, compruebo password	
	if ($username == $row['users_name']) {

		//compruebo password. si es correcto reviso los premios (añado el OR para los usuarios ya creados antes del hash)
		if (password_verify($password, $row['users_password']) OR $password == $row['users_password']) {
			if (strpos($row['users_premiocanj'], "A")>0) {
                $respuesta->respuesta = "LoginOK-A";
            } else {
                $respuesta->respuesta = "LoginOK";        
            }
		} else { //si no es correcto, devuevlo LoginNOOK
			
			$respuesta->respuesta = "LoginNOOK"; 
			
		}

	
	} else { //si el usuario no existe, lo creo (registro)
		
        $stmt2 = $con->prepare("INSERT INTO users (users_name,users_password, users_premiodisp) VALUES ('".$username."', '".$pass_insert."','A')");
                $stmt2->execute();  

				//reviso el id que se le ha asignado en la base de datos para la tabla ranking
                $stmt_new = $con->prepare("SELECT users_id FROM users WHERE users_name = '".$username."'");
                $stmt_new->execute();
                $result_new = $stmt_new->get_result();
                $row_new = $result_new->fetch_assoc();

                $stmt_regalo = $con->prepare("INSERT INTO ranking (ranking_users_id,ranking_cobre,ranking_plata,ranking_oro) VALUES (".$row_new['users_id'].",0,0,0)");
                $stmt_regalo->execute();  

                $respuesta->respuesta = "LoginOK";    

    }

                $json_array = array($respuesta);
                $ranking->results = $json_array;
                $jsonData = json_encode($ranking);

            echo $jsonData."\n";
        
mysqli_close($con);
?>
