ZYLayerStat = class("ZYLayerStat", ZYLayer)

function ZYLayerStat:ctor()
    ZYLayerStat.super.ctor(self)
    self:start()
end

function ZYLayerStat:initMemVar()
    self._text = nil
    self._stat_version = nil
    self._stat_window = nil
    self._stat_device = nil
end

function ZYLayerStat:start()
    cc.Director:getInstance():setDisplayStats(true)
    if not self._text then
        self._text = zq.UIText.new()
        self._text:setAnchorPoint(0, 0)
        self._text:setPosition(0, 0)
        self:addChild(self._text)
    end

    self._stat_version = "1.2.3"
    self._stat_window = cc.Director:getInstance():getWinSize().width .. " x " .. cc.Director:getInstance():getWinSize().height

    local device_hardware = zq.ZQDeviceInfo:getInstance():device_hardware()
    local device_telecom  = zq.ZQDeviceInfo:getInstance():device_telecom() or "-"
    local device_network  = zq.ZQDeviceInfo:getInstance():device_network()

    self._stat_device = device_hardware .. " / " .. device_telecom .. " / " .. device_network

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function (dt)
        self:update(dt)
    end)

    self:scheduleUpdate()
end

function ZYLayerStat:stop()
    cc.Director:getInstance():setDisplayStats(false)
    self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
    self._text:setText("")
end

function ZYLayerStat:update(dt)
    ZQLogD("ZYLayerStat update")
    local text = self._stat_version .. "\n"
    text = text .. string.format("%.1f fps", cc.Director:getInstance():getFrameRate())

    local mem_used = zq.ZQDeviceInfo:getInstance():memory_used()
    text = text .. " / " .. string.format("%.2fm used", mem_used / 1024*1024) .. " / "

    local mem_free = zq.ZQDeviceInfo:getInstance():memory_free()
    text = text .. string.format("%.2fm free", mem_free / 1024*1024) .. " / "

    local cpu_usage = zq.ZQDeviceInfo:getInstance():cpu_usage()
    text = text .. string.format("%.1f cpu", cpu_usage) .. "\n"

    text = text .. self._stat_device

    text = text .. " / " .. self._stat_window

    text = text .. " / " .. cc.Director:getInstance():getDrawnVertices()
    text = text .. " / " .. cc.Director:getInstance():getDrawnBatches()

    self._text:setText(text)

end

return ZYLayerStat
