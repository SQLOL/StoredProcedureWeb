# Stored Procedure Web

[![Build Status](https://travis-ci.org/TheFrozenFire/StoredProcedureWeb.png)](https://travis-ci.org/TheFrozenFire/StoredProcedureWeb)

Stored Procedure Web (SPW) is a Web Scale opinionated MVC framework built in
pure SQL. Most web developers today make use of a middleman language such as
PHP, Ruby, or Python, where the main bottleneck for performance tends to be
database access round-trips. With SPW, we cut out the middleman and serve
requests directly from the database.

SPW is a compile-once static application framework with a modular design, and
a focus on cross-cutting concerns. When you bootstrap your application, it is
loaded as a schema in your database, composed of stored procedures and a bit
of configuration. With this in mind, you can replicate your application to as
many database masters as needed, to achieve true Web Scale.

## Installation

1) Clone this repository
2) Create a new database
3) Copy the `application/config.sql.dist` and `application/modules.sql.dist`
with the .dist suffix removed, and populate any modules and configuration
as needed.
4) Execute the `install.sql` script on that database. This will "compile" your
application into the schema, set the configuration and routes up, and load your
assets into the `Assets` table.
5) Configure your SAPI. Included in the public directory is a simple PHP-based
SAPI which is helpful for developing your application. Pass the database
credentials to this script from your webserver, and the rest is taken care of.

## Building a Distributable

1) With your application installed, run the `build.sh` script with your database
name as the parameter. You can optionally specify any flags that `mysqldump`
accepts, if you need to configure your connection.
2) Copy the resulting `install.tar.gz` to your project directory in production,
and extract it. Execute the extracted install.sql on your production database
to load your application.
