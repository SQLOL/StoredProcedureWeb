delimiter ;
source src/schema/Request.sql
source src/schema/Response.sql
source src/schema/Application.sql
source src/schema/Module.sql
source src/schema/Test.sql

delimiter |
source src/procedures/Stdlib.sql
source src/procedures/Request.sql
source src/procedures/Response.sql
source src/procedures/Application.sql
source src/procedures/Module.sql

source src/sqlunit/SQLUnit.sql
source tests/sqlunit.sql
delimiter ;

CALL module_register_module ('application', TRUE);

source application/modules.sql

CALL module_load_modules;
