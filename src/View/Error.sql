CREATE PROCEDURE test$view$error$not_found (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    
    CALL asset$get ('module/Test/view/Test_Error/not-found.html', view_script);

    CALL view$render_create_result (view_id, view_script);
END|
