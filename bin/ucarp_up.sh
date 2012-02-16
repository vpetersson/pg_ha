#!/bin/sh
 
# Load variables from rc.conf
. /etc/rc.subr
load_rc_config ucarp
 
/usr/local/bin/pg_ha.sh master
/sbin/ifconfig $ucarp_if alias $ucarp_addr/32
sleep 1
/usr/local/etc/rc.d/pgpool start
