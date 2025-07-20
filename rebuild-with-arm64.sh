#!/bin/bash

echo "Rebuilding with ARM64 natives..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Clean and rebuild
./gradlew clean fatJar

# Test the new JAR
echo ""
echo "Testing rebuilt JAR..."
cd build/libs
java -XstartOnFirstThread -jar particle-life-app-all.jar