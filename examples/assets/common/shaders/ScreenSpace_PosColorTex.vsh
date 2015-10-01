attribute highp vec4 a_Position;
attribute lowp  vec4 a_Color;
attribute highp vec2 a_TexCoord;

uniform highp   vec4 u_Tint;

varying lowp    vec4 v_Color;
varying highp   vec2 v_TexCoord;

void main()
{
    gl_Position = a_Position;
    v_Color = a_Color * u_Tint;
    v_TexCoord = a_TexCoord;
}
