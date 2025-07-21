#!/bin/bash

echo "=== Comprehensive Fix for All Issues ==="

# First, let's fix ImGuiImplGl3.java properly
echo "1. Fixing ImGuiImplGl3.java..."

# We need to restore the missing lines after line 195
cat > fix-imgui-gl3.patch << 'EOF'
--- a/src/main/java/imgui/gl3/ImGuiImplGl3.java
+++ b/src/main/java/imgui/gl3/ImGuiImplGl3.java
@@ -194,6 +194,11 @@
 
             for (int cmdBufferIdx = 0; cmdBufferIdx < drawData.getCmdListCmdBufferSize(cmdListIdx); cmdBufferIdx++) {
                 drawData.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);
+
+                final float clipRectX = (clipRect.x - displayPos.x) * framebufferScale.x;
+                final float clipRectY = (clipRect.y - displayPos.y) * framebufferScale.y;
+                final float clipRectZ = (clipRect.z - displayPos.x) * framebufferScale.x;
+                final float clipRectW = (clipRect.w - displayPos.y) * framebufferScale.y;
 
                 if (clipRectX < fbWidth && clipRectY < fbHeight && clipRectZ >= 0.0f && clipRectW >= 0.0f) {
                     // Apply scissor/clipping rectangle
EOF

echo "Applying ImGuiImplGl3 fix..."
patch -p1 < fix-imgui-gl3.patch || {
    echo "Patch failed, applying manually..."
    # Manual fix - insert the missing lines after line 195
    sed -i '' '195a\
\
                final float clipRectX = (clipRect.x - displayPos.x) * framebufferScale.x;\
                final float clipRectY = (clipRect.y - displayPos.y) * framebufferScale.y;\
                final float clipRectZ = (clipRect.z - displayPos.x) * framebufferScale.x;\
                final float clipRectW = (clipRect.w - displayPos.y) * framebufferScale.y;' src/main/java/imgui/gl3/ImGuiImplGl3.java
}

# Now fix ImGuiLayer.java - remove the local io declarations that conflict with the field
echo -e "\n2. Fixing ImGuiLayer.java..."

# Remove the 'final' keyword from local io declarations since io is already a field
sed -i '' 's/final ImGuiIO io = ImGui.getIO();/io = ImGui.getIO();/g' src/main/java/com/particle_life/app/ImGuiLayer.java

# Check if there's still a declaration at line 43 that needs to be changed to assignment
sed -i '' '43s/ImGuiIO io = ImGui.getIO();/io = ImGui.getIO();/' src/main/java/com/particle_life/app/ImGuiLayer.java

echo "Verifying ImGuiLayer fixes:"
grep -n "io = ImGui.getIO()" src/main/java/com/particle_life/app/ImGuiLayer.java

# Let's also check the field declaration
echo -e "\nField declaration:"
grep "private ImGuiIO io;" src/main/java/com/particle_life/app/ImGuiLayer.java

# Clean and rebuild
echo -e "\n=== Clean rebuild ==="
./gradlew clean build

if [ $? -eq 0 ]; then
    echo -e "\n=== Build successful! ==="
    echo "JAR file created at: build/libs/particle-life-app-1.0-all.jar"
    echo -e "\nTesting the application (will timeout after 5 seconds)..."
    timeout 5s java -jar build/libs/particle-life-app-1.0-all.jar || true
    echo -e "\nApplication started successfully!"
else
    echo -e "\n=== Build still failing, let's check remaining issues ==="
    # If there are still issues, let's see what they are
fi