--[[
	x_mobs - Items Subsystem: 3D Armor Forging Shards & Materials
	Author: SaKeL
	License: MIT
]]

local modpath = core.get_modpath("x_mobs")
local utils = x_mobs.items or dofile(modpath .. "/items/utils.lua")
local S = core.get_translator("x_mobs")

local has_x_player_armor = (core.get_modpath("x_player_armor") ~= nil) and (_G.x_player_armor ~= nil)
if not has_x_player_armor then
	return
end

-- ==============================================================================
-- Legendary 3D Armor Forging Shards
-- ==============================================================================


-- 1. Titan Basalt Shard (Golem -> Titan Bastion Armor Set)
core.register_craftitem("x_mobs:titan_shard", {
	short_description = S("Titan Basalt Shard"),
	description = utils.format_legendary_tooltip({
		title = S("Titan Basalt Shard"),
		category = S("Legendary Armor Forging Material (Titan Bastion)"),
		lore = S("A dense, gilded basalt plate fragment cleaved from the Colossal Golem Titan. Pulses with unyielding geomantic fortitude."),
		stats = {
			[S("Dropped By")] = S("Golem (x_mobs:golem)"),
			[S("Forges Set")] = S("Titan Bastion 3D Armor Set"),
			[S("Crafting Grid")] = S("Helmet (5), Chestplate (8), Leggings (7), Boots (4), Shield (7)"),
		},
	}),
	inventory_image = "x_mobs_titan_shard.png",
	groups = {craftitem = 1, x_mobs_armor_material = 1, x_mobs_titan = 1},
	stack_max = 64,
})

-- 2. Glacial Permafrost Shard (Frosty Queen -> Glacial Frostborne Armor Set)
core.register_craftitem("x_mobs:glacial_shard", {
	short_description = S("Glacial Permafrost Shard"),
	description = utils.format_legendary_tooltip({
		title = S("Glacial Permafrost Shard"),
		category = S("Legendary Armor Forging Material (Glacial Frostborne)"),
		lore = S("A razor-sharp crystal of eternal permafrost shattered from the Frosty Queen's glacial mantle. Never melts and chills the surrounding air."),
		stats = {
			[S("Dropped By")] = S("Frosty Queen (x_mobs:frosty_queen)"),
			[S("Forges Set")] = S("Glacial Frostborne 3D Armor Set"),
			[S("Crafting Grid")] = S("Helmet (5), Chestplate (8), Leggings (7), Boots (4), Shield (7)"),
		},
	}),
	inventory_image = "x_mobs_glacial_shard.png",
	groups = {craftitem = 1, x_mobs_armor_material = 1, x_mobs_frost = 1},
	stack_max = 64,
})

-- 3. Sovereign Bone Shard (Skull King -> Skull Sovereign Armor Set)
core.register_craftitem("x_mobs:sovereign_shard", {
	short_description = S("Sovereign Bone Shard"),
	description = utils.format_legendary_tooltip({
		title = S("Sovereign Bone Shard"),
		category = S("Legendary Armor Forging Material (Skull Sovereign)"),
		lore = S("An ossified royal bone fragment etched with dark steel filigree and glowing cyan soul essence from the Skull King."),
		stats = {
			[S("Dropped By")] = S("Skull King (x_mobs:skull_king)"),
			[S("Forges Set")] = S("Skull Sovereign 3D Armor Set"),
			[S("Crafting Grid")] = S("Helmet (5), Chestplate (8), Leggings (7), Boots (4), Shield (7)"),
		},
	}),
	inventory_image = "x_mobs_sovereign_shard.png",
	groups = {craftitem = 1, x_mobs_armor_material = 1, x_mobs_undead = 1},
	stack_max = 64,
})

-- 4. Resonant Crystal Shard (Crystal Guardian -> Crystalline Aegis Armor Set)
core.register_craftitem("x_mobs:crystal_shard", {
	short_description = S("Resonant Crystal Shard"),
	description = utils.format_legendary_tooltip({
		title = S("Resonant Crystal Shard"),
		category = S("Legendary Armor Forging Material (Crystalline Aegis)"),
		lore = S("A faceted amethyst and quartz prism shard harvested from the Crystal Guardian. Hums with protective harmonic frequencies."),
		stats = {
			[S("Dropped By")] = S("Crystal Guardian (x_mobs:crystal_guardian)"),
			[S("Forges Set")] = S("Crystalline Aegis 3D Armor Set"),
			[S("Crafting Grid")] = S("Helmet (5), Chestplate (8), Leggings (7), Boots (4), Shield (7)"),
		},
	}),
	inventory_image = "x_mobs_crystal_shard.png",
	groups = {craftitem = 1, x_mobs_armor_material = 1, x_mobs_crystal = 1},
	stack_max = 64,
})

core.log("action", "[x_mobs] Loaded materials subsystem with 4 legendary armor forging shards.")
