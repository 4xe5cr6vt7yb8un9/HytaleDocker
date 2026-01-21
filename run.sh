#!/bin/bash
java \
  -Xms4G \
  -Xmx8G \
  -XX:AOTCache=Server/HytaleServer.aot \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -jar Server/HytaleServer.jar \
  --assets Server/Assets.zip \
  --backup \
  --backup-frequency 30