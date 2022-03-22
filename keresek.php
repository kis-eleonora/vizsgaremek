<!--Szabadság/táppénz űrlap-->

<?php 
include_once 'kerelem_kuld.php';
?>
<div class="kozep">
    <h2>KÉRELEM</h2>
    <form method="POST" onsubmit="return confirm('Biztosan leadja a kérelmet?');">

        <div class="form-row">
            <div class="form-group col-sm-6">

                <label for="kezdet">Kezdő dátum</label>
                <input class="form-control" type="date" id="kezdet" name="kezdet" required>
            </div>
            <div class="form-group col-sm-6">
                <label for="vege">Záró dátum</label>
                <input class="form-control" type="date" id="vege" name="vege">
            </div>
        </div>
        
<input type="radio" id="szabadsag" name="tavollet" value="szabadsag" checked>
            <label for="szabadsag">Szabadság</label><br>
            <input type="radio" id="tappenz" name="tavollet" value="tappenz">
            <label for="tappenz">Táppénz</label><br>

            <button type="submit" class="btn btn-success btn-lg m-2" name="kerelem" value = "true">Küldés</button>
        
    </form>

<?php
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
?>

</div>