CREATE PROCEDURE sqlunit_register_test (IN name VARCHAR(255))
BEGIN
    INSERT INTO `Test` (name)
    VALUES (CONCAT('sqlunit_test_', name))
    ;
END|

CREATE PROCEDURE sqlunit_execute ()
BEGIN
    DECLARE test_name VARCHAR(255);
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE tests CURSOR FOR SELECT
        `Test`.`name`
    FROM `Test`
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    OPEN tests;
    
    test_loop: LOOP
        FETCH tests INTO test_name;
        
        IF done THEN
            LEAVE test_loop;
        END IF;
        
        CALL sqlunit_execute_test (test_name);
    END LOOP;
    
    CLOSE tests;
END|

CREATE PROCEDURE sqlunit_execute_test (IN name VARCHAR(255))
BEGIN
    CALL call_dynamic (CONCAT('CALL ', name));
END|
