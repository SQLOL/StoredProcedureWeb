CREATE TABLE Response (
    id INT UNSIGNED NOT NULL,
    headers TEXT,
    body TEXT,
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
