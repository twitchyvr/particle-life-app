#!/bin/bash

echo "Testing the Shadow JAR..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

cd build/libs

# The JAR has a different name than expected
if [ -f "particle-life-app-all-all.jar" ]; then
    echo "✅ Found JAR: particle-life-app-all-all.jar"
    echo "Size: $(ls -lh particle-life-app-all-all.jar | awk '{print $5}')"
    echo ""
    echo "Running..."
    java -XstartOnFirstThread -jar particle-life-app-all-all.jar
else
    echo "❌ JAR not found"
    ls -la
fi