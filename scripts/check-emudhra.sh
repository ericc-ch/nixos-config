#!/bin/sh
# check-emudhra: verify this machine no longer trusts the compromised eMudhra
# intermediate CAs (Oct 2026). https://emudhra.we-have-a-problem.com/
#
# Each check fetches a host that serves a certificate from one of the leaked
# intermediates. A certificate error means the chain is rejected, which is what
# we want. A successful fetch means that tool still trusts it.
#
# Run it in a fresh shell after `nixos-rebuild switch`, since the fixes live in
# environment variables loaded at login.
set -u

# One host per compromised intermediate family and per root it chains to.
HOSTS="dv-g3b ev-g3b ov-g3c dv-g3b-aaa"

total=0
bad=0

report() { # report <tool> <host> <command...>
    tool=$1
    host=$2
    shift 2
    total=$((total + 1))
    if "$@" >/dev/null 2>&1; then
        echo "FAIL  $tool trusts $host"
        bad=$((bad + 1))
    else
        echo "ok    $tool rejects $host"
    fi
}

have() {
    command -v "$1" >/dev/null 2>&1
}

for host in $HOSTS; do
    url="https://$host-emudhra.we-have-a-problem.com/"

    report curl "$host" curl -s -o /dev/null --max-time 10 "$url"

    if have node; then
        report node "$host" node -e "fetch('$url').then(() => process.exit(0), () => process.exit(1))"
    fi

    if have deno; then
        report deno "$host" deno eval --no-check "try { await fetch('$url'); } catch { Deno.exit(1); }"
    fi

    if have bun; then
        report bun "$host" bun -e "try { await fetch('$url'); } catch { process.exit(1); }"
    fi
done

echo
if [ "$bad" -eq 0 ]; then
    echo "All $total checks reject the compromised chain."
else
    echo "$bad of $total checks still trust the compromised chain."
fi

echo
echo "For browsers, open https://emudhra.we-have-a-problem.com/ and read the"
echo "table it fills in: every row should say 'Did not connect'."
