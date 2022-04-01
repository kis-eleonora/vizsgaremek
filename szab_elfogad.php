<?php

require_once 'connect.php';

if (filter_input(INPUT_POST, "elfogadas", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    $sql = "UPDATE `keresek` SET `allapot`='elfogadva' WHERE `azon` IN(";
    $azonositok = array();
    if (empty($azonositok)) {
         $_SESSION['error'] = "Nem jelölt ki elfogadásra egy kérelmet sem.";
    } else {
        foreach ($_POST['elfogadva'] as $i => $id) {
            $elfogadva = $_POST['elfogadva'][$i];
            $azonositok[] = "$elfogadva";
        }
        $sql .= join(',', $azonositok) . ');';

        if (mysqli_query($conn, $sql)) {
            $_SESSION['success'] = "Kérelmek elfogadva!";
            include 'ertesitesek.php';
            exit();
        } else {
            $_SESSION['error'] = "ERROR: Nem sikerült végrehajtani: $sql. " . mysqli_error($conn);
        }
    }
    
}




    