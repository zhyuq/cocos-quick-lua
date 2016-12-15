--[[--
    libzq
]]
zq = zq or {}

zq.touch =  import(".touch")
import(".transform")
import(".log")

local time = import(".time")
zq.time = time.time

local color = import(".color")
zq.color = color

local num = import(".num")
zq.floatEqual = num.floatEqual



---整形转cc.c3b类型
-- @function zq.intToc3b
-- @param int intValue
-- @return cc.c3b
zq.intToc3b = color.intToc3b


function fif(condition, if_true, if_false)
  if condition then return if_true else return if_false end
end







