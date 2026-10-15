--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Entrypoint & Item Registration
	Provides:
	- `x_mobs:bestiary`: Craftable field compendium item with RMB / LMB usage
	- Game-agnostic group-based crafting recipes (`group:book`, `group:wood`, `group:stick`,
	  `group:leaves`, `group:stone`, `group:x_mobs_armor_material`)
	- Public API delegation (`x_mobs.bestiary.register_mob`, `scan_and_register_all`, etc.)

	Author: SaKeL
	License: MIT
]]

local modpath = core.get_modpath("x_mobs")
local S = core.get_translator("x_mobs")
local item_utils = x_mobs.items

---@class XMobsBestiary
---@field data XMobsBestiaryData Bestiary data registry and dynamic mob scanner
---@field storage XMobsBestiaryStorage Player persistence and tier evaluation subsystem
---@field hud XMobsBestiaryHUD Non-intrusive combat HUD toast notification subsystem
---@field events XMobsBestiaryEvents Event-driven discovery listener subsystem
---@field ui XMobsBestiaryUI Responsive Formspec v11 double-page tome UI subsystem
---@field trophy XMobsBestiaryTrophy Grand Hunter's Trophy pedestal and Exhibition Hall subsystem
---@field register_mob fun(mob_id: string, def?: BestiaryMobRegistrationDef): BestiaryEntryDef Registers or overrides a mob entry in the Bestiary
---@field register_category fun(category_id: string, label: string): BestiaryCategoryDef Registers or updates a category tab in the Bestiary UI
---@field scan_and_register_all fun() Dynamically scans and populates entries for all mobs in `x_mob_core.registered_mobs`
---@field get_entry fun(mob_id: string): BestiaryEntryDef? Retrieves a single bestiary entry by mob ID
---@field get_all_entries fun(category?: string, search_query?: string): BestiaryEntryDef[] Retrieves all bestiary entries matching optional filters
---@field open fun(player: ObjectRef?, overrides?: BestiaryUIOverrides) Opens the Bestiary UI for a player
x_mobs.bestiary = {}

-- Load Bestiary Submodules in Topological Order
x_mobs.bestiary.data    = dofile(modpath .. "/bestiary/data.lua")
x_mobs.bestiary.storage = dofile(modpath .. "/bestiary/storage.lua")
x_mobs.bestiary.hud     = dofile(modpath .. "/bestiary/hud.lua")
x_mobs.bestiary.events  = dofile(modpath .. "/bestiary/events.lua")
x_mobs.bestiary.ui      = dofile(modpath .. "/bestiary/ui.lua")
x_mobs.bestiary.trophy  = dofile(modpath .. "/bestiary/trophy.lua")

-- Expose top-level public API methods on `x_mobs.bestiary`
x_mobs.bestiary.register_mob          = x_mobs.bestiary.data.register_mob
x_mobs.bestiary.register_category     = x_mobs.bestiary.data.register_category
x_mobs.bestiary.scan_and_register_all = x_mobs.bestiary.data.scan_and_register_all
x_mobs.bestiary.get_entry             = x_mobs.bestiary.data.get_entry
x_mobs.bestiary.get_all_entries       = x_mobs.bestiary.data.get_all_entries
x_mobs.bestiary.open                  = x_mobs.bestiary.ui.open

-- ==============================================================================
-- 1. Bestiary of the Realm Craftitem Registration
-- ==============================================================================

--- Checks if pointed_thing has an on_rightclick callback registered (e.g. chest, furnace,
--- door, trophy pedestal, or interactive non-mob entity) and dispatches to it unless sneaking.
--- Allows players holding the Bestiary tome to interact with containers/nodes seamlessly.
---@param user ObjectRef Player wielding the Bestiary
---@param itemstack ItemStack Bestiary itemstack
---@param pointed_thing table? Pointed thing table from Luanti engine
---@return boolean handled True if an on_rightclick callback was executed
---@return ItemStack? itemstack Resulting itemstack from the interaction
local function handle_pointed_rightclick(user, itemstack, pointed_thing)
	if not user or not pointed_thing then
		return false
	end

	local is_sneaking = false
	if user.get_player_control then
		local ctrl = user:get_player_control()
		is_sneaking = (ctrl and ctrl.sneak == true)
	end

	if not is_sneaking then
		if pointed_thing.type == "node" and pointed_thing.under then
			local get_node = core.get_node_or_nil or core.get_node
			local node = get_node(pointed_thing.under) or (core.get_node and core.get_node(pointed_thing.under))
			if node then
				local ndef = core.registered_nodes and core.registered_nodes[node.name]
				if ndef and ndef.on_rightclick then
					local res = ndef.on_rightclick(pointed_thing.under, node, user, itemstack, pointed_thing)
					return true, (res ~= nil and res or itemstack)
				end
			end
		elseif pointed_thing.type == "object" and pointed_thing.ref then
			local target = pointed_thing.ref
			local is_valid = not target.is_valid or target:is_valid()
			if is_valid and not core.is_player(target) then
				local ent = target.get_luaentity and target:get_luaentity()
				-- If entity is not a mob in the bestiary registry, check for custom entity on_rightclick
				local is_mob = ent and (ent._is_mob or (ent.name and x_mobs.bestiary.data.get_entry(ent.name) ~= nil))
				if ent and ent.on_rightclick and not is_mob then
					local res = ent:on_rightclick(user, itemstack, pointed_thing)
					return true, (res ~= nil and res or itemstack)
				end
			end
		end
	end

	return false
