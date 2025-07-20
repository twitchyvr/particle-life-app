#!/bin/bash
# Run Particle Life with Rosetta 2 (x86_64 emulation)

JAR_NAME="particle-life-app-all.jar"

# Check if running on Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    echo "Not running on Apple Silicon, using native execution..."
    java -XstartOnFirstThread -jar build/libs/$JAR_NAME
    exit 0
fi

# Try to find x86_64 Java
if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
    JAVA_HOME_X86=$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
    echo "Found x86_64 Java 17 at: $JAVA_HOME_X86"
    echo "Running with Rosetta 2..."
    /usr/bin/arch -x86_64 "$JAVA_HOME_X86/bin/java" -XstartOnFirstThread -jar build/libs/$JAR_NAME
else
    echo "x86_64 Java 17 not found. Trying native ARM64..."
    java -XstartOnFirstThread -jar build/libs/$JAR_NAME
fi
