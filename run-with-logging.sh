#!/bin/bash

echo "Running Particle Life with logging enabled..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

cd build/libs

# Run with various debug flags
echo "Running with debug output..."
java -XstartOnFirstThread \
     -Djava.util.logging.config.file=logging.properties \
     -Dorg.lwjgl.util.Debug=true \
     -Dorg.lwjgl.util.DebugLoader=true \
     -Djava.awt.headless=false \
     -jar particle-life-app-all.jar

echo ""
echo "Exit code: $?"