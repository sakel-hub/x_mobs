--[[
	test_survival_spawning_drops.lua
	Headless verification test suite for x_mobs multiplayer survival improvements:
	  1. Cross-game item drops translation (MTG, VoxeLibre/MCL2, Hades)
	  2. Cross-game spawn surface expansion (group:soil, group:stone, group:sand)
	  3. Torchlight base protection verification (max_light <= 9 on hostile ground mobs)
	  4. Protected area spawn rejection (core.is_protected)
	  5. World static spawnpoint safe hub protection (x_mob_spawn_protect_radius)
	  6. Frosty Queen natural spawn registration and Elder loot drops
--]]

local registered_mobs = {}
local registered_spawns = {}
local registered_items = {}
local registered_nodes = {
	["air"] = { walkable = false },
	["default:stone"] = { walkable = true },
	["default:dirt_with_grass"] = { walkable = true },
	["mcl_core:stone"] = { walkable = true },
}
local settings_table = {}

_G.vector = {
	new = function(x, y, z)
		if type(x) == "table" then return { x = x.x or 0, y = x.y or 0, z = x.z or 0 } end
		return { x = x or 0, y = y or 0, z = z or 0 }
	end,
	distance = function(a, b)
		local dx = (a.x or 0) - (b.x or 0)
		local dy = (a.y or 0) - (b.y or 0)
		local dz = (a.z or 0) - (b.z or 0)
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end,
}

local core_mock = {
	registered_items = registered_items,
	registered_nodes = registered_nodes,
	registered_craftitems = {},
	registered_tools = {},
	register_entity = function() end,
	get_modpath = function(mod)
		if mod == "x_mobs" then return "." end
		if mod == "x_mob_core" then return "../x_mob_core" end
		return nil
	end,
	get_translator = function(_m) return function(s) return s end end,
	colorize = function(_c, t) return t end,
	formspec_escape = function(s) return s end,
	log = function() end,
	get_node = function(pos)
		if pos.y <= 0 then
			return { name = "default:stone" }
		else
			return { name = "air" }
		end
	end,
	get_node_or_nil = function(pos) return core.get_node(pos) end,
	get_timeofday = function() return 0.0 end, -- Midnight
	get_node_light = function(_pos) return _G.__test_light or 0 end,
	get_objects_inside_radius = function() return {} end,
	get_item_group = function(name, grp)
		if name == "default:stone" and (grp == "stone" or grp == "cracky") then return 1 end
		return 0
	end,
	settings = {
		get = function(_self, key) return settings_table[key] end,
		set = function(_self, key, val) settings_table[key] = tostring(val) end,
	},
	setting_get_pos = function(key)
		if key == "static_spawnpoint" then
			return _G.__static_spawnpoint
		end
		return nil
	end,
	is_protected = function(pos, _player)
		if _G.__protected_areas then
			for _, area in ipairs(_G.__protected_areas) do
				if vector.distance(pos, area.pos) <= area.radius then
					return true
				end
			end
		end
		return false
	end,
}

_G.core = core_mock
_G.minetest = core_mock

_G.x_mob_core = {
	registered_mobs = registered_mobs,
	register_mob = function(name, def)
		registered_mobs[name] = def
	end,
	register_spawn = function(name, def)
		def.mob_name = name
		table.insert(registered_spawns, def)
	end,
	status_effects = { register_preset = function() end },
	listen = function() end,
	emit = function() end,
}

print("====================================================================")
print("Testing x_mobs Survival Spawning & Drop System (Multiplayer / Compat)")
print("====================================================================")

-- 1. Load Compat Layer
dofile("./compat/init.lua")
assert(x_mobs.compat, "x_mobs.compat module must be loaded")
print("  ✓ x_mobs.compat module loaded successfully")

-- 2. Test Cross-Game Drop Resolution
print("\n--- 1. Testing Cross-Game Item Drop Resolution ---")

-- Test MTG baseline (canonical names preserved when registered or headless)
assert(x_mobs.compat.resolve_item("default:steel_ingot") == "default:steel_ingot")
assert(x_mobs.compat.resolve_item("farming:string") == "farming:string")
assert(x_mobs.compat.resolve_item("tnt:gunpowder") == "tnt:gunpowder")
print("  ✓ Canonical MTG item names preserved in default environment")

-- Simulate MineClone2 / VoxeLibre registered items
registered_items["mcl_core:iron_ingot"] = { description = "Iron Ingot" }
registered_items["mcl_core:gold_ingot"] = { description = "Gold Ingot" }
registered_items["mcl_core:diamond"] = { description = "Diamond" }
registered_items["mcl_core:coal_lump"] = { description = "Coal" }
registered_items["mcl_mobitems:string"] = { description = "String" }
registered_items["mcl_mobitems:gunpowder"] = { description = "Gunpowder" }
registered_items["mcl_mushrooms:mushroom_red"] = { description = "Red Mushroom" }

