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
