CREATE PROCEDURE sqlunit_test_integration_request ()
BEGIN
    DECLARE request_id INT UNSIGNED;

    CALL request (
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
        'example.org',
        FALSE
    );
    
    SET request_id := LAST_INSERT_ID();
    
    
END|
