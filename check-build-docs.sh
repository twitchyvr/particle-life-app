#!/bin/bash

echo "Checking for build documentation..."

# Look for README or build instructions
for file in README.md README.txt BUILD.md BUILDING.md BUILDING.txt; do
    if [ -f "$file" ]; then
        echo "=== $file ==="
        head -50 "$file"
        echo ""
    fi
done

# Check if there's a reference to the particle-life dependency
echo "=== Checking for particle-life references ==="
grep -r "particle-life" . --include="*.md" --include="*.txt" | grep -v ".git" | head -10