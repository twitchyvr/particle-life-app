#!/bin/bash

echo "Rebuilding with Shadow plugin..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Clean everything
echo "Cleaning..."
rm -rf build/ .gradle/
./gradlew --stop

# Build with Shadow
echo "Building with Shadow plugin..."
./gradlew clean shadowJar

if [ -f "build/libs/particle-life-app-all.jar" ]; then
    echo "✅ JAR created successfully!"
    
    # Test it
    echo ""
    echo "Testing JAR..."
    cd build/libs
    java -XstartOnFirstThread -jar particle-life-app-all.jar
else
    echo "❌ Failed to create JAR"
    ls -la build/libs/
fi