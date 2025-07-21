#!/bin/bash

echo "Checking for required files and dependencies..."

cd ~/Documents/particle-life-app

# Check for shader files
echo "Shader files in .internal:"
find .internal -name "*.glsl" -o -name "*.vert" -o -name "*.frag" 2>/dev/null

# Check what's in cursor_shaders
echo ""
echo "Contents of cursor_shaders:"
ls -la .internal/cursor_shaders/

# Check if there are any config files needed
echo ""
echo "Looking for config files:"
find . -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.properties" | grep -v build | grep -v ".git"

# Check the Main class for initialization order
echo ""
echo "Checking Main class initialization..."
grep -n "palettes" src/main/java/com/particle_life/app/Main.java | head -10