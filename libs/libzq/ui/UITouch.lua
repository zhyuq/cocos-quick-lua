--[[--
zq UITouch
-- @classmod UITouch

]]



local UIImage = import(".UIImage")
local UITouch = class("UITouch", UIImage)

--------------------------------
-- UIImage构建函数
-- @function ctor
function UITouch:ctor()
    UITouch.super.ctor(self)
    -- self:setTouchEnabled(true)
    -- self:setTouchSwallowEnabled(true)
    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))

    self._touchAreaRect = nil
    self._lpositionBeg = cc.p(0, 0)
    self._lpositionPre = cc.p(0, 0)
    self._lpositionNow = cc.p(0, 0)
    -- self._worldpositionBeg = cc.p(0, 0)
    -- self._worldpositionPre = cc.p(0, 0)
    -- self._worldpositionNow = cc.p(0, 0)
    -- self._timeBeg      = 0
    -- self._timePre      = 0
    -- self._timeNow      = 0
    -- self._timeOff      = 0

    self._touch_outside = false
    self._touch_swallow = true

    self:setTouchEnabled(true)
end

function UITouch:touchEnabled()
    return self._touch_enabled
end

function UITouch:touchSwallow()
    return self._touch_swallow
end

function UITouch:touchHighest()
    return self._touch_highest
end

function UITouch:touchOrder()
    return zq.TouchDispatch:getInstance():order(self)
end

function UITouch:touchMoved()
    return self._touch_moved
end

function UITouch:touchOutside()
    return self._touch_outside
end

function UITouch:touchPosition()
    return self:worldPositionNow()
end

function UITouch:localPositionBeg()
    return cc.p(self._lpositionBeg.x, self._lpositionBeg.y)
end

function UITouch:localPositionPre()
    return cc.p(self._lpositionPre.x, self._lpositionPre.y)
end

function UITouch:localPositionNow()
    return cc.p(self._lpositionNow.x, self._lpositionNow.y)
end

function UITouch:localPositionInc()
    return cc.pSub(self._lpositionNow, self._lpositionPre)
end

function UITouch:worldPositionBeg()
    return zq.TouchDispatch:getInstance():positionBeg()
end

function UITouch:worldPositionPre()
    return zq.TouchDispatch:getInstance():positionPre()
end

function UITouch:worldPositionNow()
    return zq.TouchDispatch:getInstance():positionNow()
end

function UITouch:worldPositionOff()
    return zq.TouchDispatch:getInstance():positionOff()
end

function UITouch:worldPositionInc()
    return zq.TouchDispatch:getInstance():positionInc()
end

function UITouch:touchTimeBeg()
    return zq.TouchDispatch:getInstance():timeBeg()
end

function UITouch:touchTimePre()
    return zq.TouchDispatch:getInstance():timePre()
end

function UITouch:touchTimeNow()
    return zq.TouchDispatch:getInstance():timeNow()
end

function UITouch:touchTimeOff()
    return zq.TouchDispatch:getInstance():timeOff()
end

function UITouch:touchAreaRect()
    if self._touchAreaRect then
        return cc.rect(this._touchAreaRect.x, this._touchAreaRect.y, this._touchAreaRect.width, this._touchAreaRect.height)
    else
        local size = self:getContentSize()
        return cc.rect(0, 0, size.width, size.height)
    end
end

function UITouch:setTouchEnabled(enable)
    self._touch_enabled = enable
    if self:isRunning() then
        if self._touch_enabled then
            zq.TouchDispatch:getInstance():register(self, true)
        else
            zq.TouchDispatch:getInstance():unregister(self)
        end
    end
end

function UITouch:setTouchSwallow(swallow)
    self._touch_swallow = swallow
end

function UITouch:setTouchMoved(moved)
    self._touch_moved = moved
end

function UITouch:setTouchOutside(outside)
    self._touch_outside = outside
end

function UITouch:setTouchAreaRect(x, y, width, height)
    if type(x) == "table" then
        self._touchAreaRect = x
    else
        self._touchAreaRect = cc.rect(x, y, width, height)
    end
end

function UITouch:zoomTouchAreaRect(factorX, factorY)
    factorY = factorY or factorX
    local size = self:getContentSize()
    local width = size.width*factorX
    local height = size.height*factorY
    self:setTouchAreaRect((size.width-width)*0.5, (size.height-height)*0.5, width, height)
end

function UITouch:setLocalPositionBeg(position)
    self._lpositionBeg = position;
    self._lpositionPre = position;
    self._lpositionNow = position;
end

function UITouch:setLocalPositionNow(position)
    self._lpositionPre = self._lpositionNow
    self._lpositionNow = position;
end

function UITouch:containsTouch(touch)
    return self:containsPoint(touch:getLocation())
end

function UITouch:containsPoint(point)
    local rc = self:touchAreaRect()
    return zq.Touch.checkTouch(self, rc, point)
end

function UITouch:onEnter()
    UITouch.super.onEnter(self)
    if self._touch_enabled and (not zq.TouchDispatch:getInstance():exist(self)) then
        zq.TouchDispatch:getInstance():register(self)
    end
end

function UITouch:onExit()
     UITouch.super.onExit(self)
    if self._touch_enabled then
        zq.TouchDispatch:getInstance():unregister(self)
    end
end

function UITouch:onTouchBegan(touch, event)
    return self:containsTouch(touch)
end

function UITouch:onTouchMoved(touch, event)

end

function UITouch:onTouchCancelled(touch, event)

end

function UITouch:onTouchEnded(touch, event)

end

function UITouch:onTouch_(event)
    local name, x, y = event.name, event.x, event.y
    local touch = {
        name = event.name,
        nowPos = cc.p(event.x, event.y),
        prevPos = cc.p(event.prevX, event.prevY),
        startPos = cc.p(event.startX, event.startY),
        startTime = event.startTime, prevTime = event.prevTime,
        nowTime = event.nowTime, offTime = event.offTime
    }

    -- time
    self:setTouchTime(touch)
    self:setWorldTouchPosition(touch)
    self:setLocalPosition(touch)

    if name == "began" then
        return self:onTouchBegan(touch)
    elseif name == "moved" then
        self:setTouchOutside(not self:containsTouch(touch) or self:isTouchOutside())
        self:onTouchMoved(touch)
    elseif name == "cancelled" then
        self:onTouchEnded(touch)
    elseif name == "ended" then
        self:onTouchEnded(touch)
    end
end

function UITouch:redraw()

end

return UITouch
