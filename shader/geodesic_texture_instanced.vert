VARYING float vHeight;

void MAIN()
{
    float u = (INSTANCE_DATA.x + 0.5) / max(uTextureWidth, 1.0);
    float sampledHeight = texture(uHeightMap, vec2(u, 0.5)).r;
    float h = uBaseHeight + sampledHeight * uHeightScale;
    vHeight = sampledHeight;
    VERTEX.y = (VERTEX.y + 0.5) * h;
    POSITION = INSTANCE_MODELVIEWPROJECTION_MATRIX * vec4(VERTEX, 1.0);
}
