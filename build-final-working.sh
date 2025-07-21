#!/bin/bash

echo "=== Particle Life macOS Build Script ==="
echo ""

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using Java:"
java -version
echo ""

# Clean
echo "Cleaning previous builds..."
rm -rf build/
./gradlew clean

# Use the working build configuration
echo "Using working build configuration..."
cp build-working.gradle build.gradle

# Build the fat JAR
echo ""
echo "Building fat JAR..."
./gradlew shadowJar

# Find the actual JAR file
JAR_FILE=$(find build/libs -name "particle-life-app*.jar" -type f | head -1)

if [ -z "$JAR_FILE" ]; then
    echo "❌ Failed to create JAR"
    echo "Contents of build/libs:"
    ls -la build/libs/
    exit 1
fi

echo "✅ JAR created successfully: $JAR_FILE"

# Test the JAR first
echo ""
echo "Testing JAR (press Ctrl+C to continue to packaging)..."
cd build/libs
timeout 5 java -XstartOnFirstThread -jar $(basename "$JAR_FILE") || true
cd ../..

# Create the app
echo ""
echo "Creating macOS app..."
./gradlew createMacApp

if [ -d "build/dist/ParticleLife.app" ]; then
    echo "✅ App created successfully!"
    
    # Create DMG
    echo ""
    echo "Creating DMG installer..."
    cd build/dist
    
    # Create a simple DMG
    hdiutil create -volname "ParticleLife" -srcfolder "ParticleLife.app" -ov -format UDZO "ParticleLife-1.0.dmg"
    
    cd ../..
    
    echo ""
    echo "=== Build Complete! ==="
    echo "📦 App: build/dist/ParticleLife.app"
    echo "💿 DMG: build/dist/ParticleLife-1.0.dmg"
    echo ""
    echo "Opening folder..."
    open build/dist/
else
    echo "❌ Failed to create app"
    exit 1
fi