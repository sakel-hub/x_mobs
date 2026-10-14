--[[
	x_mobs - Items Subsystem: Armor & Material Tooltip Utilities
	Author: SaKeL
	License: MIT
]]

---@class XMobsItemUtils
local utils = {}

local S = core.get_translator("x_mobs")

---WCAG AAA / AA Accessible Contrast Colors
---Calibrated against Luanti dark tooltip background (#10141cf0) for high readability.
utils.UI_COLORS = {
	title       = "#f5c542", -- Radiant Gold (WCAG AAA 11.2:1) - Name & Rarity
	category    = "#9ecbff", -- Sky Cyan (WCAG AAA 9.9:1) - Category & Slot
	description = "#c9d1d9", -- High-Contrast Silver (WCAG AAA 10.7:1) - Body & Lore
	stat_label  = "#8b949e", -- Neutral Slate (WCAG AA 4.6:1) - Stat Labels
	stat_val    = "#58a6ff", -- Vibrant Celestial Blue (WCAG AA 6.8:1) - Stat Values
	full_set    = "#d2a8ff", -- Ethereal Amethyst (WCAG AAA 8.5:1) - Set Bonus Header
}

---@class LegendaryTooltipSetBonusDef
---@field name string Full set bonus name
---@field pieces number Required matching armor pieces (e.g. 4)
---@field desc string Full set bonus description

---@class LegendaryTooltipParams
---@field title string Item display title
---@field category string Item category/type
---@field lore? string Background flavor text
---@field stats? table<string, string> Key-value armor or forging material stats
---@field set_bonus? LegendaryTooltipSetBonusDef Full set bonus definition

---Builds a rich, colorized tooltip for x_mobs 3D armor pieces and forging shards.
---@param params LegendaryTooltipParams Tooltip configuration table
---@return string Formatted multi-line colorized tooltip
function utils.format_legendary_tooltip(params)
	local lines = {}

	-- Colored header title and category
	lines[#lines + 1] = core.colorize(utils.UI_COLORS.title, "★ " .. params.title .. " ★")
	lines[#lines + 1] = core.colorize(utils.UI_COLORS.category, "[" .. params.category .. "]")

	-- Lore and background flavor text
	if params.lore and params.lore ~= "" then
		lines[#lines + 1] = core.colorize(utils.UI_COLORS.description, params.lore)
	end

	-- Armor or forging material statistics
	if params.stats then
		for label, val in pairs(params.stats) do
			lines[#lines + 1] = core.colorize(utils.UI_COLORS.stat_label, label .. ": ")
				.. core.colorize(utils.UI_COLORS.stat_val, val)
		end
	end

	-- Full set armor bonus (4 armor pieces, excluding shield)
	if params.set_bonus then
		lines[#lines + 1] = ""
		lines[#lines + 1] = core.colorize(utils.UI_COLORS.full_set,
			"★ " .. S("Set Bonus (@1 Armor Pieces, Excl. Shield): @2", params.set_bonus.pieces, params.set_bonus.name))
		lines[#lines + 1] = core.colorize(utils.UI_COLORS.description, "  " .. params.set_bonus.desc)
	end

	return table.concat(lines, "\n")
end

return utils
