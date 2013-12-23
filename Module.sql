delimiter |

source module/Test/src/Controller/Layout.sql
source module/Test/src/Controller/Error.sql
source module/Test/src/Controller/Index.sql

source module/Test/src/View/Index.sql
source module/Test/src/View/Error.sql
source module/Test/src/View/Layout.sql

source module/Test/src/Model/Nav.sql

source module/Test/config.sql

CREATE PROCEDURE test$register_routes ()
BEGIN
    CALL test$error$register_routes;
    CALL test$index$register_routes;
    
    CALL test$model$nav$add ('https://github.com/TheFrozenFire/StoredProcedureWeb', 'Download');
END|

CREATE PROCEDURE test$register_views ()
BEGIN
    CALL view$register_template ('test$layout$header', 'test$view$layout$header');
    CALL view$register_template ('test$layout$footer', 'test$view$layout$footer');
    CALL view$register_template ('test$layout$nav', 'test$view$layout$nav');

    CALL view$register_template ('test$error$not_found', 'test$view$error$not_found');
    CALL view$register_template ('test$error$internal_server_error', 'test$view$error$internal_server_error');
    CALL view$register_template ('test$index$index', 'test$view$index$index');
    CALL view$register_template ('test$index$about', 'test$view$index$about');
END|

CREATE PROCEDURE test$load_assets ()
BEGIN
    CALL asset$create ('module/Test/view/Layout/header.html');
    CALL asset$create ('module/Test/view/Layout/footer.html');
    CALL asset$create ('module/Test/view/Layout/nav.html');

    CALL asset$create ('module/Test/view/Test_Error/not-found.html');
    CALL asset$create ('module/Test/view/Test_Error/internal-server-error.html');
    CALL asset$create ('module/Test/view/Test_Index/index.html');
    CALL asset$create ('module/Test/view/Test_Index/about.html');
END|

delimiter ;
