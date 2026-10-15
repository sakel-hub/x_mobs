--[[
	x_mobs - Items Subsystem Loader (3D Armor Sets & Forging Materials)
	Author: SaKeL
	License: MIT
]]

local modpath = core.get_modpath("x_mobs")

-- Load agnostic utilities
x_mobs.items = dofile(modpath .. "/items/utils.lua")

local has_x_player_armor = (core.get_modpath("x_player_armor") ~= nil) and (_G.x_player_armor ~= nil)

if has_x_player_armor then
	-- Load armor forging materials, 3D armor sets, and crafting recipes
	dofile(modpath .. "/items/materials.lua")
	dofile(modpath .. "/items/armor.lua")
	dofile(modpath .. "/items/crafting.lua")
	core.log("action", "[x_mobs] Loaded 3D armor sets, materials, and crafting recipes for x_player_armor.")
else
	core.log("action", "[x_mobs] x_player_armor not detected: 3D armor sets, forging shards, and recipes disabled.")
end