end

core.register_craftitem("x_mobs:bestiary", {
	short_description = S("Bestiary of the Realm"),
	description = item_utils.format_legendary_tooltip({
		title = S("Bestiary of the Realm"),
		category = S("Hunter's Chronicle & Field Compendium"),
		lore = S(
			"A mahogany leather-bound tome etched with gold filigree and an arcane beast eye. Progressively documents all encountered monsters, combat stats, spells, and weaknesses."
		),
		stats = {
			[S("Open Chronicle")] = S("Right-Click (RMB) or Left-Click in air"),
			[S("Field Study")] = S("Right-Click on any creature to peacefully document it"),
			[S("Mastery Reward")] = S("Master all creatures to claim the Grand Hunter's Trophy"),
		},
	}),
	inventory_image = "x_mobs_bestiary_book.png",
	wield_image = "x_mobs_bestiary_book.png",
	groups = { book = 1, x_mobs_bestiary = 1 },
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)
		local handled, res = handle_pointed_rightclick(user, itemstack, pointed_thing)
		if handled then
			return res
		end
		if pointed_thing and pointed_thing.type == "object" and pointed_thing.ref then
			return x_mobs.bestiary.events.handle_field_study(user, pointed_thing.ref, itemstack)
		end
		x_mobs.bestiary.ui.open(user)
		return itemstack
	end,

	on_secondary_use = function(itemstack, user, pointed_thing)
		local handled, res = handle_pointed_rightclick(user, itemstack, pointed_thing)
		if handled then
			return res
		end
		if pointed_thing and pointed_thing.type == "object" and pointed_thing.ref then
			return x_mobs.bestiary.events.handle_field_study(user, pointed_thing.ref, itemstack)
		end
		x_mobs.bestiary.ui.open(user)
		return itemstack
	end,

	on_place = function(itemstack, placer, pointed_thing)
		local handled, res = handle_pointed_rightclick(placer, itemstack, pointed_thing)
		if handled then
			return res
		end
		if pointed_thing and pointed_thing.type == "object" and pointed_thing.ref then
			return x_mobs.bestiary.events.handle_field_study(placer, pointed_thing.ref, itemstack)
		end
		x_mobs.bestiary.ui.open(placer)
		return itemstack
	end,
})

-- ==============================================================================
-- 2. Game-Agnostic Group-Based Crafting Recipes (Zero dependency on `default`)
-- ==============================================================================

-- Recipe 1: Universal Book + Wilderness Materials (Works in MTG, VoxeLibre, Repixture, etc.)
core.register_craft({
	output = "x_mobs:bestiary",
	recipe = {
		{ "group:stick", "group:leaves", "group:stick" },
		{ "group:wood",  "group:book",   "group:wood"  },
		{ "group:stick", "group:stone",  "group:stick" },
	},
})

-- Recipe 2: Monster Hunter's Shard Compendium (Uses native x_mobs boss shard group)
core.register_craft({
	output = "x_mobs:bestiary",
	recipe = {
		{ "",            "group:x_mobs_armor_material", ""            },
		{ "group:stick", "group:wood",                  "group:stick" },
		{ "",            "group:wood",                  ""            },
	},
})

-- Recipe 3: Universal Field Journal Fallback (For survival games without `group:book`)
core.register_craft({
	output = "x_mobs:bestiary",
	recipe = {
		{ "group:stick",  "group:leaves", "group:stick"  },
		{ "group:leaves", "group:wood",   "group:leaves" },
		{ "group:stick",  "group:stone",  "group:stick"  },
	},
})

-- ==============================================================================
-- 3. Initialize Event Listeners & Dynamic Mob Scanner
-- ==============================================================================

x_mobs.bestiary.data.scan_and_register_all()
x_mobs.bestiary.events.init()

core.register_on_mods_loaded(function()
	x_mobs.bestiary.data.scan_and_register_all()
end)

core.log("action", "[x_mobs] Bestiary & Hunter's Chronicle subsystem initialized.")
