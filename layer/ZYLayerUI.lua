ZYLayerUI = class("ZYLayerUI", ZYLayer)

function ZYLayerUI:ctor()
    self._host = cc.Node:create()
    self._host:setContentSize(self:getContentSize())
    self:addChild(self._host)

    self._top = cc.Node:create()
    self._top:setContentSize(self:getContentSize())
    self:addChild(self._top)

    self:setNodeEventEnabled(true)
end

function ZYLayerUI:initMemVar()
    self._host  = nil
    self._top   = nil
end

function ZYLayerUI:onEnter()

end

function ZYLayerUI:onExit()

end

return ZYLayerUI
