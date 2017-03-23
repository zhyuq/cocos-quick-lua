kShaderTypeDefault          = "ShaderPositionTextureColor_noMVP"
kShaderTypeGrayscale        = "ShaderTypeGrayscale"
kShaderTypeMaskSprite       = "ShaderTypeMaskSprite"

local Shader = class("Shader")

function Shader:ctor(...)
    self._cache = {}
end

function Shader:getShader(shaderType)
    local vertSource = kShaderDefaultVsh
    local fragSource = ""
    if shaderType == kShaderTypeDefault then
        return cc.GLProgramCache:getInstance():getGLProgram(kShaderTypeDefault)
    elseif shaderType == kShaderTypeGrayscale then
        fragSource = kShaderGrayscaleFsh
        return self:load(vertSource, fragSource, shaderType)
    elseif shaderType == kShaderTypeMaskSprite then
        fragSource = kShaderMaskSpriteFsh
        return self:load(vertSource, fragSource, shaderType)
    end
end

function Shader:load(vsh, fsh, key)
    local program = cc.GLProgramCache:getInstance():getGLProgram(key)
    if program then
        return program
    end

    program = cc.GLProgram:new()
    self:update(program, vsh, fsh)

    table.insert(self._cache, {
        program = program,
        vsh = vsh,
        fsh = fsh
        })
    cc.GLProgramCache:getInstance():addGLProgram(program, key)

    return program
end

function Shader:update(program, vsh, fsh)
    program:initWithByteArrays(vsh, fsh)

    program:link()
    program:updateUniforms()

end

function Shader:reset()
    for i,v in ipairs(self._cache) do
        local program = v["program"]
        local vsh = v["vsh"]
        local fsh = v["fsh"]

        self:update(program, vsh, fsh)
    end
end

function Shader:getInstance()
    if not self._instance then
        self._instance = Shader.new()
    end

    return self._instance
end

zq.Shader = Shader

return Shader
