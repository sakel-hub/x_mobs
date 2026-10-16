--[[
	test_boss_loot.lua
	Headless verification script for x_mobs boss loot, 3D armor sets,
	and 4-piece x_mob_core status effect set bonuses (excluding shield).
	Author: SaKeL
]]

-- Mock Luanti Engine API
local registered_craftitems = {}
local registered_tools = {}
local registered_crafts = {}
local registered_on_punchplayers = {}
local registered_on_update_callbacks = {}
local current_gametime = 1000

local core_mock
core_mock = {
	registered_craftitems = registered_craftitems,
	registered_tools = registered_tools,
	registered_items = {},
	registered_crafts = registered_crafts,

	get_current_modname = function() return "x_mobs" end,
	get_modpath = function(mod)
		if mod == "x_mobs" then
			return "./"
		end
		if mod == "x_player_armor" then
			return "./x_player_armor"
		end
		return nil
	end,

	get_translator = function(_mod)
		return function(str, ...)
			local args = {...}
			for i, v in ipairs(args) do
				str = str:gsub("@" .. i, tostring(v))
			end
			return str
		end
	end,

	colorize = function(_color, text)
		return text
	end,

	register_craftitem = function(name, def)
		registered_craftitems[name] = def
		core_mock.registered_items[name] = def
	end,

	register_tool = function(name, def)
		registered_tools[name] = def
		core_mock.registered_items[name] = def
	end,

	register_craft = function(def)
		table.insert(registered_crafts, def)
	end,

	register_on_punchplayer = function(fn)
		table.insert(registered_on_punchplayers, fn)
	end,

	register_on_leaveplayer = function(_fn) end,
	register_entity = function(_name, _def) end,
	sound_play = function() end,
	get_gametime = function() return current_gametime end,
	log = function() end,
}

-- Mock x_mob_core status effects tracker
local registered_presets = {}
local registered_mobs = {}
local applied_buffs = {}
local applied_effects = {}
local removed_effects = {}
local frost_casts = {}

local event_listeners = {}

-- Global environment injection
_G.core = core_mock
_G.minetest = core_mock
_G.x_mob_core = {
	registered_mobs = registered_mobs,
	register_mob = function(name, def)
		registered_mobs[name] = def
	end,
	register_spawn = function(_name, _def) end,
	status_effects = {
		register_preset = function(name, def)
			registered_presets[name] = def
		end,
	},
	listen = function(event_name, cb)
		event_listeners[event_name] = event_listeners[event_name] or {}
		table.insert(event_listeners[event_name], cb)
	end,
	emit = function(event_name, ...)
		local list = event_listeners[event_name] or {}
		for _, cb in ipairs(list) do
			cb(...)
		end
	end,
	apply_buff = function(target, preset_name, opts)
		table.insert(applied_buffs, {target = target, preset = preset_name, opts = opts})
		return true
	end,
	apply_status_effect = function(target, effect_def)
		local id = type(effect_def) == "string" and effect_def or (effect_def and effect_def.id)
		table.insert(applied_effects, {target = target, id = id, def = effect_def})
		return true
	end,
	remove_status_effect = function(target, effect_id)
		table.insert(removed_effects, {target = target, id = effect_id})
		return true
	end,
}

_G.x_mobs = {
	cast_frost_envelop = function(caster, target, dur)
		table.insert(frost_casts, {caster = caster, target = target, duration = dur})
		return _G.x_mob_core.apply_status_effect(target, {id = "frost", duration = dur})
	end,
	spawn_golem_hurt = function() end,
	spawn_bone_dust = function() end,
	spawn_crystal_damage = function() end,
	spawn_regen_particles = function() end,
	spawn_crystal_regen = function() end,
}

local current_armor_stacks = {}
_G.x_player_armor = {
	register_armor = function(name, def)
		core_mock.register_tool(name, def)
	end,
	register_on_update = function(fn)
		table.insert(registered_on_update_callbacks, fn)
	end,
	get_valid_player = function(player)
		if not player or not player:is_player() then return nil, nil end
		return player:get_player_name(), {
			get_list = function(_self, listname)
				if listname == "armor" then
					return current_armor_stacks
				end
				return nil
			end,
		}
	end,
}

local function make_stack(item_name)
	if not item_name or item_name == "" then
		return {
			is_empty = function() return true end,
			get_name = function() return "" end,
			get_definition = function() return nil end,
		}
	end
	return {
		is_empty = function() return false end,
		get_name = function() return item_name end,
		get_definition = function() return registered_tools[item_name] or core_mock.registered_items[item_name] end,
	}
