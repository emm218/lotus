#version 330 core
layout (location = 0) in vec3 pos;

void main()
{
    gl_Position = vec4(pos.x, pos.y, 0.0, 1.0);
}
