#!/bin/bash

echo "Creating a workaround for the null pointer issue..."

# Create a wrapper that handles the initialization better
cat > RunParticleLife.java << 'EOF'
import com.particle_life.app.Main;

public class RunParticleLife {
    public static void main(String[] args) {
        try {
            // Set system properties
            System.setProperty("java.awt.headless", "false");
            
            // Run the main application
            Main.main(args);
        } catch (Exception e) {
            System.err.println("Application error: " + e.getMessage());
            e.printStackTrace();
            
            // Try to exit gracefully
            try {
                Thread.sleep(100);
            } catch (InterruptedException ie) {
                // ignore
            }
            System.exit(1);
        }
    }
}
EOF

# Compile the wrapper
arch -x86_64 /usr/local/opt/openjdk@17/bin/javac -cp build/libs/particle-life-app-x86.jar RunParticleLife.java

# Run with the wrapper
echo ""
echo "Running with wrapper..."
arch -x86_64 /usr/local/opt/openjdk@17/bin/java \
    -XstartOnFirstThread \
    -cp ".:build/libs/particle-life-app-x86.jar" \
    RunParticleLife