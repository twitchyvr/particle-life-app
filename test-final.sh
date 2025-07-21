#!/bin/bash

# Final test script for Particle Life App on macOS M1
echo "🔧 Setting up Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "☕ Java version:"
java -version

echo ""
echo "🚀 Launching Particle Life App with ALL fixes applied:"
echo "   ✅ Java 17 compatibility"
echo "   ✅ ImGui key mapping fixed"  
echo "   ✅ OpenGL 3.3 fallback shaders"
echo "   ✅ macOS-specific shader defaults"
echo "   ✅ Shader compilation error fixes"
echo ""
echo "📝 If you still see issues:"
echo "   - The error dialog should now be clickable"
echo "   - Try pressing [Esc] key to toggle GUI"
echo "   - Try pressing [p] then [m] to generate particles"
echo "   - Use Cmd+Q to quit if needed"
echo ""
echo "🎯 Starting application..."

./gradlew run 2>&1 | tee app-final.log