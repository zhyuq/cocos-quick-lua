--[[
    libzq
--]]

local CURRENT_MODULE_NAME = ...
local PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

require(PACKAGE_NAME .. ".cocoszq.init")
require(PACKAGE_NAME .. ".frameworkzq.init")
require(PACKAGE_NAME .. ".base.init")
require(PACKAGE_NAME .. ".draw.init")
require(PACKAGE_NAME .. ".ui.init")


