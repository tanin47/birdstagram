<?php

header('Content-type: application/json');

$birds = array("birds/04_bird.png");
$response = array("ok" => true, "birds" => $birds);

echo json_encode($response);

?>