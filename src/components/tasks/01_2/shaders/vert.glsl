attribute vec3 position;
varying vec3 vPosition;

void main (void) {
    vPosition = position;
    gl_Position = vec4(position, 1.0);
    gl_PointSize = 5.0;
}