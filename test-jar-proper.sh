#!/bin/bash

echo "Testing Particle Life JAR with proper macOS configuration..."

# Use Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

cd build/libs

# Run with all necessary flags for macOS
echo "Running with macOS-specific flags..."
java -XstartOnFirstThread \
     -Djava.awt.headless=false \
     -Djava.library.path=/usr/local/lib \
     -Dorg.lwjgl.util.Debug=true \
     -Dorg.lwjgl.librarypath=/usr/local/lib \
     -jar particle-life-app-all.jar