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
    
    CALL call_dynamic (CONCAT('CALL ', controller, '_', action, ' (', request_id, ')'));
END;

CREATE PROCEDURE application_router (IN document_uri TEXT, OUT controller VARCHAR(255), OUT action VARCHAR(255))
BEGIN
    SELECT
        `Application_Routes`.`controller` INTO controller,
        `Application_Routes`.`action` INTO action
    FROM `Application_Routes`
    WHERE
        `Application_Routes`.`pattern` REGEXP document_uri
    ;
END;
