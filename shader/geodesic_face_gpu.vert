VARYING float vHeight;

void MAIN()
{
    float sampledHeight = COLOR.x;
    float offset = (uBaseHeight + sampledHeight * uHeightScale) * COLOR.y;
    vHeight = sampledHeight;
    vec3 radial = normalize(VERTEX);
    VERTEX += radial * offset;
}
