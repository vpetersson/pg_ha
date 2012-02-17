#!/bin/sh
 
# Load variables from rc.conf
. /etc/rc.subr
load_rc_config ucarp
 
UCARPIF=$(ifconfig | grep '$ucarp_addr ')
WALSEND=$(ps aux | grep "wal sender process")
WALRECV=$(ps aux | grep "wal receiver process")

## UCARP
echo "Checking UCARP Status..."
if [ "$UCARPIF" != "" ];
then 
	echo -e "\tI'm the UCARP master!"
	## WAL Sending process
	echo "Checking for WAL Sender Process..."
	if [ "$WALSEND" != "" ];
	then 
		echo -e "\tWAL Sender Process found!"
	else
		echo -e "\tNo WAL Sender Process found."
	fi
else
	echo -e "\tI'm the UCARP slave!"
	## WAL Receiver process
	echo "Checking for WAL Receiver Process..."
	if [ "$WALRECV" != "" ];
	then 
		echo -e "\tWAL Receiver Process found!"
	else
		echo -e "\tNo WAL Receiver Process found."
	fi
fi

