#!/bin/bash

# Script to run Particle Life App on MacBook Pro M1
# This sets the correct Java version and runs the application

echo "Setting Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Java version:"
java -version

echo "Starting Particle Life App with macOS optimizations..."
echo "If you see an error dialog:"
echo "- Try clicking outside the dialog and then clicking Exit"
echo "- Or press Cmd+Q to quit"
echo "- Check the console output below for detailed errors"
echo ""

./gradlew run