#!/bin/bash

echo "=== Comprehensive ImGui Fix ==="

# First, let's see what version we're actually using
echo "Current ImGui version in build.gradle:"
grep -E "imgui-java" build.gradle

# Let's look at the ImGuiLayer.java issues
echo -e "\n=== Examining ImGuiLayer.java issues ==="
echo "The issue is that 'io' needs to be final for use in lambdas"

# Create a comprehensive fix for ImGuiLayer.java
cat > fix-imguilayer.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/ImGuiLayer.java
+++ b/src/main/java/com/particle_life/app/ImGuiLayer.java
@@ -96,7 +96,7 @@
         });
 
         // ------------------------------------------------------------
-        ImGuiIO io = ImGui.getIO();
+        final ImGuiIO io = ImGui.getIO();
 
         io.setIniFilename(null); // We don't want to save .ini file
         io.setConfigFlags(ImGuiConfigFlags.NavEnableKeyboard); // Navigation with keyboard
EOF

echo -e "\n=== Applying ImGuiLayer fix ==="
patch -p1 < fix-imguilayer.patch

# Now let's also revert the ImGuiImplGl3 changes since we're on 1.86.10
echo -e "\n=== Reverting ImGuiImplGl3 to original (compatible with 1.86.10) ==="
if [ -f "src/main/java/imgui/gl3/ImGuiImplGl3.java.backup" ]; then
    cp src/main/java/imgui/gl3/ImGuiImplGl3.java.backup src/main/java/imgui/gl3/ImGuiImplGl3.java
    echo "Restored original ImGuiImplGl3.java"
else
    echo "No backup found, checking current state..."
    sed -n '195,196p' src/main/java/imgui/gl3/ImGuiImplGl3.java
fi

# Let's make sure we have the right version for 1.86.10
echo -e "\n=== Ensuring correct method call for ImGui 1.86.10 ==="
# For 1.86.10, the method signature should be getCmdListCmdBufferClipRect(output, listIdx, bufferIdx)
sed -i '' '195,196d' src/main/java/imgui/gl3/ImGuiImplGl3.java
sed -i '' '195i\
                drawData.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo -e "\n=== Verifying all fixes ==="
echo "1. ImGuiLayer.java - checking if io is final:"
grep -n "ImGuiIO io = ImGui.getIO()" src/main/java/com/particle_life/app/ImGuiLayer.java

echo -e "\n2. ImGuiImplGl3.java - checking line 195:"
sed -n '195p' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo -e "\n=== Clean rebuild ==="
./gradlew clean build

if [ $? -eq 0 ]; then
    echo -e "\n=== Build successful! ==="
    echo "Testing the application..."
    timeout 5s java -jar build/libs/particle-life-app-1.0-all.jar || true
else
    echo -e "\n=== Build failed, checking for additional issues ==="
    # If it still fails, let's check what other issues might exist
fi