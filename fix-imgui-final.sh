#!/bin/bash

echo "=== Final ImGui Fix ==="

# First, let's fix the ImGuiImplGl3.java file properly
echo "1. Fixing ImGuiImplGl3.java line 195..."

# Let's see what's currently on line 195
echo "Current line 195:"
sed -n '195p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Fix the merged line issue
sed -i '' '195s/.*/                drawData.getCmdListCmdBufferClipRect(clipRect, cmdListIdx, cmdBufferIdx);/' src/main/java/imgui/gl3/ImGuiImplGl3.java

echo "Fixed line 195:"
sed -n '195p' src/main/java/imgui/gl3/ImGuiImplGl3.java

# Now let's fix the ImGuiLayer.java to make io final
echo -e "\n2. Fixing ImGuiLayer.java - making io final..."

# We need to find the right occurrence and make it final
# Line 301 already has final, but line 43 doesn't
sed -i '' '43s/ImGuiIO io = ImGui.getIO();/final ImGuiIO io = ImGui.getIO();/' src/main/java/com/particle_life/app/ImGuiLayer.java

echo "Checking both occurrences of io initialization:"
grep -n "ImGuiIO io = ImGui.getIO()" src/main/java/com/particle_life/app/ImGuiLayer.java

# Let's also check if there are any other io variables that need to be final
echo -e "\n3. Looking for all ImGuiIO declarations..."
grep -n "ImGuiIO" src/main/java/com/particle_life/app/ImGuiLayer.java | head -10

# Now rebuild
echo -e "\n=== Rebuilding ==="
./gradlew clean build

if [ $? -ne 0 ]; then
    echo -e "\n=== Build failed. Let's check the exact error ==="
    
    # Let's see if we need to handle the io variable differently
    echo "Checking the context around lambda expressions..."
    
    # Look at the structure of ImGuiLayer
    echo -e "\nClass structure:"
    grep -E "(class|private|public|protected).*ImGuiLayer" src/main/java/com/particle_life/app/ImGuiLayer.java
    
    # Check if io might be a class field
    echo -e "\nChecking for io as a field:"
    sed -n '1,50p' src/main/java/com/particle_life/app/ImGuiLayer.java | grep -E "(private|public|protected).*ImGuiIO"
    
    # If io is a field, we need a different approach
    echo -e "\n=== Alternative fix: using io as instance field ==="
    
    # Create a patch to make io an instance field if needed
    cat > imgui-field-fix.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/ImGuiLayer.java
+++ b/src/main/java/com/particle_life/app/ImGuiLayer.java
@@ -35,6 +35,7 @@ public class ImGuiLayer {
     private final long[] mouseCursors = new long[ImGuiMouseCursor.COUNT];
 
     private final ImGuiImplGl3 imGuiGl3 = new ImGuiImplGl3();
+    private ImGuiIO io;
 
     @SuppressWarnings("FieldCanBeLocal")
     private Graphics graphics;
@@ -40,7 +41,7 @@ public class ImGuiLayer {
     @SuppressWarnings("FieldCanBeLocal")
     private Graphics graphics;
 
-    public void init(Graphics graphics) {
+    public void init(Graphics graphics) {
         this.graphics = graphics;
 
         // Initialize ImGui
@@ -43,7 +44,7 @@ public class ImGuiLayer {
         ImGui.createContext();
 
-        ImGuiIO io = ImGui.getIO();
+        io = ImGui.getIO();
         io.setIniFilename(null); // We don't want to save .ini file
         io.setConfigFlags(ImGuiConfigFlags.NavEnableKeyboard);  // Enable Keyboard Controls
         io.setConfigFlags(io.getConfigFlags() | ImGuiConfigFlags.DockingEnable); // Enable Docking
EOF
    
    echo "Trying alternative approach..."
fi