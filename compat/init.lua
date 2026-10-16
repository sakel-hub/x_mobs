--[[
	x_mobs - Compatibility Adaptor Subsystem
	Modular cross-game and cross-mod integration layer for Luanti.
	Provides automatic translation of item drops and expansion of spawn surface
	nodes across Minetest Game, VoxeLibre / MineClone2, Hades Revisited, and Everness.

	Author: SaKeL
	License: MIT
]]

---@class XMobsCompat
local compat = {}

--- Canonical equivalence mapping between Minetest Game and other Luanti games
local ITEM_EQUIVALENTS = {
	["farming:string"]                = { "mcl_mobitems:string", "hades_farming:string" },
	["farming:cotton"]                = { "mcl_wool:wool_white", "hades_farming:cotton" },
	["vessels:glass_bottle"]          = { "mcl_potions:glass_bottle", "mcl_bottles:glass_bottle", "hades_vessels:glass_bottle" },
	["flowers:mushroom_red"]          = { "mcl_mushrooms:mushroom_red", "hades_flowers:mushroom_red" },
	["flowers:mushroom_brown"]        = { "mcl_mushrooms:mushroom_brown", "hades_flowers:mushroom_brown" },
	["tnt:gunpowder"]                 = { "mcl_mobitems:gunpowder", "hades_tnt:gunpowder" },
	["default:flint"]                 = { "mcl_core:flint", "hades_core:flint" },
	["default:coal_lump"]             = { "mcl_core:coal_lump", "hades_core:coal_lump" },
	["default:clay_lump"]             = { "mcl_core:clay_lump", "hades_core:clay_lump" },
	["default:steel_ingot"]           = { "mcl_core:iron_ingot", "hades_core:steel_ingot" },
	["default:iron_lump"]             = { "mcl_raw_ores:raw_iron", "mcl_core:iron_lump", "hades_core:iron_lump" },
	["default:tin_lump"]              = { "hades_core:tin_lump", "mcl_core:iron_nugget" },
	["default:copper_lump"]           = { "mcl_raw_ores:raw_copper", "mcl_core:copper_lump", "hades_core:copper_lump" },
	["default:gold_lump"]             = { "mcl_raw_ores:raw_gold", "mcl_core:gold_lump", "hades_core:gold_lump" },
	["default:gold_ingot"]            = { "mcl_core:gold_ingot", "hades_core:gold_ingot" },
	["default:diamond"]               = { "mcl_core:diamond", "hades_core:diamond" },
	["default:mese_crystal"]          = { "mcl_core:emerald", "hades_core:mese_crystal" },
	["default:mese_crystal_fragment"] = { "mcl_core:redstone", "hades_core:mese_crystal_fragment" },
	["default:obsidian_shard"]        = { "mcl_core:obsidian", "hades_core:obsidian_shard" },
	["default:obsidian"]              = { "mcl_core:obsidian", "hades_core:obsidian" },
	["default:stick"]                 = { "mcl_core:stick", "hades_core:stick" },
	["default:torch"]                 = { "mcl_torches:torch", "hades_torches:torch" },
	["default:apple"]                 = { "mcl_core:apple", "hades_core:apple" },
	["default:tree"]                  = { "mcl_core:tree", "hades_core:tree" },
	["default:sapling"]               = { "mcl_core:sapling", "hades_core:sapling" },
	["default:junglesapling"]         = { "mcl_core:jungle_sapling" },
	["default:gravel"]                = { "mcl_core:gravel", "hades_core:gravel" },
	["default:sand"]                  = { "mcl_core:sand", "hades_core:sand" },
	["default:cobble"]                = { "mcl_core:cobble", "hades_core:cobble" },
	["default:stone"]                 = { "mcl_core:stone", "hades_core:stone" },
	["default:ice"]                   = { "mcl_core:ice", "hades_core:ice" },
	["default:snowblock"]             = { "mcl_core:snowblock", "hades_core:snowblock" },
	["default:book"]                  = { "mcl_books:book", "hades_core:book" },
	["default:paper"]                 = { "mcl_core:paper", "hades_core:paper" },
	["everness:quartz_crystal"]       = { "mcl_nether:quartz", "hades_core:quartz_crystal" },
}

--- Checks whether an item technical name is registered in the engine
---@param item_name string
---@return boolean is_registered
local function is_registered(item_name)
	if not item_name or item_name == "" or item_name == "air" or item_name == "ignore" then
		return false
	end
	return (core.registered_items and core.registered_items[item_name] ~= nil)
		or (core.registered_craftitems and core.registered_craftitems[item_name] ~= nil)
		or (core.registered_tools and core.registered_tools[item_name] ~= nil)
		or (core.registered_nodes and core.registered_nodes[item_name] ~= nil)
