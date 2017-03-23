-- --[[--

-- 针对 zq.ZQCustomAction 的扩展
-- ]]

local ZQCustomAction = zq.ZQCustomAction

function ZQCustomAction:initWithDuration(duration)
    local func = tolua.getcfunction(self, "initWithDuration")
    if func then
        func(self, duration)
    end
end

function ZQCustomAction:startWithTarget()

end

function ZQCustomAction:update(percent)

end

function ZQCustomAction:registerScriptListener()
    local func = tolua.getcfunction(self, "registerScriptListener")

    if self._baseEventListener then return end
    self._baseEventListener = function(event)
        if event.name == "startWithTarget" then
            self:startWithTarget()
        elseif event.name == "update" then
            self:update(event.time)
        end
    end

    if func then
        func(self, self._baseEventListener)
    end

end


local CustomAction = class("CustomAction", function ()
    return zq.ZQCustomAction:create()
end)

function CustomAction:ctor()
    self:registerScriptListener()
end

function CustomAction:initWithDuration(duration)
    local func = tolua.getcfunction(self, "initWithDuration")
    if func then
        func(self, duration)
    end
end

function CustomAction:startWithTarget()
    self:step(0)
end

function CustomAction:update(percent)

end

zq.CustomAction = CustomAction
