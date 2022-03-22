<?php
require_once 'connect.php';

if (filter_input(INPUT_POST, "elfogad", FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)) {
    echo (isset($_POST['elfogadva'])?$_POST['elfogadva']:'');
}