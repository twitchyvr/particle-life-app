#!/bin/bash

echo "Looking for the missing core classes..."

# Search for Particle class definition
echo "Searching for Particle class:"
find . -name "*.java" -type f | xargs grep -l "class Particle" 2>/dev/null

echo ""
echo "Searching for Physics class:"
find . -name "*.java" -type f | xargs grep -l "class Physics" 2>/dev/null

echo ""
echo "Checking if there's a lib directory with the particle-life JAR:"
find . -name "*.jar" -type f | grep -v build | grep -v gradle

echo ""
echo "Checking if the particle-life library source is included:"
find . -path "*/com/particle_life/*.java" -type f | grep -v app | head -10