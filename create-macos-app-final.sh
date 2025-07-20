#!/bin/bash

echo "Creating final macOS app..."

JAR_NAME="particle-life-app-all.jar"
JAR_PATH="build/libs/$JAR_NAME"

if [ ! -f "$JAR_PATH" ]; then
    echo "JAR not found at: $JAR_PATH"
    exit 1
fi

# Create app structure
APP_NAME="ParticleLife"
APP_DIR="build/dist/$APP_NAME.app"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy JAR
cp "$JAR_PATH" "$APP_DIR/Contents/Resources/"

# Create launcher script
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'EOF'
#!/bin/bash

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
JAR_PATH="$DIR/../Resources/particle-life-app-all.jar"

# Log file for debugging
LOG_FILE="/tmp/particle-life.log"
echo "Starting ParticleLife at $(date)" > "$LOG_FILE"

# Check architecture
ARCH=$(uname -m)
echo "Architecture: $ARCH" >> "$LOG_FILE"

if [[ $ARCH == "arm64" ]]; then
    # On Apple Silicon, try x86_64 Java for ImGui
    X86_JAVA="/usr/local/opt/openjdk@17/bin/java"
    
    if [ -f "$X86_JAVA" ]; then
        echo "Found x86_64 Java at: $X86_JAVA" >> "$LOG_FILE"
        exec arch -x86_64 "$X86_JAVA" -XstartOnFirstThread -jar "$JAR_PATH" 2>> "$LOG_FILE"
    else
        echo "x86_64 Java not found, using system Java" >> "$LOG_FILE"
    fi
fi

# Fall back to system Java
exec java -XstartOnFirstThread -jar "$JAR_PATH" 2>> "$LOG_FILE"
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
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
</dict>
</plist>
EOF

echo ""
echo "✅ App created at: $APP_DIR"
echo ""
echo "The app will log to: /tmp/particle-life.log"
echo ""
echo "You can:"
echo "1. Test it: open '$APP_DIR'"
echo "2. Check logs if it fails: cat /tmp/particle-life.log"
echo "3. Copy to Applications: cp -r '$APP_DIR' /Applications/"