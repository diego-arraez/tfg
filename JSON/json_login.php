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

$stmt = $con->prepare("SELECT users_id, users_name, users_password, users_premiocanj FROM users WHERE users_name = '".$username."' AND users_password = '".$password."'");

        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

    if ($username == $row['users_name']) {
            if (strpos($row['users_premiocanj'], "A")>0) {
                $respuesta->respuesta = "LoginOK-A";
            } else {
                $respuesta->respuesta = "LoginOK";        
            }
        
    } else {
        $stmt = $con->prepare("SELECT users_name, users_id FROM users WHERE users_name = '".$username."'");

        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        if ($username == $row['users_name']) {
        $respuesta->respuesta = "LoginNOOK";   

        } else {
            $stmt2 = $con->prepare("INSERT INTO users (users_name,users_password, users_premiodisp) VALUES ('".$username."', '".$password."','A')");
                    $stmt2->execute();  

                    $stmt_new = $con->prepare("SELECT users_id FROM users WHERE users_name = '".$username."'");
                    $stmt_new->execute();
                    $result_new = $stmt_new->get_result();
                    $row_new = $result_new->fetch_assoc();

                    $stmt_regalo = $con->prepare("INSERT INTO ranking (ranking_users_id,ranking_cobre,ranking_plata,ranking_oro) VALUES (".$row_new['users_id'].",0,0,0)");
                    $stmt_regalo->execute();  

                    $respuesta->respuesta = "LoginOK";    


        }

    }

                $json_array = array($respuesta);
                $ranking->results = $json_array;
                $jsonData = json_encode($ranking);

            echo $jsonData."\n";
        
mysqli_close($con);
?>
