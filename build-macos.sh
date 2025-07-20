#!/bin/bash

# Particle Life macOS Build Script

echo "Building Particle Life for macOS..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script must be run on macOS to build a macOS application."
    exit 1
fi

# Check if Java 17+ is installed
java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$java_version" -lt 17 ]; then
    echo "Error: Java 17 or higher is required. Current version: $java_version"
    exit 1
fi

# Check if jpackage is available
if ! command -v jpackage &> /dev/null; then
    echo "Error: jpackage command not found. Make sure you have JDK 17+ installed."
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
./gradlew clean

# Build the fat JAR with all dependencies
echo "Building fat JAR with all dependencies..."
./gradlew fatJar

# Check if the JAR was created successfully
if [ ! -f "build/libs/particle-life-app-all.jar" ]; then
    echo "Error: Failed to create fat JAR"
    exit 1
fi

# Create the macOS app and DMG
echo "Creating macOS application and DMG installer..."
./gradlew packageMacOS

# Check if the app was created successfully
if [ -d "build/dist/ParticleLife.app" ]; then
    echo ""
    echo "✅ Build complete!"
    echo "📦 Application created at: build/dist/ParticleLife.app"
    echo "💿 DMG installer created at: build/dist/ParticleLife-1.0.dmg"
    echo ""
    
    # Open the dist folder in Finder
    open build/dist/
else
    echo "❌ Error: Failed to create macOS application"
    exit 1
fi