#!/bin/bash

echo "Creating macOS application bundle..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Find the actual JAR name
JAR_NAME=$(cd build/libs && ls particle-life-app-all*.jar | head -1)

if [ -z "$JAR_NAME" ]; then
    echo "❌ No JAR file found!"
    exit 1
fi

echo "Using JAR: $JAR_NAME"

# Create the app using jpackage
mkdir -p build/dist

jpackage \
    --type app-image \
    --name ParticleLife \
    --input build/libs \
    --main-jar "$JAR_NAME" \
    --dest build/dist \
    --mac-package-identifier com.particle.life.app \
    --mac-package-name ParticleLife \
    --java-options "-XstartOnFirstThread"

if [ -d "build/dist/ParticleLife.app" ]; then
    echo "✅ App created successfully!"
    
    # Create DMG
    echo "Creating DMG installer..."
    jpackage \
        --type dmg \
        --name ParticleLife \
        --app-image build/dist/ParticleLife.app \
        --dest build/dist
    
    echo ""
    echo "✅ Build complete!"
    echo "📦 App: build/dist/ParticleLife.app"
    echo "💿 DMG: build/dist/ParticleLife-1.0.dmg"
    
    open build/dist/
else
    echo "❌ Failed to create app"
fi