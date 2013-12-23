CREATE PROCEDURE test$layout$build (IN request_id INT UNSIGNED, INOUT body TEXT)
BEGIN
    DECLARE header TEXT;
    DECLARE footer TEXT;
    DECLARE nav TEXT;
    
    CALL test$layout$header (request_id, header);
    CALL test$layout$footer (request_id, footer);
    CALL test$layout$nav (request_id, nav);
    
    SET body := CONCAT(header, body, footer);
    CALL view$replace_placeholder (body, 'test$layout$nav', nav);
END|

CREATE PROCEDURE test$layout$header (IN request_id INT UNSIGNED, OUT header TEXT)
BEGIN
    DECLARE header_view_id INT UNSIGNED;
    
    CALL view$create ('test$layout$header', header_view_id);
    CALL view$render (header_view_id, header);
    CALL view$clean (header_view_id);
END|

CREATE PROCEDURE test$layout$footer (IN request_id INT UNSIGNED, OUT footer TEXT)
BEGIN
    DECLARE footer_view_id INT UNSIGNED;
    
    CALL view$create ('test$layout$footer', footer_view_id);
    CALL view$render (footer_view_id, footer);
    CALL view$clean (footer_view_id);
END|

CREATE PROCEDURE test$layout$nav (IN request_id INT UNSIGNED, OUT nav TEXT)
BEGIN
    DECLARE nav_view_id INT UNSIGNED;
    
    CALL view$create ('test$layout$nav', nav_view_id);
    CALL test$model$nav$populate (nav_view_id);
    CALL view$render (nav_view_id, nav);
    CALL view$clean (nav_view_id);
END|
