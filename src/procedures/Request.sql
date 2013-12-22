CREATE PROCEDURE request (
    IN request_method ENUM('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'OPTIONS', 'CONNECT', 'PATCH'),
    IN request_uri TEXT,
    IN finish TINYINT(1)
)
BEGIN
    CALL request$init;
    INSERT INTO `Request` (
        request_method,
        request_uri
    ) VALUES (
        request_method,
        request_uri
    );
    
    CALL application(LAST_INSERT_ID(), finish);
END|

CREATE PROCEDURE request$init ()
BEGIN
    SET @@max_sp_recursion_depth := 255;

    CREATE TEMPORARY TABLE IF NOT EXISTS Request$Header (
        name VARCHAR(255) NOT NULL,
        value TEXT NOT NULL,
        PRIMARY KEY (name)
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS Request$Param (
        name VARCHAR(255) NOT NULL,
        value TEXT NOT NULL,
        PRIMARY KEY (name)
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
END|

CREATE PROCEDURE request$set_header (IN header_name VARCHAR(255), IN header_value VARCHAR(255))
BEGIN
    REPLACE INTO Request$Header (name, value)
    VALUES (header_name, header_value)
    ;
END|

CREATE PROCEDURE request$get_header (IN header_name VARCHAR(255), OUT header_value VARCHAR(255))
BEGIN
    SELECT
        header.`value`
    INTO
        header_value
    FROM Request$Header header
    WHERE
        header.`name` = header_name
    ;
END|

CREATE PROCEDURE request$set_param (IN param_name VARCHAR(255), IN param_value VARCHAR(255))
BEGIN
    REPLACE INTO Request$Param (name, value)
    VALUES (param_name, param_value)
    ;
END|

CREATE PROCEDURE request$get_param (IN param_name VARCHAR(255), OUT param_value VARCHAR(255))
BEGIN
    SELECT
        param.`value`
    INTO
        param_value
    FROM Request$Param param
    WHERE
        param.`name` = param_name
    ;
END|
