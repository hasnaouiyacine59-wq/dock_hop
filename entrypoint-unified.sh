#!/bin/bash
set -e
apt update && apt install git -y
git clone https://github.com/hasnaouiyacine59-wq/dock_hop.git 
Xvfb :1 -screen 0 1920x1080x24 &
sleep 1

fluxbox &

x11vnc -display :1 -nopw -forever -quiet &

websockify --web /usr/share/novnc 6080 localhost:5900 &

nordvpnd &
sleep 2

echo "noVNC running at http://localhost:6080/vnc.html"
echo "NordVPN daemon started. Use 'docker exec -it <container> nordvpn login --token \$TOKEN' to connect."

tail -f /dev/null
