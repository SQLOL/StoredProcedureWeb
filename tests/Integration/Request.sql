CREATE PROCEDURE sqlunit_test_integration_request ()
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
        'a=b&b=c&c=d&d=e',
        'GET',
        '',
        0,
        '/?a=b&b=c&c=d&d=e',
        '/',
        'HTTP/1.1',
        '8.8.8.8',
        234234,
        '127.0.0.1',
        80,
        'example.org'
    );
END|
