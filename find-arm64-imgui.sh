#!/bin/bash

echo "Looking for ARM64 ImGui natives..."

# Check if there's an ARM64 version in homebrew
brew search imgui

# Try to find any ARM64 imgui libraries
find /opt/homebrew -name "*imgui*.dylib" 2>/dev/null | while read f; do
    echo "$f: $(file "$f")"
done

# Check GitHub for forks with ARM64 support
echo ""
echo "Checking for ARM64 forks..."
curl -s "https://api.github.com/search/repositories?q=imgui-java+arm64+in:readme" | grep -E "(full_name|description)" | head -20