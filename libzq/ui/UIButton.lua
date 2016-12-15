--[[--
zq Button控件
-- @classmod UIButton

]]

kUIButtonState = {
    Normal      = 0,
    Selected    = 1,
    Disabled    = 2
}

local UITouch = import(".UITouch")
local UIButton = class("UIButton", UITouch)

function UIButton:ctor()
    UIButton.super.ctor(self)

    self._sp_normal = zq.UIImage.new()
    self._sp_selected = zq.UIImage.new()
    self._sp_disabled = zq.UIImage.new()

    self:addChild(self._sp_normal)
    self:addChild(self._sp_selected)
    self:addChild(self._sp_disabled)

    self._sp_overlay = nil
    self._btn_state = kUIButtonState.Normal
    self._mode_scale_enable = false
    self._mode_scale_scale = 0
    self._mode_scale_origin = 1

    self._mode_allow_disable = false

    self._time_click = 0
end

function UIButton:setImage(folder, normal, selected, disabled)
    selected = selected or normal
    local ok = self._sp_normal.setImage(fif(folder, folder + "/" + normal, normal))
    ok = ok and self._sp_selected.setImage(fif(folder, folder + "/" + normal, normal))
    if disabled then
        ok = ok and self._sp_disabled.setImage(fif(folder, folder + "/" + disabled, disabled))
    elseif disabled == "" then

    end

    if normal then
        self:setContentSize(self._sp_normal:getContentSize())
    elseif selected then
        self:setContentSize(self._sp_selected:getContentSize())
    else
        self:setContentSize(self._sp_disabled:getContentSize())
    end

    self._sp_normal:setAnchorPoint(0.5, 0.5)
    self._sp_normal:setPosition(self:center())

    self._sp_selected:setAnchorPoint(0.5, 0.5)
    self._sp_selected:setPosition(self:center())

    self._sp_disabled:setAnchorPoint(0.5, 0.5)
    self._sp_disabled:setPosition(self:center())

    self:setNormal()

    return ok
end

function UIButton:getSpriteNormal()
    return self._sp_normal
end

function UIButton:getSpriteSelected()
    return self._sp_selected
end

function UIButton:getSpriteDisabled()
    return self._sp_disabled
end

function UIButton:setOverlaySprite(image, tag)
    tag = tag or 0
    if not self._sp_overlay then
        self._sp_overlay = zq.UIImage.new()
        this.addChild(self._sp_overlay)
    end

    self._sp_overlay.setImage(image)
    self._sp_overlay.setTag(tag)
    self._sp_overlay.setAnchorPoint(0.5, 0.5)
    self._sp_overlay.setPosition(self:center())

    return self._sp_overlay
end

function UIButton:getOverlaySprite()
    return self._sp_overlay
end

function UIButton:setNormal()
    self._btn_state = kUIButtonState.Normal
    self._sp_normal.setVisible(true)
    self._sp_selected.setVisible(false)
    self._sp_disabled.setVisible(false)
end

function UIButton:setSelected()
    self._btn_state = kUIButtonState.Selected
    self._sp_normal.setVisible(false)
    self._sp_selected.setVisible(true)
    self._sp_disabled.setVisible(false)
end

function UIButton:setDisabled()
    self._btn_state = kUIButtonState.Disabled
    self._sp_normal.setVisible(false)
    self._sp_selected.setVisible(false)
    self._sp_disabled.setVisible(true)
end

function UIButton:setState(state)
    if state == kUIButtonState.Normal then
        self:setNormal()
    elseif state == kUIButtonState.Selected then
        self:setSelected()
    elseif state == kUIButtonState.Disabled then
        self:setDisabled()
    else
        error("UIButton state error: " .. tostring(state))
    end
end

function UIButton:getButtonState()
    return self._btn_state
end

function UIButton:isNormal()
    return self._btn_state == kUIButtonState.Normal
end

function UIButton:isSelected()
    return self._btn_state == kUIButtonState.Selected
end

function UIButton:isDisabled()
    return self._btn_state == kUIButtonState.Disabled
end

function UIButton:setFlippedX(flippedX)
    local func = tolua.getcfunction(self, "setFlippedX")
    func(self, flippedX)

    self._sp_normal:setFlippedX(flippedX)
    self._sp_selected:setFlippedX(flippedX)
    self._sp_disabled:setFlippedX(flippedX)
end

function UIButton:setFlippedY(flippedY)
    local func = tolua.getcfunction(self, "setFlippedY")
    func(self, flippedY)

    self._sp_normal:setFlippedX(flippedY)
    self._sp_selected:setFlippedX(flippedY)
    self._sp_disabled:setFlippedX(flippedY)
