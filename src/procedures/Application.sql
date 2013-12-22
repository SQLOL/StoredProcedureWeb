CREATE PROCEDURE application (IN request_id INT UNSIGNED, IN finish TINYINT(1))
BEGIN
    DECLARE request_uri TEXT;
    DECLARE controller VARCHAR(255);
    DECLARE action VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL application$error (request_id, 500, finish);
    
    SELECT
        `Request`.`request_uri` INTO request_uri
    FROM `Request`
    WHERE
        `Request`.`id` = request_id
    ;
    
    CALL application$router (request_uri, controller, action);
    
    IF
        controller IS NOT NULL
        AND action IS NOT NULL
    THEN
        CALL application$dispatch (controller, action, request_id, finish);
    ELSE
        CALL application$error (request_id, 404, finish);
    END IF;
END|

CREATE PROCEDURE application$router (IN request_uri TEXT, OUT controller VARCHAR(255), OUT action VARCHAR(255))
BEGIN
    SELECT
        routes.`controller`,
        routes.`action`
    INTO
        controller,
        action
    FROM `Application_Route` routes
    WHERE
        (
            routes.`type` = 'plain'
            AND routes.`pattern` = request_uri
        )
        OR (
            routes.`type` = 'regex'
            AND routes.`pattern` REGEXP request_uri
        )
    ;
END|

CREATE PROCEDURE application$register_route (IN controller VARCHAR(255), IN action VARCHAR(255), IN type ENUM('plain', 'regex'), IN pattern TEXT)
BEGIN
    INSERT INTO `Application_Route` (controller, action, type, pattern)
    VALUES (controller, action, type, pattern);
END|

CREATE PROCEDURE application$dispatch (IN controller VARCHAR(255), IN action VARCHAR(255), IN request_id INT UNSIGNED, IN finish TINYINT(1))
BEGIN
    SET @dispatched_call = CONCAT('CALL ', controller, '_', action, ' (', request_id, ')');
    PREPARE dispatched_call FROM @dispatched_call;
    EXECUTE dispatched_call;
    DEALLOCATE PREPARE dispatched_call;
    
    IF finish = 1
    THEN
        CALL application$finish (request_id);
    END IF;
END|

CREATE PROCEDURE application$error (IN request_id INT UNSIGNED, IN error_code SMALLINT UNSIGNED, IN finish TINYINT(1))
BEGIN
    CASE error_code
    WHEN 404 THEN
        CALL application$dispatch_error (request_id, 'not-found');
    ELSE
        CALL application$dispatch_error (request_id, 'internal-server-error');
    END CASE;
    
    IF finish = 1
    THEN
        CALL application$finish (request_id);
    END IF;
END|

CREATE PROCEDURE application$dispatch_error (IN request_id INT UNSIGNED, IN error_name VARCHAR(255))
BEGIN
    DECLARE controller VARCHAR(255);
    DECLARE action VARCHAR(255);

    CALL application$router(CONCAT('error/', error_name), controller, action);
    
    IF
        controller IS NOT NULL
        AND action IS NOT NULL
    THEN
        CALL application$dispatch (controller, action, request_id, false);
    ELSE
        CALL application$respond (request_id, '', '');
    END IF;
END|

CREATE PROCEDURE application$respond (IN request_id INT UNSIGNED, IN headers TEXT, IN body TEXT)
BEGIN
    INSERT INTO `Response` (id, headers, body)
    VALUES (request_id, headers, body)
    ;
END;

CREATE PROCEDURE application$finish (IN request_id INT UNSIGNED)
BEGIN
    SELECT
        `Response`.`id`,
        `Response`.`headers`,
        `Response`.`body`
    FROM `Response`
    WHERE
        `Response`.`id` = request_id
    ;
    
    DELETE FROM `Request`
    WHERE
        `Request`.`id` = request_id
    ;
    
    DELETE FROM `Response`
    WHERE
        `Response`.`id` = request_id
    ;
END|

CREATE PROCEDURE application$event_sqlunit_start ()
BEGIN
    CREATE TEMPORARY TABLE TEMP_Application_Route LIKE `Application_Route`;
    INSERT INTO `TEMP_Application_Route` SELECT * FROM `Application_Route`;
    DELETE FROM `Application_Route`;
    DELETE FROM `Request`;
    DELETE FROM `Response`;
END|

CREATE PROCEDURE application$event_sqlunit_setup ()
BEGIN
    DELETE FROM `Application_Route`;
    DELETE FROM `Request`;
    DELETE FROM `Response`;
END|

CREATE PROCEDURE application$event_sqlunit_end ()
BEGIN
    DELETE FROM `Application_Route`;
    DELETE FROM `Request`;
    DELETE FROM `Response`;
    
    INSERT INTO `Application_Route` SELECT * FROM `TEMP_Application_Route`;
    DROP TEMPORARY TABLE `TEMP_Application_Route`;
END|
