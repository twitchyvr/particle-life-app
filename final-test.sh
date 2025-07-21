#!/bin/bash

# Final test for macOS M1 compatibility
echo "🎉 FINAL TEST - macOS M1 Particle Life App"
echo "=========================================="

export JAVA_HOME=$(brew --prefix openjdk@17)

echo "✅ Java 17 configured"
echo "✅ Settings reset for macOS defaults"
echo "✅ Simple shader mode enabled"
echo "✅ Null pointer fixes applied"
echo ""

echo "🚀 Starting Particle Life App..."
echo ""
echo "📋 What to expect:"
echo "   - App window should open"
echo "   - ImGui interface should be visible"
echo "   - No error dialogs"
echo "   - Basic particle rendering (simple dots)"
echo ""
echo "🎮 Quick start tips:"
echo "   - Press 'p' to set particle positions"  
echo "   - Press 'm' to generate interaction matrix"
echo "   - Adjust particle count in the GUI"
echo "   - Press 'g' for graphics settings"
echo ""
echo "⚠️  If you see issues:"
echo "   - Check this terminal for error messages"
echo "   - Use Cmd+Q to quit"
echo ""

./gradlew run