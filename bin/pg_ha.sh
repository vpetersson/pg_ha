#!/bin/sh

#
# This script is intended to be triggerd by UCARP or CARP via dev.d
# Parse the variable master or slave for the right action
#

# Define the remote node
REMOTE=box1

# Postgres user
PGUSER=pgsql

# Date
TIME=$(date +%Y-%m-%d_%H:%M)

# Since this script may launches at boot, we need to set the proper path.
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin

case "$1" in

	master)
		sudo -u $PGUSER rm -f /usr/local/pgsql/data/recovery.conf
		sudo -u $PGUSER touch /tmp/pgsql.trigger
	;;
	
	slave)
		sudo -u $PGUSER rm -f /tmp/pgsql.trigger
		echo "Restarting PGSQL in stand-alone mode."
		sudo -u $PGUSER pg_ctl stop -D /usr/local/pgsql/data/ -m fast
		sudo -u $PGUSER rm -f /usr/local/pgsql/data/recovery.conf
		sudo -u $PGUSER pg_ctl start -D /usr/local/pgsql/data/
		echo "Dumping database from $REMOTE ..."
		sudo -u $PGUSER pg_dumpall -h$REMOTE -f /usr/local/pgsql/db.dump-$TIME;
		if [ $? = 0 ]
			then
				echo "Restoring database..."
				sudo -u $PGUSER psql -U$PGUSER postgres -l -f /usr/local/pgsql/db.dump-$TIME
				sudo -u $PGUSER cp -f /usr/local/pgsql/data/recovery.bak  /usr/local/pgsql/data/recovery.conf
				echo "Restarting PGSQL in slave-mode..."
				sudo -u $PGUSER pg_ctl stop -D /usr/local/pgsql/data/
				sudo -u $PGUSER pg_ctl start -D /usr/local/pgsql/data/ 
				echo "Compressing database-dump.."
				sudo -u $PGUSER gzip /usr/local/pgsql/db.dump-$TIME
			else
				echo "Aborting. Recovery from master failed."
			fi
	;;

	slave-init)
		sudo -u $PGUSER rm -f /tmp/pgsql.trigger
		echo "Stopping PGSQL.."
		sudo -u $PGUSER pg_ctl stop -D /usr/local/pgsql/data/ -m fast
		echo "Syncing files from master to slave...(initial)"
		sudo -u $PGUSER rsync -a $PGUSER@$REMOTE:/usr/local/pgsql/data/ /usr/local/pgsql/data --checksum --delete --exclude 'postmaster.pid' --exclude '*~' --exclude '*.conf' --exclude 'recovery.*'
		echo "Putting remote master-node in backup-mode..."
		sudo -u $PGUSER psql -h$REMOTE postgres -c "SELECT pg_start_backup('restore-slave', true)" $PGUSER
		echo "Syncing files from master to slave...(final)"
		sudo -u $PGUSER rsync -a $PGUSER@$REMOTE:/usr/local/pgsql/data/ /usr/local/pgsql/data --checksum --exclude 'postmaster.pid' --exclude '*~' --exclude '*.conf' --exclude 'recovery.*'
		echo "Restoring master to regular state..."
		sudo -u $PGUSER psql -h$REMOTE postgres -c "SELECT pg_stop_backup()" $PGUSER
		sudo -u $PGUSER rm -f /usr/local/pgsql/data/recovery.done 
		sudo -u $PGUSER cp -f /usr/local/pgsql/data/recovery.bak /usr/local/pgsql/data/recovery.conf
		echo "Starting PGSQL locally..."
		sudo -u $PGUSER pg_ctl start -D /usr/local/pgsql/data/
	;;
esac