VARYING float vHeight;

void MAIN()
{
    float glow = mix(0.72, 1.18, clamp(vHeight, 0.0, 1.0));
    BASE_COLOR = vec4(uColor.rgb * glow, 1.0);
    METALNESS = 0.0;
    ROUGHNESS = 0.85;
    SPECULAR_AMOUNT = 0.12;
}
