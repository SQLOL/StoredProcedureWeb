CREATE PROCEDURE test$error$register_routes ()
BEGIN
    CALL application$register_route ('test$error', 'not_found', 'plain', 'error/not-found');
    CALL application$register_route ('test$error', 'internal_server_error', 'plain', 'error/internal-server-error');
END|

CREATE PROCEDURE test$error$not_found (IN request_id INT UNSIGNED)
BEGIN
    DECLARE headers TEXT;
    DECLARE body TEXT;
    DECLARE view_id INT UNSIGNED;
    
    CALL view$create ('test$error$not_found', view_id);
    CALL view$render (view_id, body);
    CALL view$clean (view_id);
    
    CALL test$layout$build (request_id, body);
    
    CALL application$respond (request_id, headers, body);
END|

CREATE PROCEDURE test$error$internal_server_error (IN request_id INT UNSIGNED)
BEGIN
    DECLARE headers TEXT;
    DECLARE body TEXT;
    DECLARE view_id INT UNSIGNED;
    
    CALL view$create ('test$error$internal_server_error', view_id);
    CALL view$render (view_id, body);
    CALL view$clean (view_id);
    
    CALL test$layout$build (request_id, body);
    
    CALL application$respond (request_id, headers, body);
END|