end

print("========================================")
print("Testing x_mobs Boss Loot & Set Abilities")
print("========================================")

-- 1. Load Presets, Compat & Items Subsystem
local modpath = "/Users/juraj/Library/Application Support/minetest/mods/x_mobs"
dofile(modpath .. "/compat/init.lua")
dofile(modpath .. "/vfx/status_presets.lua")
print("  ✓ vfx/status_presets.lua loaded successfully")

x_mobs.items = dofile(modpath .. "/items/utils.lua")
assert(x_mobs.items, "Utils should be returned by utils.lua")
print("  ✓ utils.lua loaded and initialized successfully")

dofile(modpath .. "/items/materials.lua")
print("  ✓ materials.lua loaded successfully")

dofile(modpath .. "/items/armor.lua")
print("  ✓ armor.lua loaded successfully")

dofile(modpath .. "/items/crafting.lua")
print("  ✓ crafting.lua loaded successfully")

-- 2. Verify Status Presets Registration & Particle Sheet Cropping
print("\n--- Verifying Status Effect Presets ---")
for _, preset_id in ipairs({"carapace", "barrier", "rejuvenation", "solar_surge", "earth_anchor", "bone_shackles", "crystallize"}) do
	local pdef = registered_presets[preset_id]
	assert(pdef, "Missing status preset in status_presets.lua: " .. preset_id)
	assert(pdef.envelop_texture, "Missing envelop_texture on preset: " .. preset_id)
	assert(pdef.particles and type(pdef.particles.texture) == "string",
		"Missing particles.texture on preset: " .. preset_id)
	assert(pdef.particles.texture:find("%^%[sheet:8x8:"),
		"Preset " .. preset_id .. " particle sheet must be cropped with ^[sheet:8x8:, got: " .. tostring(pdef.particles.texture))
	print("  ✓ Preset: " .. preset_id .. " -> " .. pdef.envelop_texture .. " (" .. pdef.particles.texture .. ")")
end

-- 3. Verify Registration Counts & Tooltips
print("\n--- Verifying Registration Counts & Tooltips ---")
local expected_materials = {
	"x_mobs:titan_shard",
	"x_mobs:glacial_shard",
	"x_mobs:sovereign_shard",
	"x_mobs:crystal_shard",
}

for _, name in ipairs(expected_materials) do
	assert(registered_craftitems[name], "Missing registered craftitem: " .. name)
	assert(registered_craftitems[name].short_description, "Missing short_description on " .. name)
	assert(registered_craftitems[name].description, "Missing description on " .. name)
	assert(not registered_craftitems[name].description:find("Passive:", 1, true), "Shard should not have a Passive section")
	print("  ✓ Craftitem: " .. name .. " - " .. registered_craftitems[name].short_description)
end

local expected_armors = {
	-- Titan
	"x_mobs:helmet_titan_bastion",
	"x_mobs:chestplate_titan_bastion",
	"x_mobs:leggings_titan_bastion",
	"x_mobs:boots_titan_bastion",
	"x_mobs:shield_titan_bastion",
	-- Frostborne
	"x_mobs:helmet_glacial_crown",
	"x_mobs:chestplate_glacial_frostborne",
	"x_mobs:leggings_glacial_frostborne",
	"x_mobs:boots_frostwalker",
	"x_mobs:shield_glacial_frostborne",
	-- Skull Sovereign
	"x_mobs:crown_skull_sovereign",
	"x_mobs:chestplate_skull_sovereign",
	"x_mobs:leggings_skull_sovereign",
	"x_mobs:boots_skull_sovereign",
	"x_mobs:shield_skull_sovereign",
	-- Crystalline Aegis
	"x_mobs:helmet_crystal_aegis",
	"x_mobs:chestplate_crystal_aegis",
	"x_mobs:leggings_crystal_aegis",
	"x_mobs:boots_crystal_aegis",
	"x_mobs:shield_resonant_prism",
}

