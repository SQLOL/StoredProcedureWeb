CREATE TABLE Request (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    request_method ENUM('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'OPTIONS', 'CONNECT', 'PATCH') NOT NULL DEFAULT 'GET',
    request_uri TEXT NOT NULL,
    INDEX request_method (request_method),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
