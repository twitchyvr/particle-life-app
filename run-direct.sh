#!/bin/bash

echo "Running Particle Life directly with Gradle..."

# Use Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Run using Gradle's run task
echo "Attempting to run with Gradle..."
./gradlew run -PmainClassName=com.particle_life.app.Main