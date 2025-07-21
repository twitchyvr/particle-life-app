#!/bin/bash

echo "Examining ImDrawData methods to understand the API..."

# Let's check what methods are available in ImDrawData
echo "=== Searching for getCmdListCmdBuffer methods in the codebase ==="
find . -name "*.java" -type f -exec grep -l "getCmdListCmdBuffer" {} \; 2>/dev/null

# Let's look at the actual line causing the issue
echo -e "\n=== The problematic line ==="
sed -n '195p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Let's see what the ImGui 1.89.0 API expects
echo -e "\n=== Checking ImDrawData class for available methods ==="
if [ -f "build/classes/java/main/imgui/ImDrawData.class" ]; then
    javap -cp build/classes/java/main imgui.ImDrawData | grep getCmdListCmdBuffer || echo "Class not compiled yet"
fi

# Let's check the imgui-java documentation or source
echo -e "\n=== Looking for ImDrawData in dependencies ==="
find ~/.gradle/caches -name "imgui-java-*.jar" -type f 2>/dev/null | head -5

# Now let's fix the issue directly by modifying the file
echo -e "\n=== Fixing the ImGuiImplGl3.java file directly ==="
cp src/main/java/imgui/gl3/ImGuiImplGl3.java src/main/java/imgui/gl3/ImGuiImplGl3.java.backup

# Fix the parameter order issue
sed -i '' 's/drawData\.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);/drawData.getCmdListCmdBufferClipRect(cmdListIdx, cmdBufferIdx, clipRect);/' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo -e "\n=== Verifying the fix ==="
sed -n '195p' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo -e "\n=== Rebuilding ==="
./gradlew clean build

if [ $? -ne 0 ]; then
    echo -e "\n=== Build still failing, let's check available methods ==="
    # Extract method signatures from error or docs
    echo "Checking gradle dependencies for imgui-java version..."
    ./gradlew dependencies | grep imgui || true
    
    echo -e "\n=== Let's try a different approach ==="
    # Restore backup
    cp src/main/java/imgui/gl3/ImGuiImplGl3.java.backup src/main/java/imgui/gl3/ImGuiImplGl3.java
    
    # Let's check if we need to use a different method entirely
    echo "Creating a comprehensive fix based on ImGui 1.89.0 API changes..."
    
    # Create a new version of the render method that's compatible with 1.89.0
    cat > imgui-render-fix.java << 'EOF'
// Replace line 195 with the correct API call for ImGui 1.89.0
// The method signature has changed - it now returns the clipRect values directly
ImVec4 clipRectValues = drawData.getCmdListCmdBufferClipRect(cmdListIdx, cmdBufferIdx);
clipRect.set(clipRectValues);
EOF
    
    # Apply this fix
    sed -i '' '195s/.*/                ImVec4 clipRectValues = drawData.getCmdListCmdBufferClipRect(cmdListIdx, cmdBufferIdx);\
                clipRect.set(clipRectValues);/' src/main/java/imgui/gl3/ImGuiImplGl3.java
    
    echo -e "\n=== Updated line ==="
    sed -n '195,196p' src/main/java/imgui/gl3/ImGuiImplGl3.java
    
    echo -e "\n=== Rebuilding with new fix ==="
    ./gradlew build
fi