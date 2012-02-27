# 'pg_ha' - PostgreSQL in High Availability #

'pg_ha' is a collection of scripts for setting up and running PostgreSQL in High Availability on FreeBSD. I've worked on for some time, and it is a relatively complex setup. You'll find the documentation [here](https://github.com/vpetersson/pg_ha/wiki/Setup-On-FreeBSD). 

The setup uses the following tools:

 * [FreeBSD](http://www.freebsd.org) (but any UNIX/Linux distribution should work with some modifications)
 * [PostgreSQL](http://www.postgresql.org/) with [Streaming Replication](http://wiki.postgresql.org/wiki/Streaming_Replication)
 * [PGPool-II](http://pgpool.net/mediawiki/index.php/Main_Page)
 * [UCARP](http://www.ucarp.org/project/ucarp)