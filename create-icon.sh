#!/bin/bash

# Create a placeholder icon file for the macOS app
# You should replace this with a proper .icns file

mkdir -p src/main/resources

# Check if iconutil is available (macOS tool for creating icons)
if command -v iconutil &> /dev/null; then
    # Create a temporary icon set
    ICONSET_DIR="ParticleLife.iconset"
    mkdir -p "$ICONSET_DIR"
    
    # Create a simple colored square as placeholder using ImageMagick or sips
    if command -v magick &> /dev/null; then
        # Use ImageMagick if available
        for size in 16 32 64 128 256 512; do
            magick -size ${size}x${size} xc:'#4A90E2' -draw "fill '#2E5090' circle $((size/2)),$((size/2)) $((size/2)),$((size/4))" "$ICONSET_DIR/icon_${size}x${size}.png"
            magick -size $((size*2))x$((size*2)) xc:'#4A90E2' -draw "fill '#2E5090' circle $size,$size $size,$((size/2))" "$ICONSET_DIR/icon_${size}x${size}@2x.png"
        done
    elif command -v sips &> /dev/null; then
        # Create a simple blue PNG and resize it
        echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==" | base64 -D > temp_icon.png
        for size in 16 32 64 128 256 512; do
            sips -z $size $size temp_icon.png --out "$ICONSET_DIR/icon_${size}x${size}.png" >/dev/null 2>&1
            sips -z $((size*2)) $((size*2)) temp_icon.png --out "$ICONSET_DIR/icon_${size}x${size}@2x.png" >/dev/null 2>&1
        done
        rm temp_icon.png
    else
        echo "Neither ImageMagick nor sips found. Creating empty icon files..."
        for size in 16 32 64 128 256 512; do
            touch "$ICONSET_DIR/icon_${size}x${size}.png"
            touch "$ICONSET_DIR/icon_${size}x${size}@2x.png"
        done
    fi
    
    # Convert to .icns
    iconutil -c icns "$ICONSET_DIR" -o src/main/resources/icon.icns
    
    # Clean up
    rm -rf "$ICONSET_DIR"
    
    echo "✅ Created placeholder icon at: src/main/resources/icon.icns"
else
    echo "⚠️  iconutil not found. Creating empty icon file..."
    touch src/main/resources/icon.icns
fi