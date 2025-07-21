#version 150 core

uniform vec4 palette[256];
uniform mat4 transform;
uniform float size;

in vec3 x;
in vec3 v;
in int type;

out vec4 vColor;

void main(void) {
    vColor = palette[type];
    gl_Position = transform * vec4(x, 1.0);
    gl_PointSize = size * 10.0;
}