

<?php
require_once 'head.php';
require_once 'naptar.php';


$year = 2022;
$month = 3;
$datum = strtotime("$year-$month-1");
require_once 'naptardb.php';
$db = new Database();
$munkaszunetek = $db->Munkaszunetek($year);
echo '<pre>';
//print_r($munkaszunetek);
echo '</pre>';
?>
<link href="naptar.css?v=<?php echo time(); ?>" rel="stylesheet" type="text/css"/>
<div id="sheet">
    <h1>Naptár</h1>
    <div class = "naptar">
        <?php
        $naptar = new Naptar();
        $naptar->havi(2022, 1);
        $naptar->havi(2022, 2);
        $naptar->havi(2022, 3);
        $naptar->havi(2022, 4);
        $naptar->havi(2022, 5);
        $naptar->havi(2022, 6);
        $naptar->havi(2022, 7);
        $naptar->havi(2022, 8);
        $naptar->havi(2022, 9);
        $naptar->havi(2022, 10);
        $naptar->havi(2022, 11);
        $naptar->havi(2022, 12);
        ?>
    </div>
</div>
</body>
</html>
