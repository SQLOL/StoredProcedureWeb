CREATE PROCEDURE module_load_modules ()
BEGIN
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE module_name VARCHAR(255);
    DECLARE modules CURSOR FOR
        SELECT
            `Module`.`name`
        FROM `Module`
        WHERE
            `Module`.`enabled` = 1
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN modules;
    
    module_load_loop: LOOP
        FETCH modules INTO module_name;
        IF done THEN
            LEAVE module_load_loop;
        END IF;
        
        CALL module_load_module (module_name);
    END LOOP;
    
    CLOSE modules;
END|

CREATE PROCEDURE module_load_module (IN module_name VARCHAR(255))
BEGIN
    DECLARE init_exists TINYINT(1) DEFAULT FALSE;

    CALL procedure_exists(CONCAT(module_name, '_init'), init_exists);
    
    IF init_exists
    THEN
        CALL call_dynamic(CONCAT('CALL ', module_name, '_init'));
    END IF;
END|

CREATE PROCEDURE module_register_module (IN module_name VARCHAR(255), IN enabled TINYINT(1))
BEGIN
    INSERT INTO `Module` (name, enabled)
    VALUES (module_name, enabled)
    ;
END|
