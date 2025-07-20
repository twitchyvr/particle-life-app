#!/bin/bash

echo "Fixing JAR naming issue..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Find the actual JAR name
JAR_FILE=$(find build/libs -name "*.jar" -type f | head -1)

if [ -z "$JAR_FILE" ]; then
    echo "No JAR found! Building again..."
    ./gradlew clean shadowJar
    JAR_FILE=$(find build/libs -name "*.jar" -type f | head -1)
fi

if [ -n "$JAR_FILE" ]; then
    echo "Found JAR: $JAR_FILE"
    JAR_NAME=$(basename "$JAR_FILE")
    
    # Update the run script
    cat > run-particle-life.sh << EOF
#!/bin/bash
# Run Particle Life with Rosetta 2 (x86_64 emulation)

JAR_NAME="$JAR_NAME"

# Check if running on Apple Silicon
if [[ \$(uname -m) != "arm64" ]]; then
    echo "Not running on Apple Silicon, using native execution..."
    java -XstartOnFirstThread -jar build/libs/\$JAR_NAME
    exit 0
fi

# Try to find x86_64 Java
if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
    JAVA_HOME_X86=\$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
    echo "Found x86_64 Java 17 at: \$JAVA_HOME_X86"
    echo "Running with Rosetta 2..."
    /usr/bin/arch -x86_64 "\$JAVA_HOME_X86/bin/java" -XstartOnFirstThread -jar build/libs/\$JAR_NAME
else
    echo "x86_64 Java 17 not found. Trying native ARM64..."
    java -XstartOnFirstThread -jar build/libs/\$JAR_NAME
fi
EOF

    chmod +x run-particle-life.sh
    
    # Update the macOS app creator
    cat > create-macos-app-fixed.sh << EOF
#!/bin/bash

echo "Creating macOS app with correct JAR..."

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="\$JAVA_HOME/bin:\$PATH"

JAR_NAME="$JAR_NAME"
JAR_PATH="build/libs/\$JAR_NAME"

if [ ! -f "\$JAR_PATH" ]; then
    echo "JAR not found at: \$JAR_PATH"
    exit 1
fi

# Create app structure
APP_NAME="ParticleLife"
APP_DIR="build/dist/\$APP_NAME.app"
rm -rf "\$APP_DIR"
mkdir -p "\$APP_DIR/Contents/MacOS"
mkdir -p "\$APP_DIR/Contents/Resources"

# Copy JAR
cp "\$JAR_PATH" "\$APP_DIR/Contents/Resources/"

# Create launcher script
cat > "\$APP_DIR/Contents/MacOS/\$APP_NAME" << 'LAUNCHER'
#!/bin/bash

# Get the directory of this script
DIR="\\\$( cd "\\\$( dirname "\\\${BASH_SOURCE[0]}" )" && pwd )"
JAR_PATH="\\\$DIR/../Resources/$JAR_NAME"

# Check if we're on Apple Silicon
if [[ \\\$(uname -m) == "arm64" ]]; then
    # Try x86_64 Java first (for ImGui compatibility)
    if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
        JAVA_HOME=\\\$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
        exec /usr/bin/arch -x86_64 "\\\$JAVA_HOME/bin/java" -XstartOnFirstThread -jar "\\\$JAR_PATH"
    fi
fi

# Fall back to system Java
exec java -XstartOnFirstThread -jar "\\\$JAR_PATH"
LAUNCHER

chmod +x "\$APP_DIR/Contents/MacOS/\$APP_NAME"

# Create Info.plist
cat > "\$APP_DIR/Contents/Info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>\$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.particle.life.app</string>
    <key>CFBundleName</key>
    <string>\$APP_NAME</string>
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
echo "✅ App created at: \$APP_DIR"
echo ""
echo "Testing the app..."
open "\$APP_DIR"
EOF

    chmod +x create-macos-app-fixed.sh
    
    echo ""
    echo "✅ Scripts updated with correct JAR name: $JAR_NAME"
    echo ""
    echo "Now you can:"
    echo "1. Test with Rosetta: ./run-particle-life.sh"
    echo "2. Create macOS app: ./create-macos-app-fixed.sh"
else
    echo "❌ No JAR file found!"
fi