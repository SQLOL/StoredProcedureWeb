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
    
    DROP TEMPORARY TABLE IF EXISTS `sqlunit_results`;
    CREATE TEMPORARY TABLE sqlunit_results (
        result ENUM('PASS', 'FAIL', 'INCOMPLETE', 'SKIPPED') NOT NULL,
        name VARCHAR(255) NOT NULL,
        message TEXT
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
    
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

CREATE PROCEDURE sqlunit_results ()
BEGIN
    SELECT
        *
    FROM `sqlunit_results`
    ;
END|

CREATE PROCEDURE sqlunit_execute_test (IN name VARCHAR(255))
BEGIN
    SET @execute_test = CONCAT('CALL ', name);
    PREPARE execute_test FROM @execute_test;
    EXECUTE execute_test;
    DEALLOCATE PREPARE execute_test;
END|

CREATE PROCEDURE sqlunit_pass (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('PASS', name, message);
END|

CREATE PROCEDURE sqlunit_fail (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('FAIL', name, message);
END|

CREATE PROCEDURE sqlunit_incomplete (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('INCOMPLETE', name, message);
END|

CREATE PROCEDURE sqlunit_skip (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('SKIPPED', name, message);
END|
