--[[
	x_mobs - High-Performance Luanti Mobs & Boss Framework
	Mod Initialization Entrypoint
]]

local modpath = core.get_modpath("x_mobs")

-- Load core API first (delegating to x_mob_core)
dofile(modpath .. "/api.lua")

-- Load entity definitions
dofile(modpath .. "/spider.lua")
dofile(modpath .. "/fallen_minion.lua")
dofile(modpath .. "/fallen_shaman.lua")
dofile(modpath .. "/armored_bug.lua")
dofile(modpath .. "/flying_insect.lua")

-- Migration: Clean up old minion_corpse entities seamlessly
core.register_entity("x_mobs:minion_corpse", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		pointable = false,
		selectionbox = {0, 0, 0, 0, 0, 0},
		static_save = false,
	},
	static_save = false,
	on_activate = function(self)
		self.object:remove()
	end,
	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,
	on_rightclick = function(_self, _clicker)
	end,
})

-- Load new skull mobs
dofile(modpath .. "/skull_king.lua")
dofile(modpath .. "/skull_lancer.lua")
dofile(modpath .. "/skull_archer.lua")

-- Load Crystal Guardian
dofile(modpath .. "/crystal_guardian.lua")

-- Load Skeleton Swordfish
dofile(modpath .. "/skeleton_swordfish.lua")

-- Load Crazy Mushroom Boss & Fungus Minions
dofile(modpath .. "/fungus_minion.lua")
dofile(modpath .. "/crazy_mushroom.lua")

core.log("action", "[x_mobs] Loaded successfully with glTF multi-track mobs, " ..
	"Nether Arachnid, Fallen Shaman & Minions, Skull Legion, Crystal Guardian, " ..
	"Skeleton Swordfish, Crazy Mushroom, and Fungus Minions.")

