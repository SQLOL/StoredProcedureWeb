CREATE PROCEDURE call_dynamic (IN call_sql TEXT)
BEGIN
    SET @call_sql_tmp := call_sql;
    PREPARE call_statement FROM @call_sql_tmp;
    EXECUTE call_statement;
    DEALLOCATE PREPARE call_statement;
END|
