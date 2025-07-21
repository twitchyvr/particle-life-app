#!/bin/bash
# Run Particle Life with proper architecture detection

JAR_NAME="particle-life-app-all.jar"

# Check if running on Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    echo "Not running on Apple Silicon, using native execution..."
    java -XstartOnFirstThread -jar build/libs/$JAR_NAME
    exit 0
fi

# For Apple Silicon, we need x86_64 Java for ImGui
X86_JAVA="/usr/local/opt/openjdk@17/bin/java"

if [ -f "$X86_JAVA" ]; then
    echo "Using x86_64 Java for ImGui compatibility..."
    arch -x86_64 "$X86_JAVA" -XstartOnFirstThread -jar build/libs/$JAR_NAME
else
    echo "x86_64 Java not found at $X86_JAVA"
    echo "Trying native ARM64 (will likely fail with ImGui)..."
    java -XstartOnFirstThread -jar build/libs/$JAR_NAME
fi