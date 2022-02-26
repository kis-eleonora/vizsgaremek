<?php

//session_start();

require_once 'connect.php';

if (empty($_POST['email'] && $_POST['jelszo'])) {

    $_SESSION['error'] = 'Az összes mező kitöltése kötelező!';
    include 'login.php';
}

if ($stmt = $conn->prepare('SELECT `email`, `jelszo`, `fonok` FROM `szemelyek` WHERE `email`= ?')) {

    $stmt->bind_param('s', $_POST['email']);
    $stmt->execute();

    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($email, $jelszo, $fonok);
        $stmt->fetch();

        if (sha1($_POST['jelszo']) === $jelszo) {

            session_regenerate_id();
            $_SESSION['login'] = true;
            if ($fonok === "") {
                $_SESSION["jog"] = "fonok";
            }
            include 'index.php';
        } else {

            $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
            include 'login.php';
//            echo 'Hibás jelszó';
        }
    } else {

        $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
        include 'login.php';
//        echo 'Hibás email'; 
    }

    $stmt->close();
}
?>
