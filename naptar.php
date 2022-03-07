<?php

class Naptar {

    private $datum = null;

    public function __construct() {
        ;
    }

    function havi($year, $month) {

        $day = 1;
        $honapnev = null;
        switch (date("m", $this->datum)) {
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
//
//            default:
//                break;
        }
        $this->datum = strtotime("$year-$month-1");

        echo '<h2>' . date('Y', $this->datum)." ". $honapnev . '</h2>
        <div class="table-responsive">
        <table class="table table-bordered text-center" id="havinaptar">
                <thead>
                    <tr class="bg-light-gray">
                        <th class="text-uppercase">Hétfő</th>
                        <th class="text-uppercase">Kedd</th>
                        <th class="text-uppercase">Szerda</th>
                        <th class="text-uppercase">Csütörtök</th>
                        <th class="text-uppercase">Péntek</th>
                        <th class="text-uppercase">Szombat</th>
                        <th class="text-uppercase">Vasárnap</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>';
        $h = intval(date('w', $this->datum)); //-- az első nap a hét hanyadik napjára esik (0-vasárnap, 1-hétfő, ...)
        $this->uresCella($h == 0 ? 6 : $h - 1); //-- az első sort feltöltjük üressel
        while (intval(date('m', $this->datum = strtotime("$year-$month-$day"))) == intval($month)) {
            echo intval(date('w', $this->datum)) == 1 ? '<tr>' : ''; //-- hétfő esetén új sort kezdünk
            $this->nap();
            echo intval(date('w', $this->datum)) == 0 ? '</tr>' : ''; //-- vasárnap esetén lezárjuk a sort
            $day++;
        };
        $day--;
        $h = intval(date('w', strtotime("$year-$month-$day")));
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
//                $style = $row["style"];
                $title = $row["title"];
                if ($title == "munkanap") {
                    $style = "munkanap";
                } else {
                    $style = "unnep";
                }
            }
        }
//        $key = array_search(date('Y-m-d', $this->datum), array_column($munkaszunetek, 'datum'));
//        if()
        echo '<td title="' . $title . '" class="' . $style . '">' . date('j', $this->datum) . "</td>";
    }

    private function uresCella($db) {
        for ($index = 0; $index < $db; $index++) {
            echo '<td class="ures">&nbsp;</td>';
        }
    }

}
