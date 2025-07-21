#!/bin/bash

echo "Restoring original files and fixing properly..."

cd ~/Documents/particle-life-app

# Restore the original ImGuiLayer.java
if [ -f src/main/java/com/particle_life/app/ImGuiLayer.java.backup ]; then
    cp src/main/java/com/particle_life/app/ImGuiLayer.java.backup src/main/java/com/particle_life/app/ImGuiLayer.java
fi

# Clear Gradle cache
echo "Clearing Gradle cache..."
rm -rf ~/.gradle/caches/7.6.4/scripts/

# Set Java 17 explicitly
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

echo "Java version:"
java -version