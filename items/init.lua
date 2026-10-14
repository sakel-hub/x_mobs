--[[
	x_mobs - Items Subsystem Loader (3D Armor Sets & Forging Materials)
	Author: SaKeL
	License: MIT
]]

local modpath = core.get_modpath("x_mobs")

-- Load agnostic utilities
x_mobs.items = dofile(modpath .. "/items/utils.lua")

-- Load armor forging materials, 3D armor sets, and crafting recipes
dofile(modpath .. "/items/materials.lua")
dofile(modpath .. "/items/armor.lua")
dofile(modpath .. "/items/crafting.lua")

core.log("action", "[x_mobs] 3D Armor Sets and forging materials subsystem initialized.")
