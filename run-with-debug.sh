#!/bin/bash

echo "Running Particle Life with debug output..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

cd ~/Documents/particle-life-app

# Run with debug flags
java -XstartOnFirstThread \
     -Dorg.lwjgl.util.Debug=true \
     -Dorg.lwjgl.util.DebugLoader=true \
     -Dorg.lwjgl.opengl.Display.enableHighDPI=true \
     -jar build/libs/particle-life-app-1.0-all.jar 2>&1 | tee particle-life-debug.log