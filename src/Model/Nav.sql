CREATE PROCEDURE test$model$nav$populate (IN nav_view_id INT UNSIGNED)
BEGIN
    INSERT INTO test$view$layout$nav (view_id, active, path, label)
    SELECT
        nav_view_id,
        false,
        nav.`path`,
        nav.`title`
    FROM test$model$nav nav
    ORDER BY nav.`sort`
    ;
END|

CREATE PROCEDURE test$model$nav$add (IN item_path TEXT, IN item_title TEXT)
BEGIN
    INSERT INTO test$model$nav (path, title)
    VALUES (item_path, item_title)
    ;
END|

CREATE TABLE test$model$nav (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    sort SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    path TEXT,
    title TEXT,
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
