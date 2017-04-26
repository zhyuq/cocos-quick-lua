--[[--
    libzq
]]
zq = zq or {}

zq.Touch =  import(".touch")
import(".transform")
import(".log")
import(".adapt")

local time = import(".time")
zq.time = time.time

local color = import(".color")
zq.color = color

local num = import(".num")
zq.floatEqual = num.floatEqual

cc.WHITE    = cc.c3b(255, 255, 255)
cc.YELLOW   = cc.c3b(255, 255, 0)
cc.GREEN    = cc.c3b(0, 255, 0)
cc.BLUE     = cc.c3b(0, 0, 255)
cc.RED      = cc.c3b(255, 0, 0)
cc.MAGENTA  = cc.c3b(255, 0, 255)
cc.BLACK    = cc.c3b(0, 0, 0)
cc.ORANGE   = cc.c3b(255, 127, 0)
cc.GRAY     = cc.c3b(166, 166, 166)
zq.WHITE    = cc.WHITE
zq.YELLOW   = cc.YELLOW
zq.GREEN    = cc.GREEN
zq.BLUE     = cc.BLUE
zq.RED      = cc.RED
zq.MAGENTA  = cc.MAGENTA
zq.BLACK    = cc.BLACK
zq.ORANGE   = cc.ORANGE
zq.GRAY     = cc.GRAY


---整形转cc.c3b类型
-- @function zq.intToc3b
-- @param int intValue
-- @return cc.c3b
zq.intToc3b = color.intToc3b
zq.hexToc3b = color.hexToc3b

import(".CustomActionEx")
import(".action")

utf8 = import(".utf8")
html = import(".html")
import(".serialize")

zq.Object = import(".object")
zq.TouchDispatch = import(".touchdispatch")


function fif(condition, if_true, if_false)
  if condition then return if_true else return if_false end
end







