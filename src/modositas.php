<!--Személyes adatok/jelszó módosítás-->

<?php
require_once 'jelszo_mod.php';
?>
<div class ="modform">
    <h2 class="text-uppercase">Adatok módosítása</h2>
    <form class="form-group" method="POST">

        <label>Régi jelszó</label>
        <input class ="form-control w-35 m-2"
               type="password" 
               name="regiJelszo" 
               placeholder="Régi jelszó">
        <br>

        <label>Új jelszó</label>
        <input class ="form-control w-35 m-2" 
               type="password" 
               name="ujJelszo" 
               placeholder="Új jelszó">
        <br>

        <label>Új jelszó megerősítése</label>
        <input class ="form-control w-35 m-2"
               type="password" 
               name="jelszoMegerosites" 
               placeholder="Új jelszó megerősítése">
        <br>

        <button type="submit" class="btn btn-success btn-lg m-2" name="modositas" value = "true">Mentés</button>
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
