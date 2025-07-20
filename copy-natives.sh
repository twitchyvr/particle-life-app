#!/bin/bash

echo "Copying native libraries..."

# Create a natives directory in your project
mkdir -p natives/macos-arm64

# Copy the dylib files from the imgui-java build
if [ -f "/tmp/imgui-java/bin/libimgui-java64.dylib" ]; then
    cp /tmp/imgui-java/bin/libimgui-java64.dylib natives/macos-arm64/
    echo "✅ Copied libimgui-java64.dylib"
else
    echo "❌ libimgui-java64.dylib not found"
fi

# Check the architecture of the dylib
echo ""
echo "Checking architecture of the dylib:"
file /tmp/imgui-java/bin/libimgui-java64.dylib

# Now let's run with the library path set
echo ""
echo "Running with native library path..."
cd build/libs
java -XstartOnFirstThread \
     -Djava.library.path=../../natives/macos-arm64 \
     -jar particle-life-app-all-all.jar