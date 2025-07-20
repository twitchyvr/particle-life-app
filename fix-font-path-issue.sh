#!/bin/bash

echo "Fixing font path issue..."

cd ~/Documents/particle-life-app

# The font exists in resources, so let's make sure it's accessible at runtime
echo "Font is at: .internal/Futura Heavy font.ttf"

# Create the .internal directory in the working directory
mkdir -p .internal
cp "src/main/resources/.internal/Futura Heavy font.ttf" ".internal/" 2>/dev/null

# Also check for the icon
if [ -f "src/main/resources/.internal/favicon.png" ]; then
    cp "src/main/resources/.internal/favicon.png" ".internal/"
fi

# List what we have
echo ""
echo "Files in .internal:"
ls -la .internal/

# Now run from the correct directory
echo ""
echo "Running from project directory..."
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -jar build/libs/particle-life-app-x86.jar