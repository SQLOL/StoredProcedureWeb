CREATE PROCEDURE test$index$register_routes ()
BEGIN
    CALL application$register_route ('test$index', 'index', 'plain', '/');
    CALL application$register_route ('test$index', 'about', 'plain', '/about');
    
    CALL test$model$nav$add ('/about', 'About');
END|

CREATE PROCEDURE test$index$index (IN request_id INT UNSIGNED)
BEGIN
    DECLARE headers TEXT;
    DECLARE body TEXT;
    DECLARE view_id INT UNSIGNED;
    
    CALL view$create ('test$index$index', view_id);
    CALL view$render (view_id, body);
    CALL view$clean (view_id);
    
    CALL test$layout$build (request_id, body);
    
    CALL application$respond (request_id, headers, body);
END|

CREATE PROCEDURE test$index$about (IN request_id INT UNSIGNED)
BEGIN
    DECLARE headers TEXT;
    DECLARE body TEXT;
    DECLARE view_id INT UNSIGNED;
    
    CALL view$create ('test$index$about', view_id);
    CALL view$render (view_id, body);
    CALL view$clean (view_id);
    
    CALL test$layout$build (request_id, body);
    
    CALL application$respond (request_id, headers, body);
END|
