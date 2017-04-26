--[[--
zq UIImage控件
-- @classmod UIImage

]]

local UIImage = class("UIImage", function()
    return cc.Sprite:create()
end)

--------------------------------
-- UIImage构建函数
-- @function ctor
function UIImage:ctor()
    self:setCascadeOpacityEnabled(true)
    self:setNodeEventEnabled(true)
end

function UIImage:setContentSize(w, h)
    if not h then
        h = w.height
        w = w.width
    end
    local func = tolua.getcfunction(self, "setContentSize")
    func(self, w, h)
end

function UIImage:isDestroyed()
    return self._destroyed or false
end

function UIImage:onEnter()
    self._destroyed = false
end

function UIImage:onExit()
    self._destroyed = true
end

return UIImage
