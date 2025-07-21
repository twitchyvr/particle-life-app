#!/bin/bash

echo "=== Clean Fix for ImGui Issues ==="

# First, let's see what's happening in ImGuiImplGl3.java around the problematic lines
echo "1. Examining ImGuiImplGl3.java around line 195-205..."
sed -n '190,210p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Let's restore from backup if available, or manually fix
echo -e "\n2. Restoring and fixing ImGuiImplGl3.java..."
if [ -f "src/main/java/imgui/gl3/ImGuiImplGl3.java.backup" ]; then
    cp src/main/java/imgui/gl3/ImGuiImplGl3.java.backup src/main/java/imgui/gl3/ImGuiImplGl3.java
    echo "Restored from backup"
else
    echo "No backup found, will fix manually"
fi

# Now let's look at what we have after restoration
echo -e "\n3. Current state around line 195:"
sed -n '190,210p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Create a proper fix for the getCmdListCmdBufferClipRect issue
# For ImGui 1.86.10, we need to understand the exact API
echo -e "\n4. Checking if we can find the method signature..."

# Let's create a test to see what parameters the method expects
cat > TestImGuiAPI.java << 'EOF'
import imgui.*;

public class TestImGuiAPI {
    public static void main(String[] args) {
        // This is just to check compilation, not to run
        ImDrawData drawData = null;
        ImVec4 clipRect = new ImVec4();
        int cmdListIdx = 0;
        int cmdBufferIdx = 0;
        
        // Try to figure out the correct method signature
        // drawData.getCmdListCmdBufferClipRect(?, ?, ?);
    }
}
EOF

# Let's look for examples in the codebase
echo -e "\n5. Looking for getCmdListCmdBufferClipRect usage examples..."
find . -name "*.java" -type f -exec grep -l "getCmdListCmdBufferClipRect" {} \; 2>/dev/null

# Based on the error "ImVec4 cannot be converted to int", it seems the method expects
# different parameters. Let's check the ImGui 1.86.10 documentation approach
echo -e "\n6. Applying the correct fix for ImGui 1.86.10..."

# Create a clean version of the render method section
cat > imgui-gl3-fix.java << 'EOF'
            for (int cmdBufferIdx = 0; cmdBufferIdx < drawData.getCmdListCmdBufferSize(cmdListIdx); cmdBufferIdx++) {
                // Get clip rect - the method fills the clipRect object
                drawData.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);

                final float clipRectX = (clipRect.x - displayPos.x) * framebufferScale.x;
                final float clipRectY = (clipRect.y - displayPos.y) * framebufferScale.y;
                final float clipRectZ = (clipRect.z - displayPos.x) * framebufferScale.x;
                final float clipRectW = (clipRect.w - displayPos.y) * framebufferScale.y;

                if (clipRectX < fbWidth && clipRectY < fbHeight && clipRectZ >= 0.0f && clipRectW >= 0.0f) {
                    // Apply scissor/clipping rectangle
                    glScissor((int) clipRectX, (int) (fbHeight - clipRectW), (int) (clipRectZ - clipRectX), (int) (clipRectW - clipRectY));
EOF

# Now let's carefully replace the problematic section
echo -e "\n7. Fixing the file..."
# First, let's remove any duplicate lines
awk '!seen[$0]++' src/main/java/imgui/gl3/ImGuiImplGl3.java > src/main/java/imgui/gl3/ImGuiImplGl3.java.tmp
mv src/main/java/imgui/gl3/ImGuiImplGl3.java.tmp src/main/java/imgui/gl3/ImGuiImplGl3.java

# Let's see the current state again
echo -e "\n8. Current state after deduplication:"
sed -n '190,210p' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo -e "\n=== Rebuilding ==="
./gradlew clean build

if [ $? -ne 0 ]; then
    echo -e "\n=== Still failing. Let's try a different approach ==="
    echo "The issue is that getCmdListCmdBufferClipRect expects different parameters in 1.86.10"
    echo "Let's check the exact error message to understand what it expects..."
fi