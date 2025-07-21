#!/bin/bash

echo "Complete fix and build script..."

# Set Java 17 for all operations
JAVA_HOME_PATH=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export JAVA_HOME="$JAVA_HOME_PATH"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using Java:"
java -version

# Stop any existing Gradle daemons
./gradlew --stop

# Clear Gradle cache
rm -rf ~/.gradle/caches/7.6.4/scripts/

# Since patching might be complex, let's try the Rosetta approach first
echo ""
echo "Setting up for Rosetta build..."

# Create a wrapper script that will run with Rosetta
cat > run-particle-life.sh << 'EOF'
#!/bin/bash
# Run Particle Life with Rosetta 2 (x86_64 emulation)

# Check if running on Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    echo "Not running on Apple Silicon, using native execution..."
    java -XstartOnFirstThread -jar build/libs/particle-life-app-all-all.jar
    exit 0
fi

# Try to find x86_64 Java
if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
    JAVA_HOME_X86=$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
    echo "Found x86_64 Java 17 at: $JAVA_HOME_X86"
    /usr/bin/arch -x86_64 "$JAVA_HOME_X86/bin/java" -XstartOnFirstThread -jar build/libs/particle-life-app-all-all.jar
else
    echo "x86_64 Java 17 not found. Installing..."
    echo "Run: arch -x86_64 brew install openjdk@17"
    echo "Then try again."
    exit 1
fi
EOF

chmod +x run-particle-life.sh

# Now build with ARM64 Java
echo ""
echo "Building JAR with ARM64 Java..."
./gradlew clean shadowJar

if [ -f "build/libs/particle-life-app-all-all.jar" ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "To run the application:"
    echo "1. For Rosetta (x86_64 emulation): ./run-particle-life.sh"
    echo "2. To try native (may fail): java -XstartOnFirstThread -jar build/libs/particle-life-app-all-all.jar"
else
    echo "❌ Build failed"
fi