#!/bin/bash

echo "Applying proper ImGui 1.89.0 fix..."

cd ~/Documents/particle-life-app

# Create a properly fixed version of ImGuiLayer.java
cat > imgui-fix.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/ImGuiLayer.java
+++ b/src/main/java/com/particle_life/app/ImGuiLayer.java
@@ -50,7 +50,10 @@
 
         // ------------------------------------------------------------
         // Keyboard mapping. ImGui will use those indices to peek into the io.KeysDown[] array.
-        final int[] keyMap = new int[ImGuiKey.COUNT];
+        // For ImGui 1.89.0, we need to initialize all keys to -1 first
+        final int[] keyMap = io.getKeyMap();
+        for (int i = 0; i < keyMap.length; i++) { keyMap[i] = -1; }
+        
         keyMap[ImGuiKey.Tab] = GLFW_KEY_TAB;
         keyMap[ImGuiKey.LeftArrow] = GLFW_KEY_LEFT;
         keyMap[ImGuiKey.RightArrow] = GLFW_KEY_RIGHT;
EOF

# Apply the patch
patch -p1 < imgui-fix.patch

# Now rebuild
echo "Rebuilding with fix..."
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

./gradlew clean shadowJar

echo ""
echo "Testing fixed version..."
java -XstartOnFirstThread -jar build/libs/particle-life-app-1.0-all.jar