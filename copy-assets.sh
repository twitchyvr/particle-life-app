#!/bin/bash

echo "Looking for and copying assets..."

cd ~/Documents/particle-life-app

# Check if assets directory exists in the project
if [ -d "assets" ]; then
    echo "Found assets directory"
    ls -la assets/
    
    # Copy to resources
    cp -r assets/* src/main/resources/ 2>/dev/null
    
    # Also copy to root for runtime access
    cp -r assets . 2>/dev/null
else
    echo "No assets directory found"
fi

# Try to find the fonts directory
if [ -d ".internal/assets/fonts" ]; then
    echo "Found fonts in .internal/assets/fonts"
    mkdir -p assets/fonts
    cp -r .internal/assets/fonts/* assets/fonts/
elif [ -d "src/main/resources/fonts" ]; then
    echo "Fonts already in resources"
else
    echo "Creating default font setup..."
    mkdir -p assets/fonts
    
    # Download Roboto font
    curl -L "https://github.com/google/fonts/raw/main/apache/roboto/static/Roboto-Regular.ttf" \
         -o assets/fonts/Roboto-Regular.ttf
    
    # Verify the integrity of the downloaded file
    echo "Verifying integrity of Roboto-Regular.ttf..."
    EXPECTED_SHA256="e8b7f1b5b3c2c3e5b8f8e5b3c2c3e5b8f8e5b3c2c3e5b8f8e5b3c2c3e5b8f8e" # Replace with actual checksum
    ACTUAL_SHA256=$(shasum -a 256 assets/fonts/Roboto-Regular.ttf | awk '{print $1}')
    if [ "$EXPECTED_SHA256" != "$ACTUAL_SHA256" ]; then
        echo "Error: Integrity check failed for Roboto-Regular.ttf"
        rm -f assets/fonts/Roboto-Regular.ttf
        exit 1
    fi
fi

# Rebuild with assets
echo ""
echo "Rebuilding with assets..."
./gradlew shadowJar

# Test again
echo ""
echo "Testing with assets..."
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -jar build/libs/particle-life-app-x86.jar