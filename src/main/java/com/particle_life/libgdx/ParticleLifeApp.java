package com.particle_life.libgdx;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3Application;
import com.badlogic.gdx.backends.lwjgl3.Lwjgl3ApplicationConfiguration;
import com.badlogic.gdx.utils.viewport.FitViewport;
import com.badlogic.gdx.utils.viewport.Viewport;

import java.util.Random;

/**
 * High-performance particle life simulator using LibGDX
 * Self-contained implementation optimized for macOS M1
 */
public class ParticleLifeApp extends ApplicationAdapter {
    
    public static void main(String[] args) {
        Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
        config.setTitle("Particle Life - LibGDX (macOS M1 Optimized)");
        config.setWindowedMode(1200, 800);
        config.useVsync(true);
        config.setForegroundFPS(60);
        
        new Lwjgl3Application(new ParticleLifeApp(), config);
    }
    
    // Graphics
    private OrthographicCamera camera;
    private Viewport viewport;
    private ShapeRenderer shapeRenderer;
    
    // Physics
    private Particle[] particles;
    private float[][] attractionMatrix;
    private int particleCount = 2000;
    private int typeCount = 6;
    private boolean paused = false;
    
    // Physics parameters
    private final float rMax = 0.1f;
    private final float friction = 0.99f;
    private final float force = 1.0f;
    private final float dt = 0.02f;
    
    // Colors for each particle type
    private final float[][] colors = {
        {1f, 0.2f, 0.2f},    // Red
        {0.2f, 1f, 0.2f},    // Green  
        {0.2f, 0.2f, 1f},    // Blue
        {1f, 1f, 0.2f},      // Yellow
        {1f, 0.2f, 1f},      // Magenta
        {0.2f, 1f, 1f}       // Cyan
    };
    
    @Override
    public void create() {
        System.out.println("🚀 LibGDX Particle Life starting on macOS M1");
        
        // Setup camera and viewport
        camera = new OrthographicCamera();
        viewport = new FitViewport(2f, 2f, camera);
        viewport.apply();
        camera.position.set(1f, 1f, 0);
        camera.update();
        
        // Setup renderer
        shapeRenderer = new ShapeRenderer();
        
        // Initialize physics
        initializePhysics();
        
        System.out.println("✅ LibGDX initialization complete");
        System.out.println("Controls: SPACE = pause/resume, R = reset, ESC = exit");
    }
    
    private void initializePhysics() {
        Random random = new Random();
        
        // Create attraction matrix
        attractionMatrix = new float[typeCount][typeCount];
        for (int i = 0; i < typeCount; i++) {
            for (int j = 0; j < typeCount; j++) {
                // Random attraction/repulsion between -1 and 1
                attractionMatrix[i][j] = (float)(random.nextGaussian() * 0.5);
            }
        }
        
        // Create particles
        particles = new Particle[particleCount];
        for (int i = 0; i < particleCount; i++) {
            particles[i] = new Particle();
            particles[i].x = random.nextFloat();
            particles[i].y = random.nextFloat();
            particles[i].vx = 0;
            particles[i].vy = 0;
            particles[i].type = random.nextInt(typeCount);
        }
        
        System.out.println("🔄 Physics initialized: " + particleCount + " particles, " + typeCount + " types");
    }
    
    @Override
    public void render() {
        // Handle input
        if (Gdx.input.isKeyJustPressed(com.badlogic.gdx.Input.Keys.SPACE)) {
            paused = !paused;
            System.out.println(paused ? "⏸️ Paused" : "▶️ Resumed");
        }
        if (Gdx.input.isKeyJustPressed(com.badlogic.gdx.Input.Keys.R)) {
            initializePhysics();
            System.out.println("🔄 Reset");
        }
        if (Gdx.input.isKeyJustPressed(com.badlogic.gdx.Input.Keys.ESCAPE)) {
            Gdx.app.exit();
        }
        
        // Update physics
        if (!paused) {
            updatePhysics();
        }
        
        // Clear screen
        Gdx.gl.glClearColor(0.05f, 0.05f, 0.1f, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        
        // Render particles
        camera.update();
        shapeRenderer.setProjectionMatrix(camera.combined);
        
        shapeRenderer.begin(ShapeRenderer.ShapeType.Filled);
        
        for (Particle particle : particles) {
            float[] color = colors[particle.type];
            shapeRenderer.setColor(color[0], color[1], color[2], 1f);
            shapeRenderer.circle(particle.x, particle.y, 0.008f);
        }
        
        shapeRenderer.end();
    }
    
    private void updatePhysics() {
        // Calculate forces
        for (int i = 0; i < particleCount; i++) {
            Particle p1 = particles[i];
            float fx = 0, fy = 0;
            
            for (int j = 0; j < particleCount; j++) {
                if (i == j) continue;
                
                Particle p2 = particles[j];
                float dx = p2.x - p1.x;
                float dy = p2.y - p1.y;
                
                // Handle wrapping
                if (dx > 0.5f) dx -= 1f;
                if (dx < -0.5f) dx += 1f;
                if (dy > 0.5f) dy -= 1f;
                if (dy < -0.5f) dy += 1f;
                
                float dist = (float)Math.sqrt(dx * dx + dy * dy);
                
                if (dist > 0 && dist < rMax) {
                    float attraction = attractionMatrix[p1.type][p2.type];
                    
                    // Particle life force function
                    float beta = 0.3f;
                    float f;
                    if (dist < beta) {
                        f = dist / beta - 1;
                    } else {
                        f = attraction * (1 - Math.abs(1 + beta - 2 * dist) / (1 - beta));
                    }
                    
                    f = f * force / dist;
                    fx += f * dx;
                    fy += f * dy;
                }
            }
            
            // Update velocity
            p1.vx = (p1.vx + fx * dt) * friction;
            p1.vy = (p1.vy + fy * dt) * friction;
        }
        
        // Update positions
        for (Particle particle : particles) {
            particle.x += particle.vx * dt;
            particle.y += particle.vy * dt;
            
            // Wrap around edges
            if (particle.x < 0) particle.x += 1;
            if (particle.x > 1) particle.x -= 1;
            if (particle.y < 0) particle.y += 1;
            if (particle.y > 1) particle.y -= 1;
        }
    }
    
    @Override
    public void resize(int width, int height) {
        viewport.update(width, height);
    }
    
    @Override
    public void dispose() {
        shapeRenderer.dispose();
    }
    
    // Simple particle class
    private static class Particle {
        float x, y;      // Position
        float vx, vy;    // Velocity
        int type;        // Particle type for interactions
    }
}