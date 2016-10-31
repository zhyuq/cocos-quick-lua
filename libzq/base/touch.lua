--[[

]]

--------------------------------

--[[--

创建和管理用户界面

]]
local touch = {}

touch.checkTouch = function (node, rect, touchPos)
    local touchPoint = touchPos
    local final_rc = node:rectToWorld(rect)
    local tmpNode = node
    while tmpNode do
        if not tmpNode:isRunning() then
            return false
        end

        if not tmpNode:isVisible() then
            return false
        end

        if tmpNode ~= node and iskindof(tmpNode, "cc.ClippingRectangleNode") then
            if tmpNode:isClippingEnabled() then
                local clipRc = tmpNode:rectToWorld(tmpNode:getClippingRegion())
                final_rc = cc.rectIntersection(final_rc, clipRc)
            end
        end

        tmpNode = tmpNode:getParent()
    end

    if not touchPos or not final_rc then
        return false
    end

    return cc.rectContainsPoint(final_rc, touchPoint)

end

return touch
