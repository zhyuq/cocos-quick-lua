--[[--
zq UIScale9 控件
-- @classmod UIScale9

]]
kUIScale9EdgeType = {
    LeftTop     = "kUIScale9EdgeLeftTop_",
    Top         = "kUIScale9EdgeTop_",
    RightTop    = "kUIScale9EdgeRightTop_",
    Right       = "kUIScale9EdgeRight_",
    RightBottom = "kUIScale9EdgeRightBottom_",
    Bottom      = "kUIScale9EdgeBottom_",
    LeftBottom  = "kUIScale9EdgeLeftBottom_",
    Left        = "kUIScale9EdgeLeft_",
    Center      = "kUIScale9EdgeCenter_",
}

kUIScale9EdgeType.Corner    = kUIScale9EdgeType.LeftTop .. "|" .. kUIScale9EdgeType.RightTop .. "|" .. kUIScale9EdgeType.RightBottom .. "|" .. kUIScale9EdgeType.LeftBottom
kUIScale9EdgeType.TCorner   = kUIScale9EdgeType.LeftTop .. "|" .. kUIScale9EdgeType.RightTop
kUIScale9EdgeType.BCorner   = kUIScale9EdgeType.RightBottom .. "|" .. kUIScale9EdgeType.LeftBottom
kUIScale9EdgeType.HEdge     = kUIScale9EdgeType.Left .. "|" .. kUIScale9EdgeType.Right
kUIScale9EdgeType.VEdge     = kUIScale9EdgeType.Top .. "|" .. kUIScale9EdgeType.Bottom
local UIScale9 = class("UIScale9", function()
        return cc.Node:create()
end)

--------------------------------
-- UIScale9构建函数
-- @function ctor
function UIScale9:ctor()
    self:setCascadeOpacityEnabled(true)

    self._image = {}
    self._size = {}

    self._scale9_image = zq.UIImage.new()
    self._scale9_image:setVisible(false)
    self:addChild(self._scale9_image)
end

function UIScale9:setImage(image)
    return self._scale9_image:setImage(image)
end

function UIScale9:setDimension(edgeType, size)
    if not self._scale9_image:getTexture() then
        return
    end

    local original = self._scale9_image:getSpriteFrame():getOriginalSize()
    if self:isContainsType(edgeType, kUIScale9EdgeType.LeftTop) then
        self:_addImage(kUIScale9EdgeType.LeftTop, cc.p(0, 0), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.Top) then
        local lt = self:getPartSize(kUIScale9EdgeType.LeftTop)
        local beg = fif(lt.width ~= 0, lt.width, original.width*0.5 - size.width*0.5)
        self:_addImage(kUIScale9EdgeType.Top, cc.p(beg, 0), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.RightTop) then
        self:_addImage(kUIScale9EdgeType.RightTop, cc.p(original.width-size.width, 0), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.Right) then
        self:_addImage(kUIScale9EdgeType.Right, cc.p(original.width-size.width, original.height*0.5 - size.height*0.5), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.RightBottom) then
        self:_addImage(kUIScale9EdgeType.RightBottom, cc.p(original.width-size.width, original.height - size.height), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.Bottom) then
        self:_addImage(kUIScale9EdgeType.Bottom, cc.p(original.width*0.5-size.width*0.5, original.height - size.height), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.LeftBottom) then
        self:_addImage(kUIScale9EdgeType.LeftBottom, cc.p(0, original.height - size.height), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.Left) then
        self:_addImage(kUIScale9EdgeType.Left, cc.p(0, original.height*0.5 - size.height*0.5), size)
    end

    if self:isContainsType(edgeType, kUIScale9EdgeType.Center) then
        self:_addImage(kUIScale9EdgeType.Center, cc.p(original.width*0.5 - size.width*0.5, original.height*0.5 - size.height*0.5), size)
    end
end

function UIScale9:setContentSize(width, height)
    if not height then
        height = width.height
        width = width.width
    end

    local changed = not cc.sizeEqualToSize(cc.size(width, height), self:getContentSize())
    local func = tolua.getcfunction(self, "setContentSize")
    func(self, width, height)

    if changed then
        self:layout()
    end
end

function UIScale9:isContainsType(edgeType, type)
    if string.find(edgeType, type) then
        return true
    end

    return false
end

