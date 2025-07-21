#!/bin/bash

echo "Checking JitPack for particle-life versions..."
curl -s "https://jitpack.io/api/builds/com.github.tom-mohr/particle-life" | python3 -m json.tool