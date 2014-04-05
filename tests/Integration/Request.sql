CREATE PROCEDURE sqlunit_test_integration_request ()
COMMENT '
@covers request
'
BEGIN
    DECLARE test_name VARCHAR(255) DEFAULT 'sqlunit_test_integration_request';
    DECLARE request_id INT UNSIGNED;

    CALL request (
        'GET',
        '/',
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
