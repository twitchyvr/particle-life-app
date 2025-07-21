#!/bin/bash

echo "Creating minimal configuration..."

cd ~/Documents/particle-life-app

# Create a palettes directory if needed
mkdir -p palettes

# Create a basic palette file (guessing the format)
cat > palettes/default.yaml << 'EOF'
name: Default
colors:
  - [255, 0, 0]      # Red
  - [0, 255, 0]      # Green  
  - [0, 0, 255]      # Blue
  - [255, 255, 0]    # Yellow
  - [255, 0, 255]    # Magenta
  - [0, 255, 255]    # Cyan
EOF

# Try running again
echo ""
echo "Running with config..."
./run-with-resources.sh