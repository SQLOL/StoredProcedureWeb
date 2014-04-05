source vendor/AssetManager/Module.sql
source vendor/Config/Module.sql
source vendor/HTTP/Module.sql
source vendor/SQLUnit/Module.sql
source vendor/StdLib/Module.sql
source vendor/View/Module.sql
source src/StoredProcedureWeb.sql

source application/config.sql
source application/modules.sql
source tests/sqlunit.sql
CALL module$load_modules;
