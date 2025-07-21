#!/bin/bash

echo "Running with detailed debugging..."

cd ~/Documents/particle-life-app

# Run with more debugging and catch the full output
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -Dorg.lwjgl.util.Debug=true \
    -Dorg.lwjgl.util.DebugLoader=true \
    -Djava.awt.headless=false \
    -jar build/libs/particle-life-app-x86.jar 2>&1 | tee particle-life-debug.log

echo ""
echo "Check particle-life-debug.log for full output"