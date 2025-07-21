#!/bin/bash

echo "Creating final distribution package..."

cd ~/Documents/particle-life-app

# Create distribution directory
DIST_DIR="ParticleLife-macOS-M1"
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Copy the app
cp -r build/dist/ParticleLife.app "$DIST_DIR/"

# Copy the run script
cp run-with-resources.sh "$DIST_DIR/run-from-terminal.sh"

# Create README
cat > "$DIST_DIR/README.txt" << 'EOF'
Particle Life for macOS (Apple Silicon Compatible)
=================================================

This version runs on Apple Silicon Macs using Rosetta 2 for compatibility.

To run:
1. Double-click ParticleLife.app
   OR
2. Use Terminal: ./run-from-terminal.sh

Requirements:
- macOS 11.0 or later
- x86_64 Java 17 (for Rosetta 2 compatibility)

Note: This uses x86_64 emulation for ImGui compatibility.
Native ARM64 support will be available when ImGui-Java adds it.

Enjoy creating beautiful particle simulations!
EOF

# Create zip file
zip -r ParticleLife-macOS-M1.zip "$DIST_DIR"

echo ""
echo "✅ Distribution package created: ParticleLife-macOS-M1.zip"
echo ""
echo "The application is now ready to use!"
echo "Share the zip file with other macOS users."