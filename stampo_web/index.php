<?php

header('Content-type: application/json');

// For changing the URL, just redirect it to the wanted URL
// $response = array("ok" => false, 
// 					"list_url" => "http://www.kejuliso.com/stampo/test.php",
// 					"base_url" => "http://www.kejuliso.com/stampo");
// echo json_encode($response);
// exit;


$dir = "birds";

$birds = array();


if ($handle = opendir($dir)) {
    while (false !== ($entry = readdir($handle))) {

    	if (!is_file($dir . "/" . $entry)) continue;

        $birds[] = $dir . "/" . $entry;
    }
}

sort($birds, SORT_STRING);
$response = array("ok" => true, "birds" => $birds);

echo json_encode($response);

?>