end

--- Resolves a canonical item name to the active game's registered equivalent.
--- If running in a headless test environment with empty registries, preserves the canonical name.
---@param item_name string Technical item name (e.g. "default:diamond")
---@return string resolved_name Active game item name
function compat.resolve_item(item_name)
	if not item_name or item_name == "" then return item_name end

	-- In headless unit test environments with empty item registries, keep canonical name
	local reg_empty = (core.registered_items == nil or next(core.registered_items) == nil)
	if reg_empty then
		return item_name
	end

	-- If the requested item is directly registered, keep it
	if is_registered(item_name) then
		return item_name
	end

	-- Search equivalent candidates for the active game
	local equivs = ITEM_EQUIVALENTS[item_name]
	if equivs then
		for i = 1, #equivs do
			local cand = equivs[i]
			if is_registered(cand) then
				return cand
			end
		end
	end

	return item_name
end

--- Resolves a declarative loot drop table to active game items.
--- Automatically translates items and filters out entries that do not exist in the active game.
---@param drop_list (table|string)[] Declarative drop entries
---@return (table|string)[] resolved_drops Validated drop table
function compat.resolve_drops(drop_list)
	if not drop_list or #drop_list == 0 then return {} end

	local reg_empty = (core.registered_items == nil or next(core.registered_items) == nil)
	local resolved = {}

	for i = 1, #drop_list do
		local entry = drop_list[i]
		if type(entry) == "string" then
			local target = compat.resolve_item(entry)
			if reg_empty or is_registered(target) then
				resolved[#resolved + 1] = target
			end
		elseif type(entry) == "table" and entry.name then
			local target = compat.resolve_item(entry.name)
			if reg_empty or is_registered(target) then
				local clone = {}
				for k, v in pairs(entry) do clone[k] = v end
				clone.name = target
				resolved[#resolved + 1] = clone
			end
		end
	end

	return resolved
end

--- Expands a base list of spawn nodes and groups to encompass cross-game surfaces
--- (e.g. group:soil -> group:dirt, group:grass_block; group:stone -> group:material_stone)
---@param base_nodes string[] List of nodes or groups
---@return string[] expanded_nodes Deduplicated surface nodes and groups
function compat.get_spawn_nodes(base_nodes)
	if not base_nodes or #base_nodes == 0 then return {} end

	local seen = {}
	local expanded = {}

	local function add_node(n)
		if n and n ~= "" and not seen[n] then
			seen[n] = true
			expanded[#expanded + 1] = n
		end
	end

	local has_soil = false
	local has_stone = false
	local has_sand = false
	local has_ice = false
	local has_water = false

	for i = 1, #base_nodes do
		local n = base_nodes[i]
		add_node(n)

		if n == "group:soil" or n == "default:dirt_with_grass" or n == "default:dirt" then
			has_soil = true
		end
		if n == "group:stone" or n == "default:stone" or n == "default:cobble" then
			has_stone = true
		end
		if n == "group:sand" or n == "default:sand" then
			has_sand = true
		end
		if n == "group:ice" or n == "group:snowy" or n == "default:ice" or n == "default:snowblock" then
			has_ice = true
		end
		if n == "group:water" or n == "default:water_source" then
			has_water = true
		end
	end

	-- VoxeLibre / MineClone2 & Hades surface expansion
	if has_soil then
		add_node("group:dirt")
		add_node("group:grass_block")
		add_node("mcl_core:dirt_with_grass")
		add_node("mcl_core:dirt")
	end

	if has_stone then
		add_node("group:material_stone")
		add_node("mcl_core:stone")
		add_node("mcl_core:cobble")
		add_node("mcl_core:deepslate")
	end

	if has_sand then
		add_node("mcl_core:sand")
		add_node("mcl_core:red_sand")
	end

	if has_ice then
		add_node("group:snowy")
		add_node("group:ice")
		add_node("mcl_core:ice")
		add_node("mcl_core:packed_ice")
		add_node("mcl_core:snowblock")
	end

	if has_water then
		add_node("mcl_core:water_source")
		add_node("hades_core:water_source")
	end

	return expanded
end

_G.x_mobs = rawget(_G, "x_mobs") or {}
_G.x_mobs.compat = compat
return compat
