#!/bin/bash

echo "Simple build script for Particle Life"

# Use Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using Java:"
java -version

# Clean and build
echo ""
echo "Cleaning..."
rm -rf build/

echo ""
echo "Building JAR..."
./gradlew fatJar

if [ -f "build/libs/particle-life-app-all.jar" ]; then
    echo ""
    echo "✅ JAR built successfully!"
    
    echo ""
    echo "Creating macOS app..."
    
    # Create the app using jpackage directly
    mkdir -p build/dist
    
    jpackage \
        --type app-image \
        --name ParticleLife \
        --input build/libs \
        --main-jar particle-life-app-all.jar \
        --dest build/dist \
        --mac-package-identifier com.particle.life.app \
        --mac-package-name ParticleLife
    
    if [ -d "build/dist/ParticleLife.app" ]; then
        echo "✅ App created successfully!"
        
        echo ""
        echo "Creating DMG..."
        
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
else
    echo "❌ Failed to build JAR"
fi