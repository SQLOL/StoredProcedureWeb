<?php
$pdo = new PDO('mysql:dbname='.$_SERVER['DB_NAME'].';host='.$_SERVER['DB_HOST'], $_SERVER['DB_USER'], $_SERVER['DB_PASSWORD']);

$headerSetter = '';
$paramSetter = '';
$params = array();
foreach($_SERVER as $key => $value) {
    if(substr($key, 0, 5) === 'HTTP') {
        $headerSetter .= 'CALL request$set_header (?, ?); ';
        $params[] = $key;
        $params[] = $value;
    } else {
        $paramSetter .= 'CALL request$set_param (?, ?); ';
        $params[] = $key;
        $params[] = $value;
    }
}

$setterStatement = $pdo->prepare('CALL request$init; '.$headerSetter.$paramSetter);
$setterStatement->execute($params);


$statement = $pdo->prepare('CALL request (
    :request_method,
    :request_uri,
    true
)');

$statement->execute(array(
    ':request_method' => $_SERVER['REQUEST_METHOD'],
    ':request_uri' => $_SERVER['REQUEST_URI'],
));

$result = $statement->fetch(PDO::FETCH_ASSOC);

if(!empty($result['headers'])) {
    $headers = explode("\n", $result['headers']);
    foreach($headers as $header) {
        if(!empty($header)) {
            header($header);
        }
    }
}
print $result['body'];
