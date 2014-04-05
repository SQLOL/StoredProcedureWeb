CREATE PROCEDURE call_dynamic (IN call_sql TEXT)
BEGIN
    SET @call_sql_tmp := call_sql;
    PREPARE call_statement FROM @call_sql_tmp;
    EXECUTE call_statement;
    DEALLOCATE PREPARE call_statement;
END|

CREATE PROCEDURE procedure_exists (IN procedure_name TEXT, OUT result TINYINT(1))
BEGIN
    SELECT count(0) INTO result
    FROM information_schema.ROUTINES AS routines
    WHERE
        routines.ROUTINE_SCHEMA = DATABASE()
        AND routines.ROUTINE_TYPE = 'PROCEDURE'
        AND routines.ROUTINE_NAME COLLATE utf8_unicode_ci = procedure_name
    ;
END|

CREATE PROCEDURE columns_in_table (IN table_name TEXT, OUT count SMALLINT UNSIGNED)
BEGIN
    SELECT COUNT(0) INTO count
    FROM information_schema.COLUMNS columns
    WHERE
        columns.TABLE_SCHEMA = DATABASE()
        AND columns.TABLE_NAME COLLATE utf8_unicode_ci = table_name
    ;
END|

CREATE PROCEDURE occurrences_of_string(IN data TEXT, IN search VARCHAR(255), OUT occurrences INT UNSIGNED)
BEGIN
    SET occurrences = LENGTH(data) - LENGTH(REPLACE(data, search, ''));
END|

CREATE PROCEDURE get_line (IN data TEXT, IN line SMALLINT SIGNED, OUT line_data TEXT)
BEGIN
    DECLARE delimiter VARCHAR(1) DEFAULT '\n';
    DECLARE number_of_lines INT UNSIGNED DEFAULT 0;
    IF line = NULL THEN
        SET line = 0;
    END IF;
    
    CALL occurrences_of_string(data, delimiter, number_of_lines);
    SET number_of_lines = number_of_lines + 1;
    
    IF line <= number_of_lines THEN
        SET line_data = SUBSTRING_INDEX(
            SUBSTRING_INDEX(data, delimiter, line),
            delimiter,
            -1
        );
    ELSE
        SET line_data = NULL;
    END IF;
END|

CREATE PROCEDURE parse_annotations (IN comment TEXT)
BEGIN
    DECLARE current_line SMALLINT UNSIGNED DEFAULT 1;
    DECLARE line_data TEXT;
    
    DROP TEMPORARY TABLE IF EXISTS `parsed_annotations`;
    CREATE TEMPORARY TABLE parsed_annotations (
        type TEXT NOT NULL,
        parameters TEXT NULL,
        line SMALLINT UNSIGNED NOT NULL
    ) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
    
    CALL get_line (comment, current_line, line_data);
    
    LINE_PARSE_LOOP: WHILE line_data IS NOT NULL DO
        SET line_data = LTRIM(line_data);
        
        IF SUBSTRING(line_data, 1, 1) != '@' OR LENGTH(line_data) <= 1 THEN
            SET current_line = current_line + 1;
            CALL get_line (comment, current_line, line_data);
            ITERATE LINE_PARSE_LOOP;
        END IF;
        
        INSERT INTO `parsed_annotations` (`type`, `parameters`, `line`)
        SELECT
            SUBSTRING(SUBSTRING_INDEX(line_data, ' ', 1), 2),
            SUBSTRING(line_data, LENGTH(SUBSTRING_INDEX(line_data, ' ', 1)) + 2),
            current_line
        ;
        
        SET current_line = current_line + 1;
        CALL get_line (comment, current_line, line_data);
    END WHILE LINE_PARSE_LOOP;
END|

CREATE PROCEDURE procedure_annotations (IN procedure_name TEXT)
BEGIN
    DECLARE routine_comment TEXT DEFAULT '';

    SELECT routines.`ROUTINE_COMMENT` INTO routine_comment
    FROM information_schema.ROUTINES AS routines
    WHERE
        routines.ROUTINE_SCHEMA = DATABASE()
        AND routines.ROUTINE_TYPE = 'PROCEDURE'
        AND routines.ROUTINE_NAME COLLATE utf8_unicode_ci = procedure_name
    ;
    
    CALL parse_annotations (routine_comment);
END|
