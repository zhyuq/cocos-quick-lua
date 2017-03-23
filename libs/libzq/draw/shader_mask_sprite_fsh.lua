kShaderMaskSpriteFsh = [[
#ifdef GL_ES
    precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

// 是否考虑遮罩的alpha值
uniform int u_mask_alpha;

// 纹理的原点在左上角，往右、往下增长
// this包围框相对于node坐标，node长宽假设都是1
uniform vec2 u_mask_this_tl;  // 左上角
uniform vec2 u_mask_this_br;  // 右下角

// node真实纹理坐标
uniform vec2 u_mask_tl;
uniform vec2 u_mask_br;

// 自身纹理坐标
uniform vec2 u_this_tl;
uniform vec2 u_this_br;

void main()
{
    // 包围框宽高
    float mask_w_this = u_mask_this_br.x - u_mask_this_tl.x;
    float mask_h_this = u_mask_this_br.y - u_mask_this_tl.y;

    // node纹理宽高
    float tex_w_mask = u_mask_br.x - u_mask_tl.x;
    float tex_h_mask = u_mask_br.y - u_mask_tl.y;

    // this纹理宽高
    float tex_w_this = u_this_br.x - u_this_tl.x;
    float tex_h_this = u_this_br.y - u_this_tl.y;

    // 当前纹理点相对于遮罩上的位置
    vec2 percent  = vec2((v_texCoord.x - u_this_tl.x) / tex_w_this, (v_texCoord.y - u_this_tl.y) / tex_h_this);
    vec2 position = vec2(u_mask_this_tl.x + percent.x * mask_w_this, u_mask_this_tl.y + percent.y * mask_h_this);

    if ((position.x < 0.0) ||
        (position.x > 1.0) ||
        (position.y < 0.0) ||
        (position.y > 1.0))
    {
        discard;
    }
    else
    {
        vec4 color_this  = texture2D(CC_Texture0, v_texCoord);
        vec4 color_mask  = texture2D(CC_Texture1, vec2(u_mask_tl.x + position.x * tex_w_mask, u_mask_tl.y + position.y * tex_h_mask));
        vec4 color_final = vec4(color_this.r, color_this.g, color_this.b, color_this.a);

        if (color_mask.a == 0.0)
        {
            discard;
        }
        else
        {
            if (u_mask_alpha != 0)
            {
                color_final.a = color_final.a * color_mask.a;
            }

            gl_FragColor = v_fragmentColor * color_final;
        }
    }
}
]]

