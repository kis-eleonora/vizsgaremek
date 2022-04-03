<?php

require __DIR__. "/../src/funkciok.php";

use PHPUnit\Framework\TestCase;

final class funkciokTest extends TestCase{
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
}