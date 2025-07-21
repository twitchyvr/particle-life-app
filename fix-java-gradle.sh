#!/bin/bash

echo "Fixing Java version for Gradle..."

# Set Java 17 explicitly
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

echo "Using Java:"
java -version

# Kill any existing Gradle daemons that might be using the wrong Java version
echo ""
echo "Stopping Gradle daemons..."
./gradlew --stop

# Clear Gradle cache for this build script
echo ""
echo "Clearing Gradle script cache..."
rm -rf ~/.gradle/caches/7.6.4/scripts/

# Now try the build again
echo ""
echo "Building with Java 17..."
./gradlew clean fatJar