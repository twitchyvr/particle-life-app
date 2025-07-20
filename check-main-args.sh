#!/bin/bash

echo "Checking Main.java for command-line arguments..."

# Look at the main method
echo "Main method content:"
grep -A 20 "public static void main" src/main/java/com/particle_life/app/Main.java

echo ""
echo "Checking for configuration options:"
grep -r "headless\|gui\|imgui" src/ --include="*.java" -i | grep -v "import"