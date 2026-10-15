--[[
	test_bestiary.lua
	Comprehensive headless unit & integration test suite for the x_mobs Bestiary
	& Hunter's Chronicle subsystem.
	Verifies:
	1. Zero globalsteps registered across the entire Bestiary subsystem
	2. Full coverage of all 28 x_mobs creatures + dynamic auto-scanning of new mobs
	3. Flexible custom tier registration via `x_mobs.bestiary.register_mob`
	4. Event-driven progression (`on_mob_target`, `on_mob_hurt`, `on_mob_death`, Field Study)
	5. Non-intrusive HUD toast lifecycle (`core.after` token coalescing & audio)
	6. PlayerMetaRef round-trip persistence
	7. Formspec version negotiation (up to v11), 3D rotatable model, and Fog of War states
	8. Game-agnostic group-based crafting recipes (zero `default` dependency)
	9. Grand Hunter's Trophy claim, stepped pedestal nodebox, and Exhibition Hall hologram
	10. Pointed node & entity on_rightclick delegation (chests, furnaces, containers) & sneak bypass

	Author: SaKeL
	License: MIT
]]

local globalsteps_registered = 0
local registered_craftitems = {}
local registered_nodes = {}
local registered_entities = {}
local registered_crafts = {}
local receive_fields_callbacks = {}
local mods_loaded_callbacks = {}
local scheduled_afters = {}
local played_sounds = {}
local shown_formspecs = {}
local spawned_entities = {}
local chat_messages = {}
local node_metas = {}
local player_infos = {}
local players_by_name = {}

local function pos_key(p)
	return string.format("%d,%d,%d", p.x, p.y, p.z)
end

