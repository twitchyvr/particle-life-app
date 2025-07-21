#!/bin/bash

echo "Examining the keyMap initialization issue..."

cd ~/Documents/particle-life-app

# Look at the exact line causing the assertion
echo "=== ImGuiKey enum values ==="
grep -A 30 "ImGuiKey\." src/main/java/com/particle_life/app/ImGuiLayer.java | grep -E "ImGuiKey\.[A-Z]" | sort | uniq

echo ""
echo "=== Checking if keyMap array is being set correctly ==="
sed -n '53,85p' src/main/java/com/particle_life/app/ImGuiLayer.java