#!/bin/bash

echo "Debugging Particle Life app..."

# First, let's check the app contents
echo "Checking app contents..."
echo "Contents of ParticleLife.app:"
ls -la build/dist/ParticleLife.app/Contents/
echo ""
echo "Contents of ParticleLife.app/Contents/MacOS:"
ls -la build/dist/ParticleLife.app/Contents/MacOS/
echo ""
echo "Contents of ParticleLife.app/Contents/app:"
ls -la build/dist/ParticleLife.app/Contents/app/

# Try running the JAR directly to see if it works
echo ""
echo "Testing JAR directly..."
cd build/libs
java -jar particle-life-app-all.jar