function UIScale9:layout()
    local size = self:getContentSize()

    if not self._scale9_image:getTexture() then
        return
    end

    local sp_lefttop = self._image[kUIScale9EdgeType.LeftTop]
    local sp_top = self._image[kUIScale9EdgeType.Top]
    local sp_righttop = self._image[kUIScale9EdgeType.RightTop]
    local sp_right = self._image[kUIScale9EdgeType.Right]
    local sp_rightbottom = self._image[kUIScale9EdgeType.RightBottom]
    local sp_bottom = self._image[kUIScale9EdgeType.Bottom]
    local sp_leftbottom = self._image[kUIScale9EdgeType.LeftBottom]
    local sp_left = self._image[kUIScale9EdgeType.Left]
    local sp_center = self._image[kUIScale9EdgeType.Center]

    local size_lefttop = cc.size(0, 0)
    if sp_lefttop then
        size_lefttop = sp_lefttop:getContentSize()
        sp_lefttop:setAnchorPoint(0, 1)
        sp_lefttop:setPosition(0, size.height)
    end

    local size_righttop = cc.size(0, 0)
    if sp_righttop then
        size_righttop = sp_righttop:getContentSize()
        sp_righttop:setAnchorPoint(1, 1)
        sp_righttop:setPosition(size.width, size.height)
    end

    local size_rightbottom = cc.size(0, 0)
    if sp_rightbottom then
        size_rightbottom = sp_rightbottom:getContentSize()
        sp_rightbottom:setAnchorPoint(1, 0)
        sp_rightbottom:setPosition(size.width, 0)
    end

    local size_leftbottom = cc.size(0, 0)
    if sp_leftbottom then
        size_leftbottom = sp_leftbottom:getContentSize()
        sp_leftbottom:setAnchorPoint(0, 0)
        sp_leftbottom:setPosition(0, 0)
    end

    local size_top = cc.size(0, 0)
    if sp_top and sp_top:getWidth() ~= 0 then
        size_top = sp_top:getContentSize()
        sp_top:setAnchorPoint(0, 1)
        sp_top:setPosition(size_lefttop.width, size.height)
        sp_top:setScaleX((size.width - size_lefttop.width - size_righttop.width)/size_top.width)
    end

    local size_right = cc.size(0, 0)
    if sp_right and sp_right:getHeight() ~= 0 then
        size_right = sp_right:getContentSize()
        sp_right:setAnchorPoint(1, 0)
        sp_right:setPosition(size.width, size_rightbottom.height)
        sp_right:setScaleY((size.height - size_righttop.height - size_rightbottom.height)/size_right.height)
    end

    local size_bottom = cc.size(0, 0)
    if sp_bottom and sp_bottom:getWidth() ~= 0 then
        size_bottom = sp_bottom:getContentSize()
        sp_bottom:setAnchorPoint(0, 0)
        sp_bottom:setPosition(size_leftbottom.width, 0)
        sp_bottom:setScaleX((size.width - size_leftbottom.width - size_rightbottom.width)/size_bottom.width)
    end

    local size_left = cc.size(0, 0)
    if sp_left and sp_left:getHeight() ~= 0 then
        size_left = sp_left:getContentSize()
        sp_left:setAnchorPoint(0, 0)
        sp_left:setPosition(0, size_leftbottom.height)
        sp_left:setScaleY((size.height - size_lefttop.height - size_leftbottom.height)/size_left.height)
    end

    local size_center = cc.size(0, 0)
    if sp_center and sp_center:getHeight() ~= 0 and sp_center:getWidth() ~= 0 then
        size_center = sp_center:getContentSize()
        sp_center:setAnchorPoint(0.5, 0)
        sp_center:setPosition(size.width*0.5, size_bottom.height)
        sp_center:setScaleX((size.width - size_left.width - size_right.width)/size_center.width)
        sp_center:setScaleY((size.height - size_top.height - size_bottom.height)/size_center.height)
    end
end

function UIScale9:clear()
    self._image = {}
    self._size = {}
    self:removeAllChildren(true)

    self._scale9_image = zq.UIImage:new()
    self._scale9_image:setVisible(false)
    self:addChild(self._scale9_image)
end

function UIScale9:_addImage(type, origin, size)
    local rect = self._scale9_image:getSpriteFrame():getRect()
    origin = cc.pAdd(origin, cc.p(rect.x, rect.y))

    local unit = zq.UIScale9Unit:new()
    unit:setTexture(self._scale9_image:getTexture())
    unit:setOriginRect(cc.rect(origin.x, origin.y, size.width, size.height))
    self:addChild(unit)

    -- ZQLogD("UIScale9Unit type: %s", tolua.type(self))
    -- ZQLogD("UIScale9Unit type: %s", tolua.type(unit))
    self._size[type] = size
    self._image[type] = unit

end

function UIScale9:getPartSize(type)
    return fif(self._image[type], self._image[type]:getContentSize(), cc.size(0, 0))
end


return UIScale9
