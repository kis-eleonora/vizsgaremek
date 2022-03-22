<?php
require_once 'connect.php';
include_once 'szab_elfogad.php';
?>
<div class="ertesitesek">
    <h2>Beérkezett szabadság kérelmek</h2>
    <div class="">
        <form method="POST">
            <table class="table table-bordered text-center">
                <thead>
                    <tr class="bg-light-gray">
                        <th class="text-uppercase">Azonosító</th>
                        <th class="text-uppercase">Név</th>
                        <th class="text-uppercase">Dátum</th>
                        <th class="text-uppercase">Elfogad</th>
                    </tr>
                </thead>
                <tbody>   
                    <?php
                    $sql = "SELECT `nev`, `datum`, `azon` FROM `keresek`, `szemelyek` WHERE szemelyek.szemely_id = keresek.szemely_id AND szemelyek.fonok=" . $_SESSION['szemely_id'] . " AND `allapot` = 'elinditva';";

                    $result = mysqli_query($conn, $sql);
                    if (mysqli_num_rows($result) > 0) {
                        
                        while ($row = mysqli_fetch_assoc($result)) {
                            echo '<tr>'
                            . '<td>' . $row['azon'] . '</td>'
                            . '<td>' . $row['nev'] . '</td>
                            <td>' . $row['datum'] . '</td>'
                            . '<td><input type = "checkbox" name = "elfogadva" value = "' . $row['azon'] . '"></td>'
                            . '</tr>';
                        }
                    }
                    ?>
                </tbody>
            </table>
            <button type="submit" class="btn btn-success btn-lg m-2" name="elfogad" value = "true">Küldés</button>
        </form>
    </div>
</div>