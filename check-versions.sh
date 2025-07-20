#!/bin/bash

echo "Checking Java version..."
java -version
echo ""

echo "Checking Gradle wrapper version..."
if [ -f "gradle/wrapper/gradle-wrapper.properties" ]; then
    grep "distributionUrl" gradle/wrapper/gradle-wrapper.properties
else
    echo "Gradle wrapper not found"
fi
echo ""

echo "Checking JAVA_HOME..."
echo "JAVA_HOME: $JAVA_HOME"
echo ""

echo "Available Java versions:"
/usr/libexec/java_home -V 2>&1