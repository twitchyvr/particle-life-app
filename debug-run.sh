#!/bin/bash

# Debug script for Particle Life App on macOS
echo "Setting Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Stopping any existing Gradle daemons..."
./gradlew --stop

echo "Java version:"
java -version

echo "Starting app with OpenGL debug..."
export LWJGL_DEBUG=true
./gradlew run 2>&1 | tee debug.log