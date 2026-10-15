--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Grand Hunter's Trophy & Exhibition Hall
	Implements:
	1. `x_mobs:trophy_master_bestiary`: Stepped 3D pedestal nodebox with open golden tome.
	2. `x_mobs:trophy_hologram`: Client-side C++ `automatic_rotate` miniature golden statue
	   projected above the pedestal (zero Lua `on_step`, zero globalsteps).
	3. Interactive Exhibition Hall UI (`formspec_version[11]`) on right-click allowing the
	   owner to enshrine any Mastered Creature atop the pedestal.

	Author: SaKeL
	License: MIT
]]

local S = core.get_translator("x_mobs")

---@class BestiaryTrophyHologramEntity
---@field object ObjectRef Engine ObjectRef handle
---@field mob_id? string Enshrined mob technical identifier

---@class BestiaryMeshBounds
---@field max_dim number Largest bounding box dimension (width, height, or depth) in glTF units
---@field y_min number Lowest vertical vertex coordinate in glTF units

---@class XMobsBestiaryTrophy
---@field FORMNAME string Trophy Exhibition Hall formspec name ("x_mobs:bestiary_trophy_hall")
---@field open_positions table<string, Vector> Currently inspected trophy pedestal position keyed by player name
---@field MESH_BOUNDS table<string, BestiaryMeshBounds> Pre-computed glTF bounding boxes for uniform hologram scaling
local trophy = {
	FORMNAME = "x_mobs:bestiary_trophy_hall",
	open_positions = {},
	-- Exact glTF mesh bounding dimensions (in Luanti glTF loader, 10.0 units at visual_size=1.0 equals 1.0 block)
	MESH_BOUNDS = {
		["x_mobs_armored_bug.glb"]        = { max_dim = 3.40,  y_min = 0.32 },
		["x_mobs_bug.glb"]                = { max_dim = 23.05, y_min = 0.03 },
		["x_mobs_chasm_weaver.glb"]       = { max_dim = 3.62,  y_min = -0.02 },
		["x_mobs_crazy_mushroom.glb"]     = { max_dim = 3.41,  y_min = 0.01 },
		["x_mobs_crypt_stalker.glb"]      = { max_dim = 3.80,  y_min = 0.00 },
		["x_mobs_dungeon_brute.glb"]      = { max_dim = 4.18,  y_min = -0.11 },
		["x_mobs_elder.glb"]              = { max_dim = 17.00, y_min = 0.00 },
		["x_mobs_fallen_minion.glb"]      = { max_dim = 2.40,  y_min = 0.00 },
		["x_mobs_fallen_shaman.glb"]      = { max_dim = 2.40,  y_min = 0.00 },
		["x_mobs_frosty_queen.glb"]       = { max_dim = 2.13,  y_min = 0.03 },
		["x_mobs_fungus_minion.glb"]      = { max_dim = 1.00,  y_min = 0.00 },
		["x_mobs_glowler.glb"]            = { max_dim = 24.13, y_min = 8.27 },
		["x_mobs_golem.glb"]              = { max_dim = 4.51,  y_min = 0.00 },
		["x_mobs_heated_sword.glb"]       = { max_dim = 1.86,  y_min = 0.16 },
		["x_mobs_monster_guardian.glb"]   = { max_dim = 2.00,  y_min = -0.50 },
		["x_mobs_natureguardian.glb"]     = { max_dim = 3.32,  y_min = -0.50 },
		["x_mobs_skeleton_swordfish.glb"] = { max_dim = 33.81, y_min = -1.59 },
		["x_mobs_skull_archer.glb"]       = { max_dim = 2.03,  y_min = 0.00 },
		["x_mobs_skull_archers.glb"]      = { max_dim = 2.03,  y_min = 0.00 },
		["x_mobs_skull_king.glb"]         = { max_dim = 2.99,  y_min = -0.02 },
		["x_mobs_skull_lancer.glb"]       = { max_dim = 18.34, y_min = -0.02 },
		["x_mobs_spectrum.glb"]           = { max_dim = 2.03,  y_min = 0.00 },
		["x_mobs_spider.glb"]             = { max_dim = 32.12, y_min = -0.09 },
		["x_mobs_suture_golem.glb"]       = { max_dim = 2.77,  y_min = -0.05 },
		["x_mobs_void_strider.glb"]       = { max_dim = 4.20,  y_min = 0.01 },
	},
}

