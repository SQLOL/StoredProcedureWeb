CREATE PROCEDURE application (IN request_id INT UNSIGNED)
BEGIN
    DECLARE document_uri TEXT;
    
    SELECT
        `Request`.`document_uri` INTO document_uri
    FROM `Request`
    WHERE
        `Request`.`id` = request_id
    ;
    
    CALL application_router (document_uri, controller, action);
    
    IF
        controller IS NULL
        OR action IS NULL
    THEN
        CALL application_error (request_id, 404);
    END IF;
    
    CALL application_dispatch (controller, action, request_id);
END|

CREATE PROCEDURE application_router (IN document_uri TEXT, OUT controller VARCHAR(255), OUT action VARCHAR(255))
BEGIN
    SELECT
        routes.`controller`,
        routes.`action`
    INTO
        controller,
        action
    FROM `Application_Routes` routes
    WHERE
        `Application_Routes`.`pattern` REGEXP document_uri
    ;
END|

CREATE PROCEDURE application_dispatch (IN controller VARCHAR(255), IN action VARCHAR(255), IN request_id INT UNSIGNED)
BEGIN
    CALL call_dynamic (CONCAT('CALL ', controller, '_', action, ' (', request_id, ')'));
    
    CALL application_retrieve_response(request_id, response);
    
    SELECT
        request_id AS 'request_id',
        response AS 'response'
    ;
END|

CREATE PROCEDURE application_error (IN request_id INT UNSIGNED, IN error_code SMALLINT UNSIGNED)
BEGIN
    CASE error_code
    WHEN 404 THEN
        CALL application_dispatch_error (request_id, 'not-found');
    ELSE
        CALL application_dispatch_error (request_id, 'internal-server-error');
    END CASE;
END|

CREATE PROCEDURE application_dispatch_error (IN request_id INT UNSIGNED, IN error_code SMALLINT UNSIGNED)
BEGIN
    CALL application_router(CONCAT('error/', error_code), controller, action);
    
    IF
        controller IS NOT NULL
        OR action IS NOT NULL
    THEN
        CALL application_dispatch (controller, action, request_id);
    END IF;
END|

source src/procedures/Application/Controller.sql