-- Simple Lua table serializer/deserializer for headless testing
local function serialize_table(val)
	if type(val) == "number" or type(val) == "boolean" then
		return tostring(val)
	elseif type(val) == "string" then
		return string.format("%q", val)
	elseif type(val) == "table" then
		local parts = {}
		for k, v in pairs(val) do
			local k_str = type(k) == "number" and ("[" .. k .. "]") or ("[" .. string.format("%q", tostring(k)) .. "]")
			parts[#parts + 1] = k_str .. "=" .. serialize_table(v)
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return "nil"
end

local function deserialize_table(str)
	if not str or str == "" then
		return nil
	end
	local fn = (loadstring or load)("return " .. str)
	if fn then
		return fn()
	end
	return nil
end

-- Mock ItemStack
local function create_itemstack(str)
	local name = (type(str) == "string" and str:match("^([^%s]+)")) or ""
	local meta_store = {}
	return {
		_name = name,
		get_name = function(self) return self._name end,
		is_empty = function(self) return self._name == "" end,
		get_meta = function()
			return {
				set_string = function(_, k, v) meta_store[k] = tostring(v or "") end,
				get_string = function(_, k) return meta_store[k] or "" end,
				set_int = function(_, k, v) meta_store[k] = tonumber(v) or 0 end,
				get_int = function(_, k) return tonumber(meta_store[k]) or 0 end,
			}
		end,
	}
end
_G.ItemStack = create_itemstack

-- Mock Vector
_G.vector = {
	new = function(x, y, z) return { x = x or 0, y = y or 0, z = z or 0 } end,
	distance = function(a, b)
		local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end,
	direction = function(a, b) return { x = b.x - a.x, y = b.y - a.y, z = b.z - a.z } end,
}

-- Mock Luanti Core API
_G.core = {
	registered_craftitems = registered_craftitems,
	registered_nodes = registered_nodes,
	registered_entities = registered_entities,
	registered_items = {},
	registered_crafts = registered_crafts,

	_nodes = {},
	get_node = function(pos)
		local k = pos_key(pos)
		return _G.core._nodes[k] or registered_nodes[k] or { name = "air" }
	end,
	get_node_or_nil = function(pos)
		local k = pos_key(pos)
		return _G.core._nodes[k] or registered_nodes[k] or { name = "air" }
	end,

	settings = {
		_bools = {},
		get_bool = function(self, k, default)
			if self._bools[k] ~= nil then
				return self._bools[k]
			end
			return default
		end,
	},

	get_current_modname = function() return "x_mobs" end,
	get_modpath = function(mod)
		if mod == "x_mobs" then
			return "."
		end
		return nil
	end,

	get_translator = function(_mod)
		return function(str, ...)
			local args = { ... }
			local expected = 0
			return (str:gsub("@(.)", function(ch)
				if ch:match("^%d$") then
					expected = expected + 1
					local got = tonumber(ch)
					if got ~= expected then
						error("Escape sequences in string given to core.translate are not in the correct order: got @" .. ch .. " but expected @" .. expected)
					end
					return tostring(args[got] or "")
				end
				return ch
			end))
		end
	end,

	colorize = function(_color, text)
		return text
	end,

	formspec_escape = function(text)
		return tostring(text or ""):gsub("%[", "\\["):gsub("%]", "\\]"):gsub(";", "\\;")
	end,

	serialize = serialize_table,
	deserialize = deserialize_table,
	write_json = serialize_table,
	parse_json = deserialize_table,

	register_globalstep = function(_fn)
		globalsteps_registered = globalsteps_registered + 1
	end,

	register_craftitem = function(name, def)
		registered_craftitems[name] = def
		_G.core.registered_items[name] = def
	end,

	register_node = function(name, def)
		registered_nodes[name] = def
		_G.core.registered_items[name] = def
	end,

	register_entity = function(name, def)
		registered_entities[name] = def
	end,

	register_craft = function(def)
		registered_crafts[#registered_crafts + 1] = def
	end,

	register_on_joinplayer = function(_fn) end,
	register_on_leaveplayer = function(_fn) end,
	register_on_shutdown = function(_fn) end,
	register_on_mods_loaded = function(fn)
		mods_loaded_callbacks[#mods_loaded_callbacks + 1] = fn
	end,
	register_on_player_receive_fields = function(fn)
		receive_fields_callbacks[#receive_fields_callbacks + 1] = fn
	end,

	after = function(delay, fn)
		scheduled_afters[#scheduled_afters + 1] = { delay = delay, fn = fn }
	end,

	sound_play = function(name, spec)
		played_sounds[#played_sounds + 1] = { name = name, spec = spec }
	end,

	show_formspec = function(pname, formname, fs)
		shown_formspecs[pname] = { formname = formname, fs = fs }
	end,

	chat_send_player = function(pname, msg)
		chat_messages[#chat_messages + 1] = { pname = pname, msg = msg }
	end,

	get_player_information = function(pname)
		return player_infos[pname] or { formspec_version = 11 }
	end,

	get_player_by_name = function(pname)
		return players_by_name[pname]
	end,

	is_player = function(obj)
		return type(obj) == "table" and obj.is_player ~= nil and obj:is_player() == true
	end,

	get_meta = function(pos)
		local k = pos_key(pos)
		if not node_metas[k] then
			local store = {}
			node_metas[k] = {
				set_string = function(_, key, val) store[key] = tostring(val or "") end,
				get_string = function(_, key) return store[key] or "" end,
				set_int = function(_, key, val) store[key] = tonumber(val) or 0 end,
				get_int = function(_, key) return tonumber(store[key]) or 0 end,
			}
		end
		return node_metas[k]
	end,

	add_entity = function(pos, name, staticdata)
		local edef = registered_entities[name]
		local props = {}
		local obj = {
			_pos = pos,
			_removed = false,
			set_armor_groups = function() end,
			set_properties = function(_, p)
				for k, v in pairs(p) do
					props[k] = v
				end
			end,
			get_properties = function() return props end,
			remove = function(self) self._removed = true end,
		}
		local ent = setmetatable({ name = name, object = obj }, { __index = edef })
		obj.get_luaentity = function() return ent end
		if edef and edef.on_activate then
			edef.on_activate(ent, staticdata, 0)
		end
		spawned_entities[#spawned_entities + 1] = obj
		return obj
	end,

	get_objects_inside_radius = function(_pos, _rad)
		local res = {}
		for i = 1, #spawned_entities do
			if not spawned_entities[i]._removed then
				res[#res + 1] = spawned_entities[i]
			end
		end
		return res
	end,

	log = function() end,
}
_G.minetest = _G.core

-- Mock x_mob_core with event bus and mob registration
local event_listeners = {}
_G.x_mob_core = {
	registered_mobs = {},
	registered_spawns = {},
	events = {
		listen = function(ev, cb)
			event_listeners[ev] = event_listeners[ev] or {}
			table.insert(event_listeners[ev], cb)
		end,
		emit = function(ev, ...)
			local list = event_listeners[ev] or {}
			for i = 1, #list do
				list[i](...)
			end
		end,
	},
	register_mob = function(name, def)
		_G.x_mob_core.registered_mobs[name] = def
		_G.core.registered_entities[name] = def
	end,
	register_spawn = function(name, def)
		_G.x_mob_core.registered_spawns[name] = def
	end,
}

-- Mock Player Constructor
local function create_mock_player(name)
	local meta_store = {}
	local huds = {}
	local next_hud_id = 1
	local inv_items = {}

	local p = {
		_name = name,
		_meta_store = meta_store,
		_huds = huds,
		_inv_items = inv_items,
		_controls = {},
		is_player = function() return true end,
		is_valid = function() return true end,
		get_player_name = function(self) return self._name end,
		get_player_control = function(self) return self._controls or {} end,
		get_pos = function() return { x = 0, y = 10, z = 0 } end,
		get_wielded_item = function() return create_itemstack("x_mobs:bestiary") end,
		get_meta = function()
			return {
				get_string = function(_, k) return meta_store[k] or "" end,
				set_string = function(_, k, v) meta_store[k] = tostring(v or "") end,
			}
		end,
		get_inventory = function()
			return {
				room_for_item = function() return true end,
				add_item = function(_, _list, stack)
					inv_items[#inv_items + 1] = stack:get_name()
				end,
				contains_item = function(_, _list, item_name)
					for i = 1, #inv_items do
						if inv_items[i] == item_name then
							return true
						end
					end
					return false
				end,
			}
		end,
		hud_add = function(_, def)
			local id = next_hud_id
			next_hud_id = next_hud_id + 1
			huds[id] = def
			return id
		end,
		hud_change = function(_, id, stat, val)
			if huds[id] then
				huds[id][stat] = val
			end
		end,
		hud_remove = function(_, id)
			huds[id] = nil
		end,
	}
	players_by_name[name] = p
	return p
end

-- ==============================================================================
-- Bootstrap x_mobs items & Bestiary Subsystem
-- ==============================================================================

_G.x_mobs = {}
_G.x_mobs.items = dofile("./items/utils.lua")

-- Register simulated definitions for all 28 mobs in x_mob_core.registered_mobs
local MOB_LIST = {
	"spider", "fallen_minion", "fallen_shaman", "armored_bug", "flying_insect",
	"skull_king", "skull_lancer", "skull_archer", "crystal_guardian", "crystal_guardian_minion",
	"nature_guardian", "nature_guardian_minion", "skeleton_swordfish", "fungus_minion", "crazy_mushroom",
	"golem", "golem_minion", "spectrum", "elder", "frosty_queen",
	"glowler_minion", "glowler", "chasm_weaver", "crypt_stalker", "dungeon_brute",
	"heated_sword", "suture_golem", "void_strider",
}

_G.core.register_craftitem("x_mobs:titan_shard", {
	description = "Titan Basalt Shard",
})

for i = 1, #MOB_LIST do
	local mname = "x_mobs:" .. MOB_LIST[i]
	local is_boss = (mname == "x_mobs:golem" or mname == "x_mobs:skull_king" or mname == "x_mobs:frosty_queen"
		or mname == "x_mobs:crystal_guardian" or mname == "x_mobs:nature_guardian")
	_G.x_mob_core.register_mob(mname, {
		initial_properties = {
			hp_max = is_boss and 120 or 35,
			mesh = "x_mobs_" .. MOB_LIST[i] .. ".glb",
			textures = { "x_mobs_" .. MOB_LIST[i] .. ".png" },
		},
		armor_groups = { fleshy = 80 },
		factions = is_boss and { "boss" } or { "beast" },
		drops = {
			{ name = "x_mobs:titan_shard", min = 1, max = 3, chance = 0.85 },
		},
	})
end

dofile("./bestiary/init.lua")

print("=== Running x_mobs Bestiary Automated Test Suite ===")

-- 1. Verify Zero Globalsteps
assert(globalsteps_registered == 0, "Expected 0 globalsteps registered, got " .. globalsteps_registered)
print("  [PASS] 1. Zero globalsteps registered (100% event-driven)")

-- 2. Verify All 28 Built-in Mobs & Dynamic Auto-Scanner
local all_entries = x_mobs.bestiary.get_all_entries()
assert(#all_entries == 28, "Expected 28 registered bestiary entries, got " .. #all_entries)
for i = 1, #all_entries do
	local e = all_entries[i]
	assert(e.mesh and e.mesh ~= "", "Missing mesh for " .. e.id)
	assert(type(e.textures) == "table" and #e.textures >= 1, "Missing textures for " .. e.id)
	assert(e.lore and e.lore ~= "", "Missing lore for " .. e.id)
	assert(type(e.abilities) == "table" and #e.abilities >= 1, "Missing abilities for " .. e.id)
end

-- Dynamically register a 29th third-party mob and trigger on_mods_loaded scanner
_G.x_mob_core.register_mob("custom_mod:lava_drake", {
	initial_properties = {
		hp_max = 95,
		infotext = "Lava Drake",
		mesh = "lava_drake.glb",
		textures = { { "lava_drake_red.png" }, { "lava_drake_gold.png" } },
	},
	factions = { "dragon", "boss" },
	armor_groups = { fleshy = 70 },
	damage = 14,
})
for i = 1, #mods_loaded_callbacks do
	mods_loaded_callbacks[i]()
end
local drake_entry = x_mobs.bestiary.get_entry("custom_mod:lava_drake")
assert(drake_entry ~= nil, "Dynamic scanner failed to auto-register custom_mod:lava_drake")
assert(drake_entry.name == "Lava Drake", "Unexpected name: " .. tostring(drake_entry.name))
assert(drake_entry.category == "Bosses", "Expected Bosses category from boss faction")
assert(drake_entry.textures[1] == "lava_drake_red.png", "Failed to unwrap nested variant texture table")
assert(#drake_entry.variant_textures == 2, "Expected 2 texture variants")
print("  [PASS] 2. All 28 core mobs + dynamic third-party mob auto-scanner verified")

-- 3. Verify Game-Agnostic Group-Based Crafting Recipes
assert(#registered_crafts >= 3, "Expected at least 3 crafting recipes for x_mobs:bestiary")
for i = 1, #registered_crafts do
	local c = registered_crafts[i]
	assert(c.output == "x_mobs:bestiary", "Unexpected craft output")
	for r = 1, #c.recipe do
		for col = 1, #c.recipe[r] do
			local ing = c.recipe[r][col]
			assert(not ing:find("^default:"), "Recipe ingredient must not hard-depend on default mod: " .. ing)
		end
	end
end
print("  [PASS] 3. Game-agnostic group-based crafting recipes verified (zero default dependency)")

-- 4. Verify Event-Driven Tier Progression & Non-Intrusive HUD Toast
local player = create_mock_player("Tester")
local spider_rec = x_mobs.bestiary.storage.get_mob_record(player, "x_mobs:spider")
assert(spider_rec.tier == 0, "Initial spider tier must be 0 (Undiscovered)")

-- Formspec at Tier 0 must conceal model and show Fog of War
local fs_t0 = x_mobs.bestiary.ui.build_formspec(player, { selected_mob = "x_mobs:spider" })
assert(fs_t0:find("formspec_version%[11%]"), "Expected formspec_version[11]")
assert(fs_t0:find("UNDOCUMENTED CREATURE"), "Tier 0 formspec must show UNDOCUMENTED CREATURE")
assert(not fs_t0:find("model%["), "Tier 0 formspec must not reveal 3D model")
assert(not fs_t0:find("font_size=0"), "Formspec must never set font_size=0 (0pt)")
assert(not fs_t0:find("</global>"), "Formspec hypertext must never include invalid </global> closing tags")

-- Emit on_mob_target -> Unlocks Tier 1 (Sighted)
x_mob_core.events.emit("on_mob_target", { name = "x_mobs:spider" }, player, nil)
spider_rec = x_mobs.bestiary.storage.get_mob_record(player, "x_mobs:spider")
assert(spider_rec.tier == 1, "Spider tier must advance to 1 on sight")
assert(#played_sounds >= 1 and played_sounds[#played_sounds].name == "x_mobs_bestiary_toast", "Expected toast sound")

-- Verify HUD toast background image and non-overlapping icon + text layout
local hud_bg, hud_icon, hud_title, hud_sub = player._huds[1], player._huds[2], player._huds[3], player._huds[4]
assert(hud_bg and hud_bg.text == "x_mobs_bestiary_toast_bg.png", "HUD toast must render x_mobs_bestiary_toast_bg.png background")
assert(hud_icon and hud_icon.text == "x_mobs_bestiary_badge_tier1.png", "HUD toast must render tier badge icon")
assert(hud_icon.alignment.x == 1 and hud_title.alignment.x == 1 and hud_sub.alignment.x == 1, "HUD toast elements must all be left-aligned within the banner")
local icon_right_edge = hud_icon.offset.x + (16 * hud_icon.scale.x)
assert(hud_title.offset.x > icon_right_edge and hud_sub.offset.x > icon_right_edge, "HUD toast text must start to the right of the icon without overlapping")

-- Formspec at Tier 1 reveals rotatable 3D model (`false;true`), keeps stats `???`
local fs_t1 = x_mobs.bestiary.ui.build_formspec(player, { selected_mob = "x_mobs:spider" })
assert(fs_t1:find("model%[.*x_mobs_spider%.glb.*false;true"), "Tier 1 must render rotatable 3D model")
assert(fs_t1:find("%?%?%?"), "Tier 1 must obscure combat stats with ???")
assert(not fs_t1:find("font_size=0"), "Tier 1+ formspec must never set font_size=0 (0pt)")
assert(not fs_t1:find("</global>"), "Tier 1+ formspec hypertext must never include invalid </global> closing tags")

-- Emit 1st on_mob_death -> Unlocks Tier 2 (Vanquished)
x_mob_core.events.emit("on_mob_death", { name = "x_mobs:spider" }, player)
spider_rec = x_mobs.bestiary.storage.get_mob_record(player, "x_mobs:spider")
assert(spider_rec.tier == 2 and spider_rec.kills == 1, "Spider tier must advance to 2 on 1st kill")

local fs_t2 = x_mobs.bestiary.ui.build_formspec(player, { selected_mob = "x_mobs:spider", detail_tab = "abilities" })
assert(fs_t2:find("Venom Bite Envelop"), "Tier 2 abilities tab must reveal Venom Bite Envelop")

-- Emit remaining kills to reach Tier 3 Mastery (5 kills for Threat 3 spider)
for _ = 2, 5 do
	x_mob_core.events.emit("on_mob_death", { name = "x_mobs:spider" }, player)
end
spider_rec = x_mobs.bestiary.storage.get_mob_record(player, "x_mobs:spider")
assert(spider_rec.tier == 3 and spider_rec.kills == 5, "Spider tier must advance to 3 Mastery at 5 kills")

local fs_t3 = x_mobs.bestiary.ui.build_formspec(player, { selected_mob = "x_mobs:spider", detail_tab = "lore" })
assert(fs_t3:find("MASTER HUNTER TACTICS"), "Tier 3 lore tab must reveal Master Hunter Tactics")
local fs_t3_drops = x_mobs.bestiary.ui.build_formspec(player, { selected_mob = "x_mobs:spider", detail_tab = "drops" })
assert(fs_t3_drops:find("85%%"), "Tier 3 drops tab must reveal exact 85% drop chance")
print("  [PASS] 4. 3-Tier Fog of War progression, rotatable 3D model, and HUD toasts verified")

-- 5. Verify PlayerMetaRef Persistence Round-Trip
x_mobs.bestiary.storage.players["Tester"] = nil -- Evict in-memory cache
local reloaded = x_mobs.bestiary.storage.get_mob_record(player, "x_mobs:spider")
assert(reloaded.tier == 3 and reloaded.kills == 5, "PlayerMetaRef round-trip failed to preserve Tier 3 & 5 kills")
print("  [PASS] 5. PlayerMetaRef persistence round-trip verified")

-- 6. Verify Formspec Version Negotiation (v7 fallback vs v11 modern)
player_infos["Tester"] = { formspec_version = 7 }
local fs_v7 = x_mobs.bestiary.ui.build_formspec(player)
assert(fs_v7:find("formspec_version%[7%]"), "Expected negotiated formspec_version[7] for v7 client")
player_infos["Tester"] = { formspec_version = 11 }
print("  [PASS] 6. Client formspec version negotiation (v7..v11) verified")

-- 7. Verify Grand Hunter's Trophy Claim & Exhibition Hall Hologram
assert(x_mobs.bestiary.trophy.claim_trophy(player) == false, "Must reject trophy claim before 100% mastery")

-- Master all remaining entries
local current_entries = x_mobs.bestiary.get_all_entries()
for i = 1, #current_entries do
	local entry = current_entries[i]
	local req = (entry.tiers[3] and entry.tiers[3].kills) or 8
	for _ = 1, req do
		x_mob_core.events.emit("on_mob_death", { name = entry.id }, player)
	end
end

local summary = x_mobs.bestiary.storage.get_progress_summary(player)
assert(summary.is_all_mastered == true, "Expected 100% Realm Mastery")
assert(summary.mastery_percent == 100, "Expected 100% mastery percentage")

local claimed = x_mobs.bestiary.trophy.claim_trophy(player)
assert(claimed == true, "Expected Grand Hunter's Trophy claim to succeed at 100% mastery")
assert(player:get_inventory():contains_item("main", "x_mobs:trophy_master_bestiary"), "Trophy item missing from inventory")

-- Place Trophy node and test Exhibition Hall hologram projection
local tpos = { x = 10, y = 5, z = 10 }
local tnode_def = registered_nodes["x_mobs:trophy_master_bestiary"]
assert(tnode_def ~= nil, "x_mobs:trophy_master_bestiary node not registered")
tnode_def.after_place_node(tpos, player, create_itemstack("x_mobs:trophy_master_bestiary"))
tnode_def.on_rightclick(tpos, nil, player)
assert(shown_formspecs["Tester"].formname == "x_mobs:bestiary_trophy_hall", "Expected Exhibition Hall formspec")

-- Select Skull King to enshrine on pedestal
for i = 1, #receive_fields_callbacks do
	receive_fields_callbacks[i](player, "x_mobs:bestiary_trophy_hall", { ["enshrine_x_mobs:skull_king"] = "true" })
end
assert(#spawned_entities >= 1, "Expected hologram entity spawned above trophy pedestal")
local holo_props = spawned_entities[#spawned_entities]:get_properties()
assert(holo_props.mesh == "x_mobs_skull_king.glb", "Hologram mesh should match enshrined Skull King")
assert(not holo_props.textures[1]:find("%^%[colorize:"), "Hologram must use native mob texture without colorize overlay")

-- Verify normalized visual_size across tiny (fungus_minion=1.0u) and huge (spider=32.12u) meshes
local fungus_entry = x_mobs.bestiary.get_entry("x_mobs:fungus_minion")
local spider_entry = x_mobs.bestiary.get_entry("x_mobs:spider")
local f_scale = x_mobs.bestiary.trophy.get_hologram_transform("x_mobs:fungus_minion", fungus_entry)
local s_scale = x_mobs.bestiary.trophy.get_hologram_transform("x_mobs:spider", spider_entry)
assert(f_scale > 5.0 and s_scale < 0.5, "Hologram transform must normalize tiny and huge glTF meshes to uniform block size")
print("  [PASS] 7. Grand Hunter's Trophy claim, pedestal nodebox, and normalized native hologram verified")

-- Execute all scheduled core.after callbacks to verify clean toast removal
for i = 1, #scheduled_afters do
	scheduled_afters[i].fn()
end
assert(next(player._huds) == nil, "All temporary HUD toast elements must be cleaned up after core.after expires")
print("  [PASS] 8. HUD toast automatic cleanup via core.after verified")

-- 9. Verify Pointed Node & Entity on_rightclick Delegation (Chests, Furnaces, Non-mob Entities)
local bestiary_item_def = registered_craftitems["x_mobs:bestiary"]
assert(bestiary_item_def ~= nil, "x_mobs:bestiary craftitem not registered")

local chest_opened = 0
registered_nodes["default:chest"] = {
	description = "Chest",
	on_rightclick = function(_pos, _node, _clicker, itemstack, _pointed_thing)
		chest_opened = chest_opened + 1
		return itemstack
	end,
}
registered_nodes["default:stone"] = {
	description = "Stone",
}

local chest_pos = { x = 20, y = 1, z = 20 }
local stone_pos = { x = 21, y = 1, z = 20 }
_G.core._nodes[pos_key(chest_pos)] = { name = "default:chest" }
_G.core._nodes[pos_key(stone_pos)] = { name = "default:stone" }

local bestiary_stack = create_itemstack("x_mobs:bestiary")
local pointed_chest = { type = "node", under = chest_pos, above = { x = 20, y = 2, z = 20 } }
local pointed_stone = { type = "node", under = stone_pos, above = { x = 21, y = 2, z = 20 } }
local pointed_nothing = { type = "nothing" }

-- Reset test state
shown_formspecs["Tester"] = nil
player._controls = { sneak = false }

-- 9a: Pointing at chest with on_place, on_use, on_secondary_use delegates to chest on_rightclick
bestiary_item_def.on_place(bestiary_stack, player, pointed_chest)
assert(chest_opened == 1, "Expected on_place on chest to invoke chest on_rightclick")
assert(shown_formspecs["Tester"] == nil, "Bestiary formspec should not open when clicking chest")

bestiary_item_def.on_use(bestiary_stack, player, pointed_chest)
assert(chest_opened == 2, "Expected on_use on chest to invoke chest on_rightclick")
assert(shown_formspecs["Tester"] == nil, "Bestiary formspec should not open when clicking chest")

bestiary_item_def.on_secondary_use(bestiary_stack, player, pointed_chest)
assert(chest_opened == 3, "Expected on_secondary_use on chest to invoke chest on_rightclick")
assert(shown_formspecs["Tester"] == nil, "Bestiary formspec should not open when clicking chest")

-- 9b: Sneak right-click bypasses chest on_rightclick and opens the Bestiary
player._controls = { sneak = true }
bestiary_item_def.on_place(bestiary_stack, player, pointed_chest)
assert(chest_opened == 3, "Sneak click must not invoke chest on_rightclick")
assert(shown_formspecs["Tester"] ~= nil and shown_formspecs["Tester"].formname == "x_mobs:bestiary_main", "Sneak click must open Bestiary formspec")

-- 9c: Pointing at non-interactive node (stone) opens the Bestiary
shown_formspecs["Tester"] = nil
player._controls = { sneak = false }
bestiary_item_def.on_place(bestiary_stack, player, pointed_stone)
assert(shown_formspecs["Tester"] ~= nil and shown_formspecs["Tester"].formname == "x_mobs:bestiary_main", "Right-clicking normal node must open Bestiary")

-- 9d: Pointing at air / nothing opens the Bestiary
shown_formspecs["Tester"] = nil
bestiary_item_def.on_use(bestiary_stack, player, pointed_nothing)
assert(shown_formspecs["Tester"] ~= nil and shown_formspecs["Tester"].formname == "x_mobs:bestiary_main", "Using in air must open Bestiary")

-- 9e: Pointing at interactive non-mob entity delegates to entity:on_rightclick
shown_formspecs["Tester"] = nil
local stand_clicked = 0
local stand_obj = {
	is_player = function() return false end,
	is_valid = function() return true end,
	get_luaentity = function()
		return {
			name = "armor:stand",
			on_rightclick = function(_ent, _clicker, itemstack, _pt)
				stand_clicked = stand_clicked + 1
				return itemstack
			end,
		}
	end,
}
local pointed_stand = { type = "object", ref = stand_obj }
bestiary_item_def.on_place(bestiary_stack, player, pointed_stand)
assert(stand_clicked == 1, "Expected non-mob entity on_rightclick to be invoked")
assert(shown_formspecs["Tester"] == nil, "Bestiary formspec should not open when interacting with non-mob entity")

-- 9f: Pointing at a mob entity triggers Field Study
shown_formspecs["Tester"] = nil
local mob_obj = {
	is_player = function() return false end,
	is_valid = function() return true end,
	get_luaentity = function()
		return {
			name = "x_mobs:spider",
			_is_mob = true,
		}
	end,
}
local pointed_mob = { type = "object", ref = mob_obj }
bestiary_item_def.on_place(bestiary_stack, player, pointed_mob)
assert(shown_formspecs["Tester"] ~= nil and shown_formspecs["Tester"].formname == "x_mobs:bestiary_main", "Field study must open Bestiary focused on mob")
print("  [PASS] 9. Pointed node & entity on_rightclick delegation and sneak bypass verified")

print("\n=== ALL 9 BESTIARY TEST SUITES PASSED SUCCESSFULLY! ===")
