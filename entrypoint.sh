#!/bin/bash
set -eu

CVD_FILE="/var/lib/clamav/main.cvd"

if [ ! -f ${CVD_FILE} ]; then
    echo "[Entrypoint] Download ClamAV Database"
    /usr/bin/freshclam
fi

echo "[Entrypoint] Update ClamAV Database"
/usr/bin/freshclam -d -c 12

echo "[Entrypoint] Run ClamAV Daemon"
exec /usr/sbin/clamd
