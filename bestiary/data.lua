--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Data Registry & Dynamic Scanner
	Provides a flexible public API (`register_mob`) alongside automatic load-time
	scanning of `x_mob_core.registered_mobs` so any mob (built-in or third-party)
	is dynamically populated with live statistics, 3D model, textures, and drops.

	Author: SaKeL
	License: MIT
]]

local S = core.get_translator("x_mobs")

---@class BestiaryCategoryDef
---@field id string Unique category identifier (e.g. "Bosses", "Undead")
---@field label string Localized display label for UI tabs

---@class BestiaryDropDef
---@field name string Itemstring of the dropped item (e.g. "x_mobs:bone_dust")
---@field chance? number Drop probability between 0.0 and 1.0 (default 1.0)
---@field min? number Minimum stack quantity dropped (default 1)
---@field max? number Maximum stack quantity dropped (default 1)

---@class BestiaryModelRotation
---@field x number Pitch rotation angle in degrees
---@field y number Yaw rotation angle in degrees

---@class BestiaryAbilityDef
---@field name string Ability title
---@field desc string Ability mechanic description
---@field badge? string Semantic tag (e.g. "DoT", "Debuff", "AoE", "Summon", "Ranged", "Physical")

---@class BestiaryTierDef
---@field name string Display name of the tier (e.g. "Sighted", "Vanquished", "Mastered")
---@field kills number Required kills to reach this tier (0 for sighting tier)
---@field desc string Unlock requirement description

---@class BestiaryMobRegistrationDef
---@field name? string Localized display title
---@field category? string Category key ("Bosses", "Undead", "Guardians", "Beasts", "Aberrations")
---@field threat_level? number Threat rating from 1 to 5 stars
---@field mesh? string 3D model filename (.glb / .b3d / .obj)
---@field model? string Alias for 3D model filename
---@field textures? string|string[]|string[][] Model texture string, list, or nested variant list
---@field variant_textures? string[][] Optional array of texture variant sets
---@field model_rotation? BestiaryModelRotation Initial 3D preview rotation angles
---@field hp_max? number Maximum health points override
---@field armor? number Fleshy armor group rating override (lower = more resistant)
---@field damage? number Primary attack damage override
---@field walk_speed? number Base movement speed override
---@field pursuit_speed? number Combat pursuit speed override
---@field factions? string[] Faction tags override
---@field drops? BestiaryDropDef[] Drop definitions override
---@field habitat? string Biome / environment summary
---@field lore? string Full ecological and arcane lore entry
---@field abilities? BestiaryAbilityDef[] List of signature abilities and spells
---@field tactics? string Tactical counter-strategies and weaknesses
---@field tiers? table<number, BestiaryTierDef> Custom tier progression definitions
---@field sort_order? number Optional sort priority (lower sorts first)

---@class BestiaryEntryDef
---@field id string Technical entity name (e.g. "x_mobs:spider")
---@field name string Localized display title
---@field category string Category key ("Bosses", "Undead", "Guardians", "Beasts", "Aberrations")
---@field threat_level number Threat rating from 1 to 5 stars
---@field mesh string 3D model filename (.glb / .b3d / .obj)
---@field textures string[] Flat array of model texture strings
---@field variant_textures? string[][] Optional array of texture variant sets
---@field model_rotation BestiaryModelRotation Initial 3D preview rotation angles
---@field hp_max number Maximum health points
---@field armor number Fleshy armor group rating (lower = more resistant)
---@field damage number Primary attack damage
---@field walk_speed number Base movement speed
---@field pursuit_speed number Combat pursuit speed
---@field factions string[] Faction tags
---@field drops BestiaryDropDef[] Item drop definitions
---@field habitat string Biome / environment summary
---@field lore string Full ecological and arcane lore entry
---@field abilities BestiaryAbilityDef[] List of signature abilities and spells
---@field tactics string Tactical counter-strategies and weaknesses
---@field tiers table<number, BestiaryTierDef> Flexible tier progression definitions
---@field sort_order? number Optional sort priority

---@class XMobsBestiaryData
---@field entries table<string, BestiaryEntryDef> Registered bestiary entries keyed by mob_id
---@field ordered_ids string[] Deterministically sorted list of registered mob IDs
---@field categories BestiaryCategoryDef[] Registered UI category tabs
local data = {
	entries = {},
	ordered_ids = {},
	categories = {
		{ id = "All",         label = S("All") },
		{ id = "Bosses",      label = S("Bosses") },
		{ id = "Undead",      label = S("Undead") },
		{ id = "Guardians",   label = S("Guardians") },
		{ id = "Beasts",      label = S("Beasts") },
		{ id = "Aberrations", label = S("Aberrations") },
	},
}

