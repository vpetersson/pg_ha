#!/bin/sh
 
# Load variables from rc.conf
. /etc/rc.subr
load_rc_config ucarp
 
UCARPIF=$(ifconfig | grep '$ucarp_addr ')
 
if [ "$UCARPIF" != "" ];
then 
	echo "I'm the master"
else
	echo "I'm the slave"
fi