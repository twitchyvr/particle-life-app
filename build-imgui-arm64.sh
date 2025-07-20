#!/bin/bash

echo "Building ImGui-Java for ARM64..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Clone ImGui-Java
cd /tmp
rm -rf imgui-java
git clone https://github.com/SpaiR/imgui-java.git
cd imgui-java

# Checkout a specific version
git checkout v1.86.10

# Build natives for macOS ARM64
./gradlew :imgui-java-natives:build -Dos=macos -Darch=arm64

# Copy the built natives
echo "Looking for built natives..."
find . -name "*.dylib" -type f

echo ""
echo "If natives were built successfully, copy them to your project's libs directory"