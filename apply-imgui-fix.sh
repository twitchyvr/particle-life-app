#!/bin/bash

echo "Applying ImGui key mapping fix..."

cd ~/Documents/particle-life-app

# Backup the original file
cp src/main/java/com/particle_life/app/ImGuiLayer.java src/main/java/com/particle_life/app/ImGuiLayer.java.backup

# Create a sed script to fix the key mapping initialization
cat > fix_keymap.sed << 'EOF'
/ImGui\.createContext()/a\
\
        // Fix key mapping issue for ImGui 1.89.0\
        ImGuiIO io = ImGui.getIO();\
        int[] keyMap = new int[ImGuiKey.COUNT];\
        for (int i = 0; i < ImGuiKey.COUNT; i++) {\
            keyMap[i] = -1;\
        }\
        io.setKeyMap(keyMap);
EOF

# Apply the fix
sed -i.bak -f fix_keymap.sed src/main/java/com/particle_life/app/ImGuiLayer.java

echo "Fix applied. Rebuilding..."

# Rebuild with the fix
./gradlew clean shadowJar

echo ""
echo "Testing the fixed version..."
java -XstartOnFirstThread -jar build/libs/particle-life-app-1.0-all.jar