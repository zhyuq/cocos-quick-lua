kShaderGrayscaleFsh = [[
#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
  vec4   color = texture2D(CC_Texture0, v_texCoord);
  float  gray  = color.r * 0.3 + color.g * 0.59 + color.b * 0.11;
  gl_FragColor = vec4(gray, gray, gray, color.a) * v_fragmentColor;
}
]]

