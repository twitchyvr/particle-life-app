#!/bin/bash

echo "Running Particle Life with extracted natives..."

# Setup directories
WORK_DIR=$(mktemp -d -t particle-life-runtime-XXXXXX)
JAR_PATH="$HOME/Documents/particle-life-app/build/libs/particle-life-app-all.jar"

# Create work directory for natives
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
for lib in *.dylib *.jnilib; do
    if [ -f "$lib" ]; then
        echo "$lib: $(lipo -info "$lib" 2>&1)"
    fi
done
shopt -u nullglob

# Try to run with correct library path
echo ""
echo "Attempting to run with x86_64 Java and extracted natives..."
cd "$HOME/Documents/particle-life-app"

# Use x86_64 Java with library path
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -Djava.library.path="$WORK_DIR/natives" \
    -Dorg.lwjgl.librarypath="$WORK_DIR/natives" \
    -Dorg.lwjgl.util.Debug=true \
    -Dorg.lwjgl.util.DebugLoader=true \
    -jar build/libs/particle-life-app-all.jar