<?php
$pdo = new PDO('mysql:dbname='.$_SERVER['DB_NAME'].';host='.$_SERVER['DB_HOST'], $_SERVER['DB_USER'], $_SERVER['DB_PASSWORD']);
$statement = $pdo->prepare('CALL request (
    :query_string,
    :request_method,
    :content_type,
    :content_length,
    :request_uri,
    :document_uri,
    :server_protocol,
    :remote_addr,
    :remote_port,
    :server_addr,
    :server_port,
    :server_name,
    true
)');

$statement->execute(array(
    ':query_string' => $_SERVER['QUERY_STRING'],
    ':request_method' => $_SERVER['REQUEST_METHOD'],
    ':content_type' => $_SERVER['CONTENT_TYPE'],
    ':content_length' => $_SERVER['CONTENT_LENGTH'],
    ':request_uri' => $_SERVER['REQUEST_URI'],
    ':document_uri' => $_SERVER['DOCUMENT_URI'],
    ':server_protocol' => $_SERVER['SERVER_PROTOCOL'],
    ':remote_addr' => $_SERVER['REMOTE_ADDR'],
    ':remote_port' => $_SERVER['REMOTE_PORT'],
    ':server_addr' => $_SERVER['SERVER_ADDR'],
    ':server_port' => $_SERVER['SERVER_PORT'],
    ':server_name' => $_SERVER['SERVER_NAME'],
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
