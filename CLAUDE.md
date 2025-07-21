# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Java-based particle life simulation application built with OpenGL, LWJGL, and ImGui. It provides a GUI for the [Particle Life Framework](https://github.com/tom-mohr/particle-life), allowing users to visualize and interact with particle simulations through various shaders, palettes, and physics parameters.

## Build System & Development Commands

**Main Build Tool:** Gradle with wrapper (`./gradlew`)

### Essential Commands
```bash
# Run the application directly
./gradlew run

# Build shadow JAR (contains all dependencies)
./gradlew shadowJar

# Run tests
./gradlew test

# Clean build directory
./gradlew clean

# Build for distribution (Windows executable + zip)
./gradlew zipApp
```

### Platform-Specific Building

**For Apple Silicon (M1/M2) Macs:**
```bash
# Build shadow JAR first
./gradlew shadowJar

# Extract resources and run with x86_64 Java
mkdir -p temp_internal
jar xf build/libs/particle-life-app-all.jar .internal
mv .internal temp_internal/
arch -x86_64 $(brew --prefix openjdk@17)/bin/java -XstartOnFirstThread -Djava.io.tmpdir=temp_internal -jar build/libs/particle-life-app-all.jar
rm -rf temp_internal
```

**Check platform detection:**
```bash
./gradlew platformInfo
```

## Architecture Overview

### Core Application Structure
- **`Main.java`** - Entry point, extends `App.java`, manages the complete application lifecycle
- **`App.java`** - Abstract base class providing LWJGL/GLFW window management and OpenGL context
- **`ImGuiLayer.java`** - Handles Dear ImGui integration with LWJGL/GLFW for GUI rendering

### Key Architecture Patterns

**Multi-threaded Physics Simulation:**
- Physics runs in background threads independent of rendering
- `PhysicsSnapshot` system provides thread-safe data transfer between physics and rendering threads
- `Loop` class manages physics simulation timing and queuing operations

**Provider Pattern for Components:**
- `ShaderProvider`, `PalettesProvider`, `MatrixGeneratorProvider`, etc.
- `SelectionManager<T>` wraps providers to handle active selection state
- Allows dynamic switching between different algorithms/renderers

**Render-to-Texture Pipeline:**
- `MultisampledFramebuffer` for anti-aliased off-screen rendering
- Separate textures for particles (`worldTexture`) and cursor (`cursorTexture`)
- Final composition through ImGui's background draw list

**Resource Management:**
- `ResourceAccess` utility handles JAR resource extraction for bundled assets
- Shaders, fonts, palettes, and icons are bundled and extracted at runtime

### Package Structure
- `com.particle_life.app` - Main application and core UI components
- `com.particle_life.app.color` - Color palettes and interpolation
- `com.particle_life.app.cursors` - Interactive cursor tools and shapes
- `com.particle_life.app.shaders` - OpenGL shader management and rendering
- `com.particle_life.app.utils` - Math utilities, camera operations, framebuffers
- `com.particle_life.app.io` - File I/O for saving/loading simulation states

## Key Technical Details

### Graphics Requirements
- **OpenGL 4.1+** required (falls back to 330, 150, 130, 120)
- **GLSL version 410 core** preferred
- Multisampling (16x) enabled for anti-aliasing

### Dependencies
- **LWJGL 3.3.0** - OpenGL/GLFW bindings with automatic native library detection
- **ImGui-Java 1.86.10** - Immediate mode GUI (downgraded for stability)
- **Particle Life Framework v0.5.1** - Core physics simulation
- **JOML 1.10.1** - Math library for vectors/matrices

### Native Library Handling
The build system automatically detects platform and architecture:
- **macOS ARM64:** `natives-macos-arm64`
- **macOS x86_64:** `natives-macos`
- **Windows x64:** `natives-windows`
- **Linux:** `natives-linux`

### Save System
Simulations are saved as ZIP files containing:
- `particles.tsv` - Particle positions, velocities, types
- `physics.toml` - Physics settings (forces, boundaries, etc.)
- `matrix.tsv` - Interaction matrix between particle types
- `img.png` - Preview thumbnail

## Common Development Scenarios

### Adding New Shaders
1. Create shader files in `src/main/resources/shaders/`
2. Update `shaders.yaml` configuration
3. Implement in `ShaderProvider.java`

### Adding New Palettes
1. Create `.map` file in `src/main/resources/palettes/`
2. Implement palette class extending `Palette`
3. Register in `PalettesProvider.java`

### Modifying Physics
- Core physics handled by external `particle-life` framework
- Local extensions in `ExtendedPhysics.java`
- Settings managed through `PhysicsSettings` and TOML serialization

### Debugging Graphics Issues
- Check OpenGL version: app displays fallback behavior for older versions
- Shader compilation errors shown in error dialog with detailed context
- Use `check-*` scripts for diagnosing platform-specific issues

## Settings and Configuration

Settings are persisted in `settings.toml` using TOML4J library. The `AppSettings` class handles:
- Graphics preferences (shaders, palettes, particle size)
- Camera settings (movement speed, zoom behavior)
- Cursor configuration (size, actions, brush power)
- Startup options (fullscreen, position setters)

## Error Handling Strategy

The application implements comprehensive error handling:
- Graceful fallbacks for graphics initialization failures
- Detailed error dialogs with stack traces and copy-to-clipboard functionality
- Platform-specific guidance for common issues (driver updates, hardware compatibility)
- Physics simulation monitoring with automatic recovery options