#!/bin/bash

echo "Checking for x86_64 Java installations..."

# Check if x86_64 Java is available
if /usr/bin/arch -x86_64 /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
    echo "✅ x86_64 Java 17 is already installed"
    JAVA_HOME_X86=$(/usr/bin/arch -x86_64 /usr/libexec/java_home -v 17)
    echo "Location: $JAVA_HOME_X86"
else
    echo "❌ x86_64 Java 17 not found"
    echo ""
    echo "To install it, run:"
    echo "arch -x86_64 brew install openjdk@17"
fi

echo ""
echo "Current architecture: $(uname -m)"
echo "ARM64 Java location: $(/usr/libexec/java_home -v 17)"