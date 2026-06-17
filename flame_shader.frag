uniform float time;
uniform vec2 resolution;
uniform sampler2D noiseTex;
varying vec2 TexCoord;

void main() {
    // Scroll 2 noise vectors at different speeds
    vec2 scroll1 = fract(TexCoord + vec2(time * 0.5));
    vec2 scroll2 = fract(TexCoord + vec2(time * 0.1, time * 0.8));
    float noise1 = texture2D(noiseTex, scroll1).r;
    float noise2 = texture2D(noiseTex, scroll2).r;
    float combinedNoise = (noise1 + noise2) * 0.5;

    // Normalize coordinates
    // vec2 st = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
    vec2 st = gl_FragCoord.xy / resolution.xy;

    // Scale and animate flame
    float t = time * 2.0;
    vec2 p = st * 4.0;
    p.y -= t; // Moves the noise upwards

    // Shape the flame: wide at bottom, sharp at top (based on vertical position)
    float mask = (1.0 - st.y) * 0.5;
    float intensity = combinedNoise * mask * 2.5;

    // Map intensity to fire colors (Yellow -> Red -> Black)
    vec4 fireColor = vec4(1.0, 0.9, 0.2, 1.0) * intensity;
    if (intensity < 1.0) fireColor = mix(vec4(1.0, 0.1, 0.0, 1.0), vec4(1.0, 0.9, 0.2, 1.0), intensity);
    if (intensity < 0.3) fireColor = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 0.1, 0.0, 1.0), intensity / 0.3);

    // Fade out at the very edges of the screen
    float border = smoothstep(0.0, 0.2, abs(st.x));
    fireColor.a *= (1.0 - border);

    gl_FragColor = fireColor;
}
