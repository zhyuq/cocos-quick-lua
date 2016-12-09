--[[--
    libzq
]]
zq = zq or {}

zq.touch =  import(".touch")
import(".transform")
import(".log")

local color = import(".color")
zq.color = color

---整形转cc.c3b类型
-- @function zq.intToc3b
-- @param int intValue
-- @return cc.c3b
zq.intToc3b = color.intToc3b

zq.Int32Max = 2147483647;
zq.Int32Min = -2147483648;

function fif(condition, if_true, if_false)
  if condition then return if_true else return if_false end
end





