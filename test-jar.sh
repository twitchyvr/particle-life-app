#!/bin/bash

echo "Testing Particle Life JAR..."

# Use Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Build the JAR
echo "Building JAR..."
./gradlew clean fatJar

# Test running the JAR with proper flags for macOS
echo ""
echo "Running JAR with macOS flags..."
cd build/libs
java -XstartOnFirstThread -Djava.awt.headless=false -jar particle-life-app-all.jar