CREATE PROCEDURE asset_create (IN relative_path TEXT)
BEGIN
    DECLARE base_path VARCHAR(255);
    DECLARE path_delimiter VARCHAR(2);
    DECLARE file_path VARCHAR(255);
    
    CALL config_get('base_path', base_path);
    CALL config_get('path_delimiter', path_delimiter);
    
    SET file_path = CONCAT(base_path, path_delimiter, relative_path);
    
    REPLACE INTO `Asset` (path, data)
    VALUES (relative_path, LOAD_FILE(file_path));
END|

CREATE PROCEDURE asset_get (IN asset_path TEXT, OUT asset_data MEDIUMBLOB)
BEGIN
    SELECT
        `Asset`.`data`
    INTO
        asset_data
    FROM `Asset`
    WHERE
        `Asset`.`path` = asset_path
    ;
END|
