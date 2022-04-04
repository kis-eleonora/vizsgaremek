<!-- A kért dátumok mentése a 'keresek' táblába -->

<?php
require_once 'connect.php';

if (filter_input(INPUT_POST, "kerelem", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    $start = new DateTime(filter_input(INPUT_POST, "kezdet"));

    $tavollet = filter_input(INPUT_POST, "tavollet");
    if ($tavollet == "szabadsag") {
        $allapot = "elinditva";
    } else {
        $allapot = "elfogadva";
    }

    if (filter_input(INPUT_POST, "vege")) {
        $end = new DateTime(filter_input(INPUT_POST, "vege"));

        if ($end < $start) {
            $_SESSION['error'] = "A kezdő dátum nem lehet későbbi, mint a záró dátum!";
            include 'keresek.php';
            exit();
        }
        else {
            $sql = sqlTobbnaposKerelem($_SESSION['szemely_id'], $end, $start, $tavollet, $allapot);
        }
    } else {

        $sql = sqlEgynaposKerelem($_SESSION['szemely_id'], $start, $tavollet, $allapot);
    }

    if (mysqli_query($conn, $sql)) {
        $_SESSION['success'] = "Kérelem elküldve!";
        include 'keresek.php';
        exit();
    } else {
        $_SESSION['error'] = "ERROR: Nem sikerült végrehajtani: $sql. " . mysqli_error($conn);
    }
}
?>