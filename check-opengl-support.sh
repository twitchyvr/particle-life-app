#!/bin/bash

echo "Checking OpenGL support on your Mac..."

# Check GPU info
echo "GPU Information:"
system_profiler SPDisplaysDataType | grep -E "(Chipset Model:|Metal:|OpenGL)" | head -20

echo ""
echo "OpenGL Extensions:"
/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/opengl_profiler.app/Contents/MacOS/opengl_profiler 2>&1 | grep -i version | head -5 || echo "Could not query OpenGL directly"