#!/bin/bash

echo "Downgrading ImGui to stable version 1.86.10..."

cd ~/Documents/particle-life-app

# Create a new build.gradle with older ImGui version
cat > build-imgui-stable.gradle << 'EOF'
plugins {
    id 'java'
    id 'application'
    id 'com.github.johnrengelman.shadow' version '7.1.2'
}

group = 'com.particle.life.app'
version = '1.0'

repositories {
    mavenLocal()
    mavenCentral()
    maven { url 'https://jitpack.io' }
}

application {
    mainClass = 'com.particle_life.app.Main'
    applicationDefaultJvmArgs = ['-XstartOnFirstThread', '-Djava.awt.headless=false']
}

sourceCompatibility = JavaVersion.VERSION_17
targetCompatibility = JavaVersion.VERSION_17

def lwjglVersion = '3.3.0'
def osName = System.getProperty('os.name').toLowerCase()
def osArch = System.getProperty('os.arch').toLowerCase()

def lwjglNatives
if (osName.contains('mac') || osName.contains('darwin')) {
    if (osArch.contains('aarch64') || osArch.contains('arm64')) {
        lwjglNatives = 'natives-macos-arm64'
    } else {
        lwjglNatives = 'natives-macos'
    }
} else if (osName.contains('win')) {
    if (osArch.contains('64')) {
        lwjglNatives = 'natives-windows'
    } else {
        lwjglNatives = 'natives-windows-x86'
    }
} else {
    lwjglNatives = 'natives-linux'
}

dependencies {
    implementation 'com.github.tom-mohr:particle-life:v0.5.1'
    implementation 'com.esotericsoftware.yamlbeans:yamlbeans:1.17'
    implementation 'com.moandjiezana.toml:toml4j:0.7.2'
    implementation 'org.apache.commons:commons-text:1.12.0'
    implementation 'org.joml:joml:1.10.1'
    
    // LWJGL
    implementation platform("org.lwjgl:lwjgl-bom:${lwjglVersion}")
    implementation 'org.lwjgl:lwjgl'
    implementation 'org.lwjgl:lwjgl-glfw'
    implementation 'org.lwjgl:lwjgl-opengl'
    implementation 'org.lwjgl:lwjgl-stb'
    
    runtimeOnly "org.lwjgl:lwjgl::${lwjglNatives}"
    runtimeOnly "org.lwjgl:lwjgl-glfw::${lwjglNatives}"
    runtimeOnly "org.lwjgl:lwjgl-opengl::${lwjglNatives}"
    runtimeOnly "org.lwjgl:lwjgl-stb::${lwjglNatives}"
    
    // ImGui - DOWNGRADED TO STABLE VERSION
    implementation 'io.github.spair:imgui-java-app:1.86.10'
    implementation 'io.github.spair:imgui-java-binding:1.86.10'
    implementation 'io.github.spair:imgui-java-lwjgl3:1.86.10'
    
    testImplementation 'org.junit.jupiter:junit-jupiter:5.8.2'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

if (osName.contains('mac') || osName.contains('darwin')) {
    dependencies {
        runtimeOnly 'io.github.spair:imgui-java-natives-macos:1.86.10'
    }
}

jar {
    manifest {
        attributes 'Main-Class': application.mainClass
    }
}

shadowJar {
    manifest {
        attributes 'Main-Class': application.mainClass
    }
    archiveBaseName = 'particle-life-app'
    archiveClassifier = 'all'
    configurations = [project.configurations.runtimeClasspath]
}

task fatJar {
    dependsOn shadowJar
}

run {
    jvmArgs = applicationDefaultJvmArgs
}

test {
    useJUnitPlatform()
}
EOF

# Use the stable build file
cp build-imgui-stable.gradle build.gradle

# Clean and rebuild
echo "Cleaning old build..."
./gradlew clean

echo "Building with stable ImGui..."
./gradlew shadowJar

echo ""
echo "Testing with stable ImGui version..."
java -XstartOnFirstThread -jar build/libs/particle-life-app-1.0-all.jar