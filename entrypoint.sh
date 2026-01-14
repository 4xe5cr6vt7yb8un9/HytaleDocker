#!/bin/bash
set -e

FIRST_RUN_FLAG="/hytale/.initialized"

if [ ! -f "$FIRST_RUN_FLAG" ]; then
    echo "First run detected — running setup..."

    # Install hytale server files
    wget https://downloader.hytale.com/hytale-downloader.zip && \
    unzip hytale-downloader.zip && \
    rm hytale-downloader.zip && \
    chmod +x /hytale/hytale-downloader-linux-amd64 && \
    ./hytale-downloader-linux-amd64 --download-path /hytale/game.zip && \
    unzip /hytale/game.zip -d /hytale && \
    rm /hytale/game.zip

    touch "$FIRST_RUN_FLAG"
fi

echo "Starting main app..."
exec "$@"
