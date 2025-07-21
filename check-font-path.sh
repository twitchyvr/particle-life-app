#!/bin/bash

echo "Checking font loading in ImGuiLayer.java..."

# Show the relevant part of ImGuiLayer.java
grep -A5 -B5 "addFontFromFileTTF" src/main/java/com/particle_life/app/ImGuiLayer.java

# Check if it's trying to load from classpath or file system
echo ""
echo "Checking if fonts are in the original project:"
find . -name "*.ttf" -type f 2>/dev/null