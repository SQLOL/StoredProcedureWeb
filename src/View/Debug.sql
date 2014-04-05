CREATE PROCEDURE application$view$debug$index (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    
    CALL asset$get ('src/view/Debug/index.html', view_script);

    CALL view$render_create_result (view_id, view_script);
END|
