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
    self:setCascadeOpacityEnabled()
end

return UIImage
