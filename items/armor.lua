--[[
	x_mobs - Items Subsystem: 3D Low-Poly Voxel Armor Sets & Full-Set Bonuses
	Author: SaKeL
	License: MIT
]]

local modpath = core.get_modpath("x_mobs")
local utils = x_mobs.items or dofile(modpath .. "/items/utils.lua")
local S = core.get_translator("x_mobs")

local DEFENSIVE_COOLDOWN = 12.0
local BODY_ELEMENTS = {"head", "torso", "legs", "feet"}

-- ==============================================================================
-- Armor Sets Definition Table
-- ==============================================================================

local ARMOR_SETS = {
	titan_bastion = {
		title = S("Titan Bastion"),
		mat_key = "titan_bastion",
		lore = S("Forged from primordial living stone and basalt slabs of the ancient Golem Titan."),
		source = S("Golem (x_mobs:golem)"),
		craft_item = S("Titan Basalt Shard (x_mobs:titan_shard)"),
		texture = "x_mobs_armor_titan_bastion.png",
		uses = 2200,
		level = {head = 18, torso = 25, legs = 20, feet = 13, shield = 18},
		models = {
			head = "x_mobs_helmet_titan_bastion.glb",
			torso = "x_mobs_chestplate_titan_bastion.glb",
			shield = "x_mobs_shield_titan_bastion.glb",
		},
		inv_icons = {
			head = "x_mobs_inv_helmet_titan_bastion.png",
			torso = "x_mobs_inv_chestplate_titan_bastion.png",
			legs = "x_mobs_inv_leggings_titan_bastion.png",
			feet = "x_mobs_inv_boots_titan_bastion.png",
			shield = "x_mobs_inv_shield_titan_bastion.png",
		},
		names = {
			head = S("Horned Basalt Helm"),
			torso = S("Monolith Cuirass"),
			legs = S("Reinforced Stone Greaves"),
			feet = S("Seismic Stompers"),
			shield = S("Basalt Crest Tower Shield"),
		},
		defensive_buff = "carapace",
		offensive_debuff = "earth_anchor",
		offensive_chance = 0.30,
		set_bonus = {
			name = S("Colossal Fortitude"),
			pieces = 4,
			desc = S("Passive Defensive: Being struck triggers Carapace (6s, 12s CD, Ironhide envelop, -30% damage, +75% poise, 3 thorns).")
				.. "\n  " .. S("Passive Offensive: 30% chance when struck to afflict attacker with Earth Anchor (4s mud envelop, 55% speed, 0 jump, 2.4x gravity)."),
		},
	},

	glacial_frostborne = {
		title = S("Glacial Frostborne"),
		mat_key = "glacial_frostborne",
		lore = S("Carved from eternal permafrost by the Frosty Queen. Emanates sub-zero glacial rime."),
		source = S("Frosty Queen (x_mobs:frosty_queen)"),
		craft_item = S("Glacial Permafrost Shard (x_mobs:glacial_shard)"),
		texture = "x_mobs_armor_glacial_frostborne.png",
		uses = 1900,
		level = {head = 17, torso = 24, legs = 19, feet = 12, shield = 17},
		models = {
			head = "x_mobs_helmet_glacial_crown.glb",
			torso = "x_mobs_chestplate_glacial_frostborne.glb",
			shield = "x_mobs_shield_glacial_frostborne.glb",
		},
		inv_icons = {
			head = "x_mobs_inv_helmet_glacial_crown.png",
			torso = "x_mobs_inv_chestplate_glacial_frostborne.png",
			legs = "x_mobs_inv_leggings_glacial_frostborne.png",
			feet = "x_mobs_inv_boots_frostwalker.png",
			shield = "x_mobs_inv_shield_glacial_frostborne.png",
		},
		names = {
			head = S("Crown of Glacial Spikes"),
			torso = S("Chilled Crystal Cuirass"),
			legs = S("Frost-Etched Greaves"),
			feet = S("Frostwalker Striders"),
			shield = S("Glacial Crest Shield"),
		},
		defensive_buff = "barrier",
		offensive_debuff = "frost",
		offensive_chance = 0.30,
		set_bonus = {
			name = S("Permafrost Sanctuary"),
			pieces = 4,
			desc = S("Passive Defensive: Being struck triggers Barrier (6s, 12s CD, Barrier envelop, cleanses debuffs, -35% damage, +80% poise).")
				.. "\n  " .. S("Passive Offensive: 30% chance when struck to encase attacker in Frost envelop (4s ice cocoon, 50% speed, 0 jump)."),
		},
	},

	skull_sovereign = {
		title = S("Skull Sovereign"),
		mat_key = "skull_sovereign",
		lore = S("Ossified royal bone filigree saturated with cold soul essence from the Skull Sovereign."),
		source = S("Skull King (x_mobs:skull_king)"),
		craft_item = S("Sovereign Bone Shard (x_mobs:sovereign_shard)"),
		texture = "x_mobs_armor_skull_sovereign.png",
		uses = 2000,
		level = {head = 18, torso = 24, legs = 19, feet = 13, shield = 17},
		models = {
			head = "x_mobs_crown_skull_sovereign.glb",
			torso = "x_mobs_chestplate_skull_sovereign.glb",
			shield = "x_mobs_shield_skull_sovereign.glb",
		},
		inv_icons = {
			head = "x_mobs_inv_crown_skull_sovereign.png",
			torso = "x_mobs_inv_chestplate_skull_sovereign.png",
			legs = "x_mobs_inv_leggings_skull_sovereign.png",
			feet = "x_mobs_inv_boots_skull_sovereign.png",
			shield = "x_mobs_inv_shield_skull_sovereign.png",
		},
		names = {
			head = S("Crown of the Skull King"),
			torso = S("Ribbed Bone Carapace"),
			legs = S("Ossified Leg Guards"),
			feet = S("Gilded Bone Greaves"),
			shield = S("Sovereign's Skull Shield"),
		},
		defensive_buff = "rejuvenation",
		offensive_debuff = "bone_shackles",
		offensive_chance = 0.25,
		set_bonus = {
			name = S("Undead Resolve"),
			pieces = 4,
			desc = S("Passive Defensive: Being struck triggers Rejuvenation (5s, 12s CD, Mending envelop, cleanses debuffs, heals 2 HP/s).")
				.. "\n  " .. S("Passive Offensive: 25% chance when struck to bind attacker in Bone Shackles (3s bone envelop, rooted, anti-heal)."),
		},
	},

	crystal_aegis = {
		title = S("Crystalline Aegis"),
		mat_key = "crystal_aegis",
		lore = S("Faceted amethyst and quartz crystal plates harmonic with the Crystal Guardian's core."),
		source = S("Crystal Guardian (x_mobs:crystal_guardian)"),
		craft_item = S("Resonant Crystal Shard (x_mobs:crystal_shard)"),
		texture = "x_mobs_armor_crystal_aegis.png",
		uses = 2100,
		level = {head = 18, torso = 24, legs = 20, feet = 13, shield = 18},
		models = {
			head = "x_mobs_helmet_crystal_aegis.glb",
			torso = "x_mobs_chestplate_crystal_aegis.glb",
			shield = "x_mobs_shield_resonant_prism.glb",
		},
		inv_icons = {
			head = "x_mobs_inv_helmet_crystal_aegis.png",
			torso = "x_mobs_inv_chestplate_crystal_aegis.png",
			legs = "x_mobs_inv_leggings_crystal_aegis.png",
			feet = "x_mobs_inv_boots_crystal_aegis.png",
			shield = "x_mobs_inv_shield_resonant_prism.png",
		},
		names = {
			head = S("Faceted Crystal Visor"),
			torso = S("Crystalline Breastplate"),
			legs = S("Prism Greaves"),
			feet = S("Resonant Sabatons"),
			shield = S("Resonant Prism Shield"),
		},
		defensive_buff = "solar_surge",
		offensive_debuff = "crystallize",
		offensive_chance = 0.25,
		set_bonus = {
			name = S("Harmonic Resonance"),
			pieces = 4,
			desc = S("Passive Defensive: Being struck triggers Solar Surge (6s, 12s CD, Radiance envelop, +30% attack, -15% damage, heals 1 HP/s).")
				.. "\n  " .. S("Passive Offensive: 25% chance when struck to Crystallize attacker (4s crystal envelop, 15% speed, +35% brittle damage)."),
		},
	},
}

