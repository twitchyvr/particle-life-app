#!/bin/bash

echo "Creating a patch to disable ImGui..."

# Create a modified App.java that skips ImGui initialization
cat > App-no-imgui.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/App.java
+++ b/src/main/java/com/particle_life/app/App.java
@@ -55,7 +55,8 @@ public abstract class App {
         
         ImGuiLayer imGuiLayer = new ImGuiLayer(window);
-        imGuiLayer.initImGui();
+        // Skip ImGui initialization for ARM64 compatibility
+        // imGuiLayer.initImGui();
         setCallbacks(imGuiLayer);
         init();
         imGuiLayer.scaleGui(scale);
EOF

echo "To apply this patch:"
echo "1. cd to your project directory"
echo "2. patch -p1 < App-no-imgui.patch"
echo "3. Rebuild with ./gradlew clean shadowJar"