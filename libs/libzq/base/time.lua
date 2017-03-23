--[[--
  time 时间处理
  @module time
]]

local time = {}

---
-- 获取秒数
time.time = function (floor)
    if floor then
        return os.time()
    end

    local millisecond = zq.DateUtils:getMilliseconds()
    return millisecond/1000
end

return time
