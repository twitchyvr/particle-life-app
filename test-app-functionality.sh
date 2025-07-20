#!/bin/bash

echo "Checking application logs for any errors..."

# Check if there are any error logs
if [ -f "/tmp/particle-life.log" ]; then
    echo "Log file contents:"
    cat /tmp/particle-life.log
fi

# Check OpenGL support
echo ""
echo "Checking OpenGL support:"
arch -x86_64 /usr/local/opt/openjdk@17/bin/java -XstartOnFirstThread -Dorg.lwjgl.opengl.Display.enableHighDPI=true -cp build/libs/particle-life-app-x86.jar -Dorg.lwjgl.util.Debug=true org.lwjgl.opengl.GL