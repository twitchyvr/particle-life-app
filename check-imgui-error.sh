#!/bin/bash

echo "Checking ImGui key mapping code..."

cd ~/Documents/particle-life-app

# Look for ImGui key mapping initialization
echo "Looking for ImGui key initialization:"
grep -n "KeyMap\|io\.getKeyMap" src/main/java/com/particle_life/app/ImGuiLayer.java

echo ""
echo "Looking for key mapping in the app:"
grep -rn "KeyMap\|keyMap" src/main/java/com/particle_life/app/ --include="*.java" | grep -v ".class"