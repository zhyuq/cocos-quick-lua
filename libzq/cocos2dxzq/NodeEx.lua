--[[--

针对 cc.Node 的扩展

]]

local c = cc
local Node = c.Node

function Node:scheduleMemberFun(callback, interval)
    if not self._schedule_callback_list then
        self._schedule_callback_list = {}
    end

    local wrapper = nil
    local callback_action = nil
    for i, v in ipairs(self._schedule_callback_list) do
        local  single = v
        if (v["callback_fn"] == callback) then
            wrapper = v["wrapper"]
            callback_action = v["action"]
            table.remove(self._schedule_callback_list, i)
            break
        end
    end

    if wrapper then
        self:stopAction(callback_action)
    end

    wrapper = handler(self, callback)
    local seq = transition.sequence({
        cc.DelayTime:create(interval),
        cc.CallFunc:create(wrapper),
    })
    local action = cc.RepeatForever:create(seq)
    self:runAction(action)
    table.insert(self._schedule_callback_list, {
        ["callback_fn"] = callback,
        ["wrapper"] = wrapper,
        ["action"] = action
        })

    return action
end

function Node:scheduleOnceMemberFun(callback, delay)
    if not self._schedule_callback_list then
        self._schedule_callback_list = {}
    end

    local wrapper = nil
    local callback_action = nil
    for i, v in ipairs(self._schedule_callback_list) do
        local  single = v
        if (v["callback_fn"] == callback) then
            wrapper = v["wrapper"]
            callback_action = v["action"]
            table.remove(self._schedule_callback_list, i)
            break
        end
    end

    if not tolua.isnull(callback_action) then
        self:stopAction(callback_action)
    end

    wrapper = handler(self, callback)
    local action = transition.sequence({
        cc.DelayTime:create(delay),
        cc.CallFunc:create(wrapper),
    })
    self:runAction(action)
    table.insert(self._schedule_callback_list, {
        ["callback_fn"] = callback,
        ["wrapper"] = wrapper,
        ["action"] = action
        })

    return action
end

function Node:unschedule(callback_fn)
    if not self._schedule_callback_list then
        return
    end

    local wrapper = nil
    local callback_action = nil
    for i, v in ipairs(self._schedule_callback_list) do
        local  single = v
        if (v["callback_fn"] == callback_fn) then
            wrapper = v["wrapper"]
            callback_action = v["action"]
            table.remove(self._schedule_callback_list, i)
            break
        end
    end

    if not tolua.isnull(callback_action) then
        self:stopAction(callback_action)
    end
end

function Node:getWidth()
    return self:getContentSize().width
end

function Node:getHeight()
    return self:getContentSize().height
end

function Node:setWidth(width)
    self:setContentSize(width, self:getHeight())
end

function Node:setHeight(height)
    self:setContentSize(self:getWidth(), height)
end

function Node:getTransformSize()
    local rect = self:getBoundingBox()
    return cc.size(rect.width, rect.height)
end

function Node:getTransformWidth()
    return self:getBoundingBox().width
end

function Node:getTransformHeight()
    return self:getBoundingBox().heigth
end

function Node:getTransformPoint(point)
    local origin = self:getContentSize()
    local percent = cc.p(point.x*origin.width, point.y*origin.height)
    local transform = self:getTransformSize()
    return cc.p(percent.x*transform.widht, percent.y*transform.height)
end

function Node:setX(x)
    self:setPositionX(x)
end

function Node:setY(y)
    self:setPositionY(y)
end

function Node:getX()
    self:getPositionX()
end

function Node:getY()
    self:getPositionY()
end

function Node:incX(delta)
    self:setX(self:getX() + delta)
end

function Node:incY(delta)
    self:setY(self:getY() + delta)
end

function Node:getRect()
    local size = self:getContentSize()
    return cc.rect(0, 0, size.width, size.height)
end

function Node:getTop()
    return self:getY() + (1 - self:getAnchorPoint().y) * self:getTransformHeight()
end

function Node:getRight()
    return self:getX() + (1 - self:getAnchorPoint().x) * self:getTransformWidth()
end

function Node:getBottom()
    return self:getY() - self:getAnchorPoint().y * self:getTransformHeight()
end

function Node:getLeft()
    return self:getX() - self:getAnchorPoint().x * self:getTransformWidth()
end

function Node:center()
    local size = self:getContentSize();
    return cc.p(size.width * 0.5, size.height * 0.5)
end

