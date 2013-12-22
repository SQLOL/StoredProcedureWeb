<?php
$pdo = new PDO('mysql:dbname='.$_SERVER['DB_NAME'].';host='.$_SERVER['DB_HOST'], $_SERVER['DB_USER'], $_SERVER['DB_PASSWORD']);

if(!empty($_SERVER)) {
    $pdo->exec('CALL request$init');

    $headerSetter = 'INSERT INTO Request$Header (name, value) VALUES'.PHP_EOL;
    $headerParams = array();
    $paramSetter = 'INSERT INTO Request$Param (name, value) VALUES'.PHP_EOL;
    $paramParams = array();
    foreach($_SERVER as $key => $value) {
        if(substr($key, 0, 5) === 'HTTP') {
            if(count($headerParams)) {
                $headerSetter .= ',';
            }
            $headerSetter .= '(?, ?)';
            $headerParams[] = $key;
            $headerParams[] = $value;
        } else {
            if(count($paramParams)) {
                $paramSetter .= ',';
            }
            $paramSetter .= '(?, ?)';
            $paramParams[] = $key;
            $paramParams[] = $value;
        }
    }
    
    if(!empty($headerParams)) {
        $headerStatement = $pdo->prepare($headerSetter);
        $headerStatement->execute($headerParams);
    }
    
    if(!empty($paramParams)) {
        $paramStatement = $pdo->prepare($paramSetter);
        $paramStatement->execute($paramParams);
    }
}


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
