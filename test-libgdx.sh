#!/bin/bash

# Test LibGDX version - optimized for macOS M1
echo "🚀 TESTING LIBGDX VERSION - macOS M1 Optimized"
echo "=============================================="

export JAVA_HOME=$(brew --prefix openjdk@17)

echo "📋 LibGDX advantages for macOS M1:"
echo "   ✅ Native Metal backend (not OpenGL)"
echo "   ✅ Automatic M1 native library handling"
echo "   ✅ Mature macOS support"
echo "   ✅ High-performance particle rendering"
echo "   ✅ Built-in UI system (no ImGui complexity)"
echo ""

echo "Building LibGDX version..."
./gradlew -b build-libgdx.gradle build

echo ""
echo "🎯 Starting LibGDX Particle Life..."
echo "Expected: Smooth 60fps particle simulation with working UI"
echo "Controls: SPACE = pause/resume, R = reset"

./gradlew -b build-libgdx.gradle run