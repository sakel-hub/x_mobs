--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Non-Intrusive Combat HUD Toast
	Displays a sleek, upper-right pixel-art toast notification with subtle audio
	when a player unlocks a new Bestiary tier. Uses `core.after()` with token
	coalescing so rapid combat events update in-place with ZERO globalsteps.

	Author: SaKeL
	License: MIT
]]

local S = core.get_translator("x_mobs")

---@class BestiaryActiveToast
---@field bg_id number HUD element ID for the ornate pixel-art toast background banner
---@field icon_id number HUD element ID for the tier badge icon in the left medallion socket
---@field title_id number HUD element ID for the header text in the upper right lane
---@field sub_id number HUD element ID for the subtitle text in the lower right lane
---@field token number Monotonic coalescing token for core.after expiration

---@class XMobsBestiaryHUD
---@field active_toasts table<string, BestiaryActiveToast> Active HUD toast state keyed by player name
---@field TOAST_DURATION number Duration in seconds before the HUD toast auto-removes
local hud = {
	active_toasts = {},
	TOAST_DURATION = 3.5,
}

local TIER_COLORS = {
	[1] = 0x9ECBFF, -- Sky Cyan (Tier I: Sighted)
	[2] = 0x58A6FF, -- Vibrant Celestial Blue (Tier II: Vanquished)
	[3] = 0xF5C542, -- Radiant Gold (Tier III: Mastered)
}

local TIER_BADGES = {
	[1] = "x_mobs_bestiary_badge_tier1.png",
	[2] = "x_mobs_bestiary_badge_tier2.png",
	[3] = "x_mobs_bestiary_badge_tier3.png",
}

---Removes any active toast HUD elements for a player.
---@param player_or_name ObjectRef|string? Player ObjectRef or player name
function hud.hide_toast(player_or_name)
	local pname
	local player
	if type(player_or_name) == "string" then
		pname = player_or_name
		player = core.get_player_by_name(pname)
	elseif core.is_player(player_or_name) then
		player = player_or_name
		pname = player:get_player_name()
	end
	if not pname or pname == "" then
		return
	end

	local active = hud.active_toasts[pname]
	if not active then
		return
	end

	if player then
		if active.bg_id then
			player:hud_remove(active.bg_id)
		end
		if active.icon_id then
			player:hud_remove(active.icon_id)
		end
		if active.title_id then
			player:hud_remove(active.title_id)
		end
		if active.sub_id then
			player:hud_remove(active.sub_id)
		end
	end

	hud.active_toasts[pname] = nil
end

---Shows or updates a non-intrusive Bestiary HUD toast notification for a player.
---@param player ObjectRef? Target player ObjectRef
---@param mob_id string Mob identifier (e.g. "x_mobs:spider")
---@param tier number Unlocked tier (1, 2, 3...)
---@param is_realm_mastery? boolean True if this unlock completed 100% of the Bestiary
function hud.show_unlock_toast(player, mob_id, tier, is_realm_mastery)
	if not core.is_player(player) then
		return
	end
	local pname = player:get_player_name()
	if pname == "" then
		return
	end

	local entry = x_mobs.bestiary.data.get_entry(mob_id)
	local mob_name = entry and entry.name or mob_id
	local tdef = entry and entry.tiers and entry.tiers[tier]
	local tier_label = tdef and tdef.name or (
		tier == 1 and S("Sighted")
		or tier == 2 and S("Vanquished")
		or S("Mastered")
	)

	local header_text = S("Bestiary — @1: @2", tier_label, mob_name)
	local sub_text = S("Tier @1 Unlocked • Right-click Bestiary", tostring(tier))
	local text_color = TIER_COLORS[tier] or 0xF5C542
	local badge_tex = TIER_BADGES[tier] or "x_mobs_bestiary_toast_icon.png"

	if is_realm_mastery then
		header_text = S("★ REALM BESTIARY MASTERED! ★")
		sub_text = S("Open Bestiary to claim your Grand Trophy!")
		text_color = 0xF5C542
		badge_tex = "x_mobs_bestiary_trophy.png"
	end

	-- Subtle per-player audio feedback (never interrupts combat)
	local sound_name = (is_realm_mastery or tier >= 3)
		and "x_mobs_bestiary_trophy"
		or "x_mobs_bestiary_toast"
	local sound_gain = is_realm_mastery and 0.65 or 0.45
	core.sound_play(sound_name, {
		to_player = pname,
		gain = sound_gain,
	}, true)

	local existing = hud.active_toasts[pname]
	local token = (existing and existing.token or 0) + 1

	if existing then
		player:hud_change(existing.icon_id, "text", badge_tex)
		player:hud_change(existing.title_id, "text", header_text)
		player:hud_change(existing.title_id, "number", text_color)
		player:hud_change(existing.sub_id, "text", sub_text)
		existing.token = token
	else
		-- 1. Ornate 192x32 pixel-art banner scaled 2x -> 384x64 screen pixels
		-- Spans x = -400..-16, y = 0..64 from top-right anchor (1.0, 0.04)
		local bg_id = player:hud_add({
			type = "image",
			position = { x = 1.0, y = 0.04 },
			alignment = { x = 1, y = 1 },
			offset = { x = -400, y = 0 },
			scale = { x = 2, y = 2 },
			text = "x_mobs_bestiary_toast_bg.png",
			z_index = 100,
		})

		-- 2. 16x16 tier badge scaled 2x -> 32x32 screen pixels
		-- Centered inside the left medallion socket (-382..-350, 16..48)
		local icon_id = player:hud_add({
			type = "image",
			position = { x = 1.0, y = 0.04 },
			alignment = { x = 1, y = 1 },
			offset = { x = -382, y = 16 },
			scale = { x = 2, y = 2 },
			text = badge_tex,
			z_index = 101,
		})

		-- 3. Left-aligned Title in the upper right text lane (starts at x = -322,
		-- 28px to the right of the icon and 14px to the right of the gilded divider)
		local title_id = player:hud_add({
			type = "text",
			position = { x = 1.0, y = 0.04 },
			alignment = { x = 1, y = 1 },
			offset = { x = -322, y = 10 },
			text = header_text,
			number = text_color,
			style = 1, -- Bold
			z_index = 102,
		})

		-- 4. Left-aligned Subtitle in the lower right text lane (starts at x = -322)
		local sub_id = player:hud_add({
			type = "text",
			position = { x = 1.0, y = 0.04 },
			alignment = { x = 1, y = 1 },
			offset = { x = -322, y = 36 },
			text = sub_text,
			number = 0xC9D1D9,
			z_index = 102,
		})

		hud.active_toasts[pname] = {
			bg_id = bg_id,
			icon_id = icon_id,
			title_id = title_id,
			sub_id = sub_id,
			token = token,
		}
	end

	-- Schedule automatic cleanup via core.after (ZERO globalsteps)
	core.after(hud.TOAST_DURATION, function()
		local cur = hud.active_toasts[pname]
		if cur and cur.token == token then
			hud.hide_toast(pname)
		end
	end)
end

core.register_on_leaveplayer(function(player)
	hud.active_toasts[player:get_player_name()] = nil
end)

return hud
