ZYUIDebug = class("ZYUIDebug", ZYUIPopup)

function ZYUIDebug:ctor()
    ZYUIPopup.super.ctor(self)

    self:buildBackground("ui_common_new/公用大框.png")
end

return ZYUIDebug
