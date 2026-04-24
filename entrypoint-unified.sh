#!/bin/bash
set -e

# Set timezone based on IP geolocation
echo "Detecting timezone from IP..."
TIMEZONE=$(curl -s http://ip-api.com/json | jq -r '.timezone' || echo "UTC")
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo $TIMEZONE > /etc/timezone
echo "Timezone set to: $TIMEZONE"

##apt update && apt install git -y
#docker login -u='mylastres0rt05_redhat' -p='4ukFQ9E2c1NOTM1FJ/edkLCc1uLlLWYary3DI5mgSAtB3y/RbFdHqOEjqDmzPfJm' quay.io
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
