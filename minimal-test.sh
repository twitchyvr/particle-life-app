#!/bin/bash

# Minimal test to isolate where the hang occurs
echo "🔍 MINIMAL HANG DETECTION TEST"
echo "============================="

export JAVA_HOME=$(brew --prefix openjdk@17)

echo "Testing each initialization phase..."

echo ""
echo "Phase 1: Testing basic Java execution..."
java -version
echo "✅ Java execution works"

echo ""
echo "Phase 2: Testing Gradle compilation..."
./gradlew compileJava --quiet
echo "✅ Compilation works"

echo ""
echo "Phase 3: Testing basic LWJGL context creation..."
# Create a minimal LWJGL test that exits immediately
cat > /tmp/LWJGLTest.java << 'EOF'
import org.lwjgl.glfw.GLFW;
import org.lwjgl.opengl.GL;

public class LWJGLTest {
    public static void main(String[] args) {
        System.out.println("Starting LWJGL test...");
        
        if (!GLFW.glfwInit()) {
            System.err.println("GLFW init failed");
            System.exit(1);
        }
        System.out.println("✅ GLFW initialized");
        
        GLFW.glfwWindowHint(GLFW.GLFW_VISIBLE, GLFW.GLFW_FALSE);
        long window = GLFW.glfwCreateWindow(1, 1, "test", 0, 0);
        
        if (window == 0) {
            System.err.println("Window creation failed");
            System.exit(1);
        }
        System.out.println("✅ Window created");
        
        GLFW.glfwMakeContextCurrent(window);
        GL.createCapabilities();
        System.out.println("✅ OpenGL context created");
        
        System.out.println("OpenGL: " + org.lwjgl.opengl.GL11.glGetString(org.lwjgl.opengl.GL11.GL_VERSION));
        
        GLFW.glfwDestroyWindow(window);
        GLFW.glfwTerminate();
        System.out.println("✅ LWJGL test completed successfully");
        System.exit(0);
    }
}
EOF

echo "Compiling LWJGL test..."
javac -cp "$(./gradlew -q printClasspath)" /tmp/LWJGLTest.java -d /tmp

echo "Running LWJGL test (5 second timeout)..."
timeout 5s java -cp "/tmp:$(./gradlew -q printClasspath)" -XstartOnFirstThread LWJGLTest

if [ $? -eq 124 ]; then
    echo "❌ LWJGL test timed out - this is likely where the hang occurs"
    echo "The issue is with OpenGL context creation on macOS M1"
else
    echo "✅ LWJGL test passed - the hang is in the application code"
fi

echo ""
echo "If LWJGL test failed, the issue is fundamental OpenGL/macOS compatibility"
echo "If LWJGL test passed, the issue is in the particle life app initialization"