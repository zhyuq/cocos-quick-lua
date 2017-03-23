--[[
    libzq
--]]

local CURRENT_MODULE_NAME = ...
local PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)

require(PACKAGE_NAME .. ".shader_default_fsh")
require(PACKAGE_NAME .. ".shader_default_vsh")
require(PACKAGE_NAME .. ".shader_grayscale_fsh")
require(PACKAGE_NAME .. ".shader_mask_sprite_fsh")
require(PACKAGE_NAME .. ".shader")
require(PACKAGE_NAME .. ".SpriteEx")


