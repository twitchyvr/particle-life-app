#!/bin/bash

echo "Testing the Shadow JAR..."

# Set Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

cd build/libs

# Dynamically find the JAR file
JAR_FILE=$(ls particle-life-app-*.jar 2>/dev/null | head -n 1)

if [ -n "$JAR_FILE" ]; then
    echo "✅ Found JAR: $JAR_FILE"
    echo "Size: $(ls -lh "$JAR_FILE" | awk '{print $5}')"
    echo ""
    echo "Running..."
    java -XstartOnFirstThread -jar "$JAR_FILE"
else
    echo "❌ JAR not found"
    ls -la
fi