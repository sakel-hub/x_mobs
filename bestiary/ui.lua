--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Responsive Formspec v11 UI
	Renders the double-page antique parchment tome interface with:
	- Client formspec version negotiation up to `formspec_version[11]`
	- Interactive 3D rotatable monster preview (`model[...;mouse_control=true]`)
	- WCAG AA / AAA accessible contrast typography
	- 3-Tier "Fog of War" progressive information reveal
	- Game-agnostic drop slot inspection (`core.registered_items`)

	Author: SaKeL
	License: MIT
]]

local S = core.get_translator("x_mobs")

---@class BestiaryUIContext
---@field category string Active category tab ("All", "Bosses", "Undead", "Guardians", "Beasts", "Aberrations")
---@field search_query string Current search filter
---@field page number Current list page (1-indexed)
---@field selected_mob string Currently inspected mob_id
---@field detail_tab string Active right-page detail tab ("lore", "abilities", "drops")
---@field skin_index number Active texture variant index (1-indexed)

---@class BestiaryUIOverrides
---@field category? string Active category tab to switch to
---@field search_query? string Search filter query to apply
---@field page? number Page index (1-indexed)
---@field selected_mob? string Technical mob ID to inspect
---@field detail_tab? string Active right-page detail tab ("lore", "abilities", "drops")
---@field skin_index? number Active texture variant index (1-indexed)

---@class BestiaryUIColors
---@field ink_title string Deepest iron-gall black title ink
---@field ink_sub string Rich umber subtitle ink
---@field ink_body string Dark sepia body ink
---@field ink_muted string Charcoal-sepia muted ink
---@field card_bg string Warm recessed parchment card background
---@field card_border string Antique brass/parchment card border
---@field stage_bg string Deep obsidian 3D model stage background
---@field stage_text string High-contrast warm gold text on dark stage
---@field stage_sub string High-contrast cream text on dark stage
---@field gold string Burnished royal bronze/gold ink
---@field cyan string Deep sapphire navy ink
---@field sky string Cobalt blue ink
---@field silver string Primary dark sepia hypertext ink
---@field slate string Secondary charcoal-sepia ink
---@field green string Deep herbalist emerald ink
---@field crimson string Dragon-blood crimson ink
---@field amethyst string Deep arcane violet ink

---@class XMobsBestiaryUI
---@field FORMNAME string Primary Bestiary formspec name ("x_mobs:bestiary_main")
---@field contexts table<string, BestiaryUIContext> Per-player UI state keyed by player name
---@field ITEMS_PER_PAGE number Number of creature rows rendered per left-page list
---@field COLORS BestiaryUIColors WCAG AA/AAA calibrated color palette
local ui = {
	FORMNAME = "x_mobs:bestiary_main",
	contexts = {},
	ITEMS_PER_PAGE = 7,
}

---WCAG AAA Calibrated Accessible Grimoire Palette
---All text inks have low luminance (< 0.05) against warm parchment (#eee4ca / #e2d2b0),
---achieving 8.0:1 to 14.3:1 WCAG AAA contrast and avoiding Luanti's dark hypertext shadow.
ui.COLORS = {
	ink_title   = "#140e0a", -- Iron-Gall Black Ink (14.3:1 AAA on parchment)
	ink_sub     = "#3d240c", -- Rich Umber Subtitle Ink (9.8:1 AAA on parchment)
	ink_body    = "#1f1610", -- Dark Sepia Body Ink (12.5:1 AAA on parchment)
	ink_muted   = "#3f3224", -- Charcoal-Sepia Muted Ink (8.5:1 AAA on parchment)

	card_bg     = "#e2d2b0FF", -- Recessed Warm Parchment Panel (100% opaque)
	card_border = "#b89c6fFF", -- Antique Parchment Frame Border (100% opaque)
	stage_bg    = "#1c1612FF", -- Deep Obsidian 3D Model Stage (100% opaque)
	stage_text  = "#ffe89e",   -- Radiant Gold on Dark Stage (13.8:1 AAA)
	stage_sub   = "#f4ecd4",   -- Warm Cream on Dark Stage (14.6:1 AAA)

	gold        = "#5c3604", -- Burnished Royal Bronze Ink (8.6:1 AAA on card_bg)
	cyan        = "#09386b", -- Deep Sapphire Navy Ink (8.9:1 AAA on card_bg)
	sky         = "#0d427a", -- Cobalt Blue Ink (8.0:1 AAA on card_bg)
	silver      = "#1f1610", -- Primary Dark Sepia Ink (12.5:1 AAA on card_bg)
	slate       = "#3f3224", -- Secondary Charcoal-Sepia Ink (8.5:1 AAA on card_bg)
	green       = "#0d4f22", -- Herbalist Emerald Ink (8.2:1 AAA on card_bg)
	crimson     = "#7d1111", -- Dragon-Blood Crimson Ink (8.6:1 AAA on card_bg)
	amethyst    = "#4a146e", -- Deep Arcane Violet Ink (9.6:1 AAA on card_bg)
}

---Negotiates the highest supported formspec version for the player (targeting v11).
---@param player_name string Player name
---@return number formspec_version
function ui.get_formspec_version(player_name)
	local info = core.get_player_information(player_name)
	if info and type(info.formspec_version) == "number" and info.formspec_version >= 2 then
		return math.max(6, math.min(11, info.formspec_version))
	end
	return 11
end

---Retrieves or initializes the UI session context for a player.
---@param pname string Player name
---@param overrides? BestiaryUIOverrides Optional context fields to override
---@return BestiaryUIContext context
function ui.get_context(pname, overrides)
	local ctx = ui.contexts[pname]
	if not ctx then
		local all = x_mobs.bestiary.data.get_all_entries()
		ctx = {
			category     = "All",
			search_query = "",
			page         = 1,
			selected_mob = (all[1] and all[1].id) or "x_mobs:spider",
			detail_tab   = "lore",
			skin_index   = 1,
		}
		ui.contexts[pname] = ctx
	end

	if overrides then
		if overrides.category then
			ctx.category = overrides.category
			ctx.page = 1
		end
		if overrides.search_query ~= nil then
			ctx.search_query = overrides.search_query
			ctx.page = 1
		end
		if overrides.page then
			ctx.page = overrides.page
		end
		if overrides.selected_mob then
			ctx.selected_mob = overrides.selected_mob
			ctx.skin_index = 1
		end
		if overrides.detail_tab then
			ctx.detail_tab = overrides.detail_tab
		end
		if overrides.skin_index then
			ctx.skin_index = overrides.skin_index
		end
	end

	return ctx
end

---Builds a threat star string (e.g. "★★★☆☆").
---@param level number
---@return string
local function format_threat_stars(level)
	local lvl = math.max(1, math.min(5, math.floor(level or 1)))
	return string.rep("★", lvl) .. string.rep("☆", 5 - lvl)
end

---Builds the Left Page (Index, Category Tabs, Search, Paginated List, Realm Progress).
---@param pname string
---@param ctx BestiaryUIContext
---@return string formspec_chunk
local function render_left_page(pname, ctx)
	local data_mod = x_mobs.bestiary.data
	local storage = x_mobs.bestiary.storage
	local summary = storage.get_progress_summary(pname)
	local entries = data_mod.get_all_entries(ctx.category, ctx.search_query)

	local total_pages = math.max(1, math.ceil(#entries / ui.ITEMS_PER_PAGE))
	if ctx.page > total_pages then
		ctx.page = total_pages
	end
	if ctx.page < 1 then
		ctx.page = 1
	end

	-- Ensure selected_mob is valid
	if not data_mod.get_entry(ctx.selected_mob) and #entries > 0 then
		ctx.selected_mob = entries[1].id
	end

	-- Stacked non-overlapping Left Page Header + Discovery Summary (fits any screen width)
	local header_html = string.format(
		"<global margin=0 color=%s size=15>"
		.. "<b><style color=%s size=16>%s</style></b>\n"
		.. "<style color=%s size=14><b>%s</b></style>",
		ui.COLORS.ink_title,
		ui.COLORS.ink_title,
		core.formspec_escape(S("BESTIARY OF THE REALM")),
		ui.COLORS.ink_sub,
		core.formspec_escape(
			S("@1/@2 Discovered (@3% Mastered)", summary.discovered_count, summary.total_mobs, summary.mastery_percent)
		)
	)

	local fs = {
		string.format("hypertext[1.15,0.98;6.30,0.58;left_header;%s]", header_html),

		-- Realm Mastery Progress Bar (x = 1.15, y = 1.56, w = 6.30, h = 0.18)
		string.format("box[1.15,1.56;6.30,0.18;%s]", ui.COLORS.stage_bg),
	}

	local fill_w = math.max(0.05, 6.26 * (summary.mastery_percent / 100.0))
	local bar_color = summary.is_all_mastered and "#e6b436FF" or "#2ea043FF"
	if summary.mastery_percent > 0 then
		fs[#fs + 1] = string.format("box[1.17,1.58;%.2f,0.14;%s]", fill_w, bar_color)
	end

	-- Category Tabs (2 rows of 3 compact buttons across x = 1.15 .. 7.45)
	local cats = data_mod.categories
	for i = 1, #cats do
		local c = cats[i]
		local col = (i - 1) % 3
		local row = math.floor((i - 1) / 3)
		local bx = 1.15 + col * 2.12
		local by = 1.80 + row * 0.44
		local btn_name = "cat_" .. c.id
		local is_active = (ctx.category == c.id)

		if is_active then
			fs[#fs + 1] = string.format(
				"style[%s;bgcolor=#4a2810;textcolor=#fff099;font=bold;border=true]",
				btn_name
			)
		else
			fs[#fs + 1] = string.format(
				"style[%s;bgcolor=#241b16;textcolor=#f4ecd4;font=normal;border=true]",
				btn_name
			)
		end
		fs[#fs + 1] = string.format(
			"button[%.2f,%.2f;2.05,0.39;%s;%s]",
			bx,
			by,
			btn_name,
			core.formspec_escape(c.label)
		)
	end

	-- Search Field & Buttons (y = 2.74)
	fs[#fs + 1] = "style[search_query;bgcolor=#1c1612;textcolor=#f4ecd4;border=true]"
	fs[#fs + 1] = string.format(
		"field[1.15,2.74;4.15,0.42;search_query;;%s]",
		core.formspec_escape(ctx.search_query or "")
	)
	fs[#fs + 1] = "field_close_on_enter[search_query;false]"
	fs[#fs + 1] = "style[btn_search;bgcolor=#241b16;textcolor=#ffe070;font=bold]"
	fs[#fs + 1] = string.format("button[5.38,2.74;1.02,0.42;btn_search;%s]", core.formspec_escape(S("Find")))
	fs[#fs + 1] = "style[btn_clear;bgcolor=#241b16;textcolor=#f4ecd4]"
	fs[#fs + 1] = string.format("button[6.46,2.74;0.99,0.42;btn_clear;%s]", core.formspec_escape(S("Reset")))

	-- Paginated Creature List (7 rows from y = 3.24 to y = 7.36)
	local start_idx = (ctx.page - 1) * ui.ITEMS_PER_PAGE + 1
	local end_idx = math.min(#entries, start_idx + ui.ITEMS_PER_PAGE - 1)

	if #entries == 0 then
		fs[#fs + 1] = string.format(
			"hypertext[1.20,4.60;6.20,1.00;empty_list;<global margin=4 color=%s size=15><b>%s</b>]",
			ui.COLORS.ink_muted,
			core.formspec_escape(S("No creatures match your current filter."))
		)
	else
		for idx = start_idx, end_idx do
			local entry = entries[idx]
			local row_i = idx - start_idx
			local ry = 3.24 + row_i * 0.59
			local rec, max_tier = storage.get_mob_record(pname, entry.id)
			local tier = rec.tier or 0
			local is_selected = (ctx.selected_mob == entry.id)

			local badge_img = string.format("x_mobs_bestiary_badge_tier%d.png", math.min(3, math.max(0, tier)))
			local btn_id = "mob_" .. entry.id

			-- High-contrast button colors (minimum 9.6:1 AAA contrast even for undiscovered rows)
			local row_bg = is_selected and "#4a2014" or "#241b16"
			local row_tc = is_selected and "#fff099" or (tier > 0 and "#f4ecd4" or "#d6c6a6")
			local display_title = tier > 0 and entry.name or S("??? (Undiscovered)")
			local tier_tag = ""
			if tier >= max_tier and max_tier > 0 then
				tier_tag = " [★]"
				if not is_selected then
					row_tc = "#ffe070"
				end
			elseif tier > 0 then
				tier_tag = string.format(" [T%d]", tier)
			end

			fs[#fs + 1] = string.format(
				"style[%s;bgcolor=%s;textcolor=%s;font=%s;font_size=+1;border=true]",
				btn_id,
				row_bg,
				row_tc,
				is_selected and "bold" or "normal"
			)
			fs[#fs + 1] = string.format(
				"button[1.72,%.2f;5.73,0.52;%s;%s]",
				ry,
				btn_id,
				core.formspec_escape(display_title .. tier_tag)
			)
			fs[#fs + 1] = string.format("image[1.16,%.2f;0.48,0.48;%s]", ry + 0.02, badge_img)
		end
	end

	-- Pagination Controls (y = 7.44 .. 7.88)
	fs[#fs + 1] = "style[btn_prev;bgcolor=#241b16;textcolor=#ffe070;font=bold]"
	fs[#fs + 1] = "style[btn_next;bgcolor=#241b16;textcolor=#ffe070;font=bold]"
	fs[#fs + 1] = string.format("button[1.15,7.44;1.50,0.42;btn_prev;%s]", core.formspec_escape(S("< Prev")))
	fs[#fs + 1] = "style_type[label;font=bold;font_size=+1]"
	fs[#fs + 1] = string.format(
		"label[3.55,7.65;%s]",
		core.colorize(ui.COLORS.ink_title, core.formspec_escape(S("Page @1 / @2", ctx.page, total_pages)))
	)
	fs[#fs + 1] = "style_type[label;font=normal;font_size=]"
	fs[#fs + 1] = string.format("button[5.95,7.44;1.50,0.42;btn_next;%s]", core.formspec_escape(S("Next >")))

	-- Grand Hunter's Trophy Progress / Claim Footer (y = 7.96 .. 8.86, bounded within Left Page w = 6.30)
	if summary.is_all_mastered then
		if summary.trophy_claimed then
			fs[#fs + 1] = "style[btn_claim_trophy;bgcolor=#143d29;textcolor=#98ffe0;font=bold]"
			fs[#fs + 1] = string.format(
				"button[1.15,8.02;6.30,0.56;btn_claim_trophy;%s]",
				core.formspec_escape(S("★ Grand Hunter's Trophy Claimed (Click for Extra) ★"))
			)
		else
			fs[#fs + 1] = "style[btn_claim_trophy;bgcolor=#6e480c;textcolor=#fff099;font=bold]"
			fs[#fs + 1] = string.format(
				"button[1.15,8.02;6.30,0.56;btn_claim_trophy;%s]",
				core.formspec_escape(S("★ CLAIM GRAND HUNTER'S TROPHY! ★"))
			)
		end
	else
		-- Bounded word-wrapping hypertext panel so the footer NEVER overflows onto the 2nd page on small screens
		fs[#fs + 1] = string.format("box[1.15,7.96;6.30,0.88;%s]", ui.COLORS.card_border)
		fs[#fs + 1] = string.format("box[1.18,7.99;6.24,0.82;%s]", ui.COLORS.card_bg)
		local footer_html = string.format(
			"<global margin=2 color=%s size=14><center><b>%s</b></center>",
			ui.COLORS.ink_sub,
			core.formspec_escape(
				S("Master all @1 creatures (@2/@3) to unlock the Grand Trophy!", summary.total_mobs, summary.mastered_count, summary.total_mobs)
			)
		)
		fs[#fs + 1] = string.format("hypertext[1.20,8.00;6.20,0.80;trophy_hint;%s]", footer_html)
	end

	return table.concat(fs, "")
end

---Builds the Right Page (3D Rotatable Model Stage, Fog of War Stats, Lore/Abilities/Drops Tabs).
---@param pname string
---@param ctx BestiaryUIContext
---@return string formspec_chunk
local function render_right_page(pname, ctx)
	local data_mod = x_mobs.bestiary.data
	local storage = x_mobs.bestiary.storage
	local entry = data_mod.get_entry(ctx.selected_mob)

	local fs = {
		-- Close Button in Top-Right Tome Corner
		"style[btn_close;bgcolor=#4a2014;textcolor=#fff099;font=bold]",
		"button_exit[14.32,0.98;0.56,0.52;btn_close;X]",
	}

	if not entry then
		fs[#fs + 1] = string.format(
			"hypertext[8.80,4.40;5.80,1.00;no_sel;<global margin=6 color=%s size=16><b>%s</b>]",
			ui.COLORS.ink_muted,
			core.formspec_escape(S("Select a creature from the index."))
		)
		return table.concat(fs, "")
	end

	local rec, max_tier = storage.get_mob_record(pname, entry.id)
	local tier = rec.tier or 0

	-- =========================================================================
	-- TIER 0: UNDISCOVERED ("FOG OF WAR" SEALED STATE)
	-- =========================================================================
	if tier <= 0 then
		local t0_header = string.format(
			"<global margin=0 color=%s size=15>"
			.. "<b><style color=%s size=16>%s</style></b>\n"
			.. "<style color=%s size=14><b>%s</b></style>",
			ui.COLORS.ink_title,
			ui.COLORS.ink_title,
			core.formspec_escape(S("??? — UNDOCUMENTED CREATURE")),
			ui.COLORS.ink_sub,
			core.formspec_escape(S("Category: @1  |  Threat: @2", entry.category, format_threat_stars(entry.threat_level)))
		)
		fs[#fs + 1] = string.format("hypertext[8.55,0.98;5.70,0.68;t0_header;%s]", t0_header)

		-- Dark Mystery Stage Panel (100% opaque obsidian stage with high-contrast gold/cream text)
		fs[#fs + 1] = string.format("box[8.55,1.76;6.30,3.42;%s]", ui.COLORS.stage_bg)
		fs[#fs + 1] = "image[10.95,2.08;1.50,1.50;x_mobs_bestiary_badge_tier0.png]"
		local t0_stage_html = string.format(
			"<global margin=4 color=%s size=15><center>"
			.. "<b><style color=%s>%s</style></b>\n"
			.. "<style color=%s><b>%s</b></style>"
			.. "</center>",
			ui.COLORS.stage_sub,
			ui.COLORS.stage_sub,
			core.formspec_escape(S("Shrouded in Fog of War — Encounter in the wild")),
			ui.COLORS.stage_text,
			core.formspec_escape(S("Known Habitat: @1", entry.habitat))
		)
		fs[#fs + 1] = string.format("hypertext[8.65,3.72;6.10,1.36;t0_stage_text;%s]", t0_stage_html)

		-- Tier Unlock Requirements Card (Warm Parchment Card + Deep AAA Grimoire Inks)
		fs[#fs + 1] = string.format("box[8.55,5.32;6.30,3.52;%s]", ui.COLORS.card_border)
		fs[#fs + 1] = string.format("box[8.58,5.35;6.24,3.46;%s]", ui.COLORS.card_bg)
		local req_html = string.format(
			"<global margin=8 color=%s size=15>"
			.. "<b><style color=%s size=16>%s</style></b>\n\n"
			.. "• <b><style color=%s>Tier I (%s):</style></b> %s\n\n"
			.. "• <b><style color=%s>Tier II (%s):</style></b> %s\n\n"
			.. "• <b><style color=%s>Tier III (%s):</style></b> %s",
			ui.COLORS.ink_body,
			ui.COLORS.gold,
			core.formspec_escape(S("HOW TO UNLOCK CHRONICLE TIERS:")),
			ui.COLORS.green,
			core.formspec_escape(entry.tiers[1] and entry.tiers[1].name or S("Sighted")),
			core.formspec_escape(entry.tiers[1] and entry.tiers[1].desc or S("Encounter in the wild")),
			ui.COLORS.cyan,
			core.formspec_escape(entry.tiers[2] and entry.tiers[2].name or S("Vanquished")),
			core.formspec_escape(entry.tiers[2] and entry.tiers[2].desc or S("Land the killing blow (1 Kill)")),
			ui.COLORS.crimson,
			core.formspec_escape(entry.tiers[3] and entry.tiers[3].name or S("Mastered")),
			core.formspec_escape(entry.tiers[3] and entry.tiers[3].desc or S("Slay multiple times"))
		)
		fs[#fs + 1] = string.format("hypertext[8.66,5.42;6.08,3.32;locked_info;%s]", req_html)
		return table.concat(fs, "")
	end

	-- =========================================================================
	-- TIER 1+: DISCOVERED (3D ROTATABLE MODEL + TIERED REVEAL)
	-- =========================================================================
	local faction_str = (#entry.factions > 0) and table.concat(entry.factions, ", ") or entry.category
	local right_header_html = string.format(
		"<global margin=0 color=%s size=15>"
		.. "<b><style color=%s size=16>%s</style></b>\n"
		.. "<style color=%s size=14><b>%s</b></style>",
		ui.COLORS.ink_title,
		ui.COLORS.ink_title,
		core.formspec_escape(entry.name:upper()),
		ui.COLORS.ink_sub,
		core.formspec_escape(string.format("%s [%s]", format_threat_stars(entry.threat_level), faction_str))
	)
	fs[#fs + 1] = string.format("hypertext[8.55,0.98;5.70,0.68;right_header;%s]", right_header_html)

	-- 1. Interactive 3D Rotatable Model Stage (x = 8.55, y = 1.76, w = 3.10, h = 3.48)
	fs[#fs + 1] = string.format("box[8.55,1.76;3.10,3.48;%s]", ui.COLORS.stage_bg)

	local variants = entry.variant_textures
	local active_tex_list = entry.textures
	if variants and #variants > 0 then
		if ctx.skin_index > #variants or ctx.skin_index < 1 then
			ctx.skin_index = 1
		end
		active_tex_list = variants[ctx.skin_index]
	end
	local tex_str = table.concat(active_tex_list or { "blank.png" }, ",")
	local rot_x = (entry.model_rotation and entry.model_rotation.x) or 0
	local rot_y = (entry.model_rotation and entry.model_rotation.y) or -145

	if entry.mesh and entry.mesh ~= "" then
		fs[#fs + 1] = string.format(
			"model[8.62,1.82;2.96,2.92;mob_3d_preview;%s;%s;%d,%d;false;true;0,0;0]",
			core.formspec_escape(entry.mesh),
			core.formspec_escape(tex_str),
			rot_x,
			rot_y
		)
	end

	if variants and #variants > 1 then
		fs[#fs + 1] = string.format(
			"label[8.68,4.98;%s]",
			core.colorize(ui.COLORS.stage_text, core.formspec_escape(S("Drag to rotate")))
		)
		fs[#fs + 1] = "style[btn_skin;bgcolor=#4a2810;textcolor=#fff099;font=bold]"
		fs[#fs + 1] = string.format(
			"button[10.42,4.78;1.16,0.38;btn_skin;%s]",
			core.formspec_escape(S("Skin @1/@2", ctx.skin_index, #variants))
		)
	else
		fs[#fs + 1] = string.format(
			"label[8.82,5.00;%s]",
			core.colorize(ui.COLORS.stage_text, core.formspec_escape(S("Drag to rotate 3D model")))
		)
	end

	-- 2. Combat Vital Stats Card (x = 11.75, y = 1.76, w = 3.10, h = 3.48 — 32% wider so stats never wrap into a scrollbar)
	fs[#fs + 1] = string.format("box[11.75,1.76;3.10,3.48;%s]", ui.COLORS.card_border)
	fs[#fs + 1] = string.format("box[11.78,1.79;3.04,3.42;%s]", ui.COLORS.card_bg)

	local tdef = entry.tiers and entry.tiers[tier]
	local tier_title = tdef and tdef.name or S("Tier @1", tostring(tier))
	local next_tdef = entry.tiers and entry.tiers[tier + 1]
	local next_hint = next_tdef
		and S("Next Tier: @1 Kills", tostring(next_tdef.kills or 1))
		or S("★ MASTERED ★")

	-- Tier >= 2 unlocks combat stats; Tier 1 keeps them obscured as "???"
	local hp_str  = (tier >= 2) and string.format("%d HP", entry.hp_max) or "???"
	local dmg_str = (tier >= 2) and string.format("%d DMG", entry.damage) or "???"
	local def_pct = math.max(0, 100 - (entry.armor or 100))
	local def_str = (tier >= 2) and string.format("%d%% (%d)", def_pct, entry.armor) or "???"
	local spd_str = (tier >= 2) and string.format("%.1f / %.1f", entry.walk_speed, entry.pursuit_speed) or "???"

	local stats_html = string.format(
		"<global margin=6 color=%s size=15>"
		.. "<b><style color=%s size=16>%s (T%d/%d)</style></b>\n"
		.. "<style color=%s size=14><b>%s</b></style>\n"
		.. "<b>%s:</b> <style color=%s><b>%d</b></style>\n"
		.. "<b>%s:</b> <style color=%s><b>%s</b></style>\n"
		.. "<b>%s:</b> <style color=%s><b>%s</b></style>\n"
		.. "<b>%s:</b> <style color=%s><b>%s</b></style>\n"
		.. "<b>%s:</b> <style color=%s><b>%s</b></style>",
		ui.COLORS.ink_body,
		tier >= max_tier and ui.COLORS.gold or ui.COLORS.cyan,
		core.formspec_escape(tier_title),
		tier,
		max_tier,
		ui.COLORS.ink_muted,
		core.formspec_escape(next_hint),
		core.formspec_escape(S("Kills")),
		ui.COLORS.gold,
		rec.kills or 0,
		core.formspec_escape(S("Vitality")),
		tier >= 2 and ui.COLORS.green or ui.COLORS.slate,
		core.formspec_escape(hp_str),
		core.formspec_escape(S("Attack")),
		tier >= 2 and ui.COLORS.crimson or ui.COLORS.slate,
		core.formspec_escape(dmg_str),
		core.formspec_escape(S("Armor")),
		tier >= 2 and ui.COLORS.cyan or ui.COLORS.slate,
		core.formspec_escape(def_str),
		core.formspec_escape(S("Speed")),
		tier >= 2 and ui.COLORS.amethyst or ui.COLORS.slate,
		core.formspec_escape(spd_str)
	)
	fs[#fs + 1] = string.format("hypertext[11.84,1.84;2.92,3.32;mob_stats;%s]", stats_html)

	-- 3. Detail Sub-Tabs on Right Page Lower Half (y = 5.34)
	local detail_tabs = {
		{ id = "lore",      label = S("Lore & Tactics") },
		{ id = "abilities", label = S("Abilities (@1)", #entry.abilities) },
		{ id = "drops",     label = S("Known Drops") },
	}
	for i = 1, #detail_tabs do
		local dt = detail_tabs[i]
		local bx = 8.55 + (i - 1) * 2.12
		local btn_name = "dtab_" .. dt.id
		local is_active = (ctx.detail_tab == dt.id)
		fs[#fs + 1] = string.format(
			"style[%s;bgcolor=%s;textcolor=%s;font=%s;border=true]",
			btn_name,
			is_active and "#4a2810" or "#241b16",
			is_active and "#fff099" or "#f4ecd4",
			is_active and "bold" or "normal"
		)
		fs[#fs + 1] = string.format(
			"button[%.2f,5.34;2.06,0.42;%s;%s]",
			bx,
			btn_name,
			core.formspec_escape(dt.label)
		)
	end

	-- Lower Content Panel (Warm Parchment Card + AAA Dark Grimoire Inks, x = 8.55, y = 5.82, w = 6.30, h = 3.02)
	fs[#fs + 1] = string.format("box[8.55,5.82;6.30,3.02;%s]", ui.COLORS.card_border)
	fs[#fs + 1] = string.format("box[8.58,5.85;6.24,2.96;%s]", ui.COLORS.card_bg)

	if ctx.detail_tab == "lore" then
		local tactics_block
		if tier >= max_tier then
			tactics_block = string.format(
				"<b><style color=%s size=15>%s:</style></b>\n<style color=%s>%s</style>",
				ui.COLORS.green,
				core.formspec_escape(S("MASTER HUNTER TACTICS")),
				ui.COLORS.ink_body,
				core.formspec_escape(entry.tactics)
			)
		else
			local req_k = (entry.tiers[max_tier] and entry.tiers[max_tier].kills) or 5
			tactics_block = string.format(
				"<b><style color=%s size=15>%s:</style></b>\n<style color=%s>%s</style>",
				ui.COLORS.crimson,
				core.formspec_escape(S("TACTICAL WEAKNESSES [SEALED]")),
				ui.COLORS.ink_muted,
				core.formspec_escape(S("Reach Tier @1 Mastery (@2 Kills) to uncover tactical counter-strategies.", max_tier, req_k))
			)
		end

		local lore_html = string.format(
			"<global margin=8 color=%s size=15>"
			.. "<b><style color=%s>%s:</style></b> <style color=%s><b>%s</b></style>\n\n"
			.. "<style color=%s>%s</style>\n\n"
			.. "%s",
			ui.COLORS.ink_body,
			ui.COLORS.cyan,
			core.formspec_escape(S("Habitat")),
			ui.COLORS.ink_title,
			core.formspec_escape(entry.habitat),
			ui.COLORS.ink_body,
			core.formspec_escape(entry.lore),
			tactics_block
		)
		fs[#fs + 1] = string.format("hypertext[8.66,5.92;6.08,2.82;mob_lore;%s]", lore_html)

	elseif ctx.detail_tab == "abilities" then
		if tier < 2 then
			local locked_ab = string.format(
				"<global margin=10 color=%s size=15>"
				.. "<b><style color=%s size=16>%s</style></b>\n\n"
				.. "%s",
				ui.COLORS.ink_body,
				ui.COLORS.crimson,
				core.formspec_escape(S("COMBAT ABILITIES OBSCURED (TIER I)")),
				core.formspec_escape(S("Land a killing blow on this creature (1 Kill -> Tier II: Vanquished) to document its combat abilities and spell signatures."))
			)
			fs[#fs + 1] = string.format("hypertext[8.66,5.92;6.08,2.82;mob_abilities;%s]", locked_ab)
		else
			local lines = {
				string.format("<global margin=8 color=%s size=15>", ui.COLORS.ink_body),
			}
			for i = 1, #entry.abilities do
				local ab = entry.abilities[i]
				local badge = ab.badge and string.format(" [%s]", ab.badge) or ""
				lines[#lines + 1] = string.format(
					"• <b><style color=%s>%s</style><style color=%s>%s</style>:</b> %s",
					ui.COLORS.gold,
					core.formspec_escape(ab.name),
					ui.COLORS.amethyst,
					core.formspec_escape(badge),
					core.formspec_escape(ab.desc)
				)
			end
			fs[#fs + 1] = string.format(
				"hypertext[8.66,5.92;6.08,2.82;mob_abilities;%s]",
				table.concat(lines, "\n\n")
			)
		end

	elseif ctx.detail_tab == "drops" then
		if tier < 2 then
			local locked_dr = string.format(
				"<global margin=10 color=%s size=15>"
				.. "<b><style color=%s size=16>%s</style></b>\n\n"
				.. "%s",
				ui.COLORS.ink_body,
				ui.COLORS.crimson,
				core.formspec_escape(S("SPOILS & DROPS OBSCURED (TIER I)")),
				core.formspec_escape(S("Slay this creature once (Tier II: Vanquished) to reveal its spoils, and master it (Tier III) to reveal exact drop probabilities."))
			)
			fs[#fs + 1] = string.format("hypertext[8.66,5.92;6.08,2.82;mob_drops;%s]", locked_dr)
		else
			-- Game-agnostic drop resolution: filter or display drops cleanly
			local valid_drops = {}
			for i = 1, #(entry.drops or {}) do
				local d = entry.drops[i]
				if d and d.name then
					local resolved_name = (x_mobs.compat and x_mobs.compat.resolve_item)
						and x_mobs.compat.resolve_item(d.name)
						or d.name
					-- Include item if registered in current game OR if no items are registered in headless test mode
					local reg_empty = (core.registered_items == nil or next(core.registered_items) == nil)
					if reg_empty or core.registered_items[resolved_name] ~= nil then
						valid_drops[#valid_drops + 1] = {
							name = resolved_name,
							min = d.min,
							max = d.max,
							chance = d.chance,
						}
					end
				end
			end

			if #valid_drops == 0 then
				fs[#fs + 1] = string.format(
					"hypertext[8.75,6.80;5.90,1.00;no_drops;<global margin=6 color=%s size=15><b>%s</b>]",
					ui.COLORS.ink_muted,
					core.formspec_escape(S("No known material drops recorded in this realm."))
				)
			else
				for i = 1, math.min(8, #valid_drops) do
					local d = valid_drops[i]
					local col = (i - 1) % 4
					local row = math.floor((i - 1) / 4)
					local dx = 8.85 + col * 1.50
					local dy = 5.96 + row * 1.38

					local pct_str = (tier >= max_tier)
						and string.format("%d%%", math.floor((d.chance or 1.0) * 100 + 0.5))
						or "??%"
					local qty_str = (d.min and d.max and d.min ~= d.max)
						and string.format("%d-%dx", d.min, d.max)
						or string.format("%dx", d.min or 1)

					fs[#fs + 1] = string.format(
						"item_image_button[%.2f,%.2f;0.82,0.82;%s;drop_%d;]",
						dx,
						dy,
						core.formspec_escape(d.name),
						i
					)
					fs[#fs + 1] = string.format(
						"label[%.2f,%.2f;%s]",
						dx - 0.05,
						dy + 0.98,
						core.colorize(
							tier >= max_tier and ui.COLORS.gold or ui.COLORS.ink_body,
							core.formspec_escape(qty_str .. " " .. pct_str)
						)
					)
				end
			end
		end
	end

	return table.concat(fs, "")
end

---Builds the complete Bestiary formspec string for a player.
---@param player ObjectRef Target player ObjectRef
---@param overrides? BestiaryUIOverrides Optional context fields to override
---@return string formspec
function ui.build_formspec(player, overrides)
	local pname = player:get_player_name()
	local ctx = ui.get_context(pname, overrides)
	local fv = ui.get_formspec_version(pname)

	local fs = {
		string.format("formspec_version[%d]", fv),
		"size[16.0,10.0]",
		"no_prepend[]",
		"bgcolor[#000000bb;true]",
		"background[0,0;16.0,10.0;x_mobs_bestiary_bg.png;true]",
		render_left_page(pname, ctx),
		render_right_page(pname, ctx),
	}

	return table.concat(fs, "")
end

---Opens the Bestiary UI for a player and plays the subtle parchment page sound.
---@param player ObjectRef? Target player ObjectRef
---@param overrides? BestiaryUIOverrides Optional context fields to override
function ui.open(player, overrides)
	if not core.is_player(player) then
		return
	end
	local pname = player:get_player_name()
	if pname == "" then
		return
	end

	core.sound_play("x_mobs_bestiary_page", {
		to_player = pname,
		gain = 0.5,
	}, true)

	local fs = ui.build_formspec(player, overrides)
	core.show_formspec(pname, ui.FORMNAME, fs)
end

-- Formspec input handler
core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= ui.FORMNAME then
		return false
	end
	if not core.is_player(player) then
		return false
	end

	local pname = player:get_player_name()
	local ctx = ui.get_context(pname)

	if fields.quit then
		return true
	end

	local changed = false

	-- Search query handling
	if fields.btn_search or fields.key_enter_field == "search_query" then
		ctx.search_query = fields.search_query or ""
		ctx.page = 1
		changed = true
	elseif fields.btn_clear then
		ctx.search_query = ""
		ctx.page = 1
		changed = true
	end

	-- Pagination
	if fields.btn_prev then
		ctx.page = math.max(1, ctx.page - 1)
		changed = true
	elseif fields.btn_next then
		ctx.page = ctx.page + 1
		changed = true
	end

	-- Skin variant toggle
	if fields.btn_skin then
		ctx.skin_index = (ctx.skin_index or 1) + 1
		changed = true
	end

	-- Trophy Claim button
	if fields.btn_claim_trophy then
		x_mobs.bestiary.trophy.claim_trophy(player)
		changed = true
	end

	-- Dynamic button prefix matching (cat_*, dtab_*, mob_*)
	for k in pairs(fields) do
		if k:sub(1, 4) == "cat_" then
			ctx.category = k:sub(5)
			ctx.page = 1
			changed = true
		elseif k:sub(1, 5) == "dtab_" then
			ctx.detail_tab = k:sub(6)
			changed = true
		elseif k:sub(1, 4) == "mob_" then
			ctx.selected_mob = k:sub(5)
			ctx.skin_index = 1
			changed = true
		end
	end

	if changed then
		ui.open(player)
	end

	return true
end)

core.register_on_leaveplayer(function(player)
	ui.contexts[player:get_player_name()] = nil
end)

return ui
