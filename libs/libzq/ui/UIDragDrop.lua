--[[--

]]

local UIDragDrop = class("UIDragDrop", zq.UITouch)

function UIDragDrop:ctor()
    UIDragDrop.super.ctor(self)

    self._delegates = {}
    self._detectInterval = 0.05
    self._detectDisInterval = 5
    self._detectNextTime = zq.time()

    self:setTouchSwallowEnabled(false)
end

function UIDragDrop:onExit()

end

function UIDragDrop:register(node)
    if table.indexof(self._delegates, node) then
        error("drag drop can't register twice: " .. tostring(node:classname()))
    end

    table.insert(self._delegates, node)
end

function UIDragDrop:unregister(node)
    local index = table.indexof(self._delegates, node)
    if index then
        table.remove(self._delegates, index)
    end
end

function UIDragDrop:unregisterAll()
    for i=#self._delegates,1,-1 do
        table.remove(self._delegates, i)
    end
end

function UIDragDrop:ignore(ignore)
    self._ignore = ignore
end

function UIDragDrop:isDragging()
    return self._dragging
end

function UIDragDrop:onTouchBegan(touch)
    self._dragging = false
    if (not self:isRunning()) or (not self:detectSource(touch)) then
        return false
    end

    if #self._delegates > 0 then
        return true
    else
        return false
    end
end

function UIDragDrop:onTouchMoved(touch)
    if self._ignore then
        return
    end

    if not self:pushSourceInfo(touch) then
        return
    end

    self:moveImage(touch)

    if self._detectNextTime < zq.time() then
        self._detectNextTime = zq.time() + self._detectInterval
        self:scheduleOnce(function ( ... )
            if not self._detectPreTouch then
                return
            end

            if self._source.dragging then
                self._source:dragging(self._source, self._target)
            end

            if not self:detectTarget() then
                return
            end

            if self._target.dragging then
                self._target:dragging(self._source, self._target)
            end

            if self._detectPreTouch then
                self._detectPreTouch = nil
            end
        end, self._detectInterval+0.01)

        if self._source.dragging then
            self._source:dragging(self._source, self._target)
        end

        if (not self._detectDisPreTouch) or cc.pGetDistance(self._detectDisPreTouch, touch["nowPos"]) > self._detectDisInterval then
            self._detectDisPreTouch = cc.p(touch["nowPos"].x, touch["nowPos"].y)
            if not self:detectTarget(touch, true) then
                return
            end
        else
            return
        end

        if self._target.dragging then
            self._target:dragging(self._source, self._target)
        end

        if self._detectDisPreTouch then
            self._detectDisPreTouch = nil
        end
    else
        self._detectPreTouch = cc.p(touch["nowPos"].x, touch["nowPos"].y)
    end
end

function UIDragDrop:onTouchEnded(touch)
    self:touchDone(touch)
end

function UIDragDrop:touchDone(touch)
    self:detectTarget(touch)

    local on_source = false
    if self._source then
        on_source = self:checkOverlap(self._source)
    end

    if self._target and not self._ignore then
        self._target:dragEnd(self._source, self._target, on_source)
    end

    if self._source and not self._ignore then
        self._source:dragEnd(self._source, self._target, on_source)
        self:popSourceInfo()
    end

    self:clear()
end

function UIDragDrop:detectSource(touch)
    if self._source then
        return true
    end

    for i=1,#self._delegates do
        local node = self._delegates[i]
        if node:isVisible() then
            local info = zq.UIDragDropInfo.new()
            info:setTouch(touch)

            node:allowDrag(info)

            if info:image() then
                ZQLogD("detectSource .... ")
                info:setPlace(node)
                self._image = info:image()
                self._source = node
                self._info = info

                local layer = ZYWorld:getInstance():scene():layerUI()
                self._image:setVisible(false)
                layer:addChild(self._image, zq.Int32Max)

                return true
            end
        end
    end

    return false
end

function UIDragDrop:moveImage(touch)
    ZQLogD("touch posX %d", touch["nowPos"].x)
    ZQLogD("touch posY %d", touch["nowPos"].y)
    self._image:setPosition(touch["nowPos"])
end

function UIDragDrop:pushSourceInfo(touch)
    if self._image:isVisible() then
        return true
    end

    self._source:dragStart(touch, self._image)
    self._image:setVisible(true)

    if self._info:scale() ~= 1.0 then
        transition.scaleTo(self._image, {scale = self._image:getScale()*self._info:scale(), time = 0.04})
    end

    self._dragging = true
    self._info:setPlace(self._source)

    return true
end

function UIDragDrop:popSourceInfo()

end

function UIDragDrop:detectTarget(touch, dragging)
    if self._target then
        if not self:checkOverlap(self._target) then
            if self._source.draggingLeave then
                self._source:draggingLeave(self._source, self._target)
            end

            if self._target.dragging then
                self._target:dragging(nil, self._target)
            end

            self._target = nil
        end
    end

    for i=1,#self._delegates do
        local node = self._delegates[i]
        if node:isVisible() then
            if (node == self._source) or (dragging and (not node.dragging)) then

            else
                if self:checkOverlap(node) then
                    if self._target and self._target ~= node and self._target.dragging then
                        self._target:dragging(nil, self._target)
                    end

                    self._target = node

                    -- emit enter
                    if self._target.dragging then
                        self._target:dragging(self._source, self._target)
                    end

                    return true
                end
            end
        end
    end

    return false
end


function UIDragDrop:checkOverlap(node)
    if not self._image then
        return false
    end

    local point = self._image:pointToWorld(self._info:getOverlapPos())
    if node.containsPoint then
        return node:containsPoint(point)
    else
        return zq.Touch.checkTouch(node, cc.rect(0, 0, node:getWidth(), node:getHeight()), point)
    end
end

function UIDragDrop:detectInterval()
    return self._detectInterval
end

function UIDragDrop:setDetectInterval(detectInterval)
    self._detectInterval = detectInterval
end

function UIDragDrop:setDetectDisInterval(detectDisInterval)
     self._detectDisInterval = detectDisInterval;
end

function UIDragDrop:clear()
    if self._image then
        self._image:removeFromParent(true)
    end

    self:unscheduleAllCallbacks()
    self._info = nil
    self._image = nil
    self._source = nil
    self._target = nil
    self._ignore = false
end

return UIDragDrop
