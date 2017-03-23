--[[

--]]
local c = cc

c.affineTransformMake = function (a, b, c, d, tx, ty)
    local t = {a = a, b = b, c = c, d = d, tx = tx, ty = ty}
    return t
end

c.pointApplyAffineTransform = function(point, t)
    local x = t.a*point.x + t.c*point.y + t.tx
    local y = t.b*point.x + t.d*point.y + t.ty
    return cc.p(x, y)
end

c.sizeApplyAffineTransform = function (size, t)
    local width = t.a*size.width + t.c*size.height
    local height = t.b*size.height + t.d*size.height
    return cc.size(width, height)
end
