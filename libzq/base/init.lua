--[[--
    libzq
]]
zq = zq or {}

zq.touch =  import(".touch")
import(".transform")
local color = import(".color")

zq.color = color

---整形转cc.c3b类型
-- @function zq.intToc3b
-- @param int intValue
-- @return cc.c3b
zq.intToc3b = color.intToc3b

zq.Int32Max = 2147483647;
zq.Int32Min = -2147483648;



