# docker-tor


# Usage

1. Install Docker: Make sure Docker is installed on your Linux ARM machine. You can find installation instructions for your specific distribution at the Docker website (https://docs.docker.com/engine/install/).

2. Download and extract Tor Browser: Download the Tor Browser bundle for Linux ARM from the link you provided (https://www.torproject.org/dist/torbrowser/12.0.6/tor-browser-linux64-12.0.6_ALL.tar.xz). Extract the contents of the tar.xz file to a directory.

3.
```shell
wget https://raw.githubusercontent.com/torproject/tor-browser/ac1c6e5e7287c7911b66f45d18c39a30b8cc9b48/browser/app/firefox/xvfb-run.sh
```

4.
```shell
docker build -t tor-browser .
docker stop tor-browser-container
docker rm tor-browser-container
docker run -d -p 9418:8080 --name tor-browser-container tor-browser
```

~ https://chatgpt.com/share/66fa85c0-be60-8009-b266-17a19b49beb0
