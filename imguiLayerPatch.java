// This patch fixes the ImGui key mapping initialization issue
// Add this to ImGuiLayer.java in the initImGui() method after ImGui.createContext()

private void fixKeyMapping() {
    ImGuiIO io = ImGui.getIO();
    
    // Clear any existing key mappings first
    final int[] keyMap = new int[ImGuiKey.COUNT];
    for (int i = 0; i < ImGuiKey.COUNT; i++) {
        keyMap[i] = -1;
    }
    
    // Set up the key mappings properly
    keyMap[ImGuiKey.Tab] = GLFW.GLFW_KEY_TAB;
    keyMap[ImGuiKey.LeftArrow] = GLFW.GLFW_KEY_LEFT;
    keyMap[ImGuiKey.RightArrow] = GLFW.GLFW_KEY_RIGHT;
    keyMap[ImGuiKey.UpArrow] = GLFW.GLFW_KEY_UP;
    keyMap[ImGuiKey.DownArrow] = GLFW.GLFW_KEY_DOWN;
    keyMap[ImGuiKey.PageUp] = GLFW.GLFW_KEY_PAGE_UP;
    keyMap[ImGuiKey.PageDown] = GLFW.GLFW_KEY_PAGE_DOWN;
    keyMap[ImGuiKey.Home] = GLFW.GLFW_KEY_HOME;
    keyMap[ImGuiKey.End] = GLFW.GLFW_KEY_END;
    keyMap[ImGuiKey.Insert] = GLFW.GLFW_KEY_INSERT;
    keyMap[ImGuiKey.Delete] = GLFW.GLFW_KEY_DELETE;
    keyMap[ImGuiKey.Backspace] = GLFW.GLFW_KEY_BACKSPACE;
    keyMap[ImGuiKey.Space] = GLFW.GLFW_KEY_SPACE;
    keyMap[ImGuiKey.Enter] = GLFW.GLFW_KEY_ENTER;
    keyMap[ImGuiKey.Escape] = GLFW.GLFW_KEY_ESCAPE;
    keyMap[ImGuiKey.A] = GLFW.GLFW_KEY_A;
    keyMap[ImGuiKey.C] = GLFW.GLFW_KEY_C;
    keyMap[ImGuiKey.V] = GLFW.GLFW_KEY_V;
    keyMap[ImGuiKey.X] = GLFW.GLFW_KEY_X;
    keyMap[ImGuiKey.Y] = GLFW.GLFW_KEY_Y;
    keyMap[ImGuiKey.Z] = GLFW.GLFW_KEY_Z;
    
    io.setKeyMap(keyMap);
}