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



