#!/bin/bash

echo "Checking build output..."

echo "Contents of build/libs:"
ls -la build/libs/

echo ""
echo "Looking for any JAR files in build directory:"
find build -name "*.jar" -type f

echo ""
echo "Checking shadowJar task output:"
./gradlew shadowJar --info | grep -A5 -B5 "archiveFile"