#!/bin/bash

echo "Fixing Gradle wrapper version..."

# First, let's check the current Gradle version
echo "Current Gradle wrapper version:"
./gradlew --version 2>/dev/null || echo "Failed to get version"

# Update to Gradle 7.6.4 which is compatible with Java 17 and the project structure
echo ""
echo "Updating to Gradle 7.6.4..."

# Create gradle wrapper properties with the correct version
mkdir -p gradle/wrapper

cat > gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.4-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

echo "Gradle wrapper properties updated."

# Now let's download the wrapper jar if it doesn't exist
if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
    echo "Downloading gradle-wrapper.jar..."
    curl -L https://github.com/gradle/gradle/raw/v7.6.4/gradle/wrapper/gradle-wrapper.jar -o gradle/wrapper/gradle-wrapper.jar
fi

# Make gradlew executable
chmod +x gradlew

echo ""
echo "Gradle wrapper fixed. Now trying to build..."