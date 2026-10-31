--[[
	x_mobs - High-Performance Luanti Mobs & Boss Framework
	Public API Namespace & Monster Visual FX
]]

local modpath = core.get_modpath("x_mobs")

---@class XMobs
---@field compat XMobsCompat Cross-game and cross-mod compatibility layer
---@field items XMobsItemUtils Item and legendary armor tooltip utilities
---@field bestiary XMobsBestiary Bestiary & Hunter's Chronicle subsystem
---@field is_mob_enabled fun(mob_id_or_name: string): boolean Checks if a mob is enabled via settings
---@field is_spawn_enabled fun(mob_id_or_name: string): boolean Checks if natural spawning is enabled for a mob
x_mobs = {}

---Checks whether a specific mob entity is enabled via configuration.
---Accepts technical identifiers ("x_mobs:spider") or short keys ("spider").
---@param mob_id_or_name string Technical mob identifier or short name
---@return boolean enabled True if mob is enabled (default: true)
function x_mobs.is_mob_enabled(mob_id_or_name)
	if not mob_id_or_name or mob_id_or_name == "" then return false end
	local key = mob_id_or_name:gsub("^x_mobs:", "")
	local val = core.settings:get_bool("x_mobs.enable_" .. key)
	if val ~= nil then
		return val
	end
	return true
end

---Checks whether natural mapgen/trickle spawning is enabled for a specific mob.
---@param mob_id_or_name string Technical mob identifier or short name
---@return boolean enabled True if natural spawning is active
function x_mobs.is_spawn_enabled(mob_id_or_name)
	if not x_mobs.is_mob_enabled(mob_id_or_name) then
		return false
	end
	if core.settings:get_bool("x_mobs.enable_spawning", true) == false then
		return false
	end
	local key = mob_id_or_name:gsub("^x_mobs:", "")
	local spawn_val = core.settings:get_bool("x_mobs.spawn_" .. key)
	if spawn_val ~= nil then
		return spawn_val
	end
	return true
end

-- Load cross-game compatibility layer
dofile(modpath .. "/compat/init.lua")

-- Load mob-specific particle and visual FX factories
dofile(modpath .. "/vfx/mob_particles.lua")

return x_mobs


