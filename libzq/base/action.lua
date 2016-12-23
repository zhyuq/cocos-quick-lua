local ActionColor = class("ActionColor", zq.CustomAction)

function ActionColor:ctor(duration, color_from, color_to)
    ActionColor.super.ctor(self)
    self:initWithDuration(duration, color_from, color_to)
end

function ActionColor:initWithDuration(duration, color_from, color_to)
    ActionColor.super.initWithDuration(self, duration)
    self._color_from = color_from
    self._color_to  = color_to
end

function ActionColor:startWithTarget()
    self:step(0)
end

function ActionColor:update(percent)
    local node = self:getTarget()

    local red   = (self._color_to.r - self._color_from.r)*percent + self._color_from.r
    local green = (self._color_to.g - self._color_from.g)*percent + self._color_from.g
    local blue  = (self._color_to.b - self._color_from.b)*percent + self._color_from.b
    node:setColor(cc.c3b(red, green, blue))
end

function ActionColor:create(duration, color_from, color_to)
    return zq.ActionColor.new(duration, color_from, color_to)
end

zq.ActionColor = ActionColor
-- zq.ActionColor.create = function (duration, color_from, color_to)
--     return zq.ActionColor.new(duration, color_from, color_to)
-- end

---transition.actionColor(sprite, {color_from = cc.c3b(0, 0, 0), color_to = cc.c3b(255, 200, 300), time = 1.5})
transition.actionColor = function (target, args)
    assert(not tolua.isnull(target), "transition.actionColor() - target is not cc.Node")
    local action = zq.ActionColor:create(args.time, args.color_from, args.color_to)
    return transition.execute(target, action, args)
end

cca.actionColor = function (dt, color_from, color_to)
    return zq.ActionColor:create(dt, color_from, color_to)
end

local ActionTween = class("ActionTween", zq.CustomAction)

function ActionTween:ctor(duration, key, from, to, ...)
    ActionTween.super.ctor(self)
    self:initWithDuration(duration, key, from, to, ...)
end

function ActionTween:initWithDuration(duration, key, from, to, ...)
    ActionTween.super.initWithDuration(self, duration)
    self._tween_key     = key
    self._tween_from    = from
    self._tween_to      = to
    self._tween_args    = {...}
end

function ActionTween:startWithTarget()
    self:step(0)
end

function ActionTween:update(percent)
    local node = self:getTarget()

    local value = (self._tween_to - self._tween_from)*percent + self._tween_from
    node[self._tween_key](node, value, unpack(self._tween_args))
end

function ActionTween:create(duration, key, from, to, ...)
    return zq.ActionTween.new(duration, key, from, to, ...)
end

zq.ActionTween = ActionTween

---transition.actionTween(sprite, {key = "function_name", from = 1, to = 5, time = 1.5})
transition.actionTween = function (target, args, ...)
    assert(not tolua.isnull(target), "transition.actionTween() - target is not cc.Node")
    local action = zq.ActionTween:create(args.time, args.key, args.from, args.to, ...)
    return transition.execute(target, action, args)
end

cca.actionTween = function (duration, key, from, to, ...)
    return zq.ActionTween:create(duration, key, from, to, ...)
end

