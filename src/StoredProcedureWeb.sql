delimiter ;
source src/schema/Request.sql
source src/schema/Application.sql
source src/schema/Module.sql

delimiter |
source src/procedures/Stdlib.sql
source src/procedures/Request.sql
source src/procedures/Response.sql
source src/procedures/Application.sql
source src/procedures/Module.sql
delimiter ;

CALL module_load_modules ();
