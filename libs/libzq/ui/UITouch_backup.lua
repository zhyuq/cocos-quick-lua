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
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))

    self._touchAreaRect = nil
    self._lpositionBeg = cc.p(0, 0)
    self._lpositionPre = cc.p(0, 0)
    self._lpositionNow = cc.p(0, 0)
    self._worldpositionBeg = cc.p(0, 0)
    self._worldpositionPre = cc.p(0, 0)
    self._worldpositionNow = cc.p(0, 0)
    self._timeBeg      = 0
    self._timePre      = 0
    self._timeNow      = 0
    self._timeOff      = 0

    self._touchOutside = false
end

function UITouch:containsTouch(touch)
    return self:containsPoint(touch["nowPos"])
end

function UITouch:containsPoint(point)
    local rc = self:getTouchAreaRect()
    return zq.Touch.checkTouch(self, rc, point)
end

function UITouch:isTouchOutside()
    return self._touchOutside
end

function UITouch:setTouchOutside(bOutside)
    self._touchOutside = bOutside
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

function UITouch:getTouchAreaRect()
    if self._touchAreaRect then
        return cc.rect(this._touchAreaRect.x, this._touchAreaRect.y, this._touchAreaRect.width, this._touchAreaRect.height)
    else
        local size = self:getContentSize()
        return cc.rect(0, 0, size.width, size.height)
    end
end

--- touch position
function UITouch:setWorldTouchPosition(touch)
    self._worldpositionBeg = touch["startPos"]
    self._worldpositionPre = touch["prevPos"]
    self._worldpositionNow = touch["nowPos"]
end

function UITouch:getWorldPositionNow()
    return cc.p(self._worldpositionNow.x, self._worldpositionNow.y)
end

function UITouch:setLocalPosition(touch)
    self._lpositionBeg = self:convertToNodeSpace(touch["startPos"])
    self._lpositionPre = self:convertToNodeSpace(touch["prevPos"])
    self._lpositionNow = self:convertToNodeSpace(touch["nowPos"])
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

function UITouch:getLocalPositionBeg()
    return cc.p(self._lpositionBeg.x, self._lpositionBeg.y)
end

function UITouch:getLocalPositionPre()
    return cc.p(self._lpositionPre.x, self._lpositionPre.y)
end

function UITouch:getLocalPositionNow()
    return cc.p(self._lpositionNow.x, self._lpositionNow.y)
end

function UITouch:getLocalPositionDelta()
    return cc.pSub(self._lpositionNow, self._lpositionPre)
end

--- touch time
function UITouch:setTouchTime(touch)
    self._timeBeg = touch["startTime"]
    self._timePre = touch["prevTime"]
    self._timeNow = touch["nowTime"]
    self._timeOff = touch["offTime"]
end

function UITouch:getTimeBeg()
    return self._timeBeg
end

function UITouch:getTimePrev()
    return self._timePre
end

function UITouch:getTimeNow()
    return self._timeNow
end

function UITouch:getTimeOff()
    return self._timeOff
end

function UITouch:onTouchBegan(touch)
    return self:containsPoint(touch["nowPos"])
end

function UITouch:onTouchMoved(touch)

end

function UITouch:onTouchCancelled(touch)

end

function UITouch:onTouchEnded(touch)

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

return UITouch
