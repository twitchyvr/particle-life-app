#!/bin/bash

echo "Applying simple keymap fix..."

cd ~/Documents/particle-life-app

# Restore original if exists
if [ -f src/main/java/com/particle_life/app/ImGuiLayer.java.backup ]; then
    cp src/main/java/com/particle_life/app/ImGuiLayer.java.backup src/main/java/com/particle_life/app/ImGuiLayer.java
fi

# Comment out the keymap lines that might be causing issues
sed -i.bak2 '53,81s/^/\/\/ /' src/main/java/com/particle_life/app/ImGuiLayer.java

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Rebuild
echo "Rebuilding..."
./gradlew clean shadowJar

echo ""
echo "Testing..."
java -XstartOnFirstThread -jar build/libs/particle-life-app-1.0-all.jar