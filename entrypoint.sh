#!/bin/bash
set -eu

CVD_FILE="/var/lib/clamav/main.cvd"

# Check For Existing ClamAV Database
if [ ! -f ${CVD_FILE} ]; then
    echo "[Entrypoint] Download ClamAV Database"
    /usr/bin/freshclam
fi

# Update ClamAV Database
echo "[Entrypoint] Update ClamAV Database"
/usr/bin/freshclam -d -c 12

# Run ClamAV Daemon
echo "[Entrypoint] Run ClamAV Daemon"
exec /usr/sbin/clamd
