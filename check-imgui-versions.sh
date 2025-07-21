#!/bin/bash

echo "Checking ImGui library versions..."

cd ~/Documents/particle-life-app

# Extract version info from the JAR
echo "ImGui classes in JAR:"
jar tf build/libs/particle-life-app-1.0-all.jar | grep -i "imgui" | grep "\.class$" | head -10

echo ""
echo "Native ImGui libraries:"
jar tf build/libs/particle-life-app-1.0-all.jar | grep -i "imgui.*\.dylib"

echo ""
echo "Checking for version info in build.gradle:"
grep -i "imgui" build.gradle