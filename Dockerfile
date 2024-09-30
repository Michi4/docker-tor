FROM ubuntu:20.04

# Set the DEBIAN_FRONTEND environment variable
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libx11-xcb-dev \
    libcanberra-gtk3-module \
    libcanberra-gtk-module \
    libcanberra-gtk3-0 \
    libcanberra-gtk0 \
    libasound2 \
    libpulse0 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    xvfb \
    zenity \
    kdialog \
    x11-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy the start-tor-browser script from the Tor Project
COPY start-tor-browser /tor-browser/Browser/

# Set the executable permission for the script
RUN chmod +x /tor-browser/Browser/start-tor-browser

# Copy Tor Browser to the container
COPY ./tor-browser /tor-browser

# Expose the Tor Browser port
EXPOSE 8080

# Set the working directory
WORKDIR /tor-browser/Browser

# Set the entrypoint command
CMD xvfb-run -a --server-args="-screen 0 1280x800x24" ./start-tor-browser --display=:99
