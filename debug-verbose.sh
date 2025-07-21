#!/bin/bash

# Verbose debugging script for Particle Life App
echo "Setting Java 17 environment..."
export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Starting app with detailed logging..."
export LWJGL_DEBUG=true

# Capture all output including stderr
./gradlew run 2>&1 | tee full-debug.log &
APP_PID=$!

echo "App started with PID: $APP_PID"
echo "Waiting 10 seconds for initialization..."
sleep 10

echo "Checking for errors in log..."
grep -A 20 -B 5 "SHADER COMPILATION ERROR\|Failed to compile shader\|ERROR\|Exception" full-debug.log

echo "App is running. Check the GUI for any error dialogs."
echo "Press Ctrl+C to stop monitoring, or kill the app with: kill $APP_PID"