assert(x_mobs.compat.resolve_item("default:steel_ingot") == "mcl_core:iron_ingot", "default:steel_ingot must resolve to mcl_core:iron_ingot")
assert(x_mobs.compat.resolve_item("default:gold_ingot") == "mcl_core:gold_ingot", "default:gold_ingot must resolve to mcl_core:gold_ingot")
assert(x_mobs.compat.resolve_item("default:diamond") == "mcl_core:diamond", "default:diamond must resolve to mcl_core:diamond")
assert(x_mobs.compat.resolve_item("default:coal_lump") == "mcl_core:coal_lump", "default:coal_lump must resolve to mcl_core:coal_lump")
assert(x_mobs.compat.resolve_item("farming:string") == "mcl_mobitems:string", "farming:string must resolve to mcl_mobitems:string")
assert(x_mobs.compat.resolve_item("tnt:gunpowder") == "mcl_mobitems:gunpowder", "tnt:gunpowder must resolve to mcl_mobitems:gunpowder")
assert(x_mobs.compat.resolve_item("flowers:mushroom_red") == "mcl_mushrooms:mushroom_red", "flowers:mushroom_red must resolve to mcl_mushrooms:mushroom_red")
print("  ✓ Item resolution seamlessly translates to VoxeLibre / MineClone2 items")

