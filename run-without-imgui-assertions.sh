#!/bin/bash

echo "Running Particle Life with ImGui assertions disabled..."

cd ~/Documents/particle-life-app

# Create a wrapper that disables assertions
cat > RunParticleLife.java << 'EOF'
import com.particle_life.app.Main;

public class RunParticleLife {
    static {
        // Disable ImGui assertions
        System.setProperty("imgui.assertion", "false");
        System.setProperty("imgui.assertion.enabled", "false");
    }
    
    public static void main(String[] args) {
        Main.main(args);
    }
}
EOF

# Compile the wrapper
javac -cp build/libs/particle-life-app-1.0-all.jar RunParticleLife.java

# Run with the wrapper
java -XstartOnFirstThread -cp ".:build/libs/particle-life-app-1.0-all.jar" RunParticleLife