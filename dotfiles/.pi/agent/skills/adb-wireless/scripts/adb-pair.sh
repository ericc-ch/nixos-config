#!/data/data/com.termux/files/usr/bin/sh
# adb-pair.sh - pair with this phone. Run it while the "Pair device with
# pairing code" dialog is open:  adb-pair.sh 123456
set -eu
here=$(dirname -- "$(readlink -f -- "$0")")

if [ $# -ne 1 ]; then
    echo "usage: adb-pair.sh <code from the pairing dialog>" >&2
    exit 64
fi

port=$(python3 "$here/adb-port.py" --pair) || {
    echo "adb-pair: the pairing service is not advertised." >&2
    echo "  Open Developer options > Wireless debugging > Pair device with pairing code," >&2
    echo "  leave the dialog open, and run this again." >&2
    exit 1
}

echo "pairing on localhost:$port" >&2
exec adb pair "localhost:$port" "$1"
