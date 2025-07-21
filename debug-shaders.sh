#!/bin/bash

# Debug particle shader compilation specifically
echo "🔍 DEBUGGING PARTICLE SHADER COMPILATION"
echo "========================================"

export JAVA_HOME=$(brew --prefix openjdk@17)
export LWJGL_DEBUG=true

echo "Starting app with maximum shader debug output..."

# Run and capture all shader-related output
timeout 10s ./gradlew run 2>&1 | tee shader-debug.log

echo ""
echo "🔍 Searching for shader errors..."
grep -i -A 10 -B 5 "shader\|compile\|error\|failed\|exception" shader-debug.log

echo ""
echo "🔍 Checking what shaders were actually loaded..."
grep -i "successfully loaded\|shader.*compiled\|shader.*failed" shader-debug.log