CREATE TABLE Request (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    query_string TEXT NOT NULL,
    request_method ENUM('GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'OPTIONS', 'CONNECT', 'PATCH') NOT NULL DEFAULT 'GET',
    content_type TEXT NOT NULL,
    content_length INT UNSIGNED NOT NULL DEFAULT 0,
    request_uri TEXT NOT NULL,
    document_uri TEXT NOT NULL,
    server_protocol TEXT NOT NULL,
    remote_addr TEXT NOT NULL,
    remote_port SMALLINT UNSIGNED NULL,
    server_addr TEXT NOT NULL,
    server_port SMALLINT UNSIGNED NULL,
    server_name TEXT NOT NULL,
    INDEX request_method (request_method),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;

CREATE TRIGGER incoming_request
    AFTER INSERT
    ON `Request` FOR EACH ROW
    CALL application (`Request`.`id`)
;
