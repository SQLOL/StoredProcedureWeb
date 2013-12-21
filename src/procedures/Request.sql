CREATE PROCEDURE request (
    IN query_string TEXT,
    IN request_method ENUM('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'OPTIONS', 'CONNECT', 'PATCH'),
    IN content_type TEXT,
    IN content_length INT UNSIGNED,
    IN request_uri TEXT,
    IN document_uri TEXT,
    IN server_protocol TEXT,
    IN remote_addr TEXT,
    IN remote_port SMALLINT UNSIGNED,
    IN server_addr TEXT,
    IN server_port SMALLINT UNSIGNED,
    IN server_name TEXT,
    IN finish TINYINT(1)
)
BEGIN
    INSERT INTO `Request` (
        query_string,
        request_method,
        content_type,
        content_length,
        request_uri,
        document_uri,
        server_protocol,
        remote_addr,
        remote_port,
        server_addr,
        server_port,
        server_name
    ) VALUES (
        query_string,
        request_method,
        content_type,
        content_length,
        request_uri,
        document_uri,
        server_protocol,
        remote_addr,
        remote_port,
        server_addr,
        server_port,
        server_name
    );
    
    CALL application(LAST_INSERT_ID(), finish);
END|
