--[[
	test_mob_settings.lua
	Automated headless unit and integration test suite for x_mobs configuration settings:
	1. Default enable state across all 28 mobs
	2. Technical ID vs short key resolution
	3. Individual mob enable/disable via `x_mobs.enable_<mob>`
	4. Natural spawning toggle hierarchy (`enable_spawning`, `spawn_<mob>`)
	5. Dynamic Bestiary alignment and total mob count calculation
	6. Completeness validation: ensures settingtypes.txt contains all 28 mob toggles
]]

local settings_store = {}

-- Headless Minetest / Luanti engine mock
_G.core = {
	settings = {
		get_bool = function(_self, key, default)
			if settings_store[key] ~= nil then
				return settings_store[key]
			end
			return default
		end,
		get = function(_self, key)
			return settings_store[key]
		end,
		set = function(_self, key, val)
			settings_store[key] = val
		end,
	},
	get_modpath = function(mod)
		if mod == "x_mobs" then return "." end
		if mod == "x_mob_core" then return "../x_mob_core" end
		return nil
	end,
	get_translator = function(_mod)
		return function(str) return str end
	end,
	log = function(_level, _msg)
		-- silent in tests
	end,
	registered_entities = {},
	register_entity = function(name, def)
		_G.core.registered_entities[name] = def
	end,
	register_craftitem = function() end,
	register_craft = function() end,
	register_node = function() end,
	register_on_joinplayer = function() end,
	register_on_leaveplayer = function() end,
	register_on_shutdown = function() end,
	register_on_mods_loaded = function() end,
}

_G.minetest = _G.core

-- Mock x_mob_core
_G.x_mob_core = {
	registered_mobs = {},
	register_mob = function(name, def)
		_G.x_mob_core.registered_mobs[name] = def
	end,
	register_spawn = function() end,
	play_sound = function() end,
	apply_status_effect = function() return true end,
	has_status_effect = function() return false end,
	is_enveloped = function() return false end,
	particles = { attach = function() end },
	listen = function() end,
	events = {
		listen = function() end,
		emit = function() end,
	},
}

print("=== Running x_mobs Configuration & Mob Settings Test Suite ===")

-- 1. Load API
dofile("./api.lua")
assert(type(x_mobs.is_mob_enabled) == "function", "x_mobs.is_mob_enabled must be a function")
assert(type(x_mobs.is_spawn_enabled) == "function", "x_mobs.is_spawn_enabled must be a function")
print("  [PASS] 1. API helper functions loaded successfully")

-- The canonical list of all 28 mobs
local all_mobs = {
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

-- 2. Test default state: all 28 mobs enabled
for _, mob in ipairs(all_mobs) do
	assert(x_mobs.is_mob_enabled(mob) == true, "Mob should be enabled by default: " .. mob)
	assert(x_mobs.is_mob_enabled("x_mobs:" .. mob) == true, "Technical ID should be enabled by default: x_mobs:" .. mob)
	assert(x_mobs.is_spawn_enabled(mob) == true, "Spawning should be enabled by default: " .. mob)
end
print("  [PASS] 2. All 28 mobs verified enabled by default (both short and namespaced IDs)")

-- 3. Test explicit disabling of individual mobs
settings_store["x_mobs.enable_spider"] = false
settings_store["x_mobs.enable_crazy_mushroom"] = false

assert(x_mobs.is_mob_enabled("spider") == false, "spider should be disabled")
assert(x_mobs.is_mob_enabled("x_mobs:spider") == false, "x_mobs:spider should be disabled")
assert(x_mobs.is_spawn_enabled("spider") == false, "spawning should be disabled if mob is disabled")

assert(x_mobs.is_mob_enabled("crazy_mushroom") == false, "crazy_mushroom should be disabled")
assert(x_mobs.is_mob_enabled("golem") == true, "golem should remain enabled")
print("  [PASS] 3. Individual mob disable settings verified")

-- Reset settings
settings_store["x_mobs.enable_spider"] = nil
settings_store["x_mobs.enable_crazy_mushroom"] = nil

-- 4. Test natural spawning toggle hierarchy
-- Case A: Global spawning disabled
settings_store["x_mobs.enable_spawning"] = false
assert(x_mobs.is_spawn_enabled("spider") == false, "spawning should be false when enable_spawning = false")
assert(x_mobs.is_mob_enabled("spider") == true, "mob entity itself should remain enabled")
settings_store["x_mobs.enable_spawning"] = nil

-- Case B: Per-mob spawn override disabled
settings_store["x_mobs.spawn_spider"] = false
assert(x_mobs.is_spawn_enabled("spider") == false, "spawn_spider = false should disable natural spawn")
assert(x_mobs.is_mob_enabled("spider") == true, "mob entity itself should remain enabled")
assert(x_mobs.is_spawn_enabled("golem") == true, "other mobs should still spawn")
settings_store["x_mobs.spawn_spider"] = nil
print("  [PASS] 4. Natural spawning hierarchy and per-mob overrides verified")

-- 5. Test settingtypes.txt completeness
local f = io.open("./settingtypes.txt", "r")
assert(f, "settingtypes.txt must exist")
local content = f:read("*a")
f:close()

for _, mob in ipairs(all_mobs) do
	local setting_pattern = "x_mobs%.enable_" .. mob .. "%s+%("
	assert(content:find(setting_pattern) ~= nil, "settingtypes.txt is missing setting for: " .. mob)
end
assert(content:find("x_mobs%.enable_spawning") ~= nil, "settingtypes.txt is missing x_mobs.enable_spawning")
assert(content:find("x_mobs%.bestiary_require_book_in_inventory") ~= nil, "settingtypes.txt is missing bestiary requirement")
print("  [PASS] 5. settingtypes.txt completeness verified for all 28 mobs and global options")

-- 6. Test dynamic Bestiary alignment with disabled mobs
local data = dofile("./bestiary/data.lua")
local initial_count = #data.get_all_entries()
assert(initial_count == 28, "Bestiary should have 28 entries initially, got: " .. initial_count)

-- Now simulate disabled mobs before loading bestiary
settings_store["x_mobs.enable_spider"] = false
settings_store["x_mobs.enable_crazy_mushroom"] = false
settings_store["x_mobs.enable_elder"] = false

-- Reload Bestiary data module
local filtered_data = dofile("./bestiary/data.lua")
local filtered_count = #filtered_data.get_all_entries()
assert(filtered_count == 25, "Bestiary should have 25 entries when 3 mobs are disabled, got: " .. filtered_count)
assert(filtered_data.get_entry("x_mobs:spider") == nil, "spider should not be in Bestiary when disabled")
assert(filtered_data.get_entry("x_mobs:crazy_mushroom") == nil, "crazy_mushroom should not be in Bestiary when disabled")
assert(filtered_data.get_entry("x_mobs:elder") == nil, "elder should not be in Bestiary when disabled")
assert(filtered_data.get_entry("x_mobs:golem") ~= nil, "golem should remain in Bestiary")

-- Verify category tabs still filter properly
local bosses = filtered_data.get_all_entries("Bosses")
assert(#bosses == 6, "Expected 6 bosses (since crazy_mushroom is disabled), got: " .. #bosses)
print("  [PASS] 6. Dynamic Bestiary alignment and category filtering verified")

print("\n=== ALL MOB SETTINGS TEST SUITES PASSED SUCCESSFULLY! ===")
