CALL config$set ('base_path', '/var/www');
CALL config$set ('path_delimiter', '/');
CALL config$set ('application$route$not-found', 'error/not-found');
CALL config$set ('application$route$internal-server-error', 'error/internal-server-error');
