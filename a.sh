#!/bin/bash
echo "sleep"
sleep 30
check_account() {
    nordvpn account 2>&1 | grep -q "Account created:"
}

if ! check_account; then
    python3 /dock_hop/camoufox_browser.py
    [ -f ok ] || exit 1
    rm ok
fi
while true; do
    timeout 400 python3 /dock_hop/cum.py
done
