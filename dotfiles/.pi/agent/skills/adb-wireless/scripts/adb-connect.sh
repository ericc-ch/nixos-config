#!/data/data/com.termux/files/usr/bin/sh
# adb-connect.sh - connect adb to this phone over wireless debugging.
# Prints the serial (localhost:PORT) and exits 0 once this phone is the one
# live transport, with no leftovers from an earlier session.
set -eu
here=$(dirname -- "$(readlink -f -- "$0")")

# mDNS can lag right after the adb server starts, so ask twice.
ports=$(python3 "$here/adb-port.py") || { sleep 1; ports=$(python3 "$here/adb-port.py"); } || {
    echo "adb-connect: no _adb-tls-connect advertisement." >&2
    echo "  Wireless debugging is off or still starting up: tap its Quick Settings tile, then retry." >&2
    exit 1
}

# Print our serial if a port from this run is connected and no other
# localhost: transport is around. A leftover one would make later unqualified
# adb commands ambiguous, so it counts as not connected yet.
connected_serial() {
    connected=$(adb devices | awk 'NR > 1 && $2 == "device" {print $1}')
    [ "$(printf '%s\n' "$connected" | grep -c '^localhost:')" -eq 1 ] || return 1
    for port in $ports; do
        if printf '%s\n' "$connected" | grep -qx "localhost:$port"; then
            printf 'localhost:%s\n' "$port"
            return 0
        fi
    done
    return 1
}

if connected_serial; then
    exit 0
fi

# adb with no argument drops every tcp transport, stale localhost ports included.
adb disconnect >/dev/null 2>&1 || true
for port in $ports; do
    adb connect "localhost:$port" >/dev/null 2>&1 || true
done

tries=0
while [ "$tries" -lt 3 ]; do
    if connected_serial; then
        exit 0
    fi
    tries=$((tries + 1))
    sleep 0.4
done

{
    echo "adb-connect: could not connect to:"
    for port in $ports; do
        printf '  localhost:%s\n' "$port"
    done
} >&2
exit 1
