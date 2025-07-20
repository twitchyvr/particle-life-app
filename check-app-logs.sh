#!/bin/bash

echo "Checking application logs..."
cat /tmp/particle-life.log

echo ""
echo "Checking what's actually in the JAR..."
cd build/libs
jar tf particle-life-app-all.jar | grep -E "(lwjgl|imgui).*\.dylib" | head -20