#!/bin/bash

echo "Diagnosing native libraries..."

# Extract natives from JAR to check architectures
cd /tmp
rm -rf particle-life-natives
mkdir particle-life-natives
cd particle-life-natives

echo "Extracting native libraries from JAR..."
jar xf ~/Documents/particle-life-app/build/libs/particle-life-app-all.jar

echo ""
echo "Finding all dylib files:"
find . -name "*.dylib" -type f | while read lib; do
    echo "$lib: $(file "$lib" | cut -d: -f2-)"
done

echo ""
echo "LWJGL natives found:"
find . -name "*lwjgl*.dylib" -type f

echo ""
echo "ImGui natives found:"
find . -name "*imgui*.dylib" -type f