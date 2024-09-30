FROM ubuntu:20.04

# Set the DEBIAN_FRONTEND environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies including ca-certificates
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libx11-xcb-dev \
    libcanberra-gtk3-module \
    libcanberra-gtk-module \
    libasound2 \
    libpulse0 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    xvfb \
    ca-certificates \
    xz-utils \    
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for the Tor Browser download URL
ENV TOR_BROWSER_URL=https://dist.torproject.org/torbrowser/

RUN echo '#!/bin/bash\n' \
    'set -e\n' \
    'echo "Fetching list of available versions..."\n' \
    'curl -s ${TOR_BROWSER_URL} | tee /tmp/tor_versions.html\n' \
    'LATEST_VERSION=$(grep -oP "[0-9]+\.[0-9]+[a-zA-Z]?[0-9]?/" /tmp/tor_versions.html | sort -V | tail -n 1 | tr -d "/")\n' \
    'if [ -z "$LATEST_VERSION" ]; then\n' \
    '  echo "Error: Could not determine the latest version. Check the HTML output:"\n' \
    '  cat /tmp/tor_versions.html\n' \
    '  exit 1\n' \
    'fi\n' \
    'echo "Latest version: $LATEST_VERSION"\n' \
    'DOWNLOAD_URL="${TOR_BROWSER_URL}${LATEST_VERSION}/tor-browser-linux-x86_64-${LATEST_VERSION}.tar.xz"\n' \
    'echo "Attempting to download from $DOWNLOAD_URL"\n' \
    'if ! wget --no-verbose --show-progress "$DOWNLOAD_URL" -O /tmp/tor-browser.tar.xz; then\n' \
    '  echo "Failed to download x86_64 version, attempting i686 version..."\n' \
    '  DOWNLOAD_URL="${TOR_BROWSER_URL}${LATEST_VERSION}/tor-browser-linux-i686-${LATEST_VERSION}.tar.xz"\n' \
    '  echo "Downloading from $DOWNLOAD_URL"\n' \
    '  if ! wget --no-verbose --show-progress "$DOWNLOAD_URL" -O /tmp/tor-browser.tar.xz; then\n' \
    '    echo "Error: Failed to download Tor Browser from $DOWNLOAD_URL"\n' \
    '    exit 1\n' \
    '  fi\n' \
    'fi\n' \
    'echo "Download completed. Extracting..."\n' \
    'tar -xJf /tmp/tor-browser.tar.xz -C /opt\n' \
    'rm /tmp/tor-browser.tar.xz\n' \
    'ln -s /opt/tor-browser* /opt/tor-browser\n' \
    'echo "Tor Browser installed successfully."\n' \
    > /usr/local/bin/install_latest_tor_browser.sh && \
    chmod +x /usr/local/bin/install_latest_tor_browser.sh && \
    /usr/local/bin/install_latest_tor_browser.sh

# Set the PATH for the Tor Browser
ENV PATH="/opt/tor-browser/Browser:${PATH}"

# Expose the Tor Browser port
EXPOSE 8080

# Set the working directory
WORKDIR /opt/tor-browser/Browser

# Set the entrypoint command
CMD ["bash", "-c", "xvfb-run -a --server-args=\"-screen 0 1280x800x24\" ./start-tor-browser --display=:99"]
