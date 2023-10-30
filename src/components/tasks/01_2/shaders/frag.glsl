precision mediump float;
varying vec3 vPosition;

void main(void) {
    gl_FragColor = vec4((vPosition + 1.0) / 2.0, 1.0);
}