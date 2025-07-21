#!/bin/bash

echo "Fixing ImGui key mapping issue in source code..."

cd ~/Documents/particle-life-app

# First, let's see the exact code causing the issue
echo "=== Current ImGuiLayer code around line 444 ==="
sed -n '430,460p' src/main/java/com/particle_life/app/Main.java

echo ""
echo "=== Checking ImGuiLayer initialization ==="
grep -n -A 30 "initImGui" src/main/java/com/particle_life/app/ImGuiLayer.java | head -50