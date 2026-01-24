#!/bin/bash
set -e

FIRST_RUN_FLAG="/hytale/.initialized"

# Check for first run
if [ ! -f "$FIRST_RUN_FLAG" ]; then
    echo "First run detected — running setup..."

    # Install hytale server files
    wget https://downloader.hytale.com/hytale-downloader.zip
    unzip -o hytale-downloader.zip hytale-downloader-linux-amd64
    rm /hytale/hytale-downloader.zip
    chmod +x /hytale/hytale-downloader-linux-amd64
    ./hytale-downloader-linux-amd64 --download-path /hytale/game.zip
    unzip -o /hytale/game.zip -d /hytale
    rm /hytale/game.zip

    touch "$FIRST_RUN_FLAG"    

    echo "Setup complete."
fi

echo "Starting main app..."

chmod +x start.sh

# --- Signal handling ---
terminate() {
    echo "Received termination signal, stopping Hytale..."

    # Gracefully stop Java
    pkill -TERM -f "HytaleServer.jar" || true
    
    # Wait up to 30 seconds for Java to exit
    for i in $(seq 1 30); do
        if ! pgrep -f "HytaleServer.jar" >/dev/null; then
            echo "Hytale stopped cleanly"
            exit 0
        fi
        sleep 1
    done

    echo "Hytale did not stop in time, forcing shutdown"
    pkill -KILL -f "HytaleServer.jar" || true
    exit 0
}

trap terminate SIGTERM SIGINT

# --- Start launcher ---
./start.sh &
LAUNCHER_PID=$!

wait $LAUNCHER_PID
