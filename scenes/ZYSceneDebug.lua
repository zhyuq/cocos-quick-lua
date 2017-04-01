ZYSceneDebug = class("ZYSceneDebug", ZYScene)

function ZYSceneDebug:ctor()
    ZYSceneDebug.super.ctor(self)
end

function ZYSceneDebug:init()
    local bg = zq.UIImage.new()
    bg:setImage("ui_role_create/背景.png")
    bg:setAnchorPoint(0.5, 0.5)
    bg:setPosition(self:center())
    self._host:addChild(bg)
end

function ZYSceneDebug:initMemVar()

end

function ZYSceneDebug:onEnter()

end

function ZYSceneDebug:onExit()

end

function ZYSceneDebug:onEnterTransitionFinish()

end


return ZYSceneDebug
