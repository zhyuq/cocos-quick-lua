ZYUIDebug = class("ZYUIDebug", ZYUIPopup)

function ZYUIDebug:ctor()
    ZYUIPopup.super.ctor(self)

    self:buildBackground("ui_common_new/公用大框.png")

    self:test_dragdrop()
end

function ZYUIDebug:test_dragdrop()
    local size = self:getContentSize()
    local block = cc.size(size.width/6, size.height/3)

    for i=1, 3 do
        for j=1,3 do
            local node = DragDropTestNode.new()
            node:setContentSize(block.width*0.7, block.height*0.7)
            node:setAnchorPoint(0.5, 0.5)
            node:setPosition(block.width/2 + block.width*i, block.height/2 + block.height*j)
            node:enableDebugDrawRect(true)
            self:addChild(node)
            self:dragdrop():register(node)
        end
    end
end

DragDropTestNode = class("DragDropTestNode", zq.UIImage)

function DragDropTestNode:ctor( ... )

end

function DragDropTestNode:allowDrag(info)
    local rect = cc.rect(0, 0, self:getWidth(), self:getHeight())
    local check = zq.Touch.checkTouch(self, rect, info:touch():getLocation())
    -- ZQLogD("check %s", tostring(check))
    if check then
        local image = zq.UIImage.new()
        image:setImage("ui_lingbao_new/底圆.png")
        -- image:setPosition(50, 50)
        -- image:enableDebugDrawRect(true)
        -- image:setContentSize(self:getContentSize())
        info:setImage(image)
    end

    -- local layer = ZYWorld:getInstance():scene():layerUI()
    -- layer:addChild(image, zq.Int32Max)

end

function DragDropTestNode:dragStart(touch)
    self:setVisible(false)
end

-- function DragDropTestNode:dragging(source, target)
--     -- body
-- end

function DragDropTestNode:dragEnd(source, target, on_source)

end
