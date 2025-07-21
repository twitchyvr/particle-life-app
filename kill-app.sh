#!/bin/bash

# Force kill any hanging Java processes
echo "🚫 FORCE KILLING HANGING PROCESSES"
echo "================================="

echo "Looking for Java processes..."
ps aux | grep java | grep -v grep

echo ""
echo "Killing all Java processes related to particle-life..."
pkill -f "particle-life"
pkill -f "gradlew run"
pkill -f "com.particle_life.app.Main"

echo ""
echo "Killing any remaining Gradle daemons..."
./gradlew --stop

echo "✅ Cleanup complete"