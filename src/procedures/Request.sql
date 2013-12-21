CREATE PROCEDURE request (
    query_string TEXT,
    request_method ENUM('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'OPTIONS', 'CONNECT', 'PATCH'),
    content_type TEXT,
    content_length INT UNSIGNED,
    request_uri TEXT,
    document_uri TEXT,
    server_protocol TEXT,
    remote_addr TEXT,
    remote_port SMALLINT UNSIGNED,
    server_addr TEXT,
    server_port SMALLINT UNSIGNED,
    server_name TEXT
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
    
    CALL application(LAST_INSERT_ID());
END|
