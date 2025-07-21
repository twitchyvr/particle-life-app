#!/bin/bash

echo "Building particle-life library locally..."

# Clone the particle-life library
cd /tmp
rm -rf particle-life
git clone https://github.com/tom-mohr/particle-life.git
cd particle-life

# Check out the v0.5.0 tag
git checkout v0.5.0

# Build and install to local Maven repository
./gradlew publishToMavenLocal

echo ""
echo "Checking if the library was installed:"
ls -la ~/.m2/repository/com/github/tom-mohr/particle-life/