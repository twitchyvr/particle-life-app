#!/bin/bash

echo "Creating macOS app with Rosetta support..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Ensure JAR exists
if [ ! -f "build/libs/particle-life-app-all-all.jar" ]; then
    echo "Building JAR first..."
    ./gradlew clean shadowJar
fi

# Create app structure
APP_NAME="ParticleLife"
APP_DIR="build/dist/$APP_NAME.app"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy JAR
cp build/libs/particle-life-app-all-all.jar "$APP_DIR/Contents/Resources/"

# Create launcher script
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'EOF'
#!/bin/bash

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
JAR_PATH="$DIR/../Resources/particle-life-app-all-all.jar"

# Check if we're on Apple Silicon
if [[ $(uname -m) == "arm64" ]]; then
    # Try x86_64 Java first (for ImGui compatibility)
    if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
        JAVA_HOME=$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
        exec /usr/bin/arch -x86_64 "$JAVA_HOME/bin/java" -XstartOnFirstThread -jar "$JAR_PATH"
    fi
fi

# Fall back to system Java
exec java -XstartOnFirstThread -jar "$JAR_PATH"
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
    <key>LSArchitecturePriority</key>
    <array>
        <string>x86_64</string>
        <string>arm64</string>
    </array>
</dict>
</plist>
EOF

# Create a simple icon
mkdir -p "$APP_DIR/Contents/Resources"
# This creates a simple colored square as icon placeholder
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00 \x00\x00\x00 \x08\x06\x00\x00\x00szz\xf4\x00\x00\x00\x19tEXtSoftware\x00Adobe ImageReadyq\xc9e<\x00\x00\x00.IDATx\xda\xec\xc1\x01\x01\x00\x00\x00\x82 \xff\xaf\xeenH@\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00IEND\xaeB`\x82' > "$APP_DIR/Contents/Resources/icon.png"

echo ""
echo "✅ App created at: $APP_DIR"
echo ""
echo "You can:"
echo "1. Run it directly: open '$APP_DIR'"
echo "2. Copy to Applications: cp -r '$APP_DIR' /Applications/"
echo ""
echo "Note: The app will try to use x86_64 Java for ImGui compatibility."

# Open the folder
open build/dist/