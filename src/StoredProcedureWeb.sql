delimiter ;
source src/schema/Application.sql
source src/schema/Module.sql

delimiter |
source src/procedures/Application.sql
source src/procedures/Module.sql
delimiter ;

source src/config.sql

CALL module$register_module ('application', TRUE);
