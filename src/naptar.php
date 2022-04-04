<!--Naptár megjelenítése-->

<?php

class Naptar {

    private $datum = null;

    public function __construct() {
        ;
    }

    function havi($year, $month) {

        $day = 1;
        $this->datum = strtotime("$year-$month-1");
        $honapnev = honapokKivalasztasa($this->datum);

        echo '<h2 class="text-uppercase">' . date('Y', $this->datum) . " " . $honapnev . '</h2>
        <div class="table-responsive">
        <table class="table text-center" id="havinaptar">
                <thead>
                        <th class="text-uppercase">Hétfő</th>
                        <th class="text-uppercase">Kedd</th>
                        <th class="text-uppercase">Szerda</th>
                        <th class="text-uppercase">Csütörtök</th>
                        <th class="text-uppercase">Péntek</th>
                        <th class="text-uppercase">Szombat</th>
                        <th class="text-uppercase">Vasárnap</th>
                </thead>
                <tbody>
                    <tr>';
        $h = intval(date('w', $this->datum)); //-- az első nap a hét hanyadik napjára esik (0-vasárnap, 1-hétfő, ...)
        $this->uresCella($h == 0 ? 6 : $h - 1); //-- az első sort feltöltjük üressel
        while (intval(date('m', $this->datum)) == intval($month)) {
            echo intval(date('w', $this->datum)) == 1 ? '<tr>' : ''; //-- hétfő esetén új sort kezdünk
            $this->nap();
            echo intval(date('w', $this->datum)) == 0 ? '</tr>' : ''; //-- vasárnap esetén lezárjuk a sort
            $this->datum = strtotime('+1 day', $this->datum);
        }
        $h = intval(date('w', $this->datum));
        $this->uresCella($h == 0 ? 0 : 7 - $h); //-- utolsó sort is feltöltjük
        echo '</tr>                    
                </tbody>
            </table>
            </div>';
    }

    private function nap() {
        //-- keressük a munkaszünetek között
        global $munkaszunetek;
        switch (intval(date('w', $this->datum))) {
            case 0:
                $style = "vasarnap";
                break;
            case 6:
                $style = "szombat";
                break;

            default:
                $style = "munkanap";
                break;
        }
        $title = "";
        foreach ($munkaszunetek as $row) {
            if ($this->datum == strtotime($row["datum"])) {
                $title = $row["title"];
                if ($title == "munkanap") {
                    $style = "munkanap";
                } else {
                    $style = "unnep";
                }
            }
        }
        echo '<td title="' . $title . '" class="' . $style . '">' . date('j', $this->datum) . "</td>";
    }

    private function uresCella($db) {
        for ($index = 0; $index < $db; $index++) {
            echo '<td class="ures">&nbsp;</td>';
        }
    }

}
