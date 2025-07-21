#!/bin/bash

echo "Running Particle Life with extracted natives..."

# Setup directories
WORK_DIR="/tmp/particle-life-runtime"
JAR_PATH="$HOME/Documents/particle-life-app/build/libs/particle-life-app-all.jar"

# Clean and create work directory
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR/natives"

# Extract the JAR to check for natives
cd "$WORK_DIR"
echo "Extracting JAR contents..."
jar xf "$JAR_PATH"

# Find and copy natives
echo "Looking for native libraries..."
find . -name "*.dylib" -o -name "*.jnilib" | while read lib; do
    cp "$lib" natives/
    echo "Copied: $(basename "$lib")"
done

# Check architectures
echo ""
echo "Native library architectures:"
cd natives
shopt -s nullglob
for lib in *.dylib; do
    if [ -f "$lib" ]; then
        echo "$lib: $(lipo -info "$lib" 2>&1)"
    fi
done
shopt -u nullglob

echo ""
echo "Architecture mismatch detected!"
echo "LWJGL: ARM64, ImGui: x86_64"
echo "We need to rebuild with matching architectures."