CREATE PROCEDURE test$view$layout$header (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    DECLARE site_name VARCHAR(255);
    
    CALL config$get ('test$site_name', site_name);
        
    CALL asset$get ('module/Test/view/Layout/header.html', view_script);
    
    CALL view$replace_placeholder (view_script, 'site_name', site_name);

    CALL view$render_create_result (view_id, view_script);
END|

CREATE PROCEDURE test$view$layout$footer (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    DECLARE site_name VARCHAR(255);
    
    CALL config$get ('test$site_name', site_name);
        
    CALL asset$get ('module/Test/view/Layout/footer.html', view_script);
    
    CALL view$replace_placeholder (view_script, 'site_name', site_name);

    CALL view$render_create_result (view_id, view_script);
END|

CREATE PROCEDURE test$view$layout$nav (IN view_id INT UNSIGNED)
BEGIN
    DECLARE view_script MEDIUMBLOB;
    DECLARE navitems TEXT DEFAULT '';
    DECLARE done TINYINT(1) DEFAULT FALSE;
    DECLARE navitem_active TINYINT(1) DEFAULT 0;
    DECLARE navitem_path TEXT;
    DECLARE navitem_label TEXT;
    DECLARE navitem CURSOR FOR
        SELECT
            navitems.`active`,
            navitems.`path`,
            navitems.`label`
        FROM `test$view$layout$nav` navitems
        WHERE
            navitems.`view_id` = view_id
        ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    CALL asset$get ('module/Test/view/Layout/nav.html', view_script);
    
    OPEN navitem;
    
    navitem_loop: LOOP
        FETCH navitem INTO navitem_active, navitem_path, navitem_label;
        IF done THEN
            LEAVE navitem_loop;
        END IF;
        
        SET navitems := CONCAT(navitems, '<li ', IF(navitem_active, 'class="active"', ''), '><a href="', navitem_path, '">', navitem_label, '</a>');
    END LOOP;
    
    CALL view$replace_placeholder (view_script, 'navitems', navitems);
            
    CALL view$render_create_result (view_id, view_script);
END|

CREATE PROCEDURE test$view$layout$nav$clean (IN view_id INT UNSIGNED)
BEGIN
    DELETE FROM test$view$layout$nav
    WHERE
        test$view$layout$nav.`view_id` = view_id
    ;
END|

CREATE TABLE test$view$layout$nav (
    view_id INT UNSIGNED NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 0,
    path TEXT,
    label TEXT,
    INDEX (view_id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
