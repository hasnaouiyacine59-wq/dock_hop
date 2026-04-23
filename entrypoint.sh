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

# Start NordVPN daemon only
nordvpnd &
sleep 2

# Start tinyproxy
tinyproxy -c /etc/tinyproxy/tinyproxy.conf

echo "NordVPN daemon started. Use 'docker exec -it nordvpn nordvpn login --token \$NORDVPN_TOKEN' to connect."
echo "HTTP proxy available on port 8888"

tail -f /dev/null
