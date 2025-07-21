#!/bin/bash

echo "Examining the clipRect issue in ImGuiImplGl3.java..."

# First, let's see what's happening around line 195
echo "=== Context around line 195 ==="
sed -n '190,200p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Let's check the method signature
echo -e "\n=== Looking for getCmdListCmdBufferClipRect usage ==="
grep -n "getCmdListCmdBufferClipRect" src/main/java/imgui/gl3/ImGuiImplGl3.java

# Let's see the clipRect declaration
echo -e "\n=== Looking for clipRect declaration ==="
grep -B5 -A5 "clipRect" src/main/java/imgui/gl3/ImGuiImplGl3.java | head -20

# Create a fix for the clipRect issue
cat > fix-cliprect.patch << 'EOF'
--- a/src/main/java/imgui/gl3/ImGuiImplGl3.java
+++ b/src/main/java/imgui/gl3/ImGuiImplGl3.java
@@ -192,7 +192,8 @@
             for (int cmdBufferIdx = 0; cmdBufferIdx < cmdBufferSize; cmdBufferIdx++) {
                 // Retrieve callback (it is stored inside ImDrawCmd as UserCallbackData)
                 int callback = drawData.getCmdListCmdBufferUserCallback(cmdListIdx, cmdBufferIdx);
-                drawData.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);
+                // For ImGui 1.89.0, we need to pass the indices first, then the output object
+                drawData.getCmdListCmdBufferClipRect(cmdListIdx, cmdBufferIdx, clipRect);
 
                 if (callback != NULL) {
                     callUserCallback(drawData, cmdListIdx, cmdBufferIdx);
EOF

echo -e "\n=== Applying clipRect fix ==="
patch -p1 < fix-cliprect.patch

echo -e "\n=== Rebuilding after clipRect fix ==="
./gradlew clean build

echo -e "\n=== Testing the build ==="
if [ -f "build/libs/particle-life-app-1.0-all.jar" ]; then
    echo "Build successful! JAR file created."
    # Try running it briefly to see if it starts
    timeout 5s java -jar build/libs/particle-life-app-1.0-all.jar || true
else
    echo "Build failed - JAR file not created"
fi