-- Test resolve_drops table transformation
local sample_drops = {
	{ name = "default:steel_ingot", min = 1, max = 3, chance = 0.8 },
	{ name = "tnt:gunpowder",       min = 1, max = 2, chance = 0.5 },
	{ name = "unregistered:rare",   min = 1, max = 1, chance = 0.1 },
}
local resolved_drops = x_mobs.compat.resolve_drops(sample_drops)
assert(#resolved_drops == 2, "resolve_drops must filter out unregistered items when registry is populated")
assert(resolved_drops[1].name == "mcl_core:iron_ingot", "First drop must be converted")
assert(resolved_drops[2].name == "mcl_mobitems:gunpowder", "Second drop must be converted")
print("  ✓ resolve_drops correctly transforms drop list, translates items, and filters missing game items")

-- Reset registered items for subsequent checks
for k in pairs(registered_items) do registered_items[k] = nil end

-- 3. Test Cross-Game Spawn Nodes Expansion
print("\n--- 2. Testing Spawn Surface Node Expansions ---")
local test_nodes = { "default:stone", "group:soil", "group:stone", "group:sand" }
local expanded = x_mobs.compat.get_spawn_nodes(test_nodes)
local expanded_set = {}
for _, n in ipairs(expanded) do expanded_set[n] = true end

assert(expanded_set["default:stone"], "default:stone preserved")
assert(expanded_set["group:soil"], "group:soil preserved")
assert(expanded_set["group:dirt"], "group:dirt added for MCL2")
assert(expanded_set["group:grass_block"], "group:grass_block added for MCL2")
assert(expanded_set["group:material_stone"], "group:material_stone added for MCL2")
assert(expanded_set["mcl_core:sand"], "mcl_core:sand added for MCL2")
print("  ✓ get_spawn_nodes correctly expands node list with MCL2 and cross-game surface groups")

-- 4. Load all mob definitions to verify their spawn parameters and drops
print("\n--- 3. Verifying All Mob Spawns and Drop Configurations ---")
dofile("./vfx/mob_particles.lua")
dofile("./items/utils.lua")

local mob_files = {
	"spider", "fallen_minion", "fallen_shaman", "armored_bug", "flying_insect",
	"skull_king", "skull_lancer", "skull_archer", "crystal_guardian",
	"crystal_guardian_minion", "nature_guardian", "nature_guardian_minion",
	"skeleton_swordfish", "fungus_minion", "crazy_mushroom", "golem",
	"golem_minion", "spectrum", "elder", "frosty_queen", "glowler_minion",
	"glowler", "chasm_weaver", "crypt_stalker", "dungeon_brute", "heated_sword",
	"suture_golem", "void_strider",
}

for _, mname in ipairs(mob_files) do
	dofile("./mobs/" .. mname .. ".lua")
end

-- Verify Frosty Queen spawn exists
local fq_spawn
for _, sp in ipairs(registered_spawns) do
	if sp.mob_name == "x_mobs:frosty_queen" then
		fq_spawn = sp
		break
	end
end
assert(fq_spawn ~= nil, "Frosty Queen must have a natural spawn registration!")
assert(fq_spawn.min_elevation == 0, "Frosty Queen min_elevation must be 0 (surface/peaks only)")
assert(fq_spawn.chance == 6000, "Frosty Queen chance must be 6000")
print("  ✓ Frosty Queen natural spawn registration verified (min_elevation = 0, chance = 6000)")

-- Verify Elder drops
local elder_mob = registered_mobs["x_mobs:elder"]
assert(elder_mob ~= nil, "Elder mob must be registered")
assert(elder_mob.drops ~= nil and #elder_mob.drops > 0, "Elder mob must have item drops!")
local elder_drop_names = {}
for _, d in ipairs(elder_mob.drops) do elder_drop_names[d.name] = true end
assert(elder_drop_names["default:coal_lump"], "Elder must drop coal")
assert(elder_drop_names["default:flint"], "Elder must drop flint")
assert(elder_drop_names["tnt:gunpowder"], "Elder must drop gunpowder")
print("  ✓ Elder drop table populated with coal, flint, and gunpowder")

-- 5. Torchlight Base Protection (max_light <= 9 for hostile mobs)
print("\n--- 4. Verifying Torchlight Base Protection Levels ---")
local hostile_night_mobs = {
	["x_mobs:spider"] = 8,
	["x_mobs:skull_archer"] = 8,
	["x_mobs:skull_lancer"] = 8,
	["x_mobs:dungeon_brute"] = 8,
	["x_mobs:fallen_minion"] = 9,
	["x_mobs:fallen_shaman"] = 9,
	["x_mobs:skull_king"] = 9,
	["x_mobs:glowler"] = 9,
	["x_mobs:glowler_minion"] = 9,
	["x_mobs:chasm_weaver"] = 9,
	["x_mobs:crypt_stalker"] = 6,
	["x_mobs:suture_golem"] = 6,
	["x_mobs:void_strider"] = 3,
}

for _, sp in ipairs(registered_spawns) do
	local expected_max = hostile_night_mobs[sp.mob_name]
	if expected_max then
		assert(sp.max_light <= expected_max,
			string.format("%s max_light is %d, expected <= %d", sp.mob_name, sp.max_light, expected_max))
	end
end
print("  ✓ All hostile ground mobs have max_light <= 9, ensuring torch-lit bases prevent hostile spawns")

-- 6. Load x_mob_core conditions module to verify protection & hub checks
print("\n--- 5. Verifying Base Protection & Safe Hub Logic in x_mob_core ---")
local conditions = dofile("../x_mob_core/spawning/conditions.lua")

local test_spawn_def = {
	mob_name = "x_mobs:spider",
	nodes = { "default:stone" },
	min_light = 0,
	max_light = 8,
	min_elevation = -31000,
	max_elevation = 31000,
}
local test_pos = { x = 0, y = 1, z = 0 }
_G.__test_light = 0

-- Normal spawn passes
assert(conditions.check(test_pos, test_spawn_def, false) == true, "Normal spawn conditions must pass")

-- Protected area rejection
_G.__protected_areas = { { pos = { x = 0, y = 1, z = 0 }, radius = 10 } }
assert(conditions.check(test_pos, test_spawn_def, false) == false, "Spawn inside protected area MUST be rejected")

-- Outside protected area passes
local unprot_pos = { x = 100, y = 1, z = 0 }
assert(conditions.check(unprot_pos, test_spawn_def, false) == true, "Spawn outside protected area must pass")
_G.__protected_areas = nil
print("  ✓ core.is_protected correctly rejects hostile mob spawning inside player base claims")

-- Static spawnpoint safe hub rejection
_G.__static_spawnpoint = { x = 0, y = 1, z = 0 }
settings_table["x_mob_spawn_protect_radius"] = "32"

-- At distance 10 (< 32), spawn rejected
assert(conditions.check(test_pos, test_spawn_def, false) == false, "Spawn within safe hub radius MUST be rejected")

-- At distance 40 (> 32), spawn permitted
local safe_pos = { x = 40, y = 1, z = 0 }
assert(conditions.check(safe_pos, test_spawn_def, false) == true, "Spawn outside safe hub radius must pass")

-- When radius is 0, safe hub check is disabled
settings_table["x_mob_spawn_protect_radius"] = "0"
assert(conditions.check(test_pos, test_spawn_def, false) == true, "Spawn at hub permitted when protect radius is 0")
_G.__static_spawnpoint = nil
print("  ✓ static_spawnpoint safe hub perimeter (x_mob_spawn_protect_radius) successfully protects spawn")

print("\n====================================================================")
print("ALL SURVIVAL SPAWNING & DROP TESTS PASSED SUCCESSFULLY! (100%)")
print("====================================================================")
