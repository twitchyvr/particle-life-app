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
