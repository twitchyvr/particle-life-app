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