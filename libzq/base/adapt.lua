--[[

]]

--------------------------------
local Adapt = class("Adapt")

function Adapt:ctor()
    self._size_screen = cc.GLView:getFrameSize()
    self._aspect_screen = self._size_screen.width/self._size_screen.height

    self._size_standard = self:adaptConfig(cc.size(1136, 640), cc.size(960, 640))

    self._ratio_width = self._size_screen.width / self._size_standard.width
    self._ratio_height = self._size_screen.height / self._size_standard.height

    self._ratio_refer = "h"
end

function Adapt:screenSize()
    return self._size_screen
end

function Adapt:screenAspectRatio()
    return self._aspect_screen
end

function Adapt:currentWidthRatio()
    return self._ratio_width
end

function Adapt:currentHeightRatio()
    return self._ratio_height
end

function Adapt:useWidthRatio()
    self._ratio_refer = "w"
end

function Adapt:useHeightRatio()
    self._ratio_refer = "h"
end

-- 1.66、1.7x定义为宽屏设备
function Adapt:isWideScreen()
    if self._aspect_screen >= 1.6 then
        return true
    end

    return false
end

function Adapt:adaptRatio()
    if self._ratio_refer == "h" then
        return self._ratio_height
    else
        return self._ratio_width
    end
end

function Adapt:adaptConfig(d_iphone5, d_iphone4)
    if self:isWideScreen() then
        return d_iphone5
    else
        return d_iphone4
    end
end

function Adapt:getInstance()
    if not self._instance then
        self._instance = Adapt.new()
    end

    return self._instance
end

zq.Adapt = Adapt

_S = function (mixed)
    local ratio = za.Adapt:getInstance():adaptRatio()
    if type(mixed) == "number" then
        return ratio*mixed;
    elseif type(mixed) == "table" then
        for k,v in pairs(mixed) do
            mixed[k] = v*ratio
        end

        return mixed
    else
        error("_S: unknown mixed", 2)
    end
end

_C = function(d_iphone5, d_iphone4)
    return zq.Adapt:getInstance():adaptConfig(d_iphone5, d_iphone4);
end

return Adapt