---Unwraps a potentially nested texture table from x_mob_core into a flat string list.
---@param raw_tex string|string[]|string[][]|nil Raw texture specification from mob definition
---@return string[] primary_textures, string[][]? all_variants
local function resolve_textures(raw_tex)
	if type(raw_tex) == "string" then
		return { raw_tex }, { { raw_tex } }
	end
	if type(raw_tex) ~= "table" or #raw_tex == 0 then
		return { "blank.png" }, nil
	end
	if type(raw_tex[1]) == "table" then
		local variants = {}
		for i = 1, #raw_tex do
			local v = raw_tex[i]
			if type(v) == "table" and #v > 0 then
				variants[#variants + 1] = v
			end
		end
		if #variants > 0 then
			return variants[1], variants
		end
		return { "blank.png" }, nil
	end
	return raw_tex, { raw_tex }
end

---Creates default 3-tier progression rules based on creature role and threat level.
---@param is_boss boolean Whether the mob belongs to the "boss" faction
---@param threat number Threat rating from 1 to 5
---@return table<number, BestiaryTierDef> tiers
function data.create_default_tiers(is_boss, threat)
	local master_kills = 8
	if is_boss then
		master_kills = 3
	elseif threat >= 4 then
		master_kills = 4
	elseif threat >= 3 then
		master_kills = 5
	end

	return {
		[1] = {
			name = S("Sighted"),
			kills = 0,
			desc = S("Encounter in the wild or study with the Bestiary"),
		},
		[2] = {
			name = S("Vanquished"),
			kills = 1,
			desc = S("Land the killing blow (1 Kill)"),
		},
		[3] = {
			name = S("Mastered"),
			kills = master_kills,
			desc = S("Slay @1 times to master anatomy and weaknesses", tostring(master_kills)),
		},
	}
end

---Registers or updates a category tab in the Bestiary UI.
---@param category_id string Unique category identifier (e.g. "Constructs")
---@param label string Localized display label
---@return BestiaryCategoryDef category
function data.register_category(category_id, label)
	assert(type(category_id) == "string" and category_id ~= "", "[x_mobs.bestiary] category_id must be a non-empty string")
	for i = 1, #data.categories do
		if data.categories[i].id == category_id then
			data.categories[i].label = label or category_id
			return data.categories[i]
		end
	end
	local cat = { id = category_id, label = label or category_id }
	data.categories[#data.categories + 1] = cat
	return cat
end

---Infers a bestiary category from a mob's factions list if not explicitly set.
---@param factions string[]? List of faction identifiers
---@return string category
local function infer_category(factions)
	if type(factions) ~= "table" then
		return "Beasts"
	end
	local fmap = {}
	for i = 1, #factions do
		fmap[factions[i]] = true
	end
	if fmap.boss then
		return "Bosses"
	elseif fmap.undead or fmap.skeleton or fmap.necrotic then
		return "Undead"
	elseif fmap.stone or fmap.golem or fmap.crystal or fmap.nature or fmap.guardian then
		return "Guardians"
	elseif fmap.insectoid or fmap.spider or fmap.aquatic then
		return "Beasts"
	end
	return "Aberrations"
end

---Formats a technical identifier (e.g. "x_mobs:skull_king") into a clean title ("Skull King").
---@param mob_id string Technical entity identifier
---@return string formatted_title
local function format_mob_title(mob_id)
	local raw = mob_id:match(":(.+)$") or mob_id
	local words = {}
	for w in raw:gmatch("[^_]+") do
		words[#words + 1] = w:sub(1, 1):upper() .. w:sub(2)
	end
	return table.concat(words, " ")
end

---Rebuilds the sorted index of mob IDs (Bosses & high threat sorted cleanly, then alphabetical).
local function rebuild_order()
	local ids = {}
	for id in pairs(data.entries) do
		ids[#ids + 1] = id
	end
	local cat_rank = {
		Bosses = 1,
		Guardians = 2,
		Undead = 3,
		Aberrations = 4,
		Beasts = 5,
	}
	table.sort(ids, function(a, b)
		local ea = data.entries[a]
		local eb = data.entries[b]
		if ea.sort_order and eb.sort_order and ea.sort_order ~= eb.sort_order then
			return ea.sort_order < eb.sort_order
		end
		local ca = cat_rank[ea.category] or 9
		local cb = cat_rank[eb.category] or 9
		if ca ~= cb then
			return ca < cb
		end
		if (ea.threat_level or 1) ~= (eb.threat_level or 1) then
			return (ea.threat_level or 1) > (eb.threat_level or 1)
		end
		return (ea.name or a) < (eb.name or b)
	end)
	data.ordered_ids = ids
end

---Registers or updates a mob entry in the Bestiary.
---Can be called before or after mob registration; dynamically merges with the `x_mob_core` definition.
---@param mob_id string Technical mob name (e.g. "x_mobs:spider")
---@param def? BestiaryMobRegistrationDef Custom bestiary entry fields to register or override
---@return BestiaryEntryDef entry
function data.register_mob(mob_id, def)
	assert(type(mob_id) == "string" and mob_id ~= "", "[x_mobs.bestiary] mob_id must be a non-empty string")
	def = def or {}

	local existing = data.entries[mob_id] or {}
	local mdef = (x_mob_core and x_mob_core.registered_mobs and x_mob_core.registered_mobs[mob_id])
		or core.registered_entities[mob_id]
		or {}
	local props = mdef.initial_properties or {}

	local factions = def.factions or existing.factions or mdef.factions or {}
	local is_boss = false
	for i = 1, #factions do
		if factions[i] == "boss" then
			is_boss = true
			break
		end
	end

	local hp_max = def.hp_max or existing.hp_max or props.hp_max or mdef._hp_max or 20
	local threat = def.threat_level or existing.threat_level
	if not threat then
		if is_boss or hp_max >= 110 then
			threat = 5
		elseif hp_max >= 75 then
			threat = 4
		elseif hp_max >= 40 then
			threat = 3
		elseif hp_max >= 24 then
			threat = 2
		else
			threat = 1
		end
	end

	local raw_tex = def.textures or existing.textures or props.textures or mdef.textures
	local primary_tex, variants = resolve_textures(raw_tex)

	local armor_fleshy = 100
	if def.armor then
		armor_fleshy = def.armor
	elseif mdef.armor_groups and mdef.armor_groups.fleshy then
		armor_fleshy = mdef.armor_groups.fleshy
	elseif existing.armor then
		armor_fleshy = existing.armor
	end

	local entry = {
		id               = mob_id,
		name             = def.name or existing.name or props.infotext or format_mob_title(mob_id),
		category         = def.category or existing.category or infer_category(factions),
		threat_level     = threat,
		mesh             = def.mesh or def.model or existing.mesh or props.mesh or mdef.mesh or "",
		textures         = primary_tex,
		variant_textures = def.variant_textures or variants or existing.variant_textures,
		model_rotation   = def.model_rotation or existing.model_rotation or { x = 0, y = -145 },
		hp_max           = hp_max,
		armor            = armor_fleshy,
		damage           = def.damage or existing.damage or mdef.damage or 4,
		walk_speed       = def.walk_speed or existing.walk_speed or mdef.walk_speed or 3.0,
		pursuit_speed    = def.pursuit_speed or existing.pursuit_speed or mdef.pursuit_speed or mdef.walk_speed or 4.0,
		factions         = factions,
		drops            = def.drops or existing.drops or mdef.drops or {},
		habitat          = def.habitat or existing.habitat or S("Dark Caverns & Wilderness"),
		lore             = def.lore or existing.lore or S("A mysterious denizen of the realm documented through field encounters."),
		abilities        = def.abilities or existing.abilities or {
			{
				name = S("Ferocious Strike"),
				desc = S("Engages targets in close-quarters combat."),
				badge = S("Physical"),
			},
		},
		tactics          = def.tactics or existing.tactics or S("Observe movement patterns and strike between attack animations."),
		tiers            = def.tiers or existing.tiers or data.create_default_tiers(is_boss, threat),
		sort_order       = def.sort_order or existing.sort_order,
	}

	data.entries[mob_id] = entry
	rebuild_order()
	return entry
end

---Scans `x_mob_core.registered_mobs` and synchronizes or auto-registers all mobs.
---Any registered mob without `_exclude_from_bestiary = true` is automatically populated.
function data.scan_and_register_all()
	if not x_mob_core or type(x_mob_core.registered_mobs) ~= "table" then
		rebuild_order()
		return
	end
	for mob_id, mdef in pairs(x_mob_core.registered_mobs) do
		if type(mob_id) == "string" and type(mdef) == "table" and not mdef._exclude_from_bestiary then
			-- Re-invoke register_mob with existing curated fields to merge live engine properties
			data.register_mob(mob_id, data.entries[mob_id])
		end
	end
	rebuild_order()
end

---Retrieves a single bestiary entry by technical mob ID.
---@param mob_id string Technical mob name (e.g. "x_mobs:spider")
---@return BestiaryEntryDef? entry
function data.get_entry(mob_id)
	return data.entries[mob_id]
end

---Retrieves all registered bestiary entries matching optional category and search query filters.
---@param category? string Category filter ("All" or nil for all categories)
---@param search_query? string Case-insensitive substring filter matched against name, ID, or category
---@return BestiaryEntryDef[] entries
function data.get_all_entries(category, search_query)
	local results = {}
	local q = search_query and search_query:lower():gsub("^%s*(.-)%s*$", "%1") or ""

	for i = 1, #data.ordered_ids do
		local id = data.ordered_ids[i]
		local entry = data.entries[id]
		if entry then
			local cat_ok = (not category or category == "" or category == "All" or entry.category == category)
			local search_ok = true
			if q ~= "" then
				local name_l = (entry.name or ""):lower()
				local id_l = id:lower()
				local cat_l = (entry.category or ""):lower()
				search_ok = (name_l:find(q, 1, true) ~= nil)
					or (id_l:find(q, 1, true) ~= nil)
					or (cat_l:find(q, 1, true) ~= nil)
			end
			if cat_ok and search_ok then
				results[#results + 1] = entry
			end
		end
	end
	return results
end

---Returns the total number of registered bestiary mobs.
---@return number total_count
function data.get_total_count()
	return #data.ordered_ids
end

-- ==============================================================================
-- Curated Lore, Abilities & Tactical Entries for all 28 x_mobs Creatures
-- ==============================================================================

local CURATED_MOBS = {
	-- 1. BOSSES
	["x_mobs:golem"] = {
		name = S("Colossal Golem"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 1,
		damage = 12,
		habitat = S("Deep Basalt Caverns & Monolithic Ruins"),
		lore = S(
			"An ancient geomantic colossus forged from crying obsidian and gilded basalt plates. Awakened by tremors in the deep earth, its core pulses with unyielding tectonic fury."
		),
		abilities = {
			{ name = S("Tectonic Boulder Hurl"), desc = S("Rips stone from the terrain and hurls explosive boulders up to 18m."), badge = "Ranged" },
			{ name = S("Seismic Ground Slam"), desc = S("Shatters the earth in close quarters, launching shockwaves and heavy knockback."), badge = "AoE" },
			{ name = S("Geomantic Reconstruction"), desc = S("Retreats at low vitality to rapidly mend its basalt carapace."), badge = "Buff" },
		},
		tactics = S("Use natural cover to block hurled boulders. Press the offensive when its health drops below 40 HP to interrupt its regeneration phase."),
	},
	["x_mobs:frosty_queen"] = {
		name = S("Frosty Queen"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 2,
		damage = 10,
		habitat = S("Glacial Peaks, Permafrost Tundras & Ice Caverns"),
		lore = S("Sovereign of the eternal blizzard, draped in a crystalline mantle of never-melting permafrost. Her mere presence freezes the moisture in her foes' lungs."),
		abilities = {
			{ name = S("Glacial Ice Shard Volley"), desc = S("Fires razor-sharp permafrost lances that chill and slow targets."), badge = "Ranged" },
			{ name = S("Permafrost Encasement"), desc = S("Envelops victims in solid rime ice, severely reducing movement speed."), badge = "Debuff" },
			{ name = S("Blizzard Nova"), desc = S("Erupts a freezing vortex around her throne when surrounded."), badge = "AoE" },
		},
		tactics = S("Keep strafing laterally to evade ice volleys. Glacial Frostborne armor grants immunity to her freezing slowness."),
	},
	["x_mobs:skull_king"] = {
		name = S("Skull King"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 3,
		damage = 8,
		habitat = S("Ancient Catacombs, Cursed Crypts & Forsaken Keeps"),
		lore = S("An undying monarch crowned in dark steel filigree and royal sapphires. He commands legions of skeletal lancers and archers with his runic warhammer."),
		abilities = {
			{ name = S("Royal Necromancy"), desc = S("Summons up to 3 skeletal retainers (Lancers & Archers) to flank foes."), badge = "Summon" },
			{ name = S("Sovereign Warhammer Smash"), desc = S("Delivers crushing melee blows with high armor resistance."), badge = "Physical" },
			{ name = S("Soul Siphon Mending"), desc = S("Regenerates 3 HP/s while rallying his undead phalanx."), badge = "Buff" },
		},
		tactics = S("Eliminate summoned Skull Archers first to prevent crossfire, then kite the King away from his phalanx."),
	},
	["x_mobs:crystal_guardian"] = {
		name = S("Crystal Guardian"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 4,
		damage = 11,
		habitat = S("Crystalline Geodes & Mese Crystal Sanctums"),
		lore = S("A towering sentinel of living resonant quartz and prism shards. Harmonics within its lattice refract incoming kinetic force into blinding arcane bursts."),
		abilities = {
			{ name = S("Prismatic Crystallize"), desc = S("Encases targets in brittle crystal; heavy blunt strikes shatter the shell for bonus damage."), badge = "Debuff" },
			{ name = S("Resonant Shard Eruption"), desc = S("Cleaves the ground, erupting jagged crystal spires."), badge = "AoE" },
			{ name = S("Fracture Split"), desc = S("Spawns resonant Crystal Guardian Minions during prolonged engagements."), badge = "Summon" },
		},
		tactics = S("Watch for its overhead slam telegraph. Crystalline Aegis armor reflects a portion of its prismatic resonance."),
	},
	["x_mobs:nature_guardian"] = {
		name = S("Nature Guardian"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 5,
		damage = 9,
		habitat = S("Primeval Forests, Coral Woods & Overgrown Shrines"),
		lore = S("An ancient arboreal warden cloaked in seasonal foliage and gnarled ironwood bark. It awakens to punish those who despoil the ancient groves."),
		abilities = {
			{ name = S("Entangling Root Snare"), desc = S("Summons woody roots from beneath the soil that immobilize prey."), badge = "Debuff" },
			{ name = S("Ironwood Trunk Slam"), desc = S("Crushes nearby foes with sweeping timber blows."), badge = "Physical" },
			{ name = S("Sylvan Awakening"), desc = S("Calls forth Nature Guardian Minions from the surrounding undergrowth."), badge = "Summon" },
		},
		tactics = S("Never stand still when it channels its floral runes—leap clear before the roots erupt beneath your feet."),
	},
	["x_mobs:crazy_mushroom"] = {
		name = S("Crazy Mushroom"),
		category = "Bosses",
		threat_level = 5,
		sort_order = 6,
		damage = 9,
		habitat = S("Mycelial Caverns & Bioluminescent Fungal Groves"),
		lore = S("A colossal, erratic fungal matriarch bloated with volatile mycotoxins. It lurches through damp caverns, blanketing intruders in choking spore clouds."),
		abilities = {
			{ name = S("Mycotoxin Spore Barrage"), desc = S("Lobs toxic fungal globules that burst into lingering poison clouds."), badge = "DoT" },
			{ name = S("Fungal Bloom Summon"), desc = S("Germinates aggressive Fungus Minions to overwhelm attackers."), badge = "Summon" },
			{ name = S("Cap Slam"), desc = S("Viciously headbutts nearby targets with rubbery knockback."), badge = "Physical" },
		},
		tactics = S("Engage at mid-range with bows and clear out Fungus Minions before they corner you in spore clouds."),
	},
	["x_mobs:dungeon_brute"] = {
		name = S("Dungeon Brute"),
		category = "Bosses",
		threat_level = 4,
		sort_order = 7,
		damage = 11,
		habitat = S("Deep Dungeons, Iron Vaults & Subterranean Arenas"),
		lore = S("A hulking juggernaut clad in scarred iron plate. Forged for pit warfare, its gauntlet punches can dent solid steel shields."),
		abilities = {
			{ name = S("Cataclysmic Ground Slam"), desc = S("Pounds the dungeon floor, sending a concussive shockwave across the room."), badge = "AoE" },
			{ name = S("Boulder Heave"), desc = S("Hurls massive masonry chunks at distant targets."), badge = "Ranged" },
			{ name = S("Iron Gauntlet Combo"), desc = S("Unleashes relentless heavy melee hooks."), badge = "Physical" },
		},
		tactics = S("Bait its heavy slam, step out of the blast radius, and punish during its recovery window."),
	},

	-- 2. GUARDIANS & ELEMENTALS
	["x_mobs:golem_minion"] = {
		name = S("Golem Minion"),
		category = "Guardians",
		threat_level = 3,
		damage = 7,
		habitat = S("Basalt Outcrops & Colossal Golem Domains"),
		lore = S("A compact basalt construct animated by fragments of a Colossal Golem's core. Though smaller, its stone fists pack formidable weight."),
		abilities = {
			{ name = S("Stone Toss"), desc = S("Flings compact rock projectiles at ranged attackers."), badge = "Ranged" },
			{ name = S("Basalt Bash"), desc = S("Heavy close-range stone slam."), badge = "Physical" },
		},
		tactics = S("Pickaxe and heavy blunt weapons chip away its stone exterior effectively."),
	},
	["x_mobs:crystal_guardian_minion"] = {
		name = S("Crystal Guardian Minion"),
		category = "Guardians",
		threat_level = 3,
		damage = 6,
		habitat = S("Crystal Caverns & Geode Chambers"),
		lore = S("A lesser shard-construct calved from a Crystal Guardian. It patrols geode chambers in coordinated packs."),
		abilities = {
			{ name = S("Prism Slash"), desc = S("Strikes with razor-edged crystal limbs."), badge = "Physical" },
			{ name = S("Shard Resonance"), desc = S("Alerts nearby crystal constructs when attacked."), badge = "Buff" },
		},
		tactics = S("Lure individual minions away from the main Crystal Guardian before engaging."),
	},
	["x_mobs:nature_guardian_minion"] = {
		name = S("Nature Guardian Minion"),
		category = "Guardians",
		threat_level = 3,
		damage = 5,
		habitat = S("Ancient Forests & Tangled Thickets"),
		lore = S("Animated briar and sapwood spirits that serve as the eyes and claws of the Nature Guardian."),
		abilities = {
			{ name = S("Briar Lash"), desc = S("Quick thorny strikes in close combat."), badge = "Physical" },
			{ name = S("Grove Pack Link"), desc = S("Coordinates flanks with nearby sylvan allies."), badge = "Mobility" },
		},
		tactics = S("Slashing weapons and fire quickly clear out packs of sylvan minions."),
	},
	["x_mobs:heated_sword"] = {
		name = S("Heated Sword"),
		category = "Guardians",
		threat_level = 4,
		damage = 9,
		habitat = S("Magma Chambers, Forges & Obsidian Depths"),
		lore = S("A sentient greatsword tempered in primordial magma and possessed by a wrathful forge spirit. It hovers effortlessly, trailing embers and molten slag."),
		abilities = {
			{ name = S("Magma Fireball Barrage"), desc = S("Launches searing fireballs from its molten blade tip."), badge = "Ranged" },
			{ name = S("Molten Cleave & Smash"), desc = S("Slams into the ground, igniting targets with burning DoT."), badge = "DoT" },
			{ name = S("Forge Temper"), desc = S("High resistance to physical and fire damage."), badge = "Buff" },
		},
		tactics = S("Fight near water or keep moving perpendicular to its fireball trajectory."),
	},

	-- 3. UNDEAD
	["x_mobs:crypt_stalker"] = {
		name = S("Crypt Stalker"),
		category = "Undead",
		threat_level = 4,
		damage = 9,
		habitat = S("Deep Crypts, Ossuaries & Forgotten Tombs"),
		lore = S("An elongated, apex osseous predator that prowls pitch-black mausoleums. Its terrifying shriek paralyzes the unwary before it lunges from the shadows."),
		abilities = {
			{ name = S("Banshee Shriek"), desc = S("Projects a sonic necrotic wave that disorients and damages prey."), badge = "AoE" },
			{ name = S("Bone Shackle Envelop"), desc = S("Traps targets in calcified bone cages."), badge = "Debuff" },
			{ name = S("Predatory Lunge"), desc = S("Closes distance with blinding skeletal agility."), badge = "Mobility" },
		},
		tactics = S("Listen for its clicking bones in dark corridors and keep well-lit retreats ready."),
	},
	["x_mobs:suture_golem"] = {
		name = S("Suture Golem"),
		category = "Undead",
		threat_level = 4,
		damage = 8,
		habitat = S("Necrotic Laboratories & Plague Catacombs"),
		lore = S("A grotesque abomination stitched together with rusted surgical staples and coarse hemp twine. Its bloated torso churns with corrosive necrotic bile."),
		abilities = {
			{ name = S("Necrotic Bile Projectile"), desc = S("Vomits globules of acidic bile that coat targets in corrosive DoT."), badge = "DoT" },
			{ name = S("Suture Mend"), desc = S("Stitches its own wounds closed during lulls in combat."), badge = "Buff" },
			{ name = S("Cadaverous Smash"), desc = S("Crushes foes with mismatched, heavy limbs."), badge = "Physical" },
		},
		tactics = S("Sidestep its bile vomit animation and maintain steady DPS to outpace its self-stitching."),
	},
	["x_mobs:skull_lancer"] = {
		name = S("Skull Lancer"),
		category = "Undead",
		threat_level = 2,
		damage = 5,
		habitat = S("Ruined Watchtowers, Crypts & Barrow Downs"),
		lore = S("An armored skeletal vanguard wielding a tempered jousting lance and spiked heraldic shield. Disciplined even in death."),
		abilities = {
			{ name = S("Impaling Lance Thrust"), desc = S("Extended melee reach with high knockback."), badge = "Physical" },
			{ name = S("Phalanx Shield Wall"), desc = S("Holds the front line to protect Skull Archers and the Skull King."), badge = "Buff" },
		},
		tactics = S("Circle around its shield side or strike immediately after a lance lunge."),
	},
	["x_mobs:skull_archer"] = {
		name = S("Skull Archer"),
		category = "Undead",
		threat_level = 2,
		damage = 4,
		habitat = S("Cursed Battlements & Underground Ruins"),
		lore = S("Draped in a tattered midnight cowl, this skeletal marksman looses bone-tipped arrows with uncanny accuracy from elevated perches."),
		abilities = {
			{ name = S("Bone Arrow Volley"), desc = S("Fires ranged arrows from up to 16m away."), badge = "Ranged" },
			{ name = S("Evasive Reposition"), desc = S("Backs away when melee fighters close in."), badge = "Mobility" },
		},
		tactics = S("Use a shield to deflect incoming arrows while closing the gap."),
	},
	["x_mobs:fallen_shaman"] = {
		name = S("Fallen Shaman"),
		category = "Undead",
		threat_level = 3,
		damage = 6,
		habitat = S("Scorched Ruins & Ritual Caverns"),
		lore = S("A zealous pyromancer priest who commands bands of Fallen Minions. Wields a skull-topped staff crackling with hellfire."),
		abilities = {
			{ name = S("Hellfire Orb"), desc = S("Casts blazing fireballs that ignite targets on impact."), badge = "Ranged" },
			{ name = S("Warband Frenzy"), desc = S("Rallies nearby Fallen Minions into a reckless charge."), badge = "Buff" },
		},
		tactics = S("Prioritize the Shaman first—without its ranged fire support, its minion pack crumbles."),
	},
	["x_mobs:fallen_minion"] = {
		name = S("Fallen Minion"),
		category = "Undead",
		threat_level = 1,
		damage = 3,
		habitat = S("Shallow Caves, Ruins & Shaman Camps"),
		lore = S("Frenzied, diminutive imps bound to the service of Fallen Shamans. Alone they are cowardly, but in swarms they overwhelm careless travelers."),
		abilities = {
			{ name = S("Swarm Rush"), desc = S("Alerts nearby pack members to converge on a single target."), badge = "Mobility" },
			{ name = S("Feral Scratch"), desc = S("Quick, low-damage claw slashes."), badge = "Physical" },
		},
		tactics = S("Wide-arc sword sweeps or bottlenecks prevent their swarm from surrounding you."),
	},
	["x_mobs:skeleton_swordfish"] = {
		name = S("Skeleton Swordfish"),
		category = "Undead",
		threat_level = 3,
		damage = 6,
		habitat = S("Abyssal Oceans, Shipwrecks & Sunken Caverns"),
		lore = S("The reanimated ossified remains of a deep-sea apex billfish. Its serrated rostral sword gleams with eerie cyan soul-light beneath the waves."),
		abilities = {
			{ name = S("Abyssal Skewer Dash"), desc = S("Propels itself through water at high speed to impale swimmers."), badge = "Mobility" },
			{ name = S("Waterlogged Brine Curse"), desc = S("Inflicts brine drag that weighs down aquatic movement."), badge = "Debuff" },
		},
		tactics = S("Fight from a boat or shoreline whenever possible; underwater it holds the speed advantage."),
	},

	-- 4. BEASTS & INSECTOIDS
	["x_mobs:spider"] = {
		name = S("Nether Arachnid"),
		category = "Beasts",
		threat_level = 3,
		damage = 7,
		habitat = S("Dark Caverns, Cursed Forests & Shaded Ravines"),
		lore = S("A nocturnal, eight-eyed hunter capable of scaling vertical stone walls and ceilings. Its spinnerets weave sticky silk while its fangs drip neurotoxic venom."),
		abilities = {
			{ name = S("Venom Bite Envelop"), desc = S("20% chance to inflict 1 HP/s armor-piercing poison for 3s."), badge = "DoT" },
			{ name = S("Viscous Web Shot"), desc = S("Ranged silk snare that slows player movement by 50% for 3s."), badge = "Debuff" },
			{ name = S("Explosive Pounce Leap"), desc = S("Leaps onto prey from afar, dealing 7 fleshy impact damage."), badge = "Mobility" },
		},
		tactics = S("Check cave ceilings before advancing. Avoid getting hit by Venom while already Webbed, which triggers a lethal synergy burst."),
	},
	["x_mobs:chasm_weaver"] = {
		name = S("Chasm Weaver"),
		category = "Beasts",
		threat_level = 3,
		damage = 6,
		habitat = S("Deep Abysses, Crystal Chasms & Lush Jungles"),
		lore = S("An ornate, jewel-toned tarantula adapted to deep subterranean chasms. It flicks clouds of barbed urticating setae hairs to blind andward off predators."),
		abilities = {
			{ name = S("Urticating Setae Barrage"), desc = S("Fires irritating barbed hairs that impair vision and movement."), badge = "Ranged" },
			{ name = S("Chasm Silk Tether"), desc = S("Anchors and snares targets with high-tensile silk."), badge = "Debuff" },
		},
		tactics = S("Keep your shield raised when it brushes its abdomen with its hind legs to launch setae."),
	},
	["x_mobs:armored_bug"] = {
		name = S("Armored Bug"),
		category = "Beasts",
		threat_level = 2,
		damage = 5,
		habitat = S("Arid Badlands, Stone Caves & Underground Hives"),
		lore = S("A heavily plated coleopteran insectoid encased in overlapping chitinous segments. Its mandibles can shear through timber and leather alike."),
		abilities = {
			{ name = S("Chitin Carapace"), desc = S("Natural armor plating that shrugs off light slashing blows."), badge = "Buff" },
			{ name = S("Mandible Crush"), desc = S("Lunges forward with interlocking jaws."), badge = "Physical" },
		},
		tactics = S("Strike with heavy weapons and time your hits between its mandible lunges."),
	},
	["x_mobs:flying_insect"] = {
		name = S("Flying Insect"),
		category = "Beasts",
		threat_level = 2,
		damage = 4,
		habitat = S("Swamps, Canopies & Humid Cavern Vaults"),
		lore = S("A swift, buzzing aerial predator with golden-amber wings and a barbed stinger. Hunts in erratic three-dimensional patterns."),
		abilities = {
			{ name = S("Aerial Dive Sting"), desc = S("Swoops down from above to deliver rapid stings."), badge = "Mobility" },
			{ name = S("Evasive Hover"), desc = S("Difficult to hit with slow melee swings while airborne."), badge = "Buff" },
		},
		tactics = S("Use bows or wait for it to swoop down to eye level before swinging."),
	},
	["x_mobs:glowler"] = {
		name = S("Glowler"),
		category = "Beasts",
		threat_level = 4,
		damage = 8,
		habitat = S("Bioluminescent Depths &Subterranean Lakes"),
		lore = S("An apex bioluminescent predator whose lures glow with hypnotic cyan light in the abyssal dark. Commands swarms of Glowler Minions."),
		abilities = {
			{ name = S("Bioluminescent Pulse"), desc = S("Discharges blinding bio-electric orbs at ranged foes."), badge = "Ranged" },
			{ name = S("Brood Call"), desc = S("Summons Glowler Minions to harry attackers."), badge = "Summon" },
		},
		tactics = S("Do not be lured into tight tunnels by its glow; fight in open chambers where you can dodge its bio-orbs."),
	},
	["x_mobs:glowler_minion"] = {
		name = S("Glowler Minion"),
		category = "Beasts",
		threat_level = 1,
		damage = 3,
		habitat = S("Bioluminescent Caves & Glowler Nests"),
		lore = S("A juvenile neon-cyan insectoid that orbits adult Glowlers, feeding on scraps and defending the brood."),
		abilities = {
			{ name = S("Neon Dart"), desc = S("Fast, erratic flying nip."), badge = "Mobility" },
		},
		tactics = S("Eliminate quickly with sweeping melee attacks so they cannot distract you from the adult Glowler."),
	},

	-- 5. ABERRATIONS
	["x_mobs:void_strider"] = {
		name = S("Void Strider"),
		category = "Aberrations",
		threat_level = 4,
		damage = 8,
		habitat = S("Deep Void Rifts, Obsidian Abysses & Astral Planes"),
		lore = S("An extradimensional cosmic stalker plated in dark void chitin etched with glowing violet nebula veins. It steps between spatial folds to ambush prey."),
		abilities = {
			{ name = S("Phase Blink Teleport"), desc = S("Warps through dimensional rifts to appear behind its target."), badge = "Mobility" },
			{ name = S("Accretion Void Beam"), desc = S("Projects a concentrated beam of cosmic entropy."), badge = "Ranged" },
			{ name = S("Planar Screech"), desc = S("Distorts gravity and warps nearby space."), badge = "AoE" },
		},
		tactics = S("Listen for its warp sound cue and immediately spin around to parry its backstab slash."),
	},
	["x_mobs:spectrum"] = {
		name = S("Spectrum"),
		category = "Aberrations",
		threat_level = 3,
		damage = 7,
		habitat = S("Haunted Ruins, Shadow Rifts & Night Skies"),
		lore = S("A floating phantom aberration draped in a tattered midnight-violet cowl. Its ectoplasmic talons phase through conventional defenses."),
		abilities = {
			{ name = S("Ectoplasmic Orb"), desc = S("Hurls spectral projectiles that shroud victims in shadow flames."), badge = "Ranged" },
			{ name = S("Wraith Levitation"), desc = S("Glides effortlessly over obstacles and chasms."), badge = "Mobility" },
		},
		tactics = S("Counter-snipe with ranged weapons or strike when it descends to talon range."),
	},
	["x_mobs:elder"] = {
		name = S("Elder"),
		category = "Aberrations",
		threat_level = 3,
		damage = 18,
		habitat = S("Silent Caverns & Dark Wilderness"),
		lore = S(
			"A deceptively quiet, volatile ambush stalker that creeps toward travelers without a single footstep. When cornered, it swells with unstable gas and detonates violently."
		),
		abilities = {
			{ name = S("Silent Stalk"), desc = S("Approaches targets with zero footstep audio."), badge = "Stealth" },
			{ name = S("Cataclysmic Detonation"), desc = S("Ignites a 2.2s fuse within 3.2m, carving a blast crater and dealing massive AoE damage."), badge = "AoE" },
			{ name = S("Tactical Defusal"), desc = S("Defuses and resumes pursuit if the player retreats beyond 6.0m before detonation."), badge = "Buff" },
		},
		tactics = S("Hit and immediately sprint backward beyond 6 blocks when you hear its sputtering fuse ignite!"),
	},
	["x_mobs:fungus_minion"] = {
		name = S("Fungus Minion"),
		category = "Aberrations",
		threat_level = 1,
		damage = 3,
		habitat = S("Damp Caves, Mushroom Biomes & Fungal Groves"),
		lore = S("An ambulatory, spore-Puffing toadstool creature spawned from the mycelium of the Crazy Mushroom."),
		abilities = {
			{ name = S("Spore Nip"), desc = S("Short-range fungal bite."), badge = "Physical" },
		},
		tactics = S("Easily dispatched in one or two strikes; watch out for swarms during Crazy Mushroom boss fights."),
	},
}

-- Register all 28 curated entries initially
for mob_id, cdef in pairs(CURATED_MOBS) do
	data.register_mob(mob_id, cdef)
end

return data
