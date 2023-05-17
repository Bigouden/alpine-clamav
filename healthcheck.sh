#!/bin/sh

if [ "$(echo PING | nc localhost 3310)" = "PONG" ]; then
	echo "ClamAV Daemon OK"
else
	echo "ClamAV Daemon KO"
	exit 1
fi
