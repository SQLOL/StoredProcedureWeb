source src/StoredProcedureWeb.sql
source vendor/SQLUnit/Module.sql

source application/config.sql
source application/modules.sql
source tests/sqlunit.sql
CALL module$load_modules;
