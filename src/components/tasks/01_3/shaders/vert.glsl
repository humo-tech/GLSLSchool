attribute vec2 position;
attribute vec4 color;
uniform bool mouseEntered;
uniform vec2 mousePos;
varying vec4 vColor;

void main (void) {
    vColor = color;

    vec2 p = position;
    if(mouseEntered) {
        vec2 toMouse = mousePos - position;
        float distanceToMouse = length(toMouse);
        vec2 normalizedToMouse = normalize(toMouse);
        vec2 offset = normalizedToMouse * 0.1 * (1.0 - distanceToMouse);
        p = position - offset;
    }

    gl_Position = vec4(p, 0.0, 1.0);
    gl_PointSize = 5.0;
}