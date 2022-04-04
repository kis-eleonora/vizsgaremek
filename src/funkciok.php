<!--Függvények-->

<?php

function fonoke($jog) {
    return $jog == "fonok";
}

function nincsenekAdatok($jelszo, $email) {
    $result = $jelszo == null || $email == null;
    return $result;
}

function jelszoEgyezes($ujJelszo, $jelszoMegerosites) {
    $result = $ujJelszo == $jelszoMegerosites;
    return $result;
}

function sqlEgynaposKerelem($szemely_id, $start, $tavollet, $allapot) {

    $start = $start->format('Y-m-d');
    $result = "INSERT INTO `keresek`(`szemely_id`, `datum`, `statusz`, `allapot`) "
            . "VALUES ('$szemely_id','$start','$tavollet','$allapot');";
    return $result;
}

function sqlTobbnaposKerelem($szemely_id, $end, $start, $tavollet, $allapot) {
    $end = $end->modify('+1 day');
    $interval = new DateInterval('P1D');
    $period = new DatePeriod($start, $interval, $end);
    $sql = "INSERT INTO `keresek` (`szemely_id`, `datum`, `statusz`, `allapot`) VALUES ";
    $napok = array();
    foreach ($period as $date) {
        $datumok = $date->format('Y-m-d');
        $napok[] = "('$szemely_id','$datumok','$tavollet','$allapot')";
    }
    return $sql . join(',', $napok);
}

function honapokKivalasztasa($datum) {

    switch (date("m", $datum)) {
        case 1:
            $honapnev = "Január";
            break;
        case 2:
            $honapnev = "Február";
            break;
        case 3:
            $honapnev = "Március";
            break;
        case 4:
            $honapnev = "Április";
            break;
        case 5:
            $honapnev = "Május";
            break;
        case 6:
            $honapnev = "Június";
            break;
        case 7:
            $honapnev = "Július";
            break;
        case 8:
            $honapnev = "Augusztus";
            break;
        case 9:
            $honapnev = "Szeptember";
            break;
        case 10:
            $honapnev = "Október";
            break;
        case 11:
            $honapnev = "November";
            break;
        case 12:
            $honapnev = "December";
            break;
    }
    return $honapnev;
}
