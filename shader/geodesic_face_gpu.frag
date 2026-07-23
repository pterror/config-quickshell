VARYING float vHeight;
VARYING vec3 vFaceDir;

vec3 heatGradient(float t)
{
    vec3 a = uColor.rgb;
    vec3 b = uSecondaryColor.rgb;
    vec3 c = uAccentColor.rgb;
    vec3 ab = mix(a, b, smoothstep(0.0, 0.55, t));
    return mix(ab, c, smoothstep(0.55, 1.0, t));
}

void MAIN()
{
    float t = clamp(vHeight, 0.0, 1.0);
    vec3 baseColor;

    if (uColorMode < 0.5) {
        baseColor = vec3(t);
    } else if (uColorMode < 1.5) {
        float monochromeGlow = mix(0.65, 1.25 + uGlowAmount, t);
        baseColor = uColor.rgb * monochromeGlow;
    } else if (uColorMode < 2.5) {
        baseColor = heatGradient(t);
    } else if (uColorMode < 3.5) {
        float aurora = 0.5 + 0.5 * sin(vFaceDir.y * uBanding + uTime * uSpeed + t * 4.0);
        baseColor = mix(mix(uColor.rgb, uSecondaryColor.rgb, aurora), uAccentColor.rgb, t * uColorMix);
    } else if (uColorMode < 4.5) {
        float bands = floor(t * max(1.0, uBanding)) / max(1.0, uBanding - 0.0001);
        baseColor = mix(uColor.rgb, uAccentColor.rgb, bands);
    } else if (uColorMode < 5.5) {
        float polar = clamp(0.5 + 0.5 * vFaceDir.y, 0.0, 1.0);
        baseColor = mix(uSecondaryColor.rgb, uAccentColor.rgb, polar);
        baseColor = mix(baseColor, uColor.rgb, t * uColorMix);
    } else if (uColorMode < 6.5) {
        float prism = 0.5 + 0.5 * sin(vFaceDir.x * uBanding + uTime * uSpeed + t * 8.0);
        vec3 prismA = mix(uColor.rgb, uSecondaryColor.rgb, prism);
        baseColor = mix(prismA, uAccentColor.rgb, 0.5 + 0.5 * sin(vFaceDir.z * uBanding - uTime * uSpeed));
    } else {
        float stripes = 0.5 + 0.5 * sin((vFaceDir.x + vFaceDir.y) * uBanding + uTime * uSpeed * 0.7);
        vec3 warm = mix(uColor.rgb, uSecondaryColor.rgb, stripes);
        baseColor = mix(warm, uAccentColor.rgb, smoothstep(0.2, 0.9, t));
    }

    float glow = mix(0.92, 1.15 + uGlowAmount, t);
    BASE_COLOR = vec4(baseColor * glow, 1.0);
    METALNESS = 0.0;
    ROUGHNESS = uRoughnessAmount;
    SPECULAR_AMOUNT = uSpecularAmount;
}
