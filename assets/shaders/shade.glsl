// wai array no work sadness
extern vec3 col1;
extern vec3 col2;
extern vec3 col3;
extern vec3 col4;
extern vec3 col5;

vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 current = Texel (texture, texture_coords);
    float ave = ( (current.r + current.b + current.g) / 3.0 );

    vec3 colorOut;

    if (ave == 0.0) {
        colorOut = col1;
    } else if (ave <= 0.25) {
        colorOut = col2;
    } else if (ave <= 0.5) {
        colorOut = col3;
    } else if (ave <= 0.75) {
        colorOut = col4;
    } else {
        colorOut = col5;
    }

    return vec4 (colorOut, current.a);
}
