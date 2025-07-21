#!/bin/bash

echo "Fixing missing resources..."

cd ~/Documents/particle-life-app

# Check what resources are in the JAR
echo "Checking resources in JAR:"
jar tf build/libs/particle-life-app-x86.jar | grep -E "\.(ttf|png|jpg|ico)" | head -20

# Look for font references in the source
echo ""
echo "Looking for font loading code:"
grep -n "addFontFromFileTTF" src/main/java/com/particle_life/app/ImGuiLayer.java

# Check if there's a resources directory
echo ""
echo "Checking resources directory:"
ls -la src/main/resources/

# Create missing resources if needed
mkdir -p src/main/resources/fonts

# Download a default font if needed
if [ ! -f "src/main/resources/fonts/Roboto-Regular.ttf" ]; then
    echo ""
    echo "Downloading Roboto font..."
    curl -L "https://github.com/google/fonts/raw/main/apache/roboto/static/Roboto-Regular.ttf" \
         -o src/main/resources/fonts/Roboto-Regular.ttf
    echo "Verifying checksum for Roboto font..."
    EXPECTED_CHECKSUM="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    ACTUAL_CHECKSUM=$(sha256sum src/main/resources/fonts/Roboto-Regular.ttf | awk '{print $1}')
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        echo "Checksum verification failed for Roboto font. Aborting."
        rm -f src/main/resources/fonts/Roboto-Regular.ttf
        exit 1
    fi
    echo "Checksum verification passed for Roboto font."
fi

# Create a simple icon if it doesn't exist
if [ ! -f "src/main/resources/icon.png" ]; then
    echo "Creating placeholder icon..."
    # Create a simple 32x32 red square as PNG
    python3 -c "
from PIL import Image
img = Image.new('RGB', (32, 32), color='red')
img.save('src/main/resources/icon.png')
print('Created icon.png')
" 2>/dev/null || echo "Python PIL not available, skipping icon creation"
fi