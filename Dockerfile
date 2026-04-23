FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV NOVNC_PORT=6080

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    iproute2 \
    iptables \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    openbox \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSf https://repo.nordvpn.com/gpg/nordvpn_public.asc | gpg --dearmor -o /usr/share/keyrings/nordvpn.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nordvpn.gpg] https://repo.nordvpn.com/deb/nordvpn/debian stable main" \
    > /etc/apt/sources.list.d/nordvpn.list

RUN apt-get update && apt-get install -y nordvpn && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 6080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
