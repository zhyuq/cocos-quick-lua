ZYWorld = class("ZYWorld", zq.Object)

function ZYWorld:ctor()

end

function ZYWorld:setup()
    ZQLogE("world: start")
end

function ZYWorld:start()
    self:setup()


end

function ZYWorld:change(cls, callback, transition)
    transition = transition or true

    local old = self._scene
    local time = fif(transition, 0.3, 0)

    self._scene = cls.new()
    if (old and transition) then
        display.replaceScene(self._scene, "fade", time, cc.c3b(0, 0, 0))
    else
        display.replaceScene(self._scene)
    end

    self._scene:init()

    if callback then

    end

    return self._scene
end

function ZYWorld:scene(...)
    local n = select('#', ...)
    if (n == 0) then
        return self._scene
    end

    for i = n, 1, -1 do
        local arg = select(i, ...)
        if isinstanceof(self._scene, arg) then
            return self._scene
        end
    end

    return nil
end

function ZYWorld:exist(...)
    local n = select('#', ...)
    for i = n, 1, -1 do
        local arg = select(i, ...)
        if isinstanceof(self._scene, arg) then
            return self._scene
        end
    end

    return nil
end

function ZYWorld:getInstance()
    if not self._instance then
        self._instance = ZYWorld.new()
    end

    return self._instance
end

return ZYWorld
