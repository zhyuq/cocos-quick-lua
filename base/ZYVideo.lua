ZYVideo = class("ZYVideo", function()
    return display.newNode()
end)

function ZYVideo:ctor()
    local black = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
    self:addChild(black)

    self._movie = ccexp.VideoPlayer:create()
    self._movie:setContentSize(cc.Director:getInstance():getWinSize())
    self._movie:setAnchorPoint(0, 0)
    self._movie:setKeepAspectRatioEnabled(true)
    self:addChild(self._movie)
end

function ZYVideo:play(file)
    local path = zq.ZQFileManage:getInstance():load_file(file)
    if (string.len(path) > 0) then
        self._movie:stop()
        self._movie:setFileName(path)
        self._movie:play()
    else
        self:emit()
    end
end

function ZYVideo:bind(callback)
    self._callback = callback
    self._movie:addEventListener(function (videoPlayer, eventType)
        if eventType == ccexp.VideoPlayerEvent.COMPLETED then
            self:scheduleOnce(function ()
                self:emit()
            end)
        end
    end)
end

function ZYVideo:emit()
    self._movie:removeFromParent()

    self:scheduleOnce(function ()
        if self._callback then
            self._callback()
        end
    end, 0.2)
end

return ZYVideo
