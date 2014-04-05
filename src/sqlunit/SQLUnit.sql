CREATE PROCEDURE sqlunit$register_test (IN name VARCHAR(255))
BEGIN
    INSERT INTO `Test` (name)
    VALUES (name)
    ;
END|

CREATE PROCEDURE sqlunit$execute ()
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
    
    CALL module$trigger_event ('sqlunit_start');
    
    OPEN tests;
    
    test_loop: LOOP
        FETCH tests INTO test_name;
        
        IF done THEN
            LEAVE test_loop;
        END IF;
        
        CALL module$trigger_event ('sqlunit_setup');
        
        CALL sqlunit$execute_test (test_name);
        
        CALL module$trigger_event ('sqlunit_teardown');
    END LOOP;
    
    CLOSE tests;
    
    CALL module$trigger_event ('sqlunit_end');
END|

CREATE PROCEDURE sqlunit$results ()
BEGIN
    DECLARE failed_tests SMALLINT UNSIGNED;
    
    SELECT
        *
    FROM `sqlunit_results`
    ;
    
    SELECT
        count(0)
    INTO
        failed_tests
    FROM `sqlunit_results`
    WHERE
        `sqlunit_results`.`result` = 'FAIL'
    ;
    
    IF failed_tests > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'One or more tests has failed.';
    END IF;
END|

CREATE PROCEDURE sqlunit$execute_test (IN name VARCHAR(255))
BEGIN
    SET @execute_test = CONCAT('CALL ', name);
    PREPARE execute_test FROM @execute_test;
    EXECUTE execute_test;
    DEALLOCATE PREPARE execute_test;
END|

CREATE PROCEDURE sqlunit$pass (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('PASS', name, message);
END|

CREATE PROCEDURE sqlunit$fail (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('FAIL', name, message);
END|

CREATE PROCEDURE sqlunit$incomplete (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('INCOMPLETE', name, message);
END|

CREATE PROCEDURE sqlunit$skip (IN name VARCHAR(255), IN message TEXT)
BEGIN
    INSERT INTO `sqlunit_results` (result, name, message)
    VALUES ('SKIPPED', name, message);
END|

CREATE PROCEDURE sqlunit$coverage ()
BEGIN
    CALL sqlunit$coverage$calculate_coverage ();
    
    SELECT
        `sqlunit_coverage`.`procedure_name` AS procedure_name,
        IF(`Test`.`name` IS NOT NULL, `Test`.`name`, 'Not covered') AS test_name
    FROM `sqlunit_coverage`
    LEFT JOIN `sqlunit_coverage_coveredby`
        ON `sqlunit_coverage_coveredby`.`procedure_name` = `sqlunit_coverage`.`procedure_name`
    LEFT JOIN `Test`
        ON `Test`.`id` = `sqlunit_coverage_coveredby`.`test_id`
    ORDER BY
        `sqlunit_coverage`.`procedure_name` ASC
    ;
END|

CREATE PROCEDURE sqlunit$coverage$calculate_coverage ()
BEGIN
    DECLARE test_id INT UNSIGNED;
    DECLARE test_name VARCHAR(255);
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE tests CURSOR FOR SELECT
        `Test`.`id` AS id,
        `Test`.`name` AS name
    FROM `Test`
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    DROP TEMPORARY TABLE IF EXISTS `sqlunit_coverage`;
    CREATE TEMPORARY TABLE sqlunit_coverage (
        procedure_name VARCHAR(64) UNIQUE NOT NULL
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
    
    INSERT INTO `sqlunit_coverage`
    SELECT
        routines.`SPECIFIC_NAME`
    FROM information_schema.ROUTINES AS routines
    WHERE
        routines.ROUTINE_SCHEMA = DATABASE()
        AND routines.ROUTINE_TYPE = 'PROCEDURE'
    GROUP BY routines.`SPECIFIC_NAME`
    ;
    
    DROP TEMPORARY TABLE IF EXISTS `sqlunit_coverage_coveredby`;
    CREATE TEMPORARY TABLE sqlunit_coverage_coveredby (
        procedure_name VARCHAR(64) NOT NULL,
        test_id INT UNSIGNED NOT NULL
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
    
    CALL module$trigger_event ('sqlunit_coverage_start');
    
    OPEN tests;
    
    test_loop: LOOP
        FETCH tests INTO test_id, test_name;
        
        IF done THEN
            LEAVE test_loop;
        END IF;
        
        CALL procedure_annotations (test_name);
        
        CALL sqlunit$coverage$associate_coverage (test_id);
        
        DELETE
            `sqlunit_coverage`
        FROM `sqlunit_coverage`
        INNER JOIN `Test`
            ON `sqlunit_coverage`.`procedure_name` = `Test`.`name`
        ;
    END LOOP;
    
    CLOSE tests;
    
    CALL module$trigger_event ('sqlunit_coverage_end');
END|

CREATE PROCEDURE sqlunit$coverage$associate_coverage (test_id INT UNSIGNED)
BEGIN
    DECLARE covered_procedure VARCHAR(64);
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE annotations CURSOR FOR SELECT
        `parameters` AS covered_procedure
    FROM `parsed_annotations`
    WHERE
        `type` = 'covers'
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    OPEN annotations;
    
    association_loop: LOOP
        FETCH annotations INTO covered_procedure;
        
        IF done THEN
            LEAVE association_loop;
        END IF;
        
        INSERT INTO `sqlunit_coverage_coveredby` (`procedure_name`, `test_id`)
        VALUES (covered_procedure, test_id);
    END LOOP;
    
    CLOSE annotations;
END|
