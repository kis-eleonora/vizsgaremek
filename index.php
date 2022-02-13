<!DOCTYPE html>
<html lang="hu">
    <head>
        <title>MikorDolgozom</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="indexcss.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <div>
            <img id="fokep" src="kepek/work-g9338c4078_1280.png" alt=""/>
            <div class="logo">
                <a href="index.html"><img id="logokep" src="kepek/logo.png" alt=""/></a>
            </div>
            <div class="container-fluid">
                <p>MŰSZAKBEOSZTÁS CÉGEKNEK</p>
                <h1>Hozza létre és ossza meg</h1> 
                <h3>beosztottjai munkarendjét percek alatt!<br>Kövesse és módosítsa bármikor munkabeosztását!</h3>
                <div class="doboz">
                    <h4>Lássuk a beosztásokat!</h4>
                    <form class="form-inline" method="POST" action="ellenorzes.php">

                        <input type="text"  class ="form-control w-35 m-2" name="email" id="email" value="" placeholder="E-mail cím">

                        <input type="password" class ="form-control w-35 m-2" name="jelszo" id="jelszo" value="" placeholder="Jelszó">
                        <button type="submit" class="btn btn-warning btn-lg m-2" >Belépés</button>

                    </form>
                    <?php
                    session_start();
                    if (isset($_SESSION['error'])) {
                        echo '<div id="error" style="color:red;">' . $_SESSION['error'] . '</div>';
                        unset($_SESSION['error']);
                        exit();
                    }
                    ?>
                </div>
            </div>
        </div>
    </body>
</html>
