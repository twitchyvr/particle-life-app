#!/bin/bash

echo "Checking shader files in the JAR..."

cd ~/Documents/particle-life-app

# List shader files in the JAR
echo "Shader files in JAR:"
jar tf build/libs/particle-life-app-1.0-all.jar | grep -E "\.(glsl|vert|frag|vs|fs)$"

echo ""
echo "Checking .internal directory:"
jar tf build/libs/particle-life-app-1.0-all.jar | grep "\.internal/"