#version 450

layout(triangles) in;
layout(triangle_strip, max_vertices = 33) out;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
    float time;
} params;

layout(location = 0) in GS_IN
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} gIn[];

layout(location = 0) out GS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;
} gOut;


vec3 computeVertex(vec3 wPos, vec3 wNorm, float time) {
    time *= 10;
    // Add dependency on time
    float val = time - (int(time) / 10) * 10;
    // Make animation smooth
    if (val > 5) {
        val = 10 - val;
    }
    // To make floor and walls move in the same direction with items inside the box
    if (abs(wPos.x) > 1.25) {
        wNorm *= -1;
    }
    // Just magic number to make animation look better
    val *= 0.03;
    // Move everything along normal
    wPos += wNorm * val;

    return wPos;
}

void main()
{
    for (int i = 0; i < 3; i++) {
        gOut.wPos = computeVertex(gIn[i].wPos, gIn[i].wNorm, params.time);
        gOut.wNorm = gIn[i].wNorm;
        gl_Position = params.mProjView * vec4(gOut.wPos, 1.0);
        EmitVertex();
    }
    EndPrimitive();
}