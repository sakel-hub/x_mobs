--[[
	x_mobs - High-Performance Luanti Mobs & Boss Framework
	Mod Initialization Entrypoint
]]

local modpath = core.get_modpath("x_mobs")

-- Load core API first (delegating to x_mob_core)
dofile(modpath .. "/api.lua")

-- Load cross-game compatibility layer (VoxeLibre/MineClone2, Hades, MTG)
dofile(modpath .. "/compat/init.lua")

-- Register x_mobs specific pixel art envelop textures for status presets
dofile(modpath .. "/vfx/status_presets.lua")

-- Load 3D armor sets and forging materials subsystem
dofile(modpath .. "/items/init.lua")

-- Load mob definitions
local mobs = {
	"spider",
	"fallen_minion",
	"fallen_shaman",
	"armored_bug",
	"flying_insect",
	"skull_king",
	"skull_lancer",
	"skull_archer",
	"crystal_guardian",
	"crystal_guardian_minion",
	"nature_guardian",
	"nature_guardian_minion",
	"skeleton_swordfish",
	"fungus_minion",
	"crazy_mushroom",
	"golem",
	"golem_minion",
	"spectrum",
	"elder",
	"frosty_queen",
	"glowler_minion",
	"glowler",
	"chasm_weaver",
	"crypt_stalker",
	"dungeon_brute",
	"heated_sword",
	"suture_golem",
	"void_strider",
}

local loaded_count = 0
for i = 1, #mobs do
	local mob = mobs[i]
	if x_mobs.is_mob_enabled(mob) then
		dofile(modpath .. "/mobs/" .. mob .. ".lua")
		loaded_count = loaded_count + 1
	else
		core.log("action", string.format("[x_mobs] Mob '%s' disabled via configuration.", mob))
	end
end

-- Load Bestiary & Hunter's Chronicle subsystem
dofile(modpath .. "/bestiary/init.lua")

core.log("action", string.format("[x_mobs] Loaded successfully with %d/%d enabled mob definitions.", loaded_count, #mobs))
