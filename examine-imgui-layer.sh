#!/bin/bash

echo "Examining ImGuiLayer.java for key mapping issues..."

cd ~/Documents/particle-life-app

# Show the ImGui initialization code
echo "=== ImGuiLayer initialization code ==="
grep -A 20 -B 5 "initImGui" src/main/java/com/particle_life/app/ImGuiLayer.java

echo ""
echo "=== Looking for key mapping code ==="
grep -n -A 10 -B 5 "KeyMap\|getKeyMap" src/main/java/com/particle_life/app/ImGuiLayer.java