--[[--
zq UIScale9Unit 控件
-- @classmod UIScale9Unit

]]
local UIImage = require("libzq.ui.UIImage")

local UIScale9Unit = class("UIScale9Unit", UIImage)

function UIScale9Unit:ctor()
    UIScale9Unit.super.ctor(self)
    self._origin_rect = cc.rect(0, 0, 0, 0)
end

function UIScale9Unit:getOriginRect()
    return self._origin_rect
end

function UIScale9Unit:setOriginRect(rect)
    self._origin_rect = rect
    self:setTextureRect(rect)
end

return UIScale9Unit
