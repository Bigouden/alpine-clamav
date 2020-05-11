#!/bin/bash
set -eu

CVD_FILE="/var/lib/clamav/main.cvd"

# Check For Existing ClamAV Database
if [ ! -f ${CVD_FILE} ]; then
    echo "[ClamAV/Freshclam] Download ClamAV Database"
    /usr/bin/freshclam
fi

# Update ClamAV Database
echo "[ClamAV/Freshclam] Update ClamAV Database"
/usr/bin/freshclam -d -c 12

# Run ClamAV Daemon
echo "[ClamAV/Freshclam] Run ClamAV Daemon"
exec /usr/sbin/clamd
