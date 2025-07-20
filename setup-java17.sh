#!/bin/bash

echo "Setting up Java 17..."

# Link OpenJDK 17 if not already linked
if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    echo "Found OpenJDK 17 at /opt/homebrew/opt/openjdk@17"
    
    # Check if it's in the system Java versions
    if ! /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
        echo "Linking OpenJDK 17 to system Java versions..."
        sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
    fi
elif [ -d "/usr/local/opt/openjdk@17" ]; then
    echo "Found OpenJDK 17 at /usr/local/opt/openjdk@17"
    
    # Check if it's in the system Java versions
    if ! /usr/libexec/java_home -V 2>&1 | grep -q "17"; then
        echo "Linking OpenJDK 17 to system Java versions..."
        sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
    fi
fi

echo ""
echo "Available Java versions:"
/usr/libexec/java_home -V