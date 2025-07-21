#!/bin/bash

echo "Installing x86_64 Java properly..."

# First, let's check what we actually have
echo "Current Homebrew architecture:"
brew config | grep "CPU"

# We need to install x86_64 Homebrew first if not present
if [ ! -d "/usr/local/bin/brew" ]; then
    echo "Installing x86_64 Homebrew..."
    TEMP_SCRIPT="/tmp/install_homebrew.sh"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$TEMP_SCRIPT"
    EXPECTED_CHECKSUM="INSERT_EXPECTED_CHECKSUM_HERE"
    ACTUAL_CHECKSUM=$(shasum -a 256 "$TEMP_SCRIPT" | awk '{print $1}')
    if [ "$ACTUAL_CHECKSUM" != "$EXPECTED_CHECKSUM" ]; then
        echo "Error: Checksum verification failed for the Homebrew installation script."
        echo "Expected: $EXPECTED_CHECKSUM"
        echo "Actual: $ACTUAL_CHECKSUM"
        rm -f "$TEMP_SCRIPT"
        exit 1
    fi
    arch -x86_64 /bin/bash "$TEMP_SCRIPT"
    rm -f "$TEMP_SCRIPT"
fi

# Now install x86_64 Java using x86_64 Homebrew
echo ""
echo "Installing x86_64 OpenJDK 17..."
arch -x86_64 /usr/local/bin/brew install openjdk@17

# Create symlinks for x86_64 Java
echo "WARNING: This script will create a system-wide symlink for x86_64 Java in /Library/Java/JavaVirtualMachines."
echo "This requires elevated privileges (sudo) and may overwrite any existing symlink or file at the target location."
# Validate the source path
if [ ! -e "/usr/local/opt/openjdk@17/libexec/openjdk.jdk" ]; then
    echo "Error: Source path '/usr/local/opt/openjdk@17/libexec/openjdk.jdk' does not exist."
    echo "Please ensure that x86_64 OpenJDK 17 is installed correctly."
    exit 1
fi

# Get user confirmation
read -p "Do you want to proceed? (yes/no): " confirm
if [[ "${confirm,,}" != "yes" ]]; then
    echo "Operation canceled by the user."
    exit 1
fi

# Create the symlink
sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17-x86_64.jdk

echo ""
echo "Verifying installations:"
echo "ARM64 Java:"
/opt/homebrew/bin/java -version 2>&1 | head -1

echo ""
echo "x86_64 Java:"
arch -x86_64 /usr/local/opt/openjdk@17/bin/java -version 2>&1 | head -1