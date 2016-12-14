--[[--

]]

local num = {}

zq.Int32Max = 2147483647;
zq.Int32Min = -2147483648;

num.Float_Epsilon  = 1.1920928955078125e-07
num.Double_Epsilon = 2.22044604925031308e-16

-- http://lua-users.org/lists/lua-l/2013-08/msg00456.html
num.floatEqual = function (lfloat, rfloat)
    return math.abs(lfloat - rfloat) < num.Float_Epsilon
end

return num
