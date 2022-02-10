<?php

session_start();
$conn = new mysqli("localhost", "root", "", "vizsgaremek");

if ($conn->errno > 0) {
    die("Adatbázis nem elérhető!");
}

$conn->set_charset("utf-8");

if (!isset($_POST['email'], $_POST['jelszo'])) {

    exit('A mezők kitöltése kötelező!');
}

if ($stmt = $conn->prepare('SELECT `email`, `jelszo` FROM `szemelyek` WHERE `email`= ?')) {

    $stmt->bind_param('s', $_POST['email']);
    $stmt->execute();

    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($email, $jelszo);
        $stmt->fetch();

        if (md5($_POST['jelszo']) === $jelszo) {

            session_regenerate_id();
            $_SESSION['loggedin'] = TRUE;

            header("location: alkalmazott.php");
        } else {
            $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
            header("location: index.php");
        }
    } else {
        $_SESSION['error'] = 'Helytelen felhasználónév vagy jelszó!';
        header("location: index.php");
    }

    $stmt->close();
}
?>
