ZYScene = class("ZYScene", function()
    return cc.Scene:create();
end)

function ZYScene:ctor()
    self._host = ZYLayer.new()
    self:addChild(self._host)

    self._layer_ui = ZYLayerUI.new()
    self._host:addChild(self._layer_ui, 1)


    self._layer_stat = ZYLayerStat.new()
    self._host:addChild(self._layer_stat, zq.Int32Max)

    self:setNodeEventEnabled(true)
end

function ZYScene:init()

end

function ZYScene:initMemVar()
    self._host = nil
    self._layer_ui = nil
    self._layer_stat = nil
end

function ZYScene:onEnter()

end

function ZYScene:onExit()

end

function ZYScene:onEnterTransitionFinish()

end

function ZYScene:layerUI()
    return self._layer_ui
end

function ZYScene:layerStat()
    return self._layer_stat
end


return ZYScene
