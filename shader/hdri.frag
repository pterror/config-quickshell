#version 440
precision highp float;

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 iResolution;
    float iYaw;
    float iPitch;
    float iFov;
};

layout(binding = 1) uniform sampler2D iChannel0;

const float PI = 3.14159265359;

void main() {
    vec2 uv = qt_TexCoord0 * 2.0 - 1.0;
    float aspect = iResolution.x / iResolution.y;
    uv *= tan(iFov / 2.0);
    uv.x *= aspect;
    vec3 dir = normalize(vec3(uv, -1.0));
    float cy = cos(iYaw), sy = sin(iYaw);
    float cp = cos(iPitch), sp = sin(iPitch);
    mat3 rot = mat3(
        cy,   0.0,   -sy,
      -sy*sp, cp,  -cy*sp,
       sy*cp, sp,   cy*cp
    );
    dir = rot * dir;
    float lon = atan(dir.z, dir.x);
    float lat = asin(clamp(dir.y, -1.0, 1.0));
    vec2 texCoord = vec2((lon + PI) / (2.0 * PI), (lat + PI / 2.0) / PI);
    fragColor = texture(iChannel0, texCoord);
}