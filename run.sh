#!/bin/bash
java \
  -Xms4G \
  -Xmx8G \
  -XX:AOTCache=/hytale/Server/HytaleServer.aot \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -jar /hytale/Server/HytaleServer.jar \
  --assets /hytale/Assets.zip \
  --backup \
  --backup-dir /hytale/backups \
  --backup-frequency 30