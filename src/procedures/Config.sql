CREATE PROCEDURE config$set (IN config_name VARCHAR(255), IN config_value VARCHAR(255))
BEGIN
    REPLACE INTO `Config` (name, value)
    VALUES (config_name, config_value)
    ;
END|

CREATE PROCEDURE config$get (IN config_name VARCHAR(255), OUT config_value VARCHAR(255))
BEGIN
    SELECT
        `Config`.`value`
    INTO
        config_value
    FROM `Config`
    WHERE
        `Config`.`name` = config_name
    ;
END|
