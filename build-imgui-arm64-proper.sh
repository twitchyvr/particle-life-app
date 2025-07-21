#!/bin/bash

echo "Building ImGui-Java for ARM64 properly..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Ensure we have required tools
if ! command -v cmake &> /dev/null; then
    echo "Installing cmake..."
    brew install cmake
fi

# Clone and build
cd /tmp
rm -rf imgui-java-arm64
git clone https://github.com/SpaiR/imgui-java.git imgui-java-arm64
cd imgui-java-arm64

# Checkout a stable version
git checkout v1.86.10

# Build the natives for ARM64
echo "Building natives for ARM64..."
cd imgui-cpp
mkdir -p build
cd build

# Configure for ARM64
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_ARCHITECTURES=arm64 \
         -DCMAKE_SYSTEM_PROCESSOR=arm64

# Build
make -j$(sysctl -n hw.ncpu)

# Check what was built
echo ""
echo "Built files:"
find . -name "*.dylib" -type f | while read f; do
    echo "$f: $(file "$f")"
done

# Copy to project if successful
if [ -f "libimgui-java64.dylib" ]; then
    echo ""
    echo "✅ Successfully built ARM64 native!"
    
    # Copy to your project
    PROJECT_DIR="$HOME/Documents/particle-life-app"
    mkdir -p "$PROJECT_DIR/natives/macos-arm64"
    cp libimgui-java64.dylib "$PROJECT_DIR/natives/macos-arm64/"
    
    echo "Copied to: $PROJECT_DIR/natives/macos-arm64/libimgui-java64.dylib"
else
    echo "❌ Build failed - trying alternative approach..."
fi