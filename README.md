# 🦠 Particle Life App

A GUI for the [Particle Life Framework](https://github.com/tom-mohr/particle-life).

- [Download](https://particle-life.com) (.exe for Windows)
- [Documentation](https://particle-life.com/docs)

Join the [Discord server](https://discord.gg/Fd64AhKzMD)!

![Screenshot of the App](./readme_assets/app_demo.png)

## Run This App From Source

You can easily run this app from the source code.

First, check that you have

- [Git](https://git-scm.com/downloads) installed.
- [Java](https://jdk.java.net/19/) installed, with a version of at least 16 and at most 22. (Check your version with `java -version`.)

**Note for Apple Silicon (ARM64) Mac users:** The application now includes improved ARM64 support. LWJGL will automatically use ARM64 natives, and ImGui-Java has been updated to the latest version (1.89.0) which may include better ARM64 compatibility in the universal macOS natives.

Then, download the source code:
```bash
git clone https://github.com/tom-mohr/particle-life-app.git
```

To run the program, make sure that you navigate into the folder:
```bash
cd particle-life-app
```

Then start the program:
```bash
./gradlew run
```

After some time, the program should launch and you should see particles on your screen.
Feel free to mess with the code!

## Running on Apple Silicon (M1/M2) Macs

Due to current limitations with ImGui-Java native libraries, you need to run under x86_64 emulation:

1. Install x86_64 Java:
   ```bash
   # Check if Homebrew is already installed under x86_64
   if ! arch -x86_64 /usr/local/bin/brew --version &>/dev/null; then
       echo "Homebrew not found. Installing Homebrew for x86_64..."
       arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   else
       echo "Homebrew is already installed under x86_64."
   fi
   # Install Java using Homebrew
   arch -x86_64 /usr/local/bin/brew install openjdk@17
   ```
2. Build the project:
   ```bash
   ./gradlew shadowJar
   ```
3. Extract resources and run:
   ```bash
   mkdir -p temp_internal
   jar xf build/libs/particle-life-app-all.jar .internal
   mv .internal temp_internal/
   arch -x86_64 $(brew --prefix openjdk@17)/bin/java -XstartOnFirstThread -Djava.io.tmpdir=temp_internal -jar build/libs/particle-life-app-all.jar
   rm -rf temp_internal
   ```

**Note:** Native ARM64 support pending ImGui-Java update.

### Platform Support

The application automatically detects your operating system and architecture to include the appropriate native libraries:

- **LWJGL**: Supports ARM64 natively on macOS, Windows, and Linux
- **ImGui-Java**: Updated to version 1.89.0 for better compatibility

To check what platform is detected for your system:
```bash
./gradlew platformInfo
```

#### ARM64 (Apple Silicon) Support Status

- ✅ **LWJGL**: Full ARM64 native support available
- ⚠️ **ImGui-Java**: Uses universal macOS natives (may contain both x86_64 and ARM64 support)
- ✅ **Build System**: Automatically detects and configures appropriate natives

If you encounter issues on Apple Silicon Macs, ensure you're using an ARM64 version of Java rather than x86_64 with Rosetta 2 for optimal performance.

## Troubleshooting

If you encounter any problems, ask for help in the [`#tech-support`](https://discord.gg/EVG8XnCn3U) channel on the Discord server.

* `Unsupported class file major version 67` (or similar).<br>
  This happens when your installed Java version is higher than 22.
  Check your current Java version with `java -version`.  You need to uninstall Java and install a version between 16 (including) and 22 (including).
  Make sure that after installing the new Java version, `java -version` actually outputs the installed version.
  Restarting the computer sometimes helps.

* **Shader compilation errors** or graphics-related crashes on startup.<br>
  This app requires modern graphics support. Please ensure:
  - **OpenGL 4.1 or higher** is supported by your GPU
  - **Graphics drivers are up to date** (especially important for Intel integrated graphics)
  - **GLSL 410 core or compatible version** is available
  
  If you continue to experience issues:
  - Try updating your graphics drivers from the manufacturer's website (NVIDIA, AMD, Intel)
  - Check that your GPU supports OpenGL 4.1+ by running `glxinfo | grep "OpenGL version"` (Linux) or using GPU-Z (Windows)
  - The app will automatically try fallback GLSL versions (330, 150, 130, 120) if 410 fails
  - If all else fails, consider upgrading your graphics hardware
  - 
* **Apple Silicon (ARM64) Macs**: If the application seems slow or encounters native library issues:
  - Ensure you're using an ARM64 version of Java (check with `java -version` - it should show `aarch64` in the output)
  - If using x86_64 Java, consider switching to an ARM64 build for better performance
  - Run `./gradlew platformInfo` to verify correct platform detection
  - The application should work on both architectures, but ARM64 Java provides optimal performance

## How to make a release

- Confirm that everything is working correctly and check in with others that the current state of the main branch is ready for release.
- Run `./gradlew zipApp` from the project root.
  This generates the zip file `particle-life-app.zip` in `./build/zipApp/`. It includes the Windows executable (`.exe`) along with other files.
- Go to the [Releases](https://github.com/tom-mohr/particle-life-app/releases) section of this GitHub repo and click `Draft a new release`.
- Click `Choose a tag` and type the new version name:
  - Prefix the version name with the letter `v`. Some good tag names might be `v1.0.0` or `v2.3.4`.
  - The version name should comply with [semantic versioning](https://semver.org/). Talk to others if you are unsure about what to choose here.
- Click `Create a new tag`.
- Set the release title to match the tag name.
- Use the description to summarize the changes of all commits since the last release.
- Add the generated `particle-life-app.zip` as an asset to the release.
- Click `Publish release`.
