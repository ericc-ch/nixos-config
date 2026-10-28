#!/data/data/com.termux/files/usr/bin/sh
# adb-connect.sh - connect adb to this phone over wireless debugging.
# Prints the serial (localhost:PORT) and exits 0 once a device is connected.
set -eu
here=$(dirname -- "$(readlink -f -- "$0")")

# mDNS can lag right after the adb server starts, so ask twice.
port=$(python3 "$here/adb-port.py") || { sleep 1; port=$(python3 "$here/adb-port.py"); } || {
    echo "adb-connect: no _adb-tls-connect advertisement." >&2
    echo "  Wireless debugging is off or still starting up: tap its Quick Settings tile, then retry." >&2
    exit 1
}
serial="localhost:$port"

if adb devices | grep -q "^${serial}[[:space:]]*device$"; then
    echo "$serial"
    exit 0
fi

# Without an argument adb drops every tcp device, stale localhost ports included.
adb disconnect >/dev/null 2>&1 || true

tries=0
while [ "$tries" -lt 3 ]; do
    adb connect "$serial" >/dev/null 2>&1 || true
    if adb devices | grep -q "^${serial}[[:space:]]*device$"; then
        echo "$serial"
        exit 0
    fi
    tries=$((tries + 1))
    sleep 0.5
done

echo "adb-connect: could not connect to $serial" >&2
exit 1
