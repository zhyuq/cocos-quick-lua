kZYTouchType = {
    None      = 0,
    Began     = 1,
    Moved     = 2,
    Ended     = 3,
    Cancelled = 4
}

local TouchDispatch = class("TouchDispatch")

function TouchDispatch:ctor()
    self._delegates = {}
    self._claimed = {}
    self._limited = {}

    self._position_beg = cc.p(0, 0)
    self._position_pre = cc.p(0, 0)
    self._position_now = cc.p(0, 0)

    self._done = true
    self._time_beg = 0
    self._time_pre = 0
    self._time_now = 0

    self._enabled = true
    self._ignore = false
    self._dirty = false

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    local function onTouchBegan(touch, event)
        return self:onTouchBegan(touch, event)
    end

    local function onTouchMoved(touch, event)
        self:onTouchMoved(touch, event)
    end

    local function onTouchCancelled(touch, event)
        self:onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        self:onTouchEnded(touch, event)
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    self._listener = listener
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )

    eventDispatcher:addEventListenerWithFixedPriority(listener, zq.Int32Max)

end

function TouchDispatch:register(delegate, override)
    override = override or false
    local index = table.indexof(self._delegates, delegate)
    if index then
        if override then
            self:unregister(delegate)
        else
            error("touch: dispatch can't add delegate twice")
        end
    end

    self._dirty = true
    table.insert(self._delegates, delegate)
    self:redraw()

end

function TouchDispatch:unregister(delegate)
    local index = table.indexof(self._delegates, delegate)
    if index then
        table.remove(self._delegates, index)
        self:redraw()
    end

end

function TouchDispatch:unregisterAll()
    self._claimed = {}
    self._delegates = {}
end

function TouchDispatch:update()
    self._dirty = true
end

function TouchDispatch:enable()
    self._enabled = true
end

function TouchDispatch:disable()
    self._enabled = false
    self:flush()
end

function TouchDispatch:isEnabled()
    return self._enabled
end

function TouchDispatch:limit(mixed)
    if mixed then
        if type(mixed) == "table" then
            self._limited = mixed
        else
            self._limited = {}
            table.insert(self._limited, mixed)
        end
    else
        self._limited = {}
    end
end

function TouchDispatch:clear()
    self:flush()
    self:limit()
    self:enable()
end

function TouchDispatch:ignore()
    self._ignore = true
end

function TouchDispatch:order(delegate)
    if self._dirty then
        return -1
    else
        local index = table.indexof(self._delegates, delegate)
        if index then
            return index
        else
            return -1
        end
    end
end

function TouchDispatch:exist(delegate)
    local index = table.indexof(self._delegates, delegate)
    if index then
        return true
    else
        return false
    end
end

function TouchDispatch:positionBeg()
    return cc.p(self._position_beg.x, self._position_beg.y)
end

function TouchDispatch:positionPre()
    return cc.p(self._position_pre.x, self._position_pre.y)
end

function TouchDispatch:positionNow()
    return cc.p(self._position_now.x, self._position_now.y)
end

function TouchDispatch:positionOff()
    return cc.pSub(self._position_now, self._position_beg)
end

function TouchDispatch:positionInc()
    return cc.pSub(self._position_now, self._position_pre)
end

function TouchDispatch:setPositionBeg(position)
    self._position_beg = position
    self._position_pre = position
    self._position_now = position
end

function TouchDispatch:setPositionNow(position)
    self._position_beg = self._position_now
    self._position_now = position
end

function TouchDispatch:timeBeg()
    return self._time_beg
end

function TouchDispatch:timePre()
    return self._time_pre
end

function TouchDispatch:timeNow()
    return self._time_now
end

function TouchDispatch:timeOff()
    return self._time_now - self._time_beg
end

function TouchDispatch:timeInc()
    return self._time_now - self._time_pre
end

function TouchDispatch:setTimeBeg(time)
    self._time_beg = time
    self._time_pre = time
    self._time_now = time
end

function TouchDispatch:setTimeNow(time)
    self._time_pre = self._time_now
    self._time_now = time
end

function TouchDispatch:type()
    return self._type
end

function TouchDispatch:typeIsBegan()
    return self._type == kZYTouchType.Began
end

function TouchDispatch:typeIsMoved()
    return self._type == kZYTouchType.Moved
end

function TouchDispatch:typeIsEnded()
    return self._type == kZYTouchType.Ended
