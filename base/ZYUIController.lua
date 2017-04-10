kZYUIZOrderFlag = {
    Min = -1,
    Def = 0,
    Max = 1
}

ZYUIController = class("ZYUIController", zq.Object)

function ZYUIController:ctor()
    self._windows = {}
end

function ZYUIController:open(cls, exclusive, flag)
    exclusive = exclusive or false
    flag = flag or kZYUIZOrderFlag.Def

    if type(cls) ~= "table" then
        error("controller: open nil class: " .. tostring(cls), 2)
    end

    if exclusive then
        self:closeAll()
    end

    if self:current(cls) then
        error("controller: not allow multi same class" .. tostring(cls), 2)
    end

    local top = self:top()
    if top then
        top:event_background(cls)
    end

    local parent = ZYWorld:getInstance():scene():layerUI()
    local zorder = 0

    local window = cls.new()
    window:setPosition(parent:center())

    if (flag == kZYUIZOrderFlag.Min) then
        zorder = -1
    elseif (flag == kZYUIZOrderFlag.Max) then
        zorder = zq.Int32Max
    else
        if top and (top:getLocalZOrder() == zq.Int32Max) then
            top = nil
            for i = #self._windows-1, 1, -1 do
                local tmp = self._windows[i]
                if tmp:getLocalZOrder() ~= zq.Int32Max then
                    top = tmp
                    break
                end
            end
            if top then
                zorder = top:getLocalZOrder() + 100
            else
                zorder = 100
            end
        end
    end

    ZQLogD("window zorder: %d", zorder)
    parent:addChild(window, zorder)
    table.insert(self._windows, window)

    return window
end

function ZYUIController:current(cls)
    if not cls then
        return self:top()
    end

    for i = #self._windows, 1, -1 do
        local window = self._windows[i]
        if isinstanceof(window, cls) or cls == window then
            return window
        end
    end

    return nil
end

function ZYUIController:count()
   return #self._windows
end

function ZYUIController:exist(...)
    local n = select('#', ...)
    for i = #self._windows, 1, -1 do
        local window = self._windows[i]

        for j = n, 1, -1 do
            local arg = select(j, ...)
            if isinstanceof(window, arg) then
                return true
            end
        end
    end

    return false
end

function ZYUIController:top()
    return self._windows[#self._windows]
end

function ZYUIController:bottom()
    return self._windows[1]
end

function ZYUIController:close(cls)
    local window = self:current(cls)
    if window then
        local idx = table.indexof(self._windows, window)
        local top = idx == #self._windows

        window:removeFromParent(true)
        table.remove(self._windows, idx)

        if top and self:top() then
            self:top():event_foreground(window)
        end

    end
end

function ZYUIController:closeGroup(...)
    local index = -1
    for i=#self._windows, 1, -1 do
        local window = self._windows[i]
        for j=1, select('#', ...) do
            local cls = select(j, ...)
            if isinstanceof(window, cls) then
                if i == #self._windows then
                    index = i
                end

                window:removeFromParent(true)
                table.remove(self._windows, i)
                break
            end
        end
    end

    if index > 0 and self:top() then
        self:top():event_foreground()
    end
end

function ZYUIController:closeExcept(cls)
    local index = -1
    for i=#self._windows,1,-1 do
        local window = self._windows[i]
        if not isinstanceof(window, cls) then
            if i == #self._windows then
                index = i
            end
            window:removeFromParent(true)
            table.remove(self._windows, i)
        end
    end

    if index > 0 and self:top() then
        self:top():event_foreground()
    end
end

function ZYUIController:closeAll()
    for i = #self._windows, 1, -1 do
        local window = self._windows[i]
        window:removeFromParent(true)
    end

    self._windows = {}
end

function ZYUIController:detachAll()
    self._windows = {}
end

function ZYUIController:exist(...)
    local n = select('#', ...)
    for i = #self._windows, 1, -1 do
        local window = self._windows[i]
        for i = n, 1, -1 do
            local arg = select(i, ...)
            if isinstanceof(window, arg) then
                return true
            end
        end
    end

    return false
end

function ZYUIController:getInstance()
    if not self._instance then
        self._instance = ZYUIController.new()
    end

    return self._instance
end

return ZYUIController
