--[[--

针对 cc.Sprite 的扩展

]]

local c = cc
local Sprite = c.Sprite

function Sprite:enableCustomDraw(enable)
    if enable then
        self._baseCustomDrawEventListener = function(event)
            if event.name == "began" then
                self:customDrawBegan()
            elseif event.name == "end" then
                self:customDrawEnd()
            end
        end

        self:registerDrawScriptHandler(self._baseCustomDrawEventListener)
    else
        self:unregisterDrawScriptHandler()
        self._baseCustomDrawEventListener = nil
    end
end

function Sprite:customDrawBegan()
    local texture = self:getTexture()
    if not texture then
        return
    end

    local size = self:getContentSize()
    local glProgram = self:getGLProgram()
    local program = glProgram:getProgram()

    if self:isMaskSpriteEnabled() then
        local sprite = self._shader_mask_sprite["sprite"]
        local mask   = sprite:getContentSize()
        local real = sprite:getTransformSize()
        local rect = sprite:rectToNode(self, cc.rect(0, 0, mask.width, mask.height))

        local m_l = 0
        local m_r = 0
        local m_b = 0
        local m_t = 0
        if real.width > 0 and real.height > 0 then
            m_l = (-rect.x) / real.width
            m_r = size.width / real.width + m_l
            m_b = (rect.y + rect.height) / real.height
            m_t = m_b - size.height / real.height
        end

        local u_mask = gl._getUniformLocation(program, "u_mask")
        local u_mask_alpha = gl._getUniformLocation(program, "u_mask_alpha")
        local u_mask_this_tl = gl._getUniformLocation(program, "u_mask_this_tl")
        local u_mask_this_br = gl._getUniformLocation(program, "u_mask_this_br")
        local u_mask_tl = gl._getUniformLocation(program, "u_mask_tl")
        local u_mask_br = gl._getUniformLocation(program, "u_mask_br")
        local u_this_tl = gl._getUniformLocation(program, "u_this_tl")
        local u_this_br = gl._getUniformLocation(program, "u_this_br")

        glProgram:use()

        gl.activeTexture(gl.TEXTURE1)
        gl._bindTexture(gl.TEXTURE_2D, sprite:getTexture():getName())

        gl.activeTexture(gl.TEXTURE0);
        local quad_this = self:getQuad()
        local quad_mask = sprite:getQuad()

        gl.uniform1i(u_mask, 1)
        gl.uniform1i(u_mask_alpha, fif(self._shader_mask_sprite["alpha"], 1, 0))
        gl.uniform2f(u_mask_this_tl, m_l, m_t)
        gl.uniform2f(u_mask_this_br, m_r, m_b)
        gl.uniform2f(u_mask_tl, quad_mask.tl.texCoords.u, quad_mask.tl.texCoords.v);
        gl.uniform2f(u_mask_br, quad_mask.br.texCoords.u, quad_mask.br.texCoords.v);
        gl.uniform2f(u_this_tl, quad_this.tl.texCoords.u, quad_this.tl.texCoords.v);
        gl.uniform2f(u_this_br, quad_this.br.texCoords.u, quad_this.br.texCoords.v);
    end
end

function Sprite:customDrawEnd()

end

function Sprite:setGrayscale(enable)
    if not self._shader_grayscale then
        self._shader_grayscale = {}
    end

    if self:isGrayscaleEnabled() == enable then
        return
    end

    self._shader_grayscale["enable"] = enable
    if enable then
        self:setGLProgram(zq.Shader:getInstance():getShader(kShaderTypeGrayscale))
        self:enableCustomDraw(true)
    else
        self:setGLProgram(zq.Shader:getInstance():getShader(kShaderTypeDefault))
    end
end

function Sprite:isGrayscaleEnabled()
    if self._shader_grayscale and self._shader_grayscale["enable"] then
        return true
    end

    return false
end

function Sprite:setMaskSprite(image, alpha)
    if not self._shader_mask_sprite then
        self._shader_mask_sprite = {}
    end

    if not self._shader_mask_sprite["sprite"] then
        local sp = cc.Sprite:create()
        sp:setAnchorPoint(cc.p(0, 0))
        sp:setPosition(0, 0)
        sp:setVisible(false)
        self:addChild(sp)
        self._shader_mask_sprite["sprite"] = sp
    end

    self._shader_mask_sprite["alpha"] = alpha or false
    self._shader_mask_sprite["sprite"]:setImage(image)

    self:setMaskSpriteEnabled(true)
end

function Sprite:setMaskSpriteEnabled(enable)
    if not self._shader_mask_sprite then
        self._shader_mask_sprite = {}
    end
    if enable == self:isMaskSpriteEnabled() then
        return
    end

    self._shader_mask_sprite["enable"] = enable
    if enable then
        self:setGLProgram(zq.Shader:getInstance():getShader(kShaderTypeMaskSprite))
        self:enableCustomDraw(true)
    else
        self:setGLProgram(zq.Shader:getInstance():getShader(kShaderTypeDefault))
    end
end

function Sprite:isMaskSpriteEnabled()
    if self._shader_mask_sprite and self._shader_mask_sprite["enable"] then
        return true
    end

    return false
end

function Sprite:getMaskSprite()
    if self._shader_mask_sprite then
        return self._shader_mask_sprite["sprite"]
    end

    return nil
end





