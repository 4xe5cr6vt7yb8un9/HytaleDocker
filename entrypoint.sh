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

# Check for updates on subsequent runs
if [ -f "$FIRST_RUN_FLAG" ]; then
    touch /hytale/version.txt

    current_game_version=$(sed -n '1p' /hytale/version.txt)
    latest_game_version=$(./hytale-downloader-linux-amd64 -print-version)

    current_downloader_version=$(sed -n '2p' /hytale/version.txt)
    latest_downloader_version=$(./hytale-downloader-linux-amd64 -version)

    # Update downloader if needed
    if [ "$current_downloader_version" != "$latest_downloader_version" ]; then
        echo "Downloader update detected: $current_downloader_version -> $latest_downloader_version"
        echo "Updating downloader..."

        wget https://downloader.hytale.com/hytale-downloader.zip && \
        unzip -o hytale-downloader.zip hytale-downloader-linux-amd64 && \
        rm /hytale/hytale-downloader.zip && \
        chmod +x /hytale/hytale-downloader-linux-amd64

        echo "$current_game_version" > /hytale/version.txt
        echo "$latest_downloader_version" >> /hytale/version.txt
    fi

    # Update game files if needed
    if [ "$current_game_version" != "$latest_game_version" ]; then
        echo "Update detected: $current_game_version -> $latest_game_version"
        echo "Updating server files..."

        ./hytale-downloader-linux-amd64 --download-path /hytale/game.zip && \
        unzip -o /hytale/game.zip -d /hytale && \
        rm /hytale/game.zip

        echo "$latest_game_version" > /hytale/version.txt
        echo "$latest_downloader_version" >> /hytale/version.txt
    else
        echo "No updates found. Current version: $current_version"
    fi
fi

echo "Starting main app..."

./start.sh

exec "$@"
