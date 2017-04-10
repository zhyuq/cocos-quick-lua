ZYUIPopup = class("ZYUIPopup", ZYUIView)

function ZYUIPopup:ctor()
    ZYUIPopup.super.ctor(self)
end

function ZYUIPopup:buildBackground(image)
    if not self._w_back then
        self._w_back = zq.UIImage.new()
        self._w_back:setAnchorPoint(0, 0)
        self._w_back:setPosition(0, 0)
        self:addChild(self._w_back)
    end

    self._w_back:setImage(image)
    self:setContentSize(self._w_back:getContentSize())
end

function ZYUIPopup:spriteBack()
    return self._w_back
end

function ZYUIPopup:event_close()
    ZYUIController:getInstance():close(self)
end

return ZYUIPopup
