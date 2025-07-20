#!/bin/bash

echo "Running with debug output..."

cd ~/Documents/particle-life-app

# Run with x86_64 Java and debug flags
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -Dorg.lwjgl.util.Debug=true \
    -Dorg.lwjgl.util.DebugLoader=true \
    -jar build/libs/particle-life-app-all.jar 2>&1 | tee /tmp/particle-life-debug.log