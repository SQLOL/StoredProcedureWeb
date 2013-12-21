CREATE TABLE View (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL,
    template VARCHAR(255) NOT NULL,
    INDEX template (template),
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;

CREATE TABLE View_Template (
    name VARCHAR(255) NOT NULL,
    callback VARCHAR(255) NOT NULL,
    PRIMARY KEY (name)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;

CREATE TABLE View_Rendered (
    id INT UNSIGNED NOT NULL,
    result TEXT,
    PRIMARY KEY (id)
) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
