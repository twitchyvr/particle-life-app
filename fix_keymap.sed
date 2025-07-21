/ImGui\.createContext()/a\
\
        // Fix key mapping issue for ImGui 1.89.0\
        ImGuiIO io = ImGui.getIO();\
        int[] keyMap = new int[ImGuiKey.COUNT];\
        for (int i = 0; i < ImGuiKey.COUNT; i++) {\
            keyMap[i] = -1;\
        }\
        io.setKeyMap(keyMap);
