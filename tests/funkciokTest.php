<?php

require __DIR__ . "/../src/funkciok.php";

use PHPUnit\Framework\TestCase;

final class funkciokTest extends TestCase {

    public function testFonokeHaFonok() {
        $jog = 'fonok';
        $ertek = fonoke($jog);
        $this->assertTrue($ertek);
    }

    public function testFonokeHaNemFonok() {
        $jog = 'alkalmazott';
        $ertek = fonoke($jog);
        $this->assertFalse($ertek);
    }

    public function testFonokeHaNull() {
        $jog = null;
        $ertek = fonoke($jog);
        $this->assertFalse($ertek);
    }

    public function testJelszoEgyezesHaMegegyezik() {
        $ujJelszo = '1111';
        $jelszoMegerosites = '1111';
        $ertek = jelszoEgyezes($ujJelszo, $jelszoMegerosites);
        $this->assertTrue($ertek);
    }

    public function testJelszoEgyezesHaNemEgyezik() {
        $ujJelszo = '1111';
        $jelszoMegerosites = '2222';
        $ertek = jelszoEgyezes($ujJelszo, $jelszoMegerosites);
        $this->assertFalse($ertek);
    }

    public function testNincsenekAdatokHaNincsEmail() {
        $email = null;
        $jelszo = '1234';
        $ertek = nincsenekAdatok($jelszo, $email);
        $this->assertTrue($ertek);
    }

    public function testNincsenekAdatokHaNincsJelszo() {
        $email = 'veres@gmail.com';
        $jelszo = null;
        $ertek = nincsenekAdatok($jelszo, $email);
        $this->assertTrue($ertek);
    }

    public function testEgyNaposKerelemSikeres() {
        $elvartsql = "INSERT INTO `keresek`(`szemely_id`, `datum`, `statusz`, `allapot`) "
                . "VALUES ('3','2022-03-03','szabadsag','elfogadva');";
        $szemely_id = '3';
        $start = new DateTime('2022-03-03');
        $tavollet = 'szabadsag';
        $allapot = 'elfogadva';
        $sql = sqlEgynaposKerelem($szemely_id, $start, $tavollet, $allapot);
        $this->assertNotNull($sql);
        $this->assertSame($elvartsql, $sql);
    }

    public function testTobbNaposKerelemKetNapos() {
        $elvartsql = "INSERT INTO `keresek` (`szemely_id`, `datum`, `statusz`, `allapot`) VALUES "
                . "('3','2022-03-01','szabadsag','elinditva'),"
                . "('3','2022-03-02','szabadsag','elinditva')";
        $szemely_id = '3';
        $end = new DateTime('2022-03-02');
        $start = new DateTime('2022-03-01');
        $tavollet = 'szabadsag';
        $allapot = 'elinditva';
        $sql = sqlTobbnaposKerelem($szemely_id, $end, $start, $tavollet, $allapot);
        $this->assertNotNull($sql);
        $this->assertSame($elvartsql, $sql);
    }

    public function testTobbNaposKerelemHetes() {
        $elvartsql = "INSERT INTO `keresek` (`szemely_id`, `datum`, `statusz`, `allapot`) VALUES "
                . "('3','2022-03-01','tappenz','elfogadva'),"
                . "('3','2022-03-02','tappenz','elfogadva'),"
                . "('3','2022-03-03','tappenz','elfogadva'),"
                . "('3','2022-03-04','tappenz','elfogadva'),"
                . "('3','2022-03-05','tappenz','elfogadva'),"
                . "('3','2022-03-06','tappenz','elfogadva'),"
                . "('3','2022-03-07','tappenz','elfogadva')";
        $szemely_id = '3';
        $end = new DateTime('2022-03-07');
        $start = new DateTime('2022-03-01');
        $tavollet = 'tappenz';
        $allapot = 'elfogadva';
        $sql = sqlTobbnaposKerelem($szemely_id, $end, $start, $tavollet, $allapot);
        $this->assertNotNull($sql);
        $this->assertSame($elvartsql, $sql);
    }

    public function testHonapokKivalasztasaHaMarcius() {
        $datum = strtotime("2022-03-1");
        $honapnev = honapokKivalasztasa($datum);
        $this->assertSame('Március', $honapnev);
    }

    public function testHonapokKivalasztasaHaDecember() {
        $datum = strtotime("2022-12-1");
        $honapnev = honapokKivalasztasa($datum);
        $this->assertSame('December', $honapnev);
    }

}