---Computes normalized visual_size scale and vertical spawn offset so any creature model
---fits uniformly inside a 0.85-block showcase volume floating above the pedestal.
---@param mob_id string Technical mob identifier
---@param entry BestiaryEntryNormalized Normalized Bestiary entry
---@return number scale Normalized visual_size scalar
---@return number y_offset Vertical offset above pedestal node origin
function trophy.get_hologram_transform(mob_id, entry)
	local target_blocks = 0.85
	local bounds = entry and entry.mesh and trophy.MESH_BOUNDS[entry.mesh]
	if bounds and bounds.max_dim > 0 then
		local scale = (target_blocks * 10.0) / bounds.max_dim
		local y_offset = 0.56 - (bounds.y_min * (scale / 10.0))
		y_offset = math.max(0.15, math.min(1.35, y_offset))
		return tonumber(string.format("%.3f", scale)) or scale,
			tonumber(string.format("%.3f", y_offset)) or y_offset
	end

	-- Fallback for custom / third-party meshes: estimate from registered collisionbox & visual_size
	local mdef = x_mob_core and x_mob_core.registered_mobs and x_mob_core.registered_mobs[mob_id]
	local ip = mdef and mdef.initial_properties
	local orig_vs = (ip and ip.visual_size and ip.visual_size.x) or 1.0
	local cbox = ip and ip.collisionbox
	local cbox_span = 1.6
	if type(cbox) == "table" and #cbox >= 6 then
		local dx = math.abs((cbox[4] or 0.5) - (cbox[1] or -0.5))
		local dy = math.abs((cbox[5] or 0.8) - (cbox[2] or -0.8))
		local dz = math.abs((cbox[6] or 0.5) - (cbox[3] or -0.5))
		cbox_span = math.max(0.5, dx, dy, dz)
	end
	local scale = orig_vs * (target_blocks / cbox_span)
	return tonumber(string.format("%.3f", scale)) or scale, 0.72
end

---Removes any existing hologram entity above a trophy pedestal position.
---@param pos Vector World node position of the trophy pedestal
function trophy.clear_hologram(pos)
	local center = { x = pos.x, y = pos.y + 0.75, z = pos.z }
	local objs = core.get_objects_inside_radius(center, 1.50)
	for i = 1, #objs do
		local obj = objs[i]
		local ent = obj:get_luaentity()
		if ent and ent.name == "x_mobs:trophy_hologram" then
			obj:remove()
		end
	end
end

---Spawns or refreshes the miniature rotating hologram entity above a pedestal.
---@param pos Vector World node position of the trophy pedestal
---@param mob_id string? Technical mob identifier to project above the pedestal
function trophy.spawn_hologram(pos, mob_id)
	trophy.clear_hologram(pos)
	if not mob_id or mob_id == "" then
		return
	end

	local entry = x_mobs.bestiary.data.get_entry(mob_id)
	if not entry or not entry.mesh or entry.mesh == "" then
		return
	end

	local _, y_offset = trophy.get_hologram_transform(mob_id, entry)
	local spawn_pos = { x = pos.x, y = pos.y + y_offset, z = pos.z }
	local sdata = core.serialize({ mob_id = mob_id })
	core.add_entity(spawn_pos, "x_mobs:trophy_hologram", sdata)
end

-- ==============================================================================
-- 1. Miniature Hologram Entity (C++ automatic_rotate, ZERO Lua on_step)
-- ==============================================================================

core.register_entity("x_mobs:trophy_hologram", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = { 0, 0, 0, 0, 0, 0 },
		selectionbox = { 0, 0, 0, 0, 0, 0 },
		pointable = false,
		visual = "mesh",
		mesh = "x_mobs_spider.glb",
		textures = { "x_mobs_bestiary_trophy_top.png" },
		visual_size = { x = 0.265, y = 0.265, z = 0.265 },
		automatic_rotate = 0.65,
		glow = 12,
		static_save = true,
	},

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({ immortal = 1 })
		local parsed = (staticdata and staticdata ~= "" and core.deserialize(staticdata)) or {}
		self.mob_id = parsed.mob_id

		local entry = self.mob_id and x_mobs.bestiary.data.get_entry(self.mob_id)
		if not entry or not entry.mesh or entry.mesh == "" then
			self.object:remove()
			return
		end

		local native_textures = {}
		local base_texs = entry.textures or { "blank.png" }
		for i = 1, #base_texs do
			native_textures[i] = base_texs[i]
		end

		local scale = trophy.get_hologram_transform(self.mob_id, entry)

		self.object:set_properties({
			mesh = entry.mesh,
			textures = native_textures,
			visual_size = { x = scale, y = scale, z = scale },
			infotext = S("Trophy Hologram: @1", entry.name),
		})
	end,

	get_staticdata = function(self)
		return core.serialize({ mob_id = self.mob_id })
	end,
})

