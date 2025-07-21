#!/bin/bash

echo "Creating final macOS app with resources..."

cd ~/Documents/particle-life-app

# Create app structure
APP_NAME="ParticleLife"
APP_DIR="build/dist/$APP_NAME.app"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"
mkdir -p "$APP_DIR/Contents/Java"

# Copy JAR
cp build/libs/particle-life-app-x86.jar "$APP_DIR/Contents/Java/"

# Extract and copy resources
cd "$APP_DIR/Contents/Resources"
jar xf ../Java/particle-life-app-x86.jar .internal
cd - > /dev/null

# Create launcher script
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'EOF'
#!/bin/bash

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_ROOT="$DIR/.."
JAR_PATH="$APP_ROOT/Java/particle-life-app-x86.jar"

# Change to Resources directory so .internal path works
cd "$APP_ROOT/Resources"

# Determine architecture and Java path
if [[ $(uname -m) == "arm64" ]]; then
    # On Apple Silicon, use x86_64 Java for compatibility
    JAVA_CMD="/usr/local/opt/openjdk@17/bin/java"
    if [ -f "$JAVA_CMD" ]; then
        exec arch -x86_64 "$JAVA_CMD" -XstartOnFirstThread -jar "$JAR_PATH" "$@"
    fi
fi

# Fall back to system Java
exec java -XstartOnFirstThread -jar "$JAR_PATH" "$@"
EOF

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.particle.life.app</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>favicon.png</string>
</dict>
</plist>
EOF

# Copy icon if exists
if [ -f "$APP_DIR/Contents/Resources/.internal/favicon.png" ]; then
    cp "$APP_DIR/Contents/Resources/.internal/favicon.png" "$APP_DIR/Contents/Resources/"
fi

echo ""
echo "✅ App created at: $APP_DIR"
echo ""
echo "You can now:"
echo "1. Run it: open '$APP_DIR'"
echo "2. Install it: cp -r '$APP_DIR' /Applications/"