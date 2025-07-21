#!/bin/bash

# Reset settings and run with macOS compatibility mode
echo "🔧 Setting up Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "🗑️  Clearing old settings to force macOS defaults..."
rm -f settings.toml

echo "🎯 Starting with emergency macOS compatibility mode:"
echo "   ✅ Simple point-based shader (no geometry shaders)"
echo "   ✅ OpenGL 1.5 compatible (should work on any Mac)"
echo "   ✅ Fresh settings with macOS defaults"
echo ""

./gradlew run 2>&1 | tee reset-run.log