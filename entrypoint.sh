#!/bin/bash
set -e

# Start virtual display
Xvfb :1 -screen 0 1280x800x24 &
sleep 1

# Start window manager
openbox &

# Start VNC server
x11vnc -display :1 -nopw -forever -quiet &

# Start noVNC
websockify --web /usr/share/novnc 6080 localhost:5900 &

echo "noVNC running at http://localhost:6080/vnc.html"

# Start NordVPN
nordvpnd &
sleep 5

if [ -n "$NORDVPN_TOKEN" ]; then
    nordvpn login --token "$NORDVPN_TOKEN"
else
    echo "Error: NORDVPN_TOKEN not set"
    exit 1
fi

nordvpn set technology nordlynx
nordvpn set killswitch enabled

nordvpn connect

echo "Current IP:"
curl -s https://ipinfo.io/ip

tail -f /dev/null
