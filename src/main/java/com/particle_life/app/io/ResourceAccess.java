package com.particle_life.app.io;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class ResourceAccess {

    public static boolean fileExists(String path) {
        // First check classpath for resources when running from JAR
        if (ResourceAccess.class.getClassLoader().getResource(path) != null) {
            return true;
        }
        // Fall back to filesystem check
        return new File(path).exists();
    }

    public static void createFile(String path) throws IOException {
        File file = new File(path);

        // ensure containing directories exist
        File dir = file.getParentFile();
        if (dir != null && !dir.exists()) {
            dir.mkdirs();
        }

        // create file
        if (!file.createNewFile()) {
            throw new IOException("File already exists: " + file.getAbsolutePath());
        }
    }

    public static String readTextFile(String path) throws IOException {
        // First try to load from classpath (when running from JAR)
        try (InputStream inputStream = ResourceAccess.class.getClassLoader().getResourceAsStream(path)) {
            if (inputStream != null) {
                return new String(inputStream.readAllBytes());
            }
        } catch (IOException e) {
            // Continue to filesystem fallback
        }
        
        // Fall back to filesystem (when running from IDE/development)
        return new String(Files.readAllBytes(Paths.get(path)));
    }

    /**
     * Gets an InputStream for a resource, trying classpath first then filesystem.
     * Caller is responsible for closing the returned InputStream.
     */
    public static InputStream getResourceStream(String path) throws IOException {
        // First try to load from classpath (when running from JAR)
        InputStream inputStream = ResourceAccess.class.getClassLoader().getResourceAsStream(path);
        if (inputStream != null) {
            return inputStream;
        }
        
        // Fall back to filesystem (when running from IDE/development)
        return Files.newInputStream(Paths.get(path));
    }

    /**
     * Gets a file path for a resource, extracting from JAR if necessary.
     * For resources that need file system access (like font loading).
     */
    public static String getResourcePath(String path) throws IOException {
        // First check if it exists on filesystem (development mode)
        File file = new File(path);
        if (file.exists()) {
            return path;
        }
        
        // Try to get from classpath
        URL resource = ResourceAccess.class.getClassLoader().getResource(path);
        if (resource != null) {
            try {
                // If it's a jar: URL, we need to extract the resource
                if (resource.getProtocol().equals("jar")) {
                    return extractResourceToTemp(path, resource);
                } else {
                    // If it's a file: URL, we can use it directly
                    return Paths.get(resource.toURI()).toString();
                }
            } catch (URISyntaxException e) {
                throw new IOException("Invalid resource URI: " + resource, e);
            }
        }
        
        throw new IOException("Resource not found: " + path);
    }

    private static String extractResourceToTemp(String resourcePath, URL resource) throws IOException {
        // Create temp file with appropriate extension
        String fileName = Paths.get(resourcePath).getFileName().toString();
        String extension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = fileName.substring(dotIndex);
        }
        
        Path tempFile = Files.createTempFile("particle-life-resource-", extension);
        synchronized (tempFiles) {
            tempFiles.add(tempFile);
        }
        
        // Extract resource to temp file
        try (InputStream inputStream = resource.openStream()) {
            Files.copy(inputStream, tempFile, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }
        
        return tempFile.toString();
    }

    /**
     * Lists all files in the given directory.
     *
     * @param directory Path relative to the app's working directory.
     *                  Must not start with "/" or "./".
     *                  Examples for allowed paths: "textures", "assets/music", ...
     */
    public static List<Path> listFiles(String directory) throws IOException {
        File file = new File(directory);

        // return empty list if directory doesn't exist
        if (!file.exists()) return List.of();

        return Files.walk(file.toPath(), 1)
                .skip(1)  // first entry is just the directory
                .collect(Collectors.toList());
    }

    public static String getFileNameWithoutExtension(File file) {
        String fileName = file.getName();
        int dotIndex = fileName.lastIndexOf('.');
        return dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);
    }
}
