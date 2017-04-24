ZYUIView = class("ZYUIView", zq.UITouch)

function ZYUIView:ctor()
    ZYUIView.super.ctor(self)

    self:setContentSize(cc.Director:getInstance():getWinSize())

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
end

function ZYUIView:hideKeyboard()
    zq.ZQDeviceInfo:getInstance():keyboard_close()
end

function ZYUIView:dragdrop()
    if not self._dragdrop then
        self._dragdrop = zq.UIDragDrop.new()
        self._dragdrop:setAnchorPoint(0, 0)
        self._dragdrop:setPosition(0, 0)
        self:addChild(self._dragdrop, zq.Int32Max)
    end

    return self._dragdrop
end

function ZYUIView:onEnter()

end

function ZYUIView:onExit()

end

function ZYUIView:bindEventBackground(callback)
    self._background_callback = callback
end

function ZYUIView:bindEventForeground(callback)
    self._foreground_callback = callback
end

function ZYUIView:onTouchBegan(touch)
    return self:isRunning() and self:isVisible()
end

function ZYUIView:onTouchEnded(touch)

end

function ZYUIView:event_close()
    -- implement in derived class
end

function ZYUIView:event_background()
    if self._background_callback then
        self._background_callback()
    end
end

function ZYUIView:event_foreground()
    if self._foreground_callback then
        self._foreground_callback()
    end
end

return ZYUIView
