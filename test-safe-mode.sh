#!/bin/bash

# Test if basic ImGui works on macOS M1 without particle rendering
echo "🧪 Testing Safe Mode - ImGui Only"
echo "================================"

export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Building safe test version..."
./gradlew compileJava

echo ""
echo "Running safe mode (ImGui only, no particle shaders)..."
echo "This should show a simple GUI if OpenGL/ImGui work at all"
echo ""

java -cp "build/classes/java/main:$(./gradlew -q printClasspath)" \
     -XstartOnFirstThread \
     -Djava.awt.headless=false \
     com.particle_life.app.SafeMain