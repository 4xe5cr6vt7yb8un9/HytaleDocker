#!/bin/bash
set -e

FIRST_RUN_FLAG="/hytale/.initialized"

# Check for first run
if [ ! -f "$FIRST_RUN_FLAG" ]; then
    echo "First run detected — running setup..."

    # Install hytale server files
    wget https://downloader.hytale.com/hytale-downloader.zip && \
    unzip hytale-downloader.zip hytale-downloader-linux-amd64 && \
    rm /hytale/hytale-downloader.zip && \
    chmod +x /hytale/hytale-downloader-linux-amd64 && \
    ./hytale-downloader-linux-amd64 --download-path /hytale/game.zip && \
    unzip -o /hytale/game.zip -d /hytale && \
    rm /hytale/game.zip

    touch "$FIRST_RUN_FLAG"    
    game_version=$(./hytale-downloader-linux-amd64 -print-version)
    downloader_version=$(./hytale-downloader-linux-amd64 -version)

    echo "$game_version" > /hytale/version.txt
    echo "$downloader_version" >> /hytale/version.txt
fi

echo "Starting main app..."

./start.sh

exec "$@"
