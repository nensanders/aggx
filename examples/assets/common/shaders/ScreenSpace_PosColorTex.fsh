uniform    sampler2D s_Texture;

varying lowp    vec4 v_Color;
varying highp   vec2 v_TexCoord;

void main()
{
    gl_FragColor = texture2D(s_Texture, v_TexCoord) * v_Color;
}
