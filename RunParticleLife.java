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
