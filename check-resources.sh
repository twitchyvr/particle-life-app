#!/bin/bash

echo "Checking for required resources..."

# Check for any config files
echo "Looking for config files..."
find . -name "*.properties" -o -name "*.yml" -o -name "*.yaml" -o -name "*.toml" 2>/dev/null | grep -v build | grep -v ".gradle"

# Check if there are any resource files in the JAR
echo ""
echo "Resources in JAR:"
jar tf build/libs/particle-life-app-all.jar | grep -E "\.(properties|yml|yaml|toml|png|jpg|gif)$" | head -20

# Check if the app creates any files
echo ""
echo "Running app and checking for created files..."
cd build/libs
BEFORE=$(ls -la)
timeout 5 java -XstartOnFirstThread -jar particle-life-app-all.jar || true
AFTER=$(ls -la)

if [ "$BEFORE" != "$AFTER" ]; then
    echo "New files created:"
    diff <(echo "$BEFORE") <(echo "$AFTER")
else
    echo "No new files created"
fi