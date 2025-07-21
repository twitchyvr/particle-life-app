#!/bin/bash

echo "Creating font loading fix..."

# First, let's see what the code is trying to do
LINE_NUM=$(grep -n "addFontFromFileTTF" src/main/java/com/particle_life/app/ImGuiLayer.java | cut -d: -f1)

if [ -n "$LINE_NUM" ]; then
    echo "Font loading found at line $LINE_NUM"
    
    # Create a patch to use a resource from classpath
    cat > fix-font-loading.patch << 'EOF'
--- a/src/main/java/com/particle_life/app/ImGuiLayer.java
+++ b/src/main/java/com/particle_life/app/ImGuiLayer.java
@@ -181,7 +181,16 @@
         ImGuiIO io = ImGui.getIO();
         ImFontConfig config = new ImFontConfig();
         config.setPixelSnapH(true);
-        io.getFonts().addFontFromFileTTF("assets/fonts/Roboto-Regular.ttf", 16, config);
+        
+        // Try to load font from resources
+        try {
+            java.io.InputStream fontStream = getClass().getResourceAsStream("/fonts/Roboto-Regular.ttf");
+            if (fontStream != null) {
+                byte[] fontData = fontStream.readAllBytes();
+                io.getFonts().addFontFromMemoryTTF(fontData, 16, config);
+                fontStream.close();
+            }
+        } catch (Exception e) {
+            // Fall back to default font
+        }
         config.destroy();
 
         // Setup ImGui style
EOF

    echo "To apply the patch:"
    echo "patch -p1 < fix-font-loading.patch"
else
    echo "Could not find font loading code"
fi