end

function TouchDispatch:typeIsCancelled()
    return self._type == kZYTouchType.Cancelled
end

function TouchDispatch:typeIsFinish()
    return self:typeIsEnded() or self:typeIsCancelled()
end

function TouchDispatch:onTouchBegan(touch, event)
    if not self._done then
        ZQLogD("touch: began but done is false")
        return false
    end

    if not self._enabled then
        ZQLogD("touch: began but enabled is false")
        return false
    end

    if #self._delegates < 1 then
        ZQLogD("touch: began but delegates is nil")
        return false
    end

    self._pass = false
    self._done = false
    self._type = kZYTouchType.Began

    self:sort()
    self:dispatch(touch, event, self._type)

    if #self._claimed <= 0 then
        self._done = true
    end

    if #self._claimed > 0 then
        return true
    end

    return false
end

function TouchDispatch:onTouchMoved(touch, event)
    self._type = kZYTouchType.Moved
    self:dispatch(touch, event, self._type)
end

function TouchDispatch:onTouchCancelled(touch, event)
    self._done = true
    self._type = kZYTouchType.Cancelled
    self:dispatch(touch, event, self._type)
end

function TouchDispatch:onTouchEnded(touch, event)
    self._done = true
    self._type = kZYTouchType.Ended
    self:dispatch(touch, event, self._type)
end

function TouchDispatch:dispatch(touch, event, type)
    if type == kZYTouchType.Began then
        self:setPositionBeg(touch:getLocation())
        self:setTimeBeg(zq.time())

        local delegates = {}
        table.insertto(delegates, self._delegates)
        for i=1, #delegates do
            local obj = delegates[i]
            repeat
                if (not obj:isRunning()) or (#self._limited > 1 and not table.indexof(self._limited, delegates)) then
                    break
                end

                obj:setTouchMoved(false)
                obj:setTouchOutside(false)

                obj:setLocalPositionBeg(obj:convertToNodeSpace(self._position_now))
                if obj:onTouchBegan(touch, event) and not obj:isDestroyed() then
                    if self._ignore then
                        break
                    end

                    table.insert(self._claimed, obj)

                    if obj:touchSwallow() then
                        break
                    end
                end
            until true
        end
        self._ignore = false
    else
        self:setPositionNow(touch:getLocation())
        self:setTimeNow(zq.time())
        for i=1,#self._claimed do
            local obj = self._claimed[i]
            repeat
                if obj:isDestroyed() then
                    break
                end

                obj:setLocalPositionNow(obj:convertToNodeSpace(self._position_now))
                if type == kZYTouchType.Moved then
                    if self._enabled then
                        obj:setTouchMoved(true)
                        obj:setTouchOutside(not obj:containsTouch(touch) or obj:touchOutside())
                        obj:onTouchMoved(touch, event)
                    end
                elseif type == kZYTouchType.Ended or type == kZYTouchType.Cancelled then
                    obj:onTouchEnded(touch, event)
                end
            until true
        end

        if type == kZYTouchType.Ended or type == kZYTouchType.Cancelled then
            self._type = kZYTouchType.None
            self._claimed = {}
        end
    end
end

function TouchDispatch:sort()
    if not self._dirty then
        return
    end

    self._dirty = false
    local store = {}
    local check = function (node)
        local index = table.indexof(self._delegates, node)
        if index and (not node:touchHighest()) then
            table.insert(store, 1, node)
            table.remove(self._delegates, index)
        end
    end

    local visit
    visit = function (node)
        local children = node:getChildren()
        if children and #children > 1 then
            node:sortAllChildren()
            local i = 1
            for i=1, #children do
                local child = children[i]
                if child:getLocalZOrder() < 0 then
                    visit(child)
                else
                    break
                end
            end

            check(node)

            for j=i, #children do
                visit(children[j])
            end
        else
            check(node)
        end
    end

    local scene = ZYWorld:getInstance():scene()
    visit(scene)

    table.insertto(self._delegates, store)

    self:redraw()

end

function TouchDispatch:redraw()
    if not zq.DEBUG then
        return
    end

    for i=1,#self._delegates do
        self._delegates[i]:redraw()
    end
end

function TouchDispatch:getInstance()
    if not self._instance then
        self._instance = TouchDispatch.new()
    end

    return self._instance
end

zq.TouchDispatch = TouchDispatch

return TouchDispatch


