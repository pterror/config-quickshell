VARYING float vHeight;

void MAIN()
{
    float glow = mix(0.55, 1.2, clamp(vHeight, 0.0, 1.0));
    FRAGCOLOR = vec4(uColor.rgb * glow, 1.0);
}
