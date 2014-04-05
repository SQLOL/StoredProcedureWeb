delimiter ;
source src/schema/Application.sql

delimiter |
source src/procedures/Application.sql
delimiter ;

source src/config.sql

CALL module$register_module ('application', TRUE);