for _, name in ipairs(expected_armors) do
	local def = registered_tools[name]
	assert(def, "Missing registered armor piece: " .. name)
	assert(def.armor_groups, "Missing armor_groups on " .. name)
	assert(def.backface_culling == false, "Armor piece " .. name .. " must have backface_culling == false")
	if def.element == "torso" then
		assert(type(def.shield_clearance) == "table", "Torso piece must define shield_clearance: " .. name)
		assert(def.shield_clearance.glb and def.shield_clearance.glb.pos.x == -0.90 and def.shield_clearance.glb.pos.z == -0.32,
			"Torso piece must define GLB shield_clearance {-0.90, 0, -0.32}: " .. name)
		assert(def.shield_clearance.b3d and def.shield_clearance.b3d.pos.x == -0.90 and def.shield_clearance.b3d.pos.z == 0.32,
			"Torso piece must define B3D shield_clearance {-0.90, 0, 0.32}: " .. name)
	else
		assert(def.shield_clearance == nil, "Non-torso piece must not define shield_clearance: " .. name)
	end
	if def.element == "shield" then
		assert(def.description:find("Shield Block:", 1, true), "Shield tooltip must show Shield Block stat: " .. name)
		assert(not def.description:find("Set Bonus", 1, true), "Shield tooltip must not show 4-piece Set Bonus: " .. name)
	else
		assert(def.description:find("Set Bonus (4 Armor Pieces, Excl. Shield):", 1, true), "Armor piece must show 4-piece Set Bonus: " .. name)
	end
	print("  ✓ Armor: " .. name .. " - " .. def.short_description)
end