-- ==============================================================================
-- Registration Dispatcher (Hooks into x_player_armor or Graceful Standalone)
-- ==============================================================================

local has_x_player_armor = (core.get_modpath("x_player_armor") ~= nil) and (_G.x_player_armor ~= nil)

local ELEMENT_TO_ITEM = {
	head = "helmet",
	torso = "chestplate",
	legs = "leggings",
	feet = "boots",
	shield = "shield",
}

for set_key, set in pairs(ARMOR_SETS) do
	for elem, slot_type in pairs(ELEMENT_TO_ITEM) do
		local item_name = "x_mobs:" .. slot_type .. "_" .. set_key
		-- Special case name aliases
		if set_key == "glacial_frostborne" and elem == "head" then
			item_name = "x_mobs:helmet_glacial_crown"
		elseif set_key == "glacial_frostborne" and elem == "feet" then
			item_name = "x_mobs:boots_frostwalker"
		elseif set_key == "skull_sovereign" and elem == "head" then
			item_name = "x_mobs:crown_skull_sovereign"
		elseif set_key == "crystal_aegis" and elem == "shield" then
			item_name = "x_mobs:shield_resonant_prism"
		end

		local item_title = set.names[elem]
		local lvl = set.level[elem]
		local inv_img = set.inv_icons[elem]
		local model_file = set.models[elem]

		local is_shield = (elem == "shield")
		local block_reduction = nil
		local block_arc = nil
		if is_shield then
			if set_key == "titan_bastion" then
				block_reduction = 0.35
				block_arc = 64
			elseif set_key == "crystal_aegis" then
				block_reduction = 0.30
				block_arc = 60
			else
				block_reduction = 0.28
				block_arc = 58
			end
		end

		local item_stats = {
			[S("Defense Group")] = "+" .. lvl .. "% " .. S("Damage Reduction"),
			[S("Durability")] = S("@1 Uses", set.uses),
			[S("Armor Slot")] = elem:sub(1, 1):upper() .. elem:sub(2),
			[S("Boss Source")] = set.source,
			[S("Forged With")] = set.craft_item,
		}
		if is_shield and block_reduction and block_arc then
			item_stats[S("Shield Block")] = "-" .. math.floor(block_reduction * 100) .. "% (" .. block_arc .. "°)"
		end

		local tooltip = utils.format_legendary_tooltip({
			title = item_title,
			category = S("Legendary 3D Armor (@1)", set.title),
			lore = set.lore,
			stats = item_stats,
			set_bonus = (not is_shield) and set.set_bonus or nil,
		})

		local piece_models = nil
		if elem == "torso" then
			piece_models = {
				torso = model_file,
				sleeve_l = "x_mobs_sleeve_l_" .. set_key .. ".glb",
				sleeve_r = "x_mobs_sleeve_r_" .. set_key .. ".glb",
			}
		elseif elem == "legs" then
			piece_models = {
				legs_l = "x_mobs_leggings_l_" .. set_key .. ".glb",
				legs_r = "x_mobs_leggings_r_" .. set_key .. ".glb",
			}
		elseif elem == "feet" then
			piece_models = {
				feet_l = "x_mobs_boot_l_" .. set_key .. ".glb",
				feet_r = "x_mobs_boot_r_" .. set_key .. ".glb",
			}
		end

		local item_groups = {
			["armor_" .. elem] = lvl,
			armor_uses = set.uses,
			["armor_material_" .. set.mat_key] = 1,
			["armor_set_" .. set_key] = 1,
			shield = is_shield and 1 or 0,
			armor_shield = is_shield and lvl or 0,
		}

		if has_x_player_armor then

			x_player_armor.register_armor(item_name, {
				description = tooltip,
				short_description = item_title,
				inventory_image = inv_img,
				texture = set.texture,
				textures = {set.texture},
				preview = inv_img,
				element = elem,
				mesh = model_file,
				models = piece_models,
				backface_culling = false,
				block_reduction = block_reduction,
				block_arc = block_arc,
				deflect_projectiles = is_shield,
				groups = item_groups,
				armor_groups = {fleshy = lvl},
				damage_groups = {cracky = 2, snappy = 3, choppy = 2, crumbly = 1, level = 1},
				reciprocate_damage = is_shield,
			})
		else
			-- Graceful standalone registration if armor mods are not active
			core.register_tool(item_name, {
				description = tooltip,
				short_description = item_title,
				inventory_image = inv_img,
				element = elem,
				mesh = (elem == "shield") and model_file or nil,
				backface_culling = false,
				groups = item_groups,
				armor_groups = {fleshy = lvl},
				tool_capabilities = {
					full_punch_interval = 1.0,
					max_drop_level = 1,
					damage_groups = {fleshy = 2},
				},
			})
		end
	end
