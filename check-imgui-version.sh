#!/bin/bash

echo "Checking ImGui version in use..."

cd ~/Documents/particle-life-app

# Check gradle dependencies
echo "ImGui dependencies:"
grep -i imgui build.gradle

echo ""
echo "Checking actual ImGui version in JAR:"
jar tf build/libs/particle-life-app-1.0-all.jar | grep -i "imgui.*\.class" | head -5