-- ==============================================================================
-- 2. Exhibition Hall Formspec (formspec_version[11])
-- ==============================================================================

---Builds the Trophy Exhibition Hall formspec for a placed pedestal.
---@param player ObjectRef Inspecting player ObjectRef
---@param pos Vector World node position of the trophy pedestal
---@return string formspec
function trophy.build_exhibition_formspec(player, pos)
	local pname = player:get_player_name()
	local fv = x_mobs.bestiary.ui.get_formspec_version(pname)
	local meta = core.get_meta(pos)

	local owner = meta:get_string("owner")
	if owner == "" then
		owner = pname
	end
	local completed_date = meta:get_string("completed_date")
	if completed_date == "" then
		completed_date = "2026"
	end
	local total_kills = meta:get_int("total_kills")
	local enshrined_id = meta:get_string("enshrined_mob")

	local mastered = x_mobs.bestiary.storage.get_mastered_mobs(owner)
	if enshrined_id == "" and #mastered > 0 then
		enshrined_id = mastered[1].id
	end
	local entry = x_mobs.bestiary.data.get_entry(enshrined_id)
		or x_mobs.bestiary.data.get_all_entries()[1]

	local fs = {
		string.format("formspec_version[%d]", fv),
		"size[11.6,7.6]",
		"no_prepend[]",
		"bgcolor[#000000bb;true]",
		"box[0,0;11.6,7.6;#0d1117]",

		-- Header Bar
		"box[0.4,0.35;10.8,0.75;#161b22]",
		string.format(
			"label[0.7,0.72;%s]",
			core.colorize("#f5c542", core.formspec_escape(S("★ GRAND HUNTER'S TROPHY — EXHIBITION HALL ★")))
		),
		"style[btn_close;bgcolor=#3a1812;textcolor=#ffe070;font=bold]",
		"button_exit[10.50,0.45;0.55,0.55;btn_close;X]",

		-- Left Column: 3D Enshrined Golden Statue Preview (x = 0.4, y = 1.3, w = 4.6, h = 5.9)
		"box[0.4,1.3;4.6,5.9;#161b22]",
		string.format(
			"label[0.65,1.68;%s]",
			core.colorize("#9ecbff", core.formspec_escape(S("Championed By: @1", owner)))
		),
		string.format(
			"label[0.65,2.02;%s]",
			core.colorize(
				"#c9d1d9",
				core.formspec_escape(S("Completed: @1  |  Slain: @2", completed_date, total_kills))
			)
		),
	}

	if entry and entry.mesh and entry.mesh ~= "" then
		local tex_str = table.concat(entry.textures or { "blank.png" }, ",")
		fs[#fs + 1] = string.format(
			"model[0.65,2.30;4.10,3.80;trophy_3d_preview;%s;%s;0,-145;true;true;0,0;0]",
			core.formspec_escape(entry.mesh),
			core.formspec_escape(tex_str)
		)
		fs[#fs + 1] = string.format(
			"label[0.75,6.45;%s]",
			core.colorize("#f5c542", core.formspec_escape(S("Enshrined: @1", entry.name)))
		)
		fs[#fs + 1] = string.format(
			"label[0.75,6.82;%s]",
			core.colorize("#8b949e", core.formspec_escape(S("Drag to rotate 3D statue")))
		)
	end

	-- Right Column: Enshrined Creature Selector (x = 5.2, y = 1.3, w = 6.0, h = 5.9)
	fs[#fs + 1] = "box[5.2,1.3;6.0,5.9;#161b22]"
	fs[#fs + 1] = string.format(
		"label[5.45,1.68;%s]",
		core.colorize("#f5c542", core.formspec_escape(S("SELECT MASTERED CREATURE TO ENSHRINE:")))
	)

	local is_owner = (pname == owner)
	local all_entries = (#mastered > 0) and mastered or x_mobs.bestiary.data.get_all_entries()

	for i = 1, math.min(14, #all_entries) do
		local m = all_entries[i]
		local col = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local bx = 5.40 + col * 2.85
		local by = 2.00 + row * 0.62
		local btn_id = "enshrine_" .. m.id
		local is_cur = (m.id == enshrined_id)

		fs[#fs + 1] = string.format(
			"style[%s;bgcolor=%s;textcolor=%s;font=%s]",
			btn_id,
			is_cur and "#8a621a" or "#21262d",
			is_cur and "#ffe070" or "#c9d1d9",
			is_cur and "bold" or "normal"
		)
		fs[#fs + 1] = string.format(
			"button[%.2f,%.2f;2.72,0.52;%s;%s]",
			bx,
			by,
			btn_id,
			core.formspec_escape(m.name)
		)
	end

	if is_owner then
		fs[#fs + 1] = "style[btn_clear_holo;bgcolor=#262330;textcolor=#ff7b72]"
		fs[#fs + 1] = string.format(
			"button[5.40,6.45;5.58,0.52;btn_clear_holo;%s]",
			core.formspec_escape(S("Hide Floating Pedestal Hologram"))
		)
	end

	return table.concat(fs, "")
end

---Claims the Grand Hunter's Trophy for a player who has mastered 100% of the Bestiary.
---@param player ObjectRef? Target player ObjectRef
---@return boolean claimed
function trophy.claim_trophy(player)
	if not core.is_player(player) then
		return false
	end
	local pname = player:get_player_name()
	local storage = x_mobs.bestiary.storage
	local summary = storage.get_progress_summary(player)

	if not summary.is_all_mastered then
		core.chat_send_player(
			pname,
			core.colorize("#ff7b72", S("[Bestiary] You must reach Tier III Mastery on all creatures before claiming the Grand Trophy!"))
		)
		return false
	end

	local stack = ItemStack("x_mobs:trophy_master_bestiary")
	local smeta = stack:get_meta()
	local date_str = os.date("%Y-%m-%d", summary.completed_at or os.time())
	smeta:set_string("owner", pname)
	smeta:set_string("completed_date", date_str)
	smeta:set_int("total_kills", summary.total_kills)

	local inv = player:get_inventory()
	if inv:room_for_item("main", stack) then
		inv:add_item("main", stack)
	else
		local ppos = player:get_pos()
		if ppos then
			core.add_item(ppos, stack)
		end
	end

	local state = storage.get_player_data(player)
	if state then
		state.trophy_claimed = true
		storage.save_player_data(player)
	end

	core.sound_play("x_mobs_bestiary_trophy", {
		to_player = pname,
		gain = 0.75,
	}, true)

	core.chat_send_player(
		pname,
		core.colorize("#f5c542", S("★ [Bestiary] Congratulations, Grand Hunter @1! You have claimed the Grand Hunter's Trophy! ★", pname))
	)
	return true
end

-- ==============================================================================
-- 3. Grand Hunter's Trophy Pedestal Node Registration
-- ==============================================================================

local item_utils = x_mobs.items

core.register_node("x_mobs:trophy_master_bestiary", {
	short_description = S("Grand Hunter's Trophy"),
	description = item_utils.format_legendary_tooltip({
		title = S("Grand Hunter's Trophy"),
		category = S("Monumental Bestiary Mastery Relic"),
		lore = S("A gilded obsidian pedestal bearing an open golden chronicle tome. Awarded exclusively to hunters who have mastered every creature in the realm."),
		stats = {
			[S("Illumination")] = S("Warm Golden Glow (Level 8)"),
			[S("Exhibition Hall")] = S("Right-click to enshrine any Mastered Creature as a rotating golden statue"),
		},
	}),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	light_source = 8,
	inventory_image = "x_mobs_bestiary_trophy.png",
	wield_image = "x_mobs_bestiary_trophy.png",
	tiles = {
		"x_mobs_bestiary_trophy_top.png",
		"x_mobs_bestiary_trophy_bottom.png",
		"x_mobs_bestiary_trophy_side.png",
		"x_mobs_bestiary_trophy_side.png",
		"x_mobs_bestiary_trophy_side.png",
		"x_mobs_bestiary_trophy_side.png",
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.4375, -0.5000, -0.4375, 0.4375, -0.3125, 0.4375 }, -- Stepped Obsidian Plinth (px,pz=1..14, py=13..15)
			{ -0.3125, -0.3125, -0.3125, 0.3125, -0.1875, 0.3125 }, -- Gilded Lower Collar (px,pz=3..12, py=11..12)
			{ -0.2500, -0.1875, -0.2500, 0.2500,  0.1875, 0.2500 }, -- Basalt Pillar Shaft & Emerald Core (px,pz=4..11, py=5..10)
			{ -0.3750,  0.1875, -0.3750, 0.3750,  0.3125, 0.3750 }, -- Upper Gilded Capital (px,pz=2..13, py=3..4)
			{ -0.3125,  0.3125, -0.3125, 0.3125,  0.4375, 0.3125 }, -- Open Golden Tome & Crest (px,pz=3..12, py=1..2)
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.4375, -0.5, -0.4375, 0.4375, 0.4375, 0.4375 },
	},
	groups = { cracky = 2, oddly_breakable_by_hand = 2, handy = 1 },

	after_place_node = function(pos, placer, itemstack)
		local meta = core.get_meta(pos)
		local smeta = itemstack:get_meta()
		local pname = core.is_player(placer) and placer:get_player_name() or "Hunter"

		local owner = smeta:get_string("owner")
		if owner == "" then
			owner = pname
		end
		local completed_date = smeta:get_string("completed_date")
		if completed_date == "" then
			completed_date = os.date("%Y-%m-%d")
		end
		local summary = x_mobs.bestiary.storage.get_progress_summary(owner)
		local total_kills = smeta:get_int("total_kills")
		if total_kills <= 0 then
			total_kills = summary.total_kills
		end

		meta:set_string("owner", owner)
		meta:set_string("completed_date", completed_date)
		meta:set_int("total_kills", total_kills)
		meta:set_string(
			"infotext",
			S("★ Grand Hunter's Trophy ★\nChampioned by @1 (@2)\nRight-click to inspect Exhibition Hall", owner, completed_date)
		)
	end,

	on_rightclick = function(pos, _node, clicker, _itemstack, _pointed_thing)
		if not core.is_player(clicker) then
			return
		end
		local pname = clicker:get_player_name()
		trophy.open_positions[pname] = pos

		core.sound_play("x_mobs_bestiary_trophy", {
			to_player = pname,
			gain = 0.55,
		}, true)

		local fs = trophy.build_exhibition_formspec(clicker, pos)
		core.show_formspec(pname, trophy.FORMNAME, fs)
	end,

	on_destruct = function(pos)
		trophy.clear_hologram(pos)
	end,
})

-- Exhibition Hall formspec input handler
core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= trophy.FORMNAME then
		return false
	end
	if not core.is_player(player) then
		return false
	end

	local pname = player:get_player_name()
	local pos = trophy.open_positions[pname]
	if fields.quit or not pos then
		trophy.open_positions[pname] = nil
		return true
	end

	local meta = core.get_meta(pos)
	local owner = meta:get_string("owner")
	if owner == "" then
		owner = pname
	end
	if owner ~= pname then
		return true
	end

	if fields.btn_clear_holo then
		meta:set_string("enshrined_mob", "")
		trophy.clear_hologram(pos)
		core.show_formspec(pname, trophy.FORMNAME, trophy.build_exhibition_formspec(player, pos))
		return true
	end

	for k in pairs(fields) do
		if k:sub(1, 9) == "enshrine_" then
			local mob_id = k:sub(10)
			local entry = x_mobs.bestiary.data.get_entry(mob_id)
			if entry then
				meta:set_string("enshrined_mob", mob_id)
				local completed_date = meta:get_string("completed_date")
				meta:set_string(
					"infotext",
					S("★ Grand Hunter's Trophy (@1) ★\nChampioned by @2 (@3)", entry.name, owner, completed_date)
				)
				trophy.spawn_hologram(pos, mob_id)
				core.show_formspec(pname, trophy.FORMNAME, trophy.build_exhibition_formspec(player, pos))
			end
			break
		end
	end

	return true
end)

return trophy