print("\n--- Verifying Crafting Recipes ---")
print("  Total Recipes Registered: " .. #registered_crafts)
assert(#registered_crafts == 20, "Expected 20 armor recipes, got " .. #registered_crafts)

-- 4. Verify 4-Piece Full-Set Detection (Excluding Shield) & Dual Passive Abilities
print("\n--- Verifying 4-Piece Full-Set Detection (Excludes Shield) & Dual Passives ---")
assert(#registered_on_punchplayers == 1, "Expected 1 on_punchplayer hook registered")
local on_punch = registered_on_punchplayers[1]

local test_player = {
	is_player = function() return true end,
	is_valid = function() return true end,
	get_player_name = function() return "tester" end,
	get_pos = function() return {x = 0, y = 10, z = 0} end,
}

local test_attacker = {
	is_player = function() return false end,
	is_valid = function() return true end,
	get_pos = function() return {x = 1, y = 10, z = 1} end,
}

-- Case A: 3 armor pieces + 1 shield of Titan Bastion -> Must NOT count as full 4-piece set
current_armor_stacks = {
	make_stack("x_mobs:helmet_titan_bastion"),
	make_stack("x_mobs:chestplate_titan_bastion"),
	make_stack("x_mobs:leggings_titan_bastion"),
	make_stack(""),
	make_stack("x_mobs:shield_titan_bastion"),
}
assert(x_mobs.items.get_equipped_full_set(test_player) == nil, "3 armor pieces + shield must NOT activate full-set bonus")
on_punch(test_player, test_attacker, 1.0, {}, {x = -1, y = 0, z = 0}, 5)
assert(#applied_buffs == 0 and #applied_effects == 0, "No buffs or effects should trigger with only 3 armor pieces + shield")
print("  ✓ 3 armor pieces + shield correctly excluded from 4-piece set bonus")

-- Force math.random to always return 0.10 so offensive proc chances (25%-30%) always succeed in test
local orig_random = math.random
rawset(math, "random", function() return 0.10 end)

local set_test_cases = {
	{
		set_key = "titan_bastion",
		items = {
			"x_mobs:helmet_titan_bastion",
			"x_mobs:chestplate_titan_bastion",
			"x_mobs:leggings_titan_bastion",
			"x_mobs:boots_titan_bastion",
		},
		expected_buff = "carapace",
		expected_debuff = "earth_anchor",
	},
	{
		set_key = "glacial_frostborne",
		items = {
			"x_mobs:helmet_glacial_crown",
			"x_mobs:chestplate_glacial_frostborne",
			"x_mobs:leggings_glacial_frostborne",
			"x_mobs:boots_frostwalker",
		},
		expected_buff = "barrier",
		expected_debuff = "frost",
	},
	{
		set_key = "skull_sovereign",
		items = {
			"x_mobs:crown_skull_sovereign",
			"x_mobs:chestplate_skull_sovereign",
			"x_mobs:leggings_skull_sovereign",
			"x_mobs:boots_skull_sovereign",
		},
		expected_buff = "rejuvenation",
		expected_debuff = "bone_shackles",
	},
	{
		set_key = "crystal_aegis",
		items = {
			"x_mobs:helmet_crystal_aegis",
			"x_mobs:chestplate_crystal_aegis",
			"x_mobs:leggings_crystal_aegis",
			"x_mobs:boots_crystal_aegis",
		},
		expected_buff = "solar_surge",
		expected_debuff = "crystallize",
	},
}

for _, tc in ipairs(set_test_cases) do
	applied_buffs = {}
	applied_effects = {}
	removed_effects = {}
	current_gametime = current_gametime + 20 -- Advance past 12s defensive cooldown

	current_armor_stacks = {
		make_stack(tc.items[1]),
		make_stack(tc.items[2]),
		make_stack(tc.items[3]),
		make_stack(tc.items[4]),
	}

	local detected = x_mobs.items.get_equipped_full_set(test_player)
	assert(detected == tc.set_key, "Expected full set " .. tc.set_key .. ", got " .. tostring(detected))

	-- 0. Probability Gating Check: roll of 0.50 (> 25%-30% chance) must NOT trigger defensive or offensive effects
	rawset(math, "random", function() return 0.50 end)
	on_punch(test_player, test_attacker, 1.0, {}, {x = -1, y = 0, z = 0}, 6)
	assert(#applied_buffs == 0, "Roll 0.50 (> 25%) must NOT trigger defensive buff for " .. tc.set_key)
	assert(#applied_effects == 0, "Roll 0.50 (> 30%) must NOT trigger offensive debuff for " .. tc.set_key)

	-- 1. Incoming Hit (with normal damage > 0 and roll 0.10 <= 25%-30% chance)
	rawset(math, "random", function() return 0.10 end)
	on_punch(test_player, test_attacker, 1.0, {}, {x = -1, y = 0, z = 0}, 6)

	assert(#applied_buffs == 1, "Expected 1 defensive buff for " .. tc.set_key)
	assert(applied_buffs[1].target == test_player, "Defensive buff should target player")
	assert(applied_buffs[1].preset == tc.expected_buff, "Expected defensive buff " .. tc.expected_buff .. ", got " .. tostring(applied_buffs[1].preset))

	assert(#applied_effects == 1, "Expected 1 offensive debuff for " .. tc.set_key)
	assert(applied_effects[1].target == test_attacker, "Offensive debuff should target attacker")
	assert(applied_effects[1].id == tc.expected_debuff, "Expected offensive debuff " .. tc.expected_debuff .. ", got " .. tostring(applied_effects[1].id))

	-- 2. Incoming Hit Mitigated to 0 Post-Armor Damage (via tool_capabilities.damage_groups.fleshy > 0)
	applied_buffs = {}
	applied_effects = {}
	current_gametime = current_gametime + 20
	on_punch(test_player, test_attacker, 1.0, {damage_groups = {fleshy = 8}}, {x = -1, y = 0, z = 0}, 0)
	assert(#applied_buffs == 1 and applied_buffs[1].preset == tc.expected_buff,
		"Mitigated 0-damage hit with fleshy > 0 must still trigger defensive buff for " .. tc.set_key)
	assert(#applied_effects == 1 and applied_effects[1].id == tc.expected_debuff,
		"Mitigated 0-damage hit with fleshy > 0 must still trigger offensive debuff for " .. tc.set_key)

	-- 3. Outgoing Strike Against Mob Entity (on_mob_hurt)
	applied_effects = {}
	local target_mob_obj = {
		is_player = function() return false end,
		is_valid = function() return true end,
		get_pos = function() return {x = 3, y = 10, z = 3} end,
	}
	x_mob_core.emit("on_mob_hurt", {object = target_mob_obj}, test_player, 10)
	assert(#applied_effects == 1 and applied_effects[1].target == target_mob_obj and applied_effects[1].id == tc.expected_debuff,
		"Outgoing strike on mob must trigger offensive debuff " .. tc.expected_debuff)

	-- 4. Outgoing Strike Against Another Player Entity (PvP on_punchplayer)
	applied_effects = {}
	local enemy_player = {
		is_player = function() return true end,
		is_valid = function() return true end,
		get_player_name = function() return "rival_player" end,
		get_pos = function() return {x = 4, y = 10, z = 4} end,
		get_inventory = function() return nil end,
	}
	-- Temporarily make get_valid_player return empty armor for rival_player and full set for test_player
	local orig_get_valid = x_player_armor.get_valid_player
	rawset(x_player_armor, "get_valid_player", function(p)
		if p == test_player then
			return orig_get_valid(p)
		end
		return "rival_player", { get_list = function() return {} end }
	end)
	on_punch(enemy_player, test_player, 1.0, {damage_groups = {fleshy = 7}}, {x = 1, y = 0, z = 0}, 5)
	rawset(x_player_armor, "get_valid_player", orig_get_valid)
	assert(#applied_effects == 1 and applied_effects[1].target == enemy_player and applied_effects[1].id == tc.expected_debuff,
		"Outgoing PvP strike on another player must trigger offensive debuff " .. tc.expected_debuff)

	-- 5. Verify set_perks metadata on non-shield pieces
	for _, iname in ipairs(tc.items) do
		local idef = registered_tools[iname]
		assert(idef and type(idef.set_perks) == "table" and #idef.set_perks == 2,
			"Armor piece " .. iname .. " must have 2 set_perks entries for ACTIVE PERKS UI")
	end

	-- 6. Unequip boots (leaving 3 pieces) and verify defensive buff is immediately removed
	current_armor_stacks[4] = make_stack("")
	x_mobs.items.sync_player_armor_set(test_player)
	assert(#removed_effects == 1 and removed_effects[1].id == tc.expected_buff,
		"Unequipping 4th piece of " .. tc.set_key .. " must remove active defensive buff " .. tc.expected_buff)

	print("  ✓ Full Set [" .. tc.set_key .. "]: Defensive=" .. tc.expected_buff
		.. ", Offensive=" .. tc.expected_debuff
		.. " (25%-30% RNG, 0-Dmg Mitigated, PvE & PvP Strikes, set_perks & Unequip Verified)")
end

rawset(math, "random", orig_random)

-- 5. Verify Secondary Punch (DoT / Thorns / Brittle) & Self-Punch Suppression
print("\n--- Verifying Secondary Punch & Self-Punch Suppression ---")
current_armor_stacks = {
	make_stack("x_mobs:crown_skull_sovereign"),
	make_stack("x_mobs:chestplate_skull_sovereign"),
	make_stack("x_mobs:leggings_skull_sovereign"),
	make_stack("x_mobs:boots_skull_sovereign"),
}
applied_buffs = {}
applied_effects = {}
current_gametime = current_gametime + 30
rawset(math, "random", function() return 0.05 end)

-- Self-punch (e.g. DoT tick where puncher == player or nil puncher) must not trigger defensive/offensive procs
on_punch(test_player, test_player, 1.0, {damage_groups = {fleshy = 4}}, {x = 0, y = 0, z = 0}, 4)
on_punch(test_player, nil, 1.0, {damage_groups = {fleshy = 4}}, {x = 0, y = 0, z = 0}, 4)
assert(#applied_buffs == 0 and #applied_effects == 0, "Self-punch or nil-hitter punch must not trigger armor set procs")

-- Secondary punch (e.g. DoT tick with external source, thorns reflection, brittle bonus damage) must be ignored
_G.x_mob_core.is_secondary_punch = function() return true end
on_punch(test_player, test_attacker, 1.0, {damage_groups = {fleshy = 6}}, {x = -1, y = 0, z = 0}, 6)
x_mob_core.emit("on_mob_hurt", {object = test_attacker}, test_player, 10)
assert(#applied_buffs == 0 and #applied_effects == 0, "Secondary punches must not trigger defensive or offensive armor set procs")
_G.x_mob_core.is_secondary_punch = function() return false end
rawset(math, "random", orig_random)
print("  ✓ Secondary punches and self/environmental punches correctly ignored by armor set procs")

-- 6. Verify Dual-Mode x_player_armor Exclusivity
print("\n--- Verifying Dual-Mode x_player_armor Exclusivity ---")

-- Mode 1: x_player_armor present (boss drops contain shards and armor pieces)
registered_mobs = {}
dofile(modpath .. "/mobs/golem.lua")
dofile(modpath .. "/mobs/frosty_queen.lua")
dofile(modpath .. "/mobs/skull_king.lua")
dofile(modpath .. "/mobs/crystal_guardian.lua")

local function has_drop_item(drops, item_name)
	for _, d in ipairs(drops or {}) do
		if d.name == item_name then
			return true
		end
	end
	return false
end

local function count_armor_drops(drops)
	local count = 0
	for _, d in ipairs(drops or {}) do
		if d.name:find("^x_mobs:helmet_") or d.name:find("^x_mobs:chestplate_") or
		   d.name:find("^x_mobs:leggings_") or d.name:find("^x_mobs:boots_") or
		   d.name:find("^x_mobs:shield_") or d.name:find("^x_mobs:crown_") then
			count = count + 1
		end
	end
	return count
end

assert(has_drop_item(registered_mobs["x_mobs:golem"].drops, "x_mobs:titan_shard"), "Golem must drop titan_shard when x_player_armor enabled")
assert(count_armor_drops(registered_mobs["x_mobs:golem"].drops) == 5, "Golem must drop 5 titan armor pieces when x_player_armor enabled")

assert(has_drop_item(registered_mobs["x_mobs:frosty_queen"].drops, "x_mobs:glacial_shard"), "Frosty Queen must drop glacial_shard when x_player_armor enabled")
assert(count_armor_drops(registered_mobs["x_mobs:frosty_queen"].drops) == 5, "Frosty Queen must drop 5 glacial armor pieces when x_player_armor enabled")

assert(has_drop_item(registered_mobs["x_mobs:skull_king"].drops, "x_mobs:sovereign_shard"), "Skull King must drop sovereign_shard when x_player_armor enabled")
assert(count_armor_drops(registered_mobs["x_mobs:skull_king"].drops) == 5, "Skull King must drop 5 sovereign armor pieces when x_player_armor enabled")

assert(has_drop_item(registered_mobs["x_mobs:crystal_guardian"].drops, "x_mobs:crystal_shard"), "Crystal Guardian must drop crystal_shard when x_player_armor enabled")
assert(count_armor_drops(registered_mobs["x_mobs:crystal_guardian"].drops) == 5, "Crystal Guardian must drop 5 crystal armor pieces when x_player_armor enabled")
print("  ✓ Mode 1 (x_player_armor enabled): all 4 boss drop tables include shards and 5 armor pieces")

-- Mode 2: x_player_armor disabled (0 shards, 0 armors, 0 recipes, 0 boss drop entries)
print("\n--- Testing Mode 2: x_player_armor DISABLED ---")
_G.x_player_armor = nil
core_mock.get_modpath = function(mod)
	if mod == "x_mobs" then
		return modpath
	end
	return nil
end

-- Clear registered registries
for k in pairs(registered_craftitems) do registered_craftitems[k] = nil end
for k in pairs(registered_tools) do registered_tools[k] = nil end
for k in pairs(core_mock.registered_items) do core_mock.registered_items[k] = nil end
for i = 1, #registered_crafts do registered_crafts[i] = nil end

-- Load items/init.lua and directly execute materials, armor, and crafting
dofile(modpath .. "/items/init.lua")
dofile(modpath .. "/items/materials.lua")
dofile(modpath .. "/items/armor.lua")
dofile(modpath .. "/items/crafting.lua")

-- Verify zero items registered
assert(next(registered_craftitems) == nil, "Craftitems must be empty when x_player_armor is disabled")
assert(next(registered_tools) == nil, "Tools/armor must be empty when x_player_armor is disabled")
assert(next(core_mock.registered_items) == nil, "Registered items must be empty when x_player_armor is disabled")
assert(#registered_crafts == 0, "No crafting recipes should be registered when x_player_armor is disabled")
print("  ✓ Mode 2 items/init: 0 craftitems, 0 armor tools, 0 crafting recipes registered")

-- Reload boss definitions in disabled mode
registered_mobs = {}
dofile(modpath .. "/mobs/golem.lua")
dofile(modpath .. "/mobs/frosty_queen.lua")
dofile(modpath .. "/mobs/skull_king.lua")
dofile(modpath .. "/mobs/crystal_guardian.lua")

local bosses = { "x_mobs:golem", "x_mobs:frosty_queen", "x_mobs:skull_king", "x_mobs:crystal_guardian" }
for _, bname in ipairs(bosses) do
	local bdef = registered_mobs[bname]
	assert(bdef, "Boss " .. bname .. " must still be registered")
	assert(#bdef.drops > 0, "Boss " .. bname .. " must retain baseline drops")
	assert(count_armor_drops(bdef.drops) == 0, "Boss " .. bname .. " must have 0 armor drops when x_player_armor disabled")
	for _, d in ipairs(bdef.drops) do
		assert(not d.name:find("^x_mobs:.*_shard"), "Boss " .. bname .. " must have 0 x_mobs shard drops when x_player_armor disabled, found: " .. d.name)
	end
	print("  ✓ Boss " .. bname .. " has clean baseline drops with zero armor/shards")
end

print("\n========================================")
print("ALL TESTS PASSED SUCCESSFULLY! (100%)")
print("========================================")
