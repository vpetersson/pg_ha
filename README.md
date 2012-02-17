# Scripts for setting up PostgreSQL in High Availability for FreeBSD #

This is a compilation of scripts that I've worked on for some time. This is a relatively complex setup, and you'll find the documentation for the setup in [this](http://viktorpetersson.com/2012/02/17/high-availability-with-postgresql-pgpool-ii-and-freebsd/) blog-post. Don't try to use the scripts without first reading the blog-post, as you'll most likely just get confused.

Just as a quick reference, the setup uses the following:

 * PostgreSQL with Streaming Replication
 * PGPool-II
 * UCARP