#!/bin/sh

export LC_ALL=C
ctl="$HOME/.local/bin/omniwmctl"
[ -x "$ctl" ] || ctl=/opt/homebrew/bin/omniwmctl
[ -x "$ctl" ] || exit 0

usage=$(/usr/sbin/sysctl -n vm.swapusage 2>/dev/null) || usage=
used_bytes=$(printf '%s\n' "$usage" | /usr/bin/awk '
    {
        for (i = 1; i <= NF - 2; i++) {
            if ($i != "used" || $(i + 1) != "=") continue
            amount = $(i + 2)
            if (amount !~ /^[0-9]+([.][0-9]+)?[BKMGT]$/) exit
            unit = substr(amount, length(amount))
            printf "%.0f", (amount + 0) * 1024 ^ (index("BKMGT", unit) - 1)
            exit
        }
    }
')

if [ -n "$used_bytes" ]; then
    "$ctl" shell set nordSwapUsedBytes "$used_bytes" >/dev/null 2>&1
else
    "$ctl" shell unset nordSwapUsedBytes >/dev/null 2>&1
fi
