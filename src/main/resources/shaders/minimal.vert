#version 120

uniform vec4 palette[256];
uniform mat4 transform;

attribute vec3 x;
attribute int type;

varying vec4 vColor;

void main(void) {
    vColor = palette[type];
    gl_Position = transform * vec4(x, 1.0);
    gl_PointSize = 5.0;
}