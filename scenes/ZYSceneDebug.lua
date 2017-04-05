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

    bg:playCCBI("ccbi_ui/金丹－红.ccbi")
    -- local box = zq.ZQTextBox:create(cc.size(100, 50))
    -- box:setContentSize(cc.size(100, 50))
    -- box:setAnchorPoint(cc.p(0.5, 0.5))
    -- box:setPosition(self:center())
    -- self._host:addChild(box)

    -- local box = zq.ZQTextBox:create(cc.size(100, 50))
    -- box:setContentSize(cc.size(100, 50))
    -- box:setAnchorPoint(cc.p(0.5, 0.5))
    -- box:setPosition(cc.p(self:centerX(), self:centerY()+100))
    -- self._host:addChild(box)

     local box = zq.ZQTextArea:create(cc.size(100, 50))
    box:setContentSize(cc.size(100, 50))
    box:setAnchorPoint(cc.p(0.5, 0.5))
    box:setPosition(cc.p(self:centerX(), self:centerY()))
    self._host:addChild(box)

    local label = zq.UIText.new()
    -- label:setGlobalStrokeWidth(3)
    label:setGlobalStrokeColor(zq.intToc3b(0xff0000))
    -- label:setLayoutWidth(70)
    local translate = zq.Locale.translate;
    label:setRichText(zq.Locale:getInstance():translate("<font color=#ff0000>移除</font>黄色<font color=#00ff00 size=20 underline=true>绿Xx色\n换行乐</font>天排55566"), zq.intToc3b(0xffffff), 18, true)
    label:setPosition(600, 100)
    self:addChild(label)
    label:enableDebugDrawRect(true, zq.intToc3b(0x000000))
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
