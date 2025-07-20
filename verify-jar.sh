#!/bin/bash

echo "Verifying JAR contents..."

# Check if the JAR exists
if [ -f "build/libs/particle-life-app-all.jar" ]; then
    echo "JAR file found!"
    
    # List the main class
    echo ""
    echo "Checking for Main class:"
    jar tf build/libs/particle-life-app-all.jar | grep -E "(Main\.class|particle.*Main)"
    
    # Check for LWJGL natives
    echo ""
    echo "Checking for LWJGL native libraries:"
    jar tf build/libs/particle-life-app-all.jar | grep -E "\.dylib|\.jnilib" | head -10
    
    # Extract and check the manifest
    echo ""
    echo "Manifest contents:"
    unzip -p build/libs/particle-life-app-all.jar META-INF/MANIFEST.MF
    
    # Try running with more verbose output
    echo ""
    echo "Running with verbose output..."
    cd build/libs
    java -XstartOnFirstThread -verbose:class -jar particle-life-app-all.jar 2>&1 | head -50
else
    echo "JAR file not found!"
fi