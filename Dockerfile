# Base image
FROM debian:bookworm-slim

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    LANG=C.UTF-8

# Update system and install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    xvfb \
    x11vnc \
    fluxbox \
    torbrowser-launcher \
    novnc \
    websockify \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install and setup Tor Browser
RUN wget -qO - https://deb.torproject.org/torproject.org-keyring.gpg | gpg --import && \
    torbrowser-launcher --install && \
    rm -rf ~/.cache/torbrowser

# Copy NoVNC files
RUN mkdir -p /opt/novnc && cp -r /usr/share/novnc/* /opt/novnc/

# Expose ports for VNC and web
EXPOSE 5901 8080

# Launch script for the browser
CMD xvfb-run --server-args="-screen 0 1024x768x24" torbrowser-launcher &
    x11vnc -display :1 -forever -nopw -listen 0.0.0.0 &
    websockify --web=/opt/novnc 8080 localhost:5901
