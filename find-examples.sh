#!/bin/bash

echo "Looking for example files or presets..."

cd ~/Documents/particle-life-app

# Look for example or preset files
find . -name "*example*" -o -name "*preset*" -o -name "*demo*" | grep -v ".git" | grep -v "build"

# Check if there's a data or config directory
if [ -d "data" ]; then
    echo "Found data directory:"
    ls -la data/
fi

if [ -d "config" ]; then
    echo "Found config directory:"
    ls -la config/
fi

# Look for any initialization files in resources
echo ""
echo "Resources directory structure:"
find src/main/resources -type f | grep -v ".git"