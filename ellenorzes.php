<?php

session_start();

require_once 'connect.php';

if (empty($_POST['email'] && $_POST['jelszo'])) {

    exit('A mezők kitöltése kötelező!');
}

if ($stmt = $conn->prepare('SELECT `email`, `jelszo`, `jog_ID` FROM `szemelyek` WHERE `email`= ?')) {

    $stmt->bind_param('s', $_POST['email']);
    $stmt->execute();

    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($email, $jelszo, $jog_ID);
        $stmt->fetch();

        if (md5($_POST['jelszo']) === $jelszo ) {

            session_regenerate_id();
            $_SESSION['loggedin'] = TRUE;
            if ($jog_ID === 1) {
                header("location: vezeto.php");
            } else {
                 header("location: alkalmazott.php");
            }

            
        } else {
            
            $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
            header("location: index.php");
//            echo 'Hibás jelszó';
        }
    } else {
        
        $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
        header("location: index.php");
//        echo 'Hibás email'; 
    }

    $stmt->close();
}
?>
