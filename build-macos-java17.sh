#!/bin/bash

# Particle Life macOS Build Script with Java version management

echo "Building Particle Life for macOS..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script must be run on macOS to build a macOS application."
    exit 1
fi

# Try to use Java 17 or 21 if available
JAVA_17_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)
JAVA_21_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null)

if [ -n "$JAVA_17_HOME" ]; then
    echo "Using Java 17 at: $JAVA_17_HOME"
    export JAVA_HOME="$JAVA_17_HOME"
elif [ -n "$JAVA_21_HOME" ]; then
    echo "Using Java 21 at: $JAVA_21_HOME"
    export JAVA_HOME="$JAVA_21_HOME"
else
    echo "Warning: Java 17 or 21 not found. Using default Java version."
    echo "This might cause compatibility issues with Gradle."
fi

# Update PATH to use the selected Java
export PATH="$JAVA_HOME/bin:$PATH"

# Show which Java we're using
echo "Java version:"
java -version
echo ""

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