#!/bin/bash

echo "Creating macOS app with correct JAR..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

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
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'LAUNCHER'
#!/bin/bash

# Get the directory of this script
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
JAR_PATH="\$DIR/../Resources/particle-life-app-all.jar"

# Check if we're on Apple Silicon
if [[ \$(uname -m) == "arm64" ]]; then
    # Try x86_64 Java first (for ImGui compatibility)
    if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
        JAVA_HOME=\$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
        exec /usr/bin/arch -x86_64 "\$JAVA_HOME/bin/java" -XstartOnFirstThread -jar "\$JAR_PATH"
    fi
fi

# Fall back to system Java
exec java -XstartOnFirstThread -jar "\$JAR_PATH"
LAUNCHER

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << PLIST
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
PLIST

echo ""
echo "✅ App created at: $APP_DIR"
echo ""
echo "Testing the app..."
open "$APP_DIR"
