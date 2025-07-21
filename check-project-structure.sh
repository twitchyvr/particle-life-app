#!/bin/bash

echo "Checking project structure..."
echo ""
echo "Source files:"
find src -name "*.java" -type f | head -20

echo ""
echo "Current build.gradle content:"
cat build.gradle