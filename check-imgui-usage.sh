#!/bin/bash

echo "Checking ImGui usage in the project..."

# Find all Java files that use ImGui
echo "Files using ImGui:"
grep -r "import imgui" src/ --include="*.java" | head -20

echo ""
echo "ImGui method calls:"
grep -r "ImGui\." src/ --include="*.java" | head -20

echo ""
echo "Checking if there's a way to disable ImGui:"
grep -r -i "imgui.*enable\|disable.*imgui\|use.*imgui" src/ --include="*.java"