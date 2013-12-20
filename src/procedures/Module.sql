CREATE PROCEDURE module_load_modules ()
BEGIN
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE module_name VARCHAR(255);
    DECLARE module_path TEXT;
    DECLARE module_entry_point TEXT;
    DECLARE modules CURSOR FOR
        SELECT
            `Module`.`name`,
            `Module`.`path`
        FROM `Module`
        WHERE
            `Module`.`enabled` = 1
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN modules;
    
    module_load_loop: LOOP
        FETCH modules INTO module_name, module_path;
        IF done THEN
            LEAVE module_load_loop;
        END IF;
        
        SELECT CONCAT(module_path, '/Module.sql') INTO module_entry_point;
        
        CALL call_dynamic(CONCAT('source ', module_entry_point));
    END LOOP;
    
    CLOSE modules;
END|
