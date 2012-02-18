#!/bin/sh
 
# Load variables from rc.conf
. /etc/rc.subr
load_rc_config ucarp
 
/usr/local/etc/rc.d/pgpool stop
/sbin/ifconfig $ucarp_if -alias $ucarp_addr
echo "Refusing to do go back online to avoid a split-brain situation."
echo ""
echo "Manually run 'pg_ha.sh slave' or 'pg_ha.sh init-slave' after ensuring the master got the latest data."
