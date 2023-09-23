#!/bin/sh

CVD_FILE="/var/lib/clamav/main.cvd"

# Check For Existing ClamAV Database
if [ ! -f ${CVD_FILE} ]; then
	echo "[ClamAV/Freshclam] Download ClamAV Database"
	/usr/bin/freshclam
fi

# Update ClamAV Database
echo "[ClamAV/Freshclam] Update ClamAV Database"
/usr/bin/freshclam -d -c 12

################
# Classic Mode #
################

# Run ClamAV Daemon
if [ -z "${CI}" ]; then
	echo "[ClamAV/Freshclam] Run ClamAV Daemon"
	exec /usr/sbin/clamd
fi

###############
# Gitlab Mode #
###############

# Standalone Mode
if [ "${1}" = "sh" ]; then
	# Start CLAMAV (Background)
	/usr/sbin/clamd &
	# Wait For Working CLAMAV
	while [ ! "$(echo PING | nc localhost 3310)" = "PONG" ]; do # DevSkim: ignore DS162092
		sleep 0.5
	done
	# Launch Shell
	/bin/sh
elif [ "${1}" = "service" ]; then
	# Start CLAMAV (Foreground)
	/usr/sbin/clamd
else
	echo "Invalid ${1} Argument !"
	exit 1
fi
