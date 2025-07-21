#!/bin/bash

echo "Testing the newly built JAR..."

# Dynamically detect JAVA_HOME
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH="$JAVA_HOME/bin:$PATH"

# Find the actual JAR name
JAR_FILE=$(find build/libs -name "particle-life-app-all*.jar" | head -1)

if [ -f "$JAR_FILE" ]; then
    echo "✅ JAR found at: $JAR_FILE"
    echo "Size: $(ls -lh "$JAR_FILE" | awk '{print $5}')"
    echo ""
    
    # Try running it
    echo "Attempting to run the application..."
    cd build/libs
    java -XstartOnFirstThread -jar $(basename "$JAR_FILE")
else
    echo "❌ JAR not found!"
    echo "Contents of build/libs:"
    ls -la build/libs/
fi