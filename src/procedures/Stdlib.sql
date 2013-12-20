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
        AND routines.ROUTINE_NAME = procedure_name
    ;
END|
