CREATE PROCEDURE test$view$index$index (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    
    CALL asset$get ('module/Test/view/Test_Index/index.html', view_script);

    CALL view$render_create_result (view_id, view_script);
END|

CREATE PROCEDURE test$view$index$about (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    
    CALL asset$get ('module/Test/view/Test_Index/about.html', view_script);
    
    CALL view$render_create_result (view_id, view_script);
END|
