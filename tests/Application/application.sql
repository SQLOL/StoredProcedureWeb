CREATE PROCEDURE sqlunit_test_application_application_router_plain ()
COMMENT '
@covers application$router
'
BEGIN
    DECLARE test_name VARCHAR(255) DEFAULT 'sqlunit_test_application_application_router_plain';
    DECLARE selected_controller VARCHAR(255);
    DECLARE selected_action VARCHAR(255);
    
    CALL application$register_route ('sqlunit_test_application_application', 'route_match', 'plain', 'abcdefghijklmnopqrstuvwxyz');
    
    CALL application$router ('abcdefghijklmnopqrstuvwxyz', selected_controller, selected_action);
    
    IF
        selected_controller IS NULL
        OR selected_action IS NULL
    THEN
        CALL sqlunit$fail (test_name, 'Router not matching plain strings');
    ELSE
        CALL sqlunit$pass (test_name, 'Success');
    END IF;
END|

CREATE PROCEDURE sqlunit_test_application_application_router_plain_fail ()
COMMENT '
@covers application$router
'
BEGIN
    DECLARE test_name VARCHAR(255) DEFAULT 'sqlunit_test_application_application_router_plain_fail';
    DECLARE selected_controller VARCHAR(255);
    DECLARE selected_action VARCHAR(255);
    
    CALL application$register_route ('sqlunit_test_application_application', 'route_match', 'plain', 'abcdefghijklmnopqrstuvwxy');
    
    CALL application$router ('abcdefghijklmnopqrstuvwxyz', selected_controller, selected_action);
    
    IF
        selected_controller IS NOT NULL
        OR selected_action IS NOT NULL
    THEN
        CALL sqlunit$fail (test_name, 'Router is matching any string');
    ELSE
        CALL sqlunit$pass (test_name, 'Success');
    END IF;
END|
