#!/bin/bash
check_account() {
    nordvpn account 2>&1 | grep -q "Account created:"
}

if ! check_account; then
    python3 /dock_hop/camoufox_browser.py
    check_account || exit 1
fi
[ -f ok ] && rm ok
while true; do
    timeout 400 python3 /dock_hop/cum.py
done
