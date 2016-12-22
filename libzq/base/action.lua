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

zq.ActionColor = ActionColor
