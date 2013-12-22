CREATE PROCEDURE sqlunit_test_integration_request ()
BEGIN
    DECLARE test_name VARCHAR(255) DEFAULT 'sqlunit_test_integration_request';
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
        23423,
        '127.0.0.1',
        80,
        'example.org',
        FALSE
    );
    
    SET request_id := LAST_INSERT_ID();
    
    IF request_id IS NULL
    THEN
        CALL sqlunit$fail (test_name, 'Request ID not generated');
    ELSE
        CALL sqlunit$pass (test_name, 'Success');
    END IF;
END|
