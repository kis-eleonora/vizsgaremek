<?php
require_once 'connect.php';
?>
<div class="beosztottak">
    <h2>Beosztottak listája</h2>
    <ol>
        <?php
        $sql = "SELECT `nev` FROM `szemelyek` WHERE `fonok` = " . $_SESSION['szemely_id'] . ";";
        $result = mysqli_query($conn, $sql);
        if (mysqli_num_rows($result) > 0) {

            while ($row = mysqli_fetch_assoc($result)) {
                echo '<li>' . $row['nev'] . '</li>';
            }
        } else {
            echo 'Nincsenek beosztottak.';
        }
        ?>
    </ol>
</div>