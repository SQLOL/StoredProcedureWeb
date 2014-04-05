CREATE PROCEDURE application$debug$index (IN request_id INT UNSIGNED)
BEGIN
    DECLARE headers TEXT;
    DECLARE body TEXT;
    DECLARE view_id INT UNSIGNED;
    
    CALL view$create ('application$debug$index', view_id);
    CALL view$render (view_id, body);
    CALL view$clean (view_id);
    
    CALL application$respond (request_id, headers, body);
END|
