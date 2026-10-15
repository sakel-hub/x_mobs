--[[
	x_mobs - Items Subsystem: 3D Armor Set Crafting Recipes
	Author: SaKeL
	License: MIT
]]

local has_x_player_armor = (core.get_modpath("x_player_armor") ~= nil) and (_G.x_player_armor ~= nil)
if not has_x_player_armor then
	return
end

local ARMOR_RECIPES = {

	{
		ingredient = "x_mobs:titan_shard",
		helmet     = "x_mobs:helmet_titan_bastion",
		chestplate = "x_mobs:chestplate_titan_bastion",
		leggings   = "x_mobs:leggings_titan_bastion",
		boots      = "x_mobs:boots_titan_bastion",
		shield     = "x_mobs:shield_titan_bastion",
	},
	{
		ingredient = "x_mobs:glacial_shard",
		helmet     = "x_mobs:helmet_glacial_crown",
		chestplate = "x_mobs:chestplate_glacial_frostborne",
		leggings   = "x_mobs:leggings_glacial_frostborne",
		boots      = "x_mobs:boots_frostwalker",
		shield     = "x_mobs:shield_glacial_frostborne",
	},
	{
		ingredient = "x_mobs:sovereign_shard",
		helmet     = "x_mobs:crown_skull_sovereign",
		chestplate = "x_mobs:chestplate_skull_sovereign",
		leggings   = "x_mobs:leggings_skull_sovereign",
		boots      = "x_mobs:boots_skull_sovereign",
		shield     = "x_mobs:shield_skull_sovereign",
	},
	{
		ingredient = "x_mobs:crystal_shard",
		helmet     = "x_mobs:helmet_crystal_aegis",
		chestplate = "x_mobs:chestplate_crystal_aegis",
		leggings   = "x_mobs:leggings_crystal_aegis",
		boots      = "x_mobs:boots_crystal_aegis",
		shield     = "x_mobs:shield_resonant_prism",
	},
}

for i = 1, #ARMOR_RECIPES do
	local set = ARMOR_RECIPES[i]
	local ing = set.ingredient

	-- Helmet / Crown (5 shards)
	core.register_craft({
		output = set.helmet,
		recipe = {
			{ing, ing, ing},
			{ing, "",  ing},
		},
	})

	-- Chestplate (8 shards)
	core.register_craft({
		output = set.chestplate,
		recipe = {
			{ing, "",  ing},
			{ing, ing, ing},
			{ing, ing, ing},
		},
	})

	-- Leggings (7 shards)
	core.register_craft({
		output = set.leggings,
		recipe = {
			{ing, ing, ing},
			{ing, "",  ing},
			{ing, "",  ing},
		},
	})

	-- Boots (4 shards)
	core.register_craft({
		output = set.boots,
		recipe = {
			{ing, "", ing},
			{ing, "", ing},
		},
	})

	-- Shield (7 shards)
	core.register_craft({
		output = set.shield,
		recipe = {
			{ing, ing, ing},
			{ing, ing, ing},
			{"",  ing, ""},
		},
	})
end

core.log("action", "[x_mobs] Loaded deterministic crafting recipes for 4 legendary 3D armor sets.")
