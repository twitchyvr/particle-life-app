#!/bin/bash

echo "Running Particle Life with extracted resources..."

cd ~/Documents/particle-life-app

# Extract .internal resources from JAR
echo "Extracting resources..."
jar xf build/libs/particle-life-app-x86.jar .internal

# Check what was extracted
echo ""
echo "Extracted files:"
ls -la .internal/

# Now run the application
echo ""
echo "Starting application..."
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -Duser.dir="$(pwd)" \
    -jar build/libs/particle-life-app-x86.jar