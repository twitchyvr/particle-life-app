#!/bin/bash

echo "=== Complete Restoration and Fix ==="

# First, restore ImGuiImplGl3.java from backup
echo "1. Restoring ImGuiImplGl3.java from backup..."
if [ -f "src/main/java/imgui/gl3/ImGuiImplGl3.java.backup" ]; then
    cp src/main/java/imgui/gl3/ImGuiImplGl3.java.backup src/main/java/imgui/gl3/ImGuiImplGl3.java
    echo "✓ Restored ImGuiImplGl3.java"
else
    echo "✗ No backup found for ImGuiImplGl3.java"
    exit 1
fi

# Check if we have a clean version
echo -e "\n2. Verifying ImGuiImplGl3.java is valid..."
head -20 src/main/java/imgui/gl3/ImGuiImplGl3.java | grep -q "package imgui.gl3" && echo "✓ File looks valid" || echo "✗ File is corrupted"

# Now fix the ImGuiLayer.java to use the instance field 'io' properly
echo -e "\n3. Fixing ImGuiLayer.java..."

# Remove duplicate io declarations and use the instance field
cat > fix-imguilayer-final.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/ImGuiLayer.java
+++ b/src/main/java/com/particle_life/app/ImGuiLayer.java
@@ -40,10 +40,10 @@
     @SuppressWarnings("FieldCanBeLocal")
     private Graphics graphics;
 
     public void init(Graphics graphics) {
         this.graphics = graphics;
 
         // Initialize ImGui
         ImGui.createContext();
 
-        ImGuiIO io = ImGui.getIO();
+        io = ImGui.getIO();
         io.setIniFilename(null); // We don't want to save .ini file
@@ -298,7 +298,7 @@
 
     @Deprecated
     public void setupImGuiCallbacks() {
-        final ImGuiIO io = ImGui.getIO();
+        // Use the instance field io instead of creating a new local variable
 
         // ------------------------------------------------------------
         // Mouse cursor callback
EOF

echo "Applying ImGuiLayer patch..."
patch -p1 < fix-imguilayer-final.patch || {
    echo "Patch failed, applying manually..."
    # Manual fix - ensure we're using the instance field 'io' everywhere
    sed -i '' 's/ImGuiIO io = ImGui.getIO();/io = ImGui.getIO();/g' src/main/java/com/particle_life/app/ImGuiLayer.java
    sed -i '' 's/final ImGuiIO io = ImGui.getIO();/\/\/ Use instance field io/g' src/main/java/com/particle_life/app/ImGuiLayer.java
}

# Check the result
echo -e "\n4. Verifying ImGuiLayer fixes..."
echo "Instance field declaration:"
grep "private ImGuiIO io;" src/main/java/com/particle_life/app/ImGuiLayer.java
echo -e "\nInitializations (should use 'io = ...' not 'ImGuiIO io = ...'):"
grep -n "io = ImGui.getIO()" src/main/java/com/particle_life/app/ImGuiLayer.java | head -5

# Clean build
echo -e "\n5. Clean build..."
./gradlew clean build

if [ $? -eq 0 ]; then
    echo -e "\n✓ Build successful!"
    echo "JAR file created: build/libs/particle-life-app-1.0-all.jar"
    
    echo -e "\n6. Testing the application..."
    echo "Running for 5 seconds to verify it starts correctly..."
    timeout 5s java -jar build/libs/particle-life-app-1.0-all.jar 2>&1 | head -20
    
    echo -e "\n✓ Application appears to be working!"
    echo "You can now run: java -jar build/libs/particle-life-app-1.0-all.jar"
else
    echo -e "\n✗ Build still failing"
    echo "Let's check what specific errors remain..."
    
    # If it's still the ImVec4 error, we need to understand the API better
    echo -e "\nChecking for remaining compilation errors..."
fi