end

function UIButton:setModeScale(enable, scale)
    self._mode_scale_enable = enable
    self._mode_scale_scale = scale

    if (not enable) then
        self:setScale(self._mode_scale_origin)
    end
end

function UIButton:setModeAllowDisable(allow)
    self._mode_allow_disable = allow
end

function UIButton:bindClick(callback)
    self._click_callback = callback
end

function UIButton:bindDBClick(callback)
    self._dbclick_callback = callback
end

function UIButton:bindLongPress(callback, interval)
    self._longpress_callback = callback
    self._longpress_interval = interval or 0
end

function UIButton:bindDelay(callback, interval)
    self._delay_callback = callback
    self._delay_interval = interval or 0
end

function UIButton:bindMoving(callback)
    self._moving_callback = callback
end

function UIButton:bindBegan(callback)
    self._began_callback = callback
end

function UIButton:bindFinish(callback)
    self._finish_callback = callback
end

function UIButton:setClickMusic(music)
    self._click_music = music
end

function UIButton:setDBClickMusic(music)
    self._dbclick_music = music
end

function UIButton:setLongPressMusic(music)
    self._longpress_music = music
end

function UIButton:setDelayMusic(music)
    self._delay_music = music
end

function UIButton:setFinishMusic(music)
    self._finish_music = music
end

function UIButton:allowEmit()
    return not self:isTouchOutside()
end

function UIButton:emitClick()
    if self._click_callback and self:allowEmit() then
        if self._click_music then

        end

        self._click_callback()
    end
end

function UIButton:emitDBClick()
    if self._dbclick_callback and self:allowEmit() then
        if self._dbclick_music then

        end

        self._dbclick_callback()
    end
end

function UIButton:emitLongPress()
    if self._longpress_callback and self:allowEmit() then
        if self._longpress_music then

        end

        self._longpress_callback()
    end
end

function UIButton:emitDelay()
    if self._delay_callback and self:allowEmit() then
        if self._delay_music then

        end

        self._delay_callback()
    end
end

function UIButton:emitMoving()
    if self._moving_callback then
        if self._moving_music then

        end

        self._moving_callback()
    end
end

function UIButton:emitBegan()
    if self._began_callback then
        if self._began_music then

        end

        self._began_callback()
    end
end

function UIButton:emitFinish()
    if self._finish_callback then
        if self._finish_music then

        end

        self._finish_callback()
    end
end

function UIButton:allowTouch()
    return not self:isDisabled() or self._mode_allow_disable
end

function UIButton:touchDone(touch)
    local now = zq.time()
    local off = now - self._time_click
    self:unschedule(self.emitClick)

    if self._mode_scale_enable then
        self:setScale(self._mode_scale_origin)
    end

    if self._delay_callback and self:getTimeOff() >= self._delay_interval then
        return
    end

    if not self._dbclick_callback then
        self:emitClick()
    elseif self._time_click ~= 0 and off <= 0.27 then
        self._time_click = 0
        self:emitDBClick()
    elseif self:allowEmit() then
        self._time_click = zq.time()
        self.scheduleOnceMemberFun(self.emitClick, 0.27)
    end
end

function UIButton:onTouchBegan(touch)
    if self:allowTouch() and self:containsTouch(touch) then
        self:emitBegan()

        if self._longpress_callback then
            self:scheduleMemberFun(self.emitLongPress, self._longpress_interval)
        end

        if self._delay_callback then
            self:scheduleOnceMemberFun(self.emitDelay, self._delay_interval)
        end

        if not self:isDisabled() then
            self:setSelected()
        end

        if self._mode_scale_enable then
            self._mode_scale_origin = self:getScale()
            self:setScale(self._mode_scale_scale)
        end

        return true
    end

    return false
end

function UIButton:onTouchMoved(touch)
    self:unschedule(self.emitDelay)
    if not self:allowTouch() then
        return
    end

    if not self:isNormal() and not self:isDisabled() and not self._moving_callback and self:isTouchOutside() then
        self:setNormal()
    end

    self:emitMoving()
end

function UIButton:onTouchEnded(touch)
    self:unschedule(self.emitLongPress)
    self:unschedule(self.emitDelay)

    if not self:allowTouch() then
        self:emitFinish()
    else
        if not self:isDisabled() then
            self:setNormal()
            self:touchDone(touch)
            self:emitFinish()
        end
    end
end




return UIButton
