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
	sound_play = function(...) end,
	get_gametime = function() return current_gametime end,
	log = function(...) end,
}

-- Mock x_mob_core status effects tracker
local registered_presets = {}
local applied_buffs = {}
local applied_effects = {}
local removed_effects = {}
local frost_casts = {}

-- Global environment injection
_G.core = core_mock
_G.minetest = core_mock
_G.x_mob_core = {
	status_effects = {
		register_preset = function(name, def)
			registered_presets[name] = def
		end,
	},
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

-- 1. Load Presets & Items Subsystem
local modpath = "/Users/juraj/Library/Application Support/minetest/mods/x_mobs"
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

-- 2. Verify Status Presets Registration
print("\n--- Verifying Status Effect Presets ---")
for _, preset_id in ipairs({"carapace", "barrier", "rejuvenation", "solar_surge", "earth_anchor", "bone_shackles", "crystallize"}) do
	assert(registered_presets[preset_id], "Missing status preset in status_presets.lua: " .. preset_id)
	assert(registered_presets[preset_id].envelop_texture, "Missing envelop_texture on preset: " .. preset_id)
	print("  ✓ Preset: " .. preset_id .. " -> " .. registered_presets[preset_id].envelop_texture)
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
math.random = function() return 0.10 end

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

	on_punch(test_player, test_attacker, 1.0, {}, {x = -1, y = 0, z = 0}, 6)

	assert(#applied_buffs == 1, "Expected 1 defensive buff for " .. tc.set_key)
	assert(applied_buffs[1].target == test_player, "Defensive buff should target player")
	assert(applied_buffs[1].preset == tc.expected_buff, "Expected defensive buff " .. tc.expected_buff .. ", got " .. tostring(applied_buffs[1].preset))

	assert(#applied_effects == 1, "Expected 1 offensive debuff for " .. tc.set_key)
	assert(applied_effects[1].target == test_attacker, "Offensive debuff should target attacker")
	assert(applied_effects[1].id == tc.expected_debuff, "Expected offensive debuff " .. tc.expected_debuff .. ", got " .. tostring(applied_effects[1].id))

	-- Unequip boots (leaving 3 pieces) and verify defensive buff is immediately removed
	current_armor_stacks[4] = make_stack("")
	x_mobs.items.sync_player_armor_set(test_player)
	assert(#removed_effects == 1 and removed_effects[1].id == tc.expected_buff,
		"Unequipping 4th piece of " .. tc.set_key .. " must remove active defensive buff " .. tc.expected_buff)

	print("  ✓ Full Set [" .. tc.set_key .. "]: Defensive=" .. tc.expected_buff .. ", Offensive=" .. tc.expected_debuff .. ", Unequip Cleanup Verified")
end

math.random = orig_random

print("\n========================================")
print("ALL TESTS PASSED SUCCESSFULLY! (100%)")
print("========================================")
