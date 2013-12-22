CREATE PROCEDURE view$create (IN template_name VARCHAR(255), OUT view_id INT UNSIGNED)
BEGIN
    INSERT INTO `View` (template)
    VALUES (template_name)
    ;
    
    SET view_id = LAST_INSERT_ID();
END|

CREATE PROCEDURE view$clean (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_name VARCHAR(255);
    DECLARE cleanup_handler_exists TINYINT(1) DEFAULT 0;
    
    SELECT
        `View_Template`.`callback`
    INTO
        view_name
    FROM `View`
    INNER JOIN `View_Template`
        ON `View_Template`.`name` = `View`.`template`
    WHERE
        `View`.`id` = view_id
    ;
    
    CALL procedure_exists(CONCAT(view_name, '$clean'), cleanup_handler_exists);
    IF cleanup_handler_exists = 1 THEN
        CALL call_dynamic (CONCAT('CALL ', view_name, '$clean (', view_id, ')'));
    END IF;
    
    DELETE FROM `View`
    WHERE
        `View`.`id` = view_id
    ;
END|

CREATE PROCEDURE view$render (IN view_id INT UNSIGNED, OUT rendered TEXT)
BEGIN
    DECLARE view_callback VARCHAR(255);
    DECLARE view_template_name VARCHAR(255);
    
    CALL view$get_template (view_id, view_template_name);
    
    CALL view$template_get_callback (view_template_name, view_callback);

    SET @view_template_call := CONCAT('CALL ', view_callback, ' (', view_id, ')');
    PREPARE view_template_call_statement FROM @view_template_call;
    EXECUTE view_template_call_statement;
    DEALLOCATE PREPARE view_template_call_statement;
    
    CALL view$render_get_result_clean (view_id, rendered);
END|

CREATE PROCEDURE view$register_template (IN view_template_name VARCHAR(255), IN view_template_callback VARCHAR(255))
BEGIN
    INSERT INTO `View_Template` (name, callback)
    VALUES (view_template_name, view_template_callback)
    ;
END|

CREATE PROCEDURE view$get_template (IN view_id INT UNSIGNED, OUT view_template_name VARCHAR(255))
BEGIN
    SELECT
        `View`.`template`
    INTO
        view_template_name
    FROM `View`
    WHERE
        `View`.`id` = view_id
    ;
END;

CREATE PROCEDURE view$template_get_callback (IN name VARCHAR(255), OUT view_callback VARCHAR(255))
BEGIN
    SELECT
        `View_Template`.`callback`
    INTO
        view_callback
    FROM `View_Template`
    WHERE
        `View_Template`.`name` = name
    ;
END|

CREATE PROCEDURE view$render_create_result (IN view_id INT UNSIGNED, IN rendered TEXT)
BEGIN
    INSERT INTO `View_Rendered` (id, result)
    VALUES (view_id, rendered)
    ;
END|

CREATE PROCEDURE view$render_get_result_clean (IN view_id INT UNSIGNED, OUT rendered TEXT)
BEGIN
    CALL view$render_get_result (view_id, rendered);
    
    DELETE FROM `View_Rendered`
    WHERE
        `View_Rendered`.`id` = view_id
    ;
END|

CREATE PROCEDURE view$render_get_result (IN view_id INT UNSIGNED, OUT rendered TEXT)
BEGIN
    SELECT
        `View_Rendered`.`result`
    INTO
        rendered
    FROM `View_Rendered`
    WHERE
        `View_Rendered`.`id` = view_id
    ;
END|

CREATE PROCEDURE view$replace_placeholder (INOUT content TEXT, IN placeholder VARCHAR(255), IN replacement VARCHAR(255))
BEGIN
    SET content = REPLACE(content, CONCAT('{%', placeholder, '%}'), replacement);
END|
