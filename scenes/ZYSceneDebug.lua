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
    local box1 = zq.ZQTextBox:create(cc.size(100, 50))
    box1:setContentSize(cc.size(100, 50))
    box1:setAnchorPoint(cc.p(0.5, 0.5))
    box1:setPosition(self:center())
    self:addChild(box1)

    local box2 = zq.ZQTextBox:create(cc.size(100, 50))
    box2:setContentSize(cc.size(100, 50))
    box2:setAnchorPoint(cc.p(0.5, 0.5))
    box2:setPosition(cc.p(self:centerX(), self:centerY()+100))
    self._host:addChild(box2)

    -- local box = zq.ZQTextArea:create(cc.size(100, 50))
    -- box:setContentSize(cc.size(100, 50))
    -- box:setAnchorPoint(cc.p(0.5, 0.5))
    -- box:setPosition(cc.p(self:centerX(), self:centerY()))
    -- self._host:addChild(box)

    local label = zq.UIText.new()
    -- label:setGlobalStrokeWidth(3)
    label:setGlobalStrokeColor(zq.intToc3b(0xff0000))
    -- label:setLayoutWidth(70)
    local translate = zq.Locale.translate;
    label:setRichText(zq.Locale:getInstance():translate("<font color=#ff0000>移除</font>黄色<font color=#00ff00 size=20 underline=true>绿Xx色\n换行乐</font>天排55566"), zq.intToc3b(0xffffff), 18, true)
    label:setPosition(600, 100)
    self._host:addChild(label)
    label:enableDebugDrawRect(true, zq.intToc3b(0x000000))

    -- ZYStorage:getInstance():set("test_storage_1", {a="b", [1] = 3}, true)
    -- ZQLogD("test_storage_1 %s", tostring(ZYStorage:getInstance():get("test_storage_1")))
    -- dump(ZYStorage:getInstance():get("test_storage_1"))

    -- ZQLogD("serialize %s", table.serialize({[2] = "b", [1] = "a", [3] = "c", [26] = "z", b = "5",}))

    -- ZYStorage:getInstance():del("test_storage_1", true)


    -- video test
    -- local video = ZYVideo.new()
    -- self:addChild(video)
    -- video:play("video/kaitou.mp4")
    -- video:bind(function ( ... )
    --     video:removeFromParent()
    -- end)

    -- local touch = zq.UIButton.new()
    -- touch:setAnchorPoint(0, 0)
    -- touch:setContentSize(self:getContentSize())
    -- touch:bindDBClick(function ( ... )
    --     video:removeFromParent(true)
    -- end)
    -- self:addChild(touch)

    local img = zq.UIImage.new()
    img:setImage("ui_role_bag_new/人物标题.png")
    img:setAnchorPoint(0.5, 0.5)
    img:setPosition(self:center())
    self._host:addChild(img)

    ZYUIController:getInstance():open(ZYUIDebug)
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
