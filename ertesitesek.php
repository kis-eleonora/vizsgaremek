<?php
require_once 'connect.php';
include_once 'szab_elfogad.php';
?>
<div class="kozep">
    <?php
    if ($_SESSION["jog"] == "fonok") {
        echo' <h2>Beérkezett szabadság kérelmek</h2>
    <div class="">
        <form method="POST">
            <table class="table table-bordered text-center">
                <thead>
                    <tr class="bg-light-gray">
<!--                        <th class="text-uppercase">Azonosító</th>-->
                        <th class="text-uppercase">Név</th>
                        <th class="text-uppercase">Dátum</th>
                        <th class="text-uppercase">Elfogad</th>
                    </tr>
                </thead>
                <tbody>';

        $sql = "SELECT `nev`, `datum`, `azon` FROM `keresek`, `szemelyek` WHERE szemelyek.szemely_id = keresek.szemely_id AND szemelyek.fonok=" . $_SESSION['szemely_id'] . " AND `allapot` = 'elinditva';";

        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) > 0) {

            while ($row = mysqli_fetch_assoc($result)) {
                echo '<tr>'
//                            . '<td>' . $row['azon'] . '</td>'
                . '<td>' . $row['nev'] . '</td>
                            <td>' . $row['datum'] . '</td>'
                . '<td><input type = "checkbox" id= "elfogadva[]" name = "elfogadva[]" value = "' . $row['azon'] . '"></td>'
                . '</tr>';
            }
        }

        echo'</tbody>
             </table>
            <button type="submit" class="btn btn-success btn-lg m-2" name = "elfogadas" value = "true">Küldés</button>
        </form>';
        if (isset($_SESSION['error'])) {
            echo '<div id="error" style="color:red;">' . $_SESSION['error'] . '</div>';
            unset($_SESSION['error']);
            exit();
        }
        if (isset($_SESSION['success'])) {
            echo '<div id="success" style="color:green;">' . $_SESSION['success'] . '</div>';
            unset($_SESSION['success']);
            exit();
        }
        echo'</div>';
    } else {
        echo '<div class="elfogadott">'
        . '<h2>Elfogadott szabadságok</h2>'
        . '<ul>';
        $sql = "SELECT `nev`, `datum`, `azon` FROM `keresek`, `szemelyek` WHERE szemelyek.szemely_id = keresek.szemely_id AND szemelyek.szemely_id=" . $_SESSION['szemely_id'] . " AND `allapot` = 'elfogadva' AND `statusz` = 'szabadsag';";
        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) > 0) {

            while ($row = mysqli_fetch_assoc($result)) {
                echo '<li>' . $row['datum'] . '</li>';
            }
            echo '</ul></div>';
        } else {
            echo 'Nincsen elfogadott kérelem.';
        }

        echo '<div class="elfogadasra">'
        . '<h2>Elfogadásra vár</h2>'
        . '<ul>';
        $sql = "SELECT `nev`, `datum`, `azon` FROM `keresek`, `szemelyek` WHERE szemelyek.szemely_id = keresek.szemely_id AND szemelyek.szemely_id=" . $_SESSION['szemely_id'] . " AND `allapot` = 'elinditva' AND `statusz` = 'szabadsag';";
        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) > 0) {

            while ($row = mysqli_fetch_assoc($result)) {
                echo '<li>' . $row['datum'] . '</li>';
            }
            echo '</ul></div>';
        } else {
            echo 'Nincsen elfogadásra váró kérelem.';
        }

        echo '<h2>Megmaradt szabadnapok száma:</h2>';
        $sql = "SELECT (SELECT `eves_szabadsag` FROM `szemelyek` WHERE `szemely_id` = " . $_SESSION['szemely_id'] . ") - (SELECT COUNT(`azon`) FROM `keresek` WHERE `statusz`= 'szabadsag' AND `allapot`= 'elfogadva' AND `szemely_id` = " . $_SESSION['szemely_id'] . ") AS maradt;";
        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) > 0) {

            while ($row = mysqli_fetch_assoc($result)) {
                echo '<h3>' . $row['maradt'] . '</h3>';
            }
        }
    }
    ?>
</div>

