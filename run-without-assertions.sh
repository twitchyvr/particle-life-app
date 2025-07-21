#!/bin/bash

echo "Running Particle Life with assertions disabled..."

cd ~/Documents/particle-life-app

# Run with assertions disabled
java -XstartOnFirstThread \
     -da \
     -Dimgui.assertion.enabled=false \
     -jar build/libs/particle-life-app-1.0-all.jar