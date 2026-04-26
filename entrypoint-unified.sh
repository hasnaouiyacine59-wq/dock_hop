#!/bin/bash
set -e
#e
# Set timezone based on IP geolocation
echo "Detecting timezone from IP..."
TIMEZONE=$(curl -s http://ip-api.com/json | jq -r '.timezone' || echo "UTC")
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo $TIMEZONE > /etc/timezone
echo "Timezone set to: $TIMEZONE"

##apt update && apt install git -y
#docker login -u='mylastres0rt05_redhat' -p='4ukFQ9E2c1NOTM1FJ/edkLCc1uLlLWYary3DI5mgSAtB3y/RbFdHqOEjqDmzPfJm' quay.io
if [ -d "dock_hop/.git" ]; then
    (cd dock_hop && git pull)
else
    rm -rf dock_hop
    git clone https://github.com/hasnaouiyacine59-wq/dock_hop.git
fi 
Xvfb :1 -screen 0 1920x1080x24 &
sleep 2

fluxbox &

x11vnc -display :1 -nopw -forever -quiet -rfbport 5900 &
sleep 1

websockify --web /usr/share/novnc 6080 localhost:5900 &

# Start D-Bus (required by nordvpnd)
mkdir -p /var/run/dbus /run/nordvpn
dbus-daemon --system --fork || true

# Clean up stale nordvpnd socket/pid if present
rm -f /run/nordvpn/nordvpnd.sock /run/nordvpnd.pid

/etc/init.d/nordvpn start
sleep 3

# Configure NordVPN to allow local network access
nordvpn set killswitch off
nordvpn whitelist add subnet 172.0.0.0/8

echo "noVNC running at http://localhost:6080/vnc.html"
echo "NordVPN daemon started. Use 'docker exec -it <container> nordvpn login --token \$TOKEN' to connect."

tail -f /dev/null
