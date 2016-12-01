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

end

function UIImage:init()
    self._image_plist = nil
    self._image_frame = nil
end

function UIImage:setImage(image)
    return self:setFrame(nil, image);
end

function UIImage:setFrame(plist, frame)
    if self._image_plist == plist and self._image_frame == frame then
        return
    end

    local spriteFrame = nil
    if frame then
        if plist then
            spriteFrame =
        else
            --todo
        end

    else

    end

end

return UIImage
