#!/bin/bash

echo "=== Particle Life Diagnostic Script ==="
echo ""

# Set Java 17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Check Java version
echo "Java version:"
java -version
echo ""

# Check if source files exist
echo "Checking for source files..."
find . -name "Main.java" -o -name "ParticleLife.java" 2>/dev/null | head -10
echo ""

# Check the project structure
echo "Project structure:"
ls -la src/main/java/com/particle_life/app/ 2>/dev/null || echo "Source directory not found"
echo ""

# Try to compile and run a simple test
echo "Creating a simple test class..."
mkdir -p test-build

cat > TestApp.java << 'EOF'
import javax.swing.*;

public class TestApp {
    public static void main(String[] args) {
        System.out.println("Test app starting...");
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Test");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(400, 300);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
            System.out.println("Window should be visible now");
        });
        
        // Keep the main thread alive
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Test app ending...");
    }
}
EOF

echo "Compiling and running test app..."
javac TestApp.java
java TestApp

echo ""
echo "If the test window appeared, Java GUI is working."
echo ""

# Now let's check the actual JAR
if [ -f "build/libs/particle-life-app-all.jar" ]; then
    echo "Checking JAR manifest..."
    jar xf build/libs/particle-life-app-all.jar META-INF/MANIFEST.MF
    cat META-INF/MANIFEST.MF
    rm -rf META-INF
    
    echo ""
    echo "Checking for Main class in JAR..."
    jar tf build/libs/particle-life-app-all.jar | grep -i "main\.class" | head -5
    
    echo ""
    echo "Trying to run with explicit classpath..."
    cd build/libs
    java -XstartOnFirstThread -cp particle-life-app-all.jar com.particle_life.app.Main
fi