CREATE TABLE Application_Route (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    controller VARCHAR(255) NOT NULL,
    action VARCHAR(255) NOT NULL,
    type ENUM('plain', 'regex') NOT NULL,
    pattern TEXT NOT NULL,
    INDEX controller (controller),
    INDEX controller_action (controller, action),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
