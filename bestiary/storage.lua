--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Player Persistence & Tier Logic
	Manages in-memory cached player discovery state backed by `PlayerMetaRef`
	("x_mobs:bestiary"). Evaluates flexible multi-tier progression rules with
	zero disk I/O bottlenecks and zero globalsteps.

	Author: SaKeL
	License: MIT
]]

---@class PlayerMobRecord
---@field tier number Current unlocked tier (0 = Undiscovered, 1 = Sighted, 2 = Vanquished, 3 = Mastered)
---@field kills number Total lifetime kills of this mob by the player
---@field sighted boolean Whether the player has encountered/sighted this mob
---@field damage_dealt number Cumulative damage dealt to this mob species
---@field first_seen number Timestamp of first encounter
---@field last_killed number Timestamp of most recent kill

---@class PlayerBestiaryState
---@field discovered table<string, PlayerMobRecord> Map of mob_id -> record
---@field trophy_claimed boolean Whether the player has claimed the Grand Hunter's Trophy
---@field completed_at? number Timestamp when 100% mastery was achieved

---@class BestiaryProgressSummary
---@field total_mobs number Total number of registered bestiary mobs
---@field discovered_count number Number of mobs at Tier 1+ (Sighted)
---@field vanquished_count number Number of mobs at Tier 2+ (Vanquished)
---@field mastered_count number Number of mobs at maximum mastery tier
---@field total_kills number Cumulative kills across all registered mobs
---@field mastery_percent number Overall completion percentage (0..100)
---@field is_all_mastered boolean Whether all registered mobs have reached maximum mastery
---@field trophy_claimed boolean Whether the player has claimed the Grand Hunter's Trophy
---@field completed_at? number Unix timestamp when 100% mastery was achieved

---@class XMobsBestiaryStorage
---@field players table<string, PlayerBestiaryState> In-memory session cache of player states keyed by player name
---@field META_KEY string PlayerMetaRef storage key ("x_mobs:bestiary")
local storage = {
	players = {},
	META_KEY = "x_mobs:bestiary",
}

---Resolves a player name and ObjectRef from either a player name string or player ObjectRef.
---@param player_or_name ObjectRef|string? Player ObjectRef or player name
---@return string? pname, ObjectRef? player
local function resolve_player(player_or_name)
	if not player_or_name then
		return nil, nil
	end
	if type(player_or_name) == "string" then
		return player_or_name, core.get_player_by_name(player_or_name)
	end
	if core.is_player(player_or_name) then
		local pname = player_or_name:get_player_name()
		if pname ~= "" then
			return pname, player_or_name
		end
	end
	return nil, nil
end

---Calculates the highest unlocked tier for a mob record given its entry's flexible `tiers` definition.
---@param entry BestiaryEntryDef? Bestiary entry definition
---@param rec PlayerMobRecord? Player progression record for the mob
---@return number current_tier, number max_tier
function storage.calculate_tier(entry, rec)
	local tiers = entry and entry.tiers or {}
	local max_tier = #tiers
	if max_tier == 0 then
		max_tier = 3
	end

	if not rec or (not rec.sighted and (rec.kills or 0) <= 0) then
		return 0, max_tier
	end

	local kills = rec.kills or 0
	local unlocked = 1

	for t = 1, max_tier do
		local tdef = tiers[t]
		if tdef then
			local req_kills = tdef.kills or 0
			if kills >= req_kills then
				unlocked = t
			end
		end
	end

	return unlocked, max_tier
end

---Loads or initializes a player's bestiary state from PlayerMetaRef.
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@return PlayerBestiaryState? state
function storage.get_player_data(player_or_name)
	local pname, player = resolve_player(player_or_name)
	if not pname then
		return nil
	end

	if storage.players[pname] then
		return storage.players[pname]
	end

	local state = {
		discovered = {},
		trophy_claimed = false,
		completed_at = nil,
	}

	if player then
		local meta = player:get_meta()
		local raw = meta:get_string(storage.META_KEY)
		if raw ~= "" then
			local parsed = core.parse_json(raw) or core.deserialize(raw)
			if type(parsed) == "table" then
				if type(parsed.discovered) == "table" then
					state.discovered = parsed.discovered
				end
				state.trophy_claimed = (parsed.trophy_claimed == true)
				state.completed_at = tonumber(parsed.completed_at)
			end
		end
	end

	storage.players[pname] = state
	return state
