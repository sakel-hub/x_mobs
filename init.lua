--[[
	x_mobs - High-Performance Luanti Mobs & Boss Framework
	Mod Initialization Entrypoint
]]

local modpath = core.get_modpath("x_mobs")

-- Load core API first (delegating to x_mob_core)
dofile(modpath .. "/api.lua")

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
}

for i = 1, #mobs do
	dofile(modpath .. "/mobs/" .. mobs[i] .. ".lua")
end

core.log("action", "[x_mobs] Loaded successfully with " .. #mobs .. " mob definitions.")
