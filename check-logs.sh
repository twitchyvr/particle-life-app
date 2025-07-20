#!/bin/bash

echo "Checking crash logs for ParticleLife..."
echo "Opening Console app - look for ParticleLife entries..."

# Open Console app
open /System/Applications/Utilities/Console.app

echo ""
echo "Also checking for crash reports..."
ls -la ~/Library/Logs/DiagnosticReports/ | grep -i particle | tail -10

echo ""
echo "You can also try running the app from terminal to see errors:"
echo "build/dist/ParticleLife.app/Contents/MacOS/ParticleLife"