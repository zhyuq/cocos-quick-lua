--[[--

针对 cc.Sprite 的扩展

]]

local c = cc
local Sprite = c.Sprite

function Sprite:setImage(image)
    return self:setFrame(nil, image);
end

function Sprite:setFrame(plist, frame)
    if self._image_plist == plist and self._image_frame == frame then
        return true
    end

    local spriteFrame = nil
    if frame then
        if plist then
            spriteFrame = zq.ZQImageLoader:getInstance():load_frame(plist, frame)
        else
            spriteFrame = zq.ZQImageLoader:getInstance():load_image(frame)
        end

        if not spriteFrame then
            self:clearSprite()
            return false
        end

        self:setSpriteFrame(spriteFrame)
        self:setContentSize(self:getContentSize())
    else
        self:clearSprite()
    end

    return true

end

function Sprite:clearSprite()
    self._image_plist = nil
    self._image_frame = nil
    self:setTexture(nil)
    self:setTextureRect(cc.rect(0, 0, 0, 0))
    self:setContentSize(self:getContentSize())
end

function Sprite:imagePlist()
    return self._image_plist
end

function Sprite:imageFrame()
    return self._image_frame
end



