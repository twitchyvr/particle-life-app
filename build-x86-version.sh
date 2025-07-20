#!/bin/bash

echo "Building x86_64 version for Rosetta compatibility..."

# Set Java 17 (ARM64 for building, doesn't matter)
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Backup current build.gradle
cp build.gradle build.gradle.arm64.bak

# Use x86 build configuration
cp build-x86.gradle build.gradle

# Clean and build
./gradlew clean shadowJar

# Check the result
if [ -f "build/libs/particle-life-app-x86.jar" ]; then
    echo ""
    echo "✅ Built x86_64 JAR successfully!"
    
    # Verify natives
    echo ""
    echo "Checking native architectures in JAR:"
    cd /tmp
    rm -rf check-x86
    mkdir check-x86
    cd check-x86
    jar xf ~/Documents/particle-life-app/build/libs/particle-life-app-x86.jar
    
    echo "LWJGL natives:"
    find . -path "*/lwjgl*.dylib" -type f | while read lib; do
        echo "  $(basename "$lib"): $(file "$lib" | grep -o 'x86_64\|arm64')"
    done
    
    echo "ImGui natives:"
    find . -name "*imgui*.dylib" -type f | while read lib; do
        echo "  $(basename "$lib"): $(file "$lib" | grep -o 'x86_64\|arm64')"
    done
    
    # Test run
    echo ""
    echo "Testing with x86_64 Java..."
    cd ~/Documents/particle-life-app
    arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
        -XstartOnFirstThread \
        -jar build/libs/particle-life-app-x86.jar
else
    echo "❌ Build failed"
    ls -la build/libs/
fi