function Node:centerX()
    return self:getWidth()*0.5
end

function Node:centerY()
    return self:getHeight()*0.5
end

function Node:halfPosition()
    local size = self:getTransformSize();
    local pos  = self:getPosition();
    local ar   = self:getAnchorPoint();
    return cc.p(pos.x + (0.5 - ar.x) * size.width, pos.y + (0.5 - ar.y) * size.height);
end

function Node:halfPositionX()
    return self:halfPosition().x
end

function Node:halfPositionY()
    return self:halfPosition().y
end

function Node:pointToWorld(point)
    return self:convertToWorldSpace(point)
end

function Node:sizeToWorld(size)
    return cc.sizeApplyAffineTransform(size, self:getNodeToWorldAffineTransform())
end

function Node:rectToWorld(rect)
    local origin = self:convertToWorldSpace(cc.p(rect.x, rect.y))
    local size = self:sizeToWorld(cc.size(rect.width, rect.height))
    return cc.rect(origin.x, origin.y, size.width, size.height)
end

function Node:stopAllChildrenActions()
    self:stopAllActions()
    local child = self:getChildren()
    for i,v in ipairs(child) do
        v.stopAllChildrenActions()
    end
end

function Node:unscheduleAllChildren()
    self:unscheduleAllCallbacks()
    local child = self:getChildren()
    for i,v in ipairs(child) do
        v.unscheduleAllChildren()
    end
end

function Node:setChildrenCascadeOpacity(enable)
    self:setCascadeOpacityEnabled(enable)
    local child = self:getChildren()
    for i,v in ipairs(child) do
        v.setChildrenCascadeOpacity(enable)
    end
end

function Node:enableDebugDrawRect(enable, random, anchor)
    if self._debug_draw_rect_enable_ == enable then
        return
    end

    self._debug_draw_rect_enable_ = enable
    self._debug_draw_rect_color_ = self._debug_draw_rect_color_ or cc.c4f(1, 0, 0, 1)
    self._debug_draw_rect_anchor_ = anchor or false
    self._debug_draw_rect_size_ = self._debug_draw_rect_size_ or cc.size(0, 0)
    if not self._debug_draw_rect_node_ then
        self._debug_draw_rect_node_ = cc.DrawNode:create()
        self._debug_draw_rect_node_:setAnchorPoint(cc.p(0, 0))
        self._debug_draw_rect_node_:setPosition(cc.p(0, 0))
        self:addChild(self._debug_draw_rect_node_, zq.Int32Max)
    end

    self._debug_draw_rect_node_:setVisible(enable)
    if random then
        self._debug_draw_rect_color_ = cc.c4f(math.random(), math.random(), math.random(), 1)
    end

    if (not enable) then
        return
    end

    if self._debug_draw_rect_handle_ then
        self:stopAction(self._debug_draw_rect_handle_)
    end

    self._debug_draw_rect_handle_ = self:schedule(handler(self, self.debugDrawCallFunc), 0)

end

function Node:debugDrawCallFunc()
    if cc.sizeEqualToSize(self._debug_draw_rect_size_, self:getContentSize()) then
        return
    end

    self._debug_draw_rect_size_ = self:getContentSize()
    local points = {
        cc.p(0, 0),
        cc.p(0, self._debug_draw_rect_size_.height),
        cc.p(self._debug_draw_rect_size_.width, self._debug_draw_rect_size_.height),
        cc.p(self._debug_draw_rect_size_.width, 0)
    }

    local params = {}
    params.borderWidth = 0.6
    params.borderColor = self._debug_draw_rect_color_
    params.fillColor = cc.c4f(0,0,0,0)
    self._debug_draw_rect_node_:clear()
    self._debug_draw_rect_node_:drawPolygon(points, params)

    if self._debug_draw_rect_anchor_ then
        local anchorXPos = self:getAnchorPoint().x*self._debug_draw_rect_size_.width
        local anchorYPos = self:getAnchorPoint().y*self._debug_draw_rect_size_.height
        local points = {
            cc.p(anchorXPos-3, anchorYPos-3),
            cc.p(anchorXPos-3, anchorYPos+3),
            cc.p(anchorXPos+3, anchorYPos+3),
            cc.p(anchorXPos+3, anchorYPos-3)
        }

        self._debug_draw_rect_node_:drawPolygon(points, params)
    end
end

function Node:setDebugDrawColor(intColor)
    self._debug_draw_rect_color_ = zq.color.intToc4f(intColor)
end


