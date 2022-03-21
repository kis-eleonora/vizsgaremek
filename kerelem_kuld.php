<!-- A kért dátumok mentése a 'keresek' táblába -->

<?php

require_once 'connect.php';

if (filter_input(INPUT_POST, "kerelem", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    $start = new DateTime(filter_input(INPUT_POST, "kezdet"));
    $end = new DateTime(filter_input(INPUT_POST, "vege"));
    echo $end->format('Y-m-d');
    $tavollet = filter_input(INPUT_POST, "tavollet");
    if ($tavollet == "szabadsag") {
        $allapot = "elinditva";
    } else {
        $allapot = "elfogadva";
    }
    if (!$end) {
        $start->format('Y-m-d');
//        $datumok = $start->format('Y-m-d');
        $sql = "INSERT INTO `keresek`(`szemely_id`, `datum`, `statusz`, `allapot`) VALUES ('" . $_SESSION['szemely_id'] . "','$start','$tavollet','$allapot');";
    } else {
        $end = $end->modify('+1 day');
        $interval = new DateInterval('P1D');
        $period = new DatePeriod($start, $interval, $end);
        $sql = "INSERT INTO `keresek` (`szemely_id`, `datum`, `statusz`, `allapot`) VALUES ";
        $napok = array();
        foreach ($period as $date) {
            $datumok = $date->format('Y-m-d');
            echo $datumok;
            echo "<br>";
            $napok[] = "('" . $_SESSION['szemely_id'] . "','$datumok','$tavollet','$allapot')";
        }
        $sql .= join(',', $napok);
         
    }
     if (mysqli_query($conn, $sql)) {
            $_SESSION['success'] = "Kérelem elküldve!";
            include 'keresek.php';
            exit();
        } else {
            $_SESSION['error'] = "ERROR: Nem sikerült végrehajtani: $sql. " . mysqli_error($conn);
        }

//    echo $tavollet;
//    echo "<br>";
//    echo $_SESSION['szemely_id'];
//    echo "<br>";
}
?>