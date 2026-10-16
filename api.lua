--[[
	x_mobs - High-Performance Luanti Mobs & Boss Framework
	Public API Namespace & Monster Visual FX
]]

local modpath = core.get_modpath("x_mobs")

---@class XMobs
---@field compat XMobsCompat Cross-game and cross-mod compatibility layer
---@field items XMobsItemUtils Item and legendary armor tooltip utilities
---@field bestiary XMobsBestiary Bestiary & Hunter's Chronicle subsystem
x_mobs = {}

-- Load cross-game compatibility layer
dofile(modpath .. "/compat/init.lua")

-- Load mob-specific particle and visual FX factories
dofile(modpath .. "/vfx/mob_particles.lua")

return x_mobs


