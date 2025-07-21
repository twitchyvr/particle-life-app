#!/bin/bash

echo "Looking for the created JAR file..."
find build -name "*.jar" -type f 2>/dev/null

echo ""
echo "Checking shadowJar output location..."
./gradlew shadowJar --info | grep -E "(archiveFile|Created|Writing)"