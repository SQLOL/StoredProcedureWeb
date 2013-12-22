CREATE PROCEDURE module$load_modules ()
BEGIN
    CALL module$ducktype_method ('init');
    CALL module$ducktype_method ('register_routes');
    CALL module$ducktype_method ('register_views');
    CALL module$ducktype_method ('load_assets');
END|

CREATE PROCEDURE module$ducktype_method (IN method VARCHAR(255))
BEGIN
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE method_callback VARCHAR(255);
    DECLARE methods CURSOR FOR
        SELECT
            routines.ROUTINE_NAME
        FROM information_schema.ROUTINES AS routines
        WHERE
            routines.ROUTINE_SCHEMA = DATABASE()
            AND routines.ROUTINE_TYPE = 'PROCEDURE'
            AND routines.ROUTINE_NAME COLLATE utf8_unicode_ci IN (
                SELECT
                    CONCAT(`Module`.`name`, '$', method)
                FROM `Module`
                WHERE
                    `Module`.`enabled` = 1
            )
    ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN methods;
    
    method_handler_loop: LOOP
        FETCH methods INTO method_callback;
        IF done THEN
            LEAVE method_handler_loop;
        END IF;
        
        SET @ducktyped_method := CONCAT('CALL ', method_callback);
        PREPARE ducktype_call FROM @ducktyped_method;
        EXECUTE ducktype_call;
        DEALLOCATE PREPARE ducktype_call;
    END LOOP;
    
    CLOSE methods;
END|

CREATE PROCEDURE module$register_module (IN module_name VARCHAR(255), IN enabled TINYINT(1))
BEGIN
    INSERT INTO `Module` (name, enabled)
    VALUES (module_name, enabled)
    ;
END|

CREATE PROCEDURE module$trigger_event (IN event_name VARCHAR(255))
BEGIN
    CALL module$ducktype_method (CONCAT('event$', event_name));
END|
