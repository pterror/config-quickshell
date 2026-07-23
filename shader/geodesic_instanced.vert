VARYING float vHeight;

void MAIN()
{
    float h = uBaseHeight + max(INSTANCE_DATA.x, 0.0) * uHeightScale;
    vHeight = clamp(max(INSTANCE_DATA.x, 0.0), 0.0, 1.0);
    VERTEX.y = (VERTEX.y + 0.5) * h;
    POSITION = INSTANCE_MODELVIEWPROJECTION_MATRIX * vec4(VERTEX, 1.0);
}
