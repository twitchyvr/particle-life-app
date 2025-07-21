#!/bin/bash

# OpenGL diagnostic script for macOS M1
echo "🔍 OpenGL Diagnostics for macOS M1"
echo "=================================="

echo "Java version:"
export JAVA_HOME=$(brew --prefix openjdk@17)
java -version

echo ""
echo "System info:"
system_profiler SPDisplaysDataType | grep -E "(Chipset Model|Metal Support)"

echo ""
echo "Checking OpenGL support..."
# Create a simple OpenGL test
cat > /tmp/opengl_test.java << 'EOF'
import org.lwjgl.opengl.GL;
import org.lwjgl.glfw.GLFW;
import static org.lwjgl.opengl.GL11.*;

public class opengl_test {
    public static void main(String[] args) {
        if (!GLFW.glfwInit()) {
            System.err.println("GLFW initialization failed");
            return;
        }
        
        GLFW.glfwWindowHint(GLFW.GLFW_VISIBLE, GLFW.GLFW_FALSE);
        long window = GLFW.glfwCreateWindow(1, 1, "test", 0, 0);
        
        if (window == 0) {
            System.err.println("Window creation failed");
            return;
        }
        
        GLFW.glfwMakeContextCurrent(window);
        GL.createCapabilities();
        
        System.out.println("OpenGL Vendor: " + glGetString(GL_VENDOR));
        System.out.println("OpenGL Renderer: " + glGetString(GL_RENDERER)); 
        System.out.println("OpenGL Version: " + glGetString(GL_VERSION));
        System.out.println("GLSL Version: " + glGetString(GL_SHADING_LANGUAGE_VERSION));
        
        GLFW.glfwDestroyWindow(window);
        GLFW.glfwTerminate();
    }
}
EOF

echo ""
echo "Starting app with maximum debug output..."
export LWJGL_DEBUG=true
export JAVA_OPTS="-Dorg.lwjgl.util.Debug=true -Dorg.lwjgl.util.DebugLoader=true"

timeout 15s ./gradlew run 2>&1 | tee diagnostic.log

echo ""
echo "Searching for specific errors..."
grep -i -A 5 -B 5 "shader\|opengl\|error\|exception\|failed" diagnostic.log | head -50