#!/bin/bash

# Test script to check if particle life app is working
echo "Setting Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Testing Particle Life App..."
echo "If you see this and then the app launches, try:"
echo "1. Press 'p' to set particle positions"
echo "2. Press 'm' to generate a matrix"
echo "3. Press 'g' to open graphics settings"
echo "4. Try pressing 'Esc' to toggle GUI"
echo ""

./gradlew run