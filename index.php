<?php
session_start();
$menu = filter_input(INPUT_GET, "menu", FILTER_SANITIZE_STRING);
$_SESSION["login"] = $_SESSION["login"] ?? false;
$_SESSION["jog"] = $_SESSION["jog"] ?? "alkalmazott";
require_once 'src/head.php';
require_once 'src/funkciok.php';

if ($_SESSION["login"]) {
    ?>
    <nav class="navbar navbar-expand-lg bg-white navbar-light">
        <a class="navbar-brand" href="index.php"><img id="logo" src="kepek/logo2.png" alt=""/></a>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-center" id="navbarNavDropdown">
            <ul class="navbar-nav">
                <li class="nav-item active">
                    <a class="nav-link text-success" href="index.php?menu=beosztasaim">NAPTÁR</a>
                </li>
                <?php
                if (fonoke($_SESSION["jog"])) {
                    echo '<li class="nav-item active">
                    <a class="nav-link text-success" href="index.php?menu=beosztottjaim">BEOSZTOTTJAIM</a>
                </li>';
                } else {
                    echo '<li class="nav-item">
                    <a class="nav-link text-success" href="index.php?menu=keresek">KÉRÉSEK</a>
                </li>';
                }
                ?>


                <li class="nav-item">
                    <a class="nav-link text-success" href="index.php?menu=ertesitesek">ÉRTESÍTÉSEK</a>
                </li>
             
                <li class="nav-item dropdown">
                    <a class="nav-link text-success dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        SZEMÉLYES
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                        <a class="dropdown-item" href="index.php?menu=modositas">SZEMÉLYES ADATOK MÓDOSÍTÁSA</a>
                        <a class="dropdown-item" href="index.php?menu=kijelentkezes">KIJELENTKEZÉS</a>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
<!--<div class="fooldal">
    <img id="indexkep" src="kepek/laptop-g05b34184f_1280.png" alt=""/>
</div>-->
    <?php
    if (isset($_SESSION['nev'])) {
        echo '<aside class="udvozlet"><img id="avatar" src="kepek/avatar-ga9d1324f5_1280.png" alt=""/><h3> Üdvözöljük, kedves <br><strong>' . $_SESSION['nev'] . '</strong>!</h3></aside>';
    }
    ?>

    <div>
        <?php
        switch ($menu) {
            case "beosztottjaim":
                include 'src/beosztottjaim.php';
                break;
            case "beosztasaim":
                include 'src/beosztasaim.php';
                break;
            case "keresek":
                include 'src/keresek.php';
                break;
            case "ertesitesek":
                include 'src/ertesitesek.php';
                break;
            case "modositas":
                include 'src/modositas.php';
                break;
            case "kijelentkezes":
                session_destroy();
                header('location:index.php');
                break;

            default:
                break;
        }
        ?>
    </div>
    <?php
} else {
    include 'src/login.php';
}
?>

</body>
</html>
