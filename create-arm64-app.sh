#!/bin/bash

echo "Creating ARM64-native macOS app..."

cd ~/Documents/particle-life-app

# Create app structure
APP_NAME="ParticleLife"
APP_DIR="build/dist/${APP_NAME}-ARM64.app"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy JAR
cp build/libs/particle-life-app-1.0-all.jar "$APP_DIR/Contents/Resources/"

# Create launcher script for ARM64
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'EOF'
#!/bin/bash

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
JAR_PATH="$DIR/../Resources/particle-life-app-1.0-all.jar"

# Use native ARM64 Java
exec java -XstartOnFirstThread -jar "$JAR_PATH"
EOF

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ParticleLife</string>
    <key>CFBundleIdentifier</key>
    <string>com.particle.life.app</string>
    <key>CFBundleName</key>
    <string>ParticleLife</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
</dict>
</plist>
EOF

echo "✅ ARM64 app created at: $APP_DIR"