end

-- ==============================================================================
-- 4-Piece Full-Set Evaluator (Excludes Shield) & Event-Driven State Sync
-- ==============================================================================

--- Per-player active 4-piece set cache: [player_name] = set_key
local active_player_sets = {}

--- Per-player last defensive proc timestamp: [player_name] = gametime
local defensive_cooldowns = {}

--- Resolves the player's armor inventory list (supports x_player_armor detached inventory + standalone fallback)
---@param player ObjectRef Target player
---@return table? armor_list List of equipped ItemStacks
local function get_player_armor_list(player)
	if not player or not player:is_player() then return nil end

	local xpa = rawget(_G, "x_player_armor")
	if xpa and xpa.get_valid_player then
		local _, detached_inv = xpa.get_valid_player(player)
		if detached_inv then
			local list = detached_inv:get_list("armor")
			if list then return list end
		end
	end

	local inv = player.get_inventory and player:get_inventory()
	if inv then
		return inv:get_list("armor")
	end
	return nil
end

--- Evaluates whether a player is wearing all 4 body armor pieces (head, torso, legs, feet)
--- of the same x_mobs armor set, strictly excluding shields.
---@param player ObjectRef Target player
---@return string? set_key Matching full set key or nil
function utils.get_equipped_full_set(player)
	local armor_list = get_player_armor_list(player)
	if not armor_list then return nil end

	local covered_by_set = {}

	for i = 1, #armor_list do
		local stack = armor_list[i]
		if stack and not stack:is_empty() then
			local sname = stack:get_name()
			local def = (stack.get_definition and stack:get_definition())
				or (core.registered_tools and core.registered_tools[sname])
				or (core.registered_items and core.registered_items[sname])
			local groups = (def and def.groups) or {}

			-- Strictly exclude shields from counting toward the 4-piece armor bonus
			local is_shield = (def and def.element == "shield")
				or ((groups.shield or 0) > 0)
				or ((groups.armor_shield or 0) > 0)
				or (sname:find("shield", 1, true) ~= nil)

			if not is_shield then
				local elem = def and def.element
				if not elem then
					for _, body_el in ipairs(BODY_ELEMENTS) do
						if (groups["armor_" .. body_el] or 0) > 0 then
							elem = body_el
							break
						end
					end
				end
				if not elem then
					if sname:find("helmet", 1, true) or sname:find("crown", 1, true) then
						elem = "head"
					elseif sname:find("chestplate", 1, true) then
						elem = "torso"
					elseif sname:find("leggings", 1, true) then
						elem = "legs"
					elseif sname:find("boots", 1, true) then
						elem = "feet"
					end
				end

				if elem and elem ~= "shield" then
					for set_key in pairs(ARMOR_SETS) do
						if (groups["armor_set_" .. set_key] or 0) > 0 or sname:find(set_key, 1, true)
								or (set_key == "glacial_frostborne" and (sname == "x_mobs:helmet_glacial_crown" or sname == "x_mobs:boots_frostwalker")) then
							covered_by_set[set_key] = covered_by_set[set_key] or {}
							covered_by_set[set_key][elem] = true
						end
					end
				end
			end
		end
	end

	for set_key, slots in pairs(covered_by_set) do
		if slots.head and slots.torso and slots.legs and slots.feet then
			return set_key
		end
	end

	return nil
end

--- Synchronizes a player's active 4-piece set state and removes any lingering
--- set defensive status effect when a piece is unequipped or broken.
---@param player ObjectRef Target player
---@return string? active_set Current active 4-piece set key or nil
function utils.sync_player_armor_set(player)
	if not player or not player:is_player() then return nil end
	local pname = player:get_player_name()
	if not pname or pname == "" then return nil end

	local old_set = active_player_sets[pname]
	local new_set = utils.get_equipped_full_set(player)

	if old_set and old_set ~= new_set then
		local old_def = ARMOR_SETS[old_set]
		if old_def and old_def.defensive_buff and rawget(_G, "x_mob_core") and x_mob_core.remove_status_effect then
			x_mob_core.remove_status_effect(player, old_def.defensive_buff)
		end
	end

	active_player_sets[pname] = new_set
	return new_set
end

if has_x_player_armor and x_player_armor.register_on_update then
	x_player_armor.register_on_update(function(player)
		utils.sync_player_armor_set(player)
	end)
end

if core.register_on_leaveplayer then
	core.register_on_leaveplayer(function(player)
		if not player or not player:is_player() then return end
		local pname = player:get_player_name()
		if pname then
			active_player_sets[pname] = nil
			defensive_cooldowns[pname] = nil
		end
	end)
end

-- ==============================================================================
-- Full-Set Dual Passive Combat Abilities (Event-Driven via x_mob_core & x_mobs)
-- ==============================================================================

core.register_on_punchplayer(function(player, hitter, _time_from_last_punch, _tool_capabilities, _dir, damage)
	if not player or not player:is_player() then return end
	if (damage or 0) <= 0 then return end

	local set_key = utils.sync_player_armor_set(player)
	if not set_key then return end

	local set = ARMOR_SETS[set_key]
	if not set or not rawget(_G, "x_mob_core") then return end

	local pname = player:get_player_name()
	local ppos = player:get_pos()
	local now = core.get_gametime and core.get_gametime() or 0

	-- 1. Passive Defensive Buff (applied to the defending wearer with 12s cooldown)
	local last_def = defensive_cooldowns[pname] or -999
	if (now - last_def) >= DEFENSIVE_COOLDOWN then
		defensive_cooldowns[pname] = now

		if set_key == "titan_bastion" and x_mob_core.apply_buff then
			x_mob_core.apply_buff(player, set.defensive_buff, {
				duration = 6.0,
				speed_factor = 1.0,
			})
			if ppos then
				core.sound_play("x_mobs_golem_hurt.1", {pos = ppos, gain = 0.9, max_hear_distance = 20}, true)
			end
		elseif set_key == "glacial_frostborne" and x_mob_core.apply_buff then
			x_mob_core.apply_buff(player, set.defensive_buff, {
				duration = 6.0,
				cleanse_debuffs = true,
			})
			if ppos then
				core.sound_play("x_mobs_frosty_queen_freeze.1", {pos = ppos, gain = 0.85, max_hear_distance = 20}, true)
			end
		elseif set_key == "skull_sovereign" and x_mob_core.apply_buff then
			x_mob_core.apply_buff(player, set.defensive_buff, {
				duration = 5.0,
				heal = 2,
				interval = 1.0,
				cleanse_debuffs = true,
			})
			if x_mobs.spawn_regen_particles then
				x_mobs.spawn_regen_particles(player)
			end
			if ppos then
				core.sound_play("x_mobs_skull_king_summon.1", {pos = ppos, gain = 0.9, max_hear_distance = 20}, true)
			end
		elseif set_key == "crystal_aegis" and x_mob_core.apply_buff then
			x_mob_core.apply_buff(player, set.defensive_buff, {
				duration = 6.0,
				heal = 1,
				interval = 1.0,
			})
			if x_mobs.spawn_crystal_regen then
				x_mobs.spawn_crystal_regen(player)
			end
			if ppos then
				core.sound_play("x_mobs_crystal_guardian_hurt", {pos = ppos, gain = 0.9, max_hear_distance = 20}, true)
			end
		end
	end

	-- 2. Passive Offensive Debuff (chance to afflict the attacker with boss debuff + envelop)
	if hitter and hitter.is_valid and hitter:is_valid() and hitter ~= player then
		local chance = set.offensive_chance or 0.25
		if math.random() <= chance then
			local hpos = hitter:get_pos()

			if set_key == "titan_bastion" and x_mob_core.apply_status_effect then
				x_mob_core.apply_status_effect(hitter, set.offensive_debuff)
				if hpos then
					if x_mobs.spawn_golem_hurt then
						x_mobs.spawn_golem_hurt(hpos, false)
					end
					core.sound_play("x_mobs_golem_impact", {pos = hpos, gain = 0.85, max_hear_distance = 24}, true)
				end
			elseif set_key == "glacial_frostborne" then
				if x_mobs.cast_frost_envelop then
					x_mobs.cast_frost_envelop(player, hitter, 4.0)
				elseif x_mob_core.apply_status_effect then
					x_mob_core.apply_status_effect(hitter, "ice")
				end
			elseif set_key == "skull_sovereign" and x_mob_core.apply_status_effect then
				x_mob_core.apply_status_effect(hitter, set.offensive_debuff)
				if hpos then
					if x_mobs.spawn_bone_dust then
						x_mobs.spawn_bone_dust(hpos)
					end
					core.sound_play("x_mobs_skull_king_attack", {pos = hpos, gain = 0.85, max_hear_distance = 24}, true)
				end
			elseif set_key == "crystal_aegis" and x_mob_core.apply_status_effect then
				x_mob_core.apply_status_effect(hitter, set.offensive_debuff)
				if hpos then
					if x_mobs.spawn_crystal_damage then
						x_mobs.spawn_crystal_damage(hpos, 10)
					end
					core.sound_play("x_mobs_crystal_guardian_smash", {pos = hpos, gain = 0.85, max_hear_distance = 24}, true)
				end
			end
		end
	end
end)

core.log("action", "[x_mobs] Loaded armor subsystem with 4 custom 3D low-poly voxel armor sets and x_mob_core full-set bonuses.")
