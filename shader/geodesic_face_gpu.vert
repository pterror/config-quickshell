VARYING float vHeight;
VARYING vec3 vFaceDir;

const float PI = 3.14159265358979323846;
const float TAU = 6.28318530717958647692;

vec3 decodeFaceDir(vec4 encoded)
{
    float azimuth = encoded.y * TAU - PI;
    float y = encoded.z * 2.0 - 1.0;
    float radial = sqrt(max(0.0, 1.0 - y * y));
    return normalize(vec3(cos(azimuth) * radial, y, sin(azimuth) * radial));
}

float proceduralHeight(vec3 dir)
{
    float phase = uTime * uSpeed;
    float value = 0.75;

    if (uHeightMode < 0.5) {
        value = 0.75;
    } else if (uHeightMode < 1.5) {
        value = 0.5 + 0.5 * sin(phase + dir.x * uFrequencyA + dir.z * uFrequencyB);
    } else if (uHeightMode < 2.5) {
        value = 0.5
            + 0.22 * sin(phase * 1.1 + dir.x * uFrequencyA + dir.z * uFrequencyB)
            + 0.18 * cos(phase * 0.8 + dir.y * (uFrequencyA + 1.5) - dir.x * uTwist)
            + 0.10 * sin(phase * 1.7 + (dir.x + dir.y + dir.z) * (uFrequencyB + 2.0));
    } else if (uHeightMode < 3.5) {
        value = 0.5 + 0.5 * sin(phase * 0.7 + dir.y * uFrequencyA + uBias * PI);
    } else if (uHeightMode < 4.5) {
        value = 0.5 + 0.5 * sin(phase + atan(dir.z, dir.x) * uTwist + dir.y * uFrequencyA);
    } else if (uHeightMode < 5.5) {
        value = 1.0 - abs(sin(phase * 1.4 + atan(dir.z, dir.x) * uFrequencyB + dir.y * uFrequencyA));
    } else if (uHeightMode < 6.5) {
        float craterA = sin(phase * 0.45 + dir.x * uFrequencyA);
        float craterB = cos(phase * 0.35 + dir.z * (uFrequencyB + 1.5));
        value = pow(0.5 + 0.5 * craterA * craterB, 2.2);
    } else {
        float ripple = sin(phase * 1.2 + length(dir.xz) * (uFrequencyA + uFrequencyB));
        float mesh = sin(phase * 0.7 + dir.x * uFrequencyA) * sin(phase * 0.9 + dir.z * uFrequencyB);
        value = 0.5 + 0.3 * ripple + 0.2 * mesh;
    }

    value = 0.5 + (value - 0.5) * uAmplitude + uBias * 0.5;
    return clamp(value, 0.0, 1.0);
}

void MAIN()
{
    vec3 faceDir = decodeFaceDir(COLOR);
    float sampledHeight = uRenderMode > 0.5 && uHasHeightMap > 0.5
        ? texture(uHeightMap, UV0).r
        : proceduralHeight(faceDir);
    float offset = (uBaseHeight + sampledHeight * uHeightScale) * COLOR.x;
    vHeight = sampledHeight;
    vFaceDir = faceDir;
    vec3 radial = normalize(VERTEX);
    VERTEX += radial * offset;
}
