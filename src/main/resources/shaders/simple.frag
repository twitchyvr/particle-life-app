#version 150 core

in vec4 vColor;
out vec4 FragColor;

void main(void) {
    // Simple circular points
    vec2 coord = gl_PointCoord * 2.0 - 1.0;
    if (length(coord) > 1.0) discard;
    
    FragColor = vColor;
}