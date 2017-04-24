--[[--

]]

local UIDragDropInfo = class("UIDragDropInfo")

function UIDragDropInfo:ctor()
    self._image = nil
    self._scale = 1.0
    self._touch = nil
    self._place = false
    self._overlap_pos = nil
end

function UIDragDropInfo:image()
    return self._image
end

function UIDragDropInfo:setImage(image)
    self._image = image
end

function UIDragDropInfo:scale()
    return self._scale
end

function UIDragDropInfo:setScale(scale)
    self._scale = scale
end

function UIDragDropInfo:touch()
    return self._touch
end

function UIDragDropInfo:setTouch(touch)
    self._touch = touch
end

function UIDragDropInfo:place()
    return self._place
end

function UIDragDropInfo:setPlace(refer)
    if self._place then
        return
    end

    if refer then
        local point = refer:convertToNodeSpace(self._touch["nowPos"])
        point.x = fif(refer:getWidth() > 0, point.x / refer:getWidth(), 0.5)
        point.y = fif(refer:getHeight() > 0, point.y / refer:getHeight(), 0.5)

        self._image:setAnchorPoint(point)
    end

    self._place = true
    self._image:setPosition(self._touch["nowPos"])
end

function UIDragDropInfo:setOverlapPos(pos)
    self._overlap_pos = pos
end

function UIDragDropInfo:getOverlapPos()
    return fif(self._overlap_pos, self._overlap_pos, self._image:center())
end

return UIDragDropInfo
