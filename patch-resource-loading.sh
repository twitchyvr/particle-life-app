#!/bin/bash

echo "Creating a patch to load resources from JAR..."

# Create a modified ImGuiLayer that loads from classpath
cat > ImGuiLayer-patch.java << 'EOF'
// Add this method to ImGuiLayer class after the initImGui method starts:

    private void loadFontFromResources(ImFontAtlas fontAtlas, String resourcePath, float size, ImFontConfig fontConfig) {
        try {
            // First try to load from file system (for development)
            File fontFile = new File(resourcePath);
            if (fontFile.exists()) {
                fontAtlas.addFontFromFileTTF(resourcePath, size, fontConfig);
                return;
            }
            
            // Try to load from classpath
            InputStream fontStream = getClass().getResourceAsStream("/" + resourcePath);
            if (fontStream == null) {
                // Try without leading slash
                fontStream = getClass().getResourceAsStream(resourcePath);
            }
            
            if (fontStream != null) {
                byte[] fontData = fontStream.readAllBytes();
                fontAtlas.addFontFromMemoryTTF(fontData, size, fontConfig);
                fontStream.close();
            } else {
                System.err.println("Could not find font: " + resourcePath);
                fontAtlas.addFontDefault();
            }
        } catch (Exception e) {
            System.err.println("Error loading font: " + e.getMessage());
            fontAtlas.addFontDefault();
        }
    }

// Then replace the line:
// fontAtlas.addFontFromFileTTF(".internal/Futura Heavy font.ttf", 16, fontConfig);
// with:
// loadFontFromResources(fontAtlas, ".internal/Futura Heavy font.ttf", 16, fontConfig);
EOF

echo ""
echo "For now, let's try a simpler approach - extract and run:"