end

---Persists a player's bestiary state to PlayerMetaRef in compact JSON format.
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@return boolean saved
function storage.save_player_data(player_or_name)
	local pname, player = resolve_player(player_or_name)
	if not pname then
		return false
	end

	local state = storage.players[pname]
	if not state or not player then
		return false
	end

	local meta = player:get_meta()
	local serialized = core.write_json(state)
	if serialized then
		meta:set_string(storage.META_KEY, serialized)
		return true
	end
	return false
end

---Checks whether the player is allowed to record Bestiary progress (honors optional inventory requirement setting).
---@param player ObjectRef? Player ObjectRef
---@return boolean allowed
function storage.can_player_record(player)
	if not core.is_player(player) then
		return false
	end
	local require_book = core.settings:get_bool("x_mobs.bestiary_require_book_in_inventory", false)
	if not require_book then
		return true
	end
	local inv = player:get_inventory()
	return inv:contains_item("main", "x_mobs:bestiary")
end

---Retrieves a player's progression record for a specific mob (without mutating state).
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@param mob_id string Technical mob name (e.g. "x_mobs:spider")
---@return PlayerMobRecord record, number max_tier
function storage.get_mob_record(player_or_name, mob_id)
	local data_mod = x_mobs.bestiary.data
	local entry = data_mod.get_entry(mob_id)
	local state = storage.get_player_data(player_or_name)
	local rec = state and state.discovered[mob_id]

	if not rec then
		local _, max_tier = storage.calculate_tier(entry, nil)
		return {
			tier = 0,
			kills = 0,
			sighted = false,
			damage_dealt = 0,
			first_seen = 0,
			last_killed = 0,
		}, max_tier
	end

	local tier, max_tier = storage.calculate_tier(entry, rec)
	rec.tier = tier
	return rec, max_tier
end

---Records a sighting or combat encounter with a mob.
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@param mob_id string Technical mob name (e.g. "x_mobs:spider")
---@param dmg_dealt? number Optional damage dealt during this hit
---@return boolean tier_advanced, number new_tier, PlayerMobRecord? record
function storage.record_encounter(player_or_name, mob_id, dmg_dealt)
	local pname, player = resolve_player(player_or_name)
	if not pname or not player or not storage.can_player_record(player) then
		return false, 0, nil
	end

	local data_mod = x_mobs.bestiary.data
	local entry = data_mod.get_entry(mob_id)
	if not entry then
		return false, 0, nil
	end

	local state = storage.get_player_data(player)
	if not state then
		return false, 0, nil
	end

	local now = os.time()
	local rec = state.discovered[mob_id]
	local old_tier = 0

	if not rec then
		rec = {
			tier = 0,
			kills = 0,
			sighted = true,
			damage_dealt = 0,
			first_seen = now,
			last_killed = 0,
		}
		state.discovered[mob_id] = rec
	else
		old_tier = storage.calculate_tier(entry, rec)
		if not rec.sighted then
			rec.sighted = true
			if (rec.first_seen or 0) == 0 then
				rec.first_seen = now
			end
		end
	end

	if dmg_dealt and dmg_dealt > 0 then
		rec.damage_dealt = (rec.damage_dealt or 0) + dmg_dealt
	end

	local new_tier = storage.calculate_tier(entry, rec)
	rec.tier = new_tier

	local advanced = (new_tier > old_tier)
	if advanced or (dmg_dealt and dmg_dealt > 0) then
		storage.save_player_data(player)
	end

	return advanced, new_tier, rec
end

---Records a killing blow landed by a player on a mob and evaluates tier & mastery completion.
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@param mob_id string Technical mob name (e.g. "x_mobs:spider")
---@return boolean tier_advanced, number new_tier, PlayerMobRecord? record, boolean newly_mastered_all
function storage.record_kill(player_or_name, mob_id)
	local pname, player = resolve_player(player_or_name)
	if not pname or not player or not storage.can_player_record(player) then
		return false, 0, nil, false
	end

	local data_mod = x_mobs.bestiary.data
	local entry = data_mod.get_entry(mob_id)
	if not entry then
		return false, 0, nil, false
	end

	local state = storage.get_player_data(player)
	if not state then
		return false, 0, nil, false
	end

	local now = os.time()
	local rec = state.discovered[mob_id]
	local old_tier = 0

	if not rec then
		rec = {
			tier = 0,
			kills = 0,
			sighted = true,
			damage_dealt = 0,
			first_seen = now,
			last_killed = now,
		}
		state.discovered[mob_id] = rec
	else
		old_tier = storage.calculate_tier(entry, rec)
		rec.sighted = true
	end

	rec.kills = (rec.kills or 0) + 1
	rec.last_killed = now

	local new_tier = storage.calculate_tier(entry, rec)
	rec.tier = new_tier

	local advanced = (new_tier > old_tier)
	local newly_mastered_all = false

	if advanced then
		local summary = storage.get_progress_summary(player)
		if summary.is_all_mastered and not state.completed_at then
			state.completed_at = now
			newly_mastered_all = true
		end
	end

	storage.save_player_data(player)
	return advanced, new_tier, rec, newly_mastered_all
end

---Computes overall Bestiary completion statistics for a player.
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@return BestiaryProgressSummary summary
function storage.get_progress_summary(player_or_name)
	local data_mod = x_mobs.bestiary.data
	local entries = data_mod.get_all_entries()
	local state = storage.get_player_data(player_or_name)

	local total_mobs = #entries
	local discovered_count = 0
	local vanquished_count = 0
	local mastered_count = 0
	local total_kills = 0
	local total_tier_points = 0
	local max_tier_points = 0

	for i = 1, total_mobs do
		local entry = entries[i]
		local rec = state and state.discovered[entry.id]
		local tier, max_t = storage.calculate_tier(entry, rec)
		max_tier_points = max_tier_points + max_t
		total_tier_points = total_tier_points + tier

		if tier >= 1 then
			discovered_count = discovered_count + 1
		end
		if tier >= 2 then
			vanquished_count = vanquished_count + 1
		end
		if tier >= max_t and max_t > 0 then
			mastered_count = mastered_count + 1
		end
		if rec and rec.kills then
			total_kills = total_kills + rec.kills
		end
	end

	local mastery_percent = 0
	if max_tier_points > 0 then
		mastery_percent = math.floor((total_tier_points / max_tier_points) * 100 + 0.5)
	end

	local is_all_mastered = (total_mobs > 0 and mastered_count >= total_mobs)

	return {
		total_mobs       = total_mobs,
		discovered_count = discovered_count,
		vanquished_count = vanquished_count,
		mastered_count   = mastered_count,
		total_kills      = total_kills,
		mastery_percent  = mastery_percent,
		is_all_mastered  = is_all_mastered,
		trophy_claimed   = state and state.trophy_claimed == true or false,
		completed_at     = state and state.completed_at or nil,
	}
end

---Returns a list of all BestiaryEntryDef entries that the player has fully Mastered (Tier 3).
---@param player_or_name ObjectRef|string Player ObjectRef or player name
---@return BestiaryEntryDef[] mastered_entries
function storage.get_mastered_mobs(player_or_name)
	local data_mod = x_mobs.bestiary.data
	local entries = data_mod.get_all_entries()
	local state = storage.get_player_data(player_or_name)
	local mastered = {}

	for i = 1, #entries do
		local entry = entries[i]
		local rec = state and state.discovered[entry.id]
		local tier, max_t = storage.calculate_tier(entry, rec)
		if tier >= max_t and max_t > 0 then
			mastered[#mastered + 1] = entry
		end
	end

	return mastered
end

-- Lifecycle cache management hooks (Zero globalsteps)
core.register_on_joinplayer(function(player)
	storage.get_player_data(player)
end)

core.register_on_leaveplayer(function(player)
	local pname = player:get_player_name()
	storage.save_player_data(player)
	storage.players[pname] = nil
end)

core.register_on_shutdown(function()
	for pname in pairs(storage.players) do
		storage.save_player_data(pname)
	end
end)

return storage
