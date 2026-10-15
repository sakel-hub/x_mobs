--[[
	x_mobs - Bestiary & Hunter's Chronicle Subsystem: Event-Driven Discovery Hooks
	Subscribes to `x_mob_core.events` (`on_mob_target`, `on_mob_hurt`, `on_mob_death`,
	`on_mob_rightclick`) for 100% event-driven progression with ZERO globalsteps.

	Author: SaKeL
	License: MIT
]]

---@class BestiaryMobLuaEntity
---@field name string Technical entity identifier (e.g. "x_mobs:spider")
---@field object? ObjectRef Engine ObjectRef handle
---@field _killer? ObjectRef Last attacker recorded by x_mob_core
---@field _shooter? ObjectRef|string Projectile shooter reference
---@field _owner? ObjectRef|string Summoner or projectile owner reference
---@field owner? ObjectRef|string Alternative owner reference

---@class XMobsBestiaryEvents
local events = {}

---Extracts a valid player ObjectRef from an attacker reference (handles direct player or projectile owner).
---@param ref ObjectRef? Attacker or target ObjectRef
---@return ObjectRef? player
local function resolve_attacker_player(ref)
	if not ref then
		return nil
	end
	if core.is_player(ref) then
		return ref
	end
	local ent = ref:get_luaentity()
	if ent then
		local owner = ent._shooter or ent._owner or ent.owner
		if type(owner) == "string" then
			return core.get_player_by_name(owner)
		elseif core.is_player(owner) then
			return owner
		end
	end
	return nil
end

---Extracts the canonical mob_id from a mob luaentity table.
---@param mob_self BestiaryMobLuaEntity? Mob Lua entity instance
---@return string? mob_id
local function resolve_mob_id(mob_self)
	if type(mob_self) ~= "table" then
		return nil
	end
	local name = mob_self.name
	if type(name) == "string" and name ~= "" then
		-- Ensure dynamic registration if this is an x_mob_core mob not yet in registry
		if not x_mobs.bestiary.data.get_entry(name) then
			if x_mob_core and x_mob_core.registered_mobs and x_mob_core.registered_mobs[name] then
				x_mobs.bestiary.data.register_mob(name)
			else
				return nil
			end
		end
		return name
	end
	return nil
end

---Handles a peaceful Field Study when a player right-clicks an entity while wielding the Bestiary.
---@param player ObjectRef? Player performing the field study
---@param target_ref ObjectRef? Pointed entity ObjectRef
---@param itemstack ItemStack? Wielded Bestiary itemstack
---@return ItemStack? itemstack
function events.handle_field_study(player, target_ref, itemstack)
	if not core.is_player(player) then
		return itemstack
	end
	if not target_ref or core.is_player(target_ref) then
		x_mobs.bestiary.ui.open(player)
		return itemstack
	end

	local ent = target_ref:get_luaentity()
	local mob_id = resolve_mob_id(ent)
	if not mob_id then
		x_mobs.bestiary.ui.open(player)
		return itemstack
	end

	local advanced, new_tier = x_mobs.bestiary.storage.record_encounter(player, mob_id, 0)
	if advanced then
		x_mobs.bestiary.hud.show_unlock_toast(player, mob_id, new_tier, false)
	end

	-- Open Bestiary directly focused on the studied creature
	x_mobs.bestiary.ui.open(player, { selected_mob = mob_id })
	return itemstack
end

---Registers all event listeners on `x_mob_core.events`.
function events.init()
	if not x_mob_core or not x_mob_core.events then
		return
	end

	-- 1. Sighted Encounter: Mob acquires player as target during AI perception
	x_mob_core.events.listen("on_mob_target", function(mob_self, target, _old_target)
		local player = resolve_attacker_player(target)
		if not player then
			return
		end
		local mob_id = resolve_mob_id(mob_self)
		if not mob_id then
			return
		end
		local advanced, new_tier = x_mobs.bestiary.storage.record_encounter(player, mob_id, 0)
		if advanced then
			x_mobs.bestiary.hud.show_unlock_toast(player, mob_id, new_tier, false)
		end
	end)

	-- 2. Combat Engagement: Player deals damage to mob
	x_mob_core.events.listen("on_mob_hurt", function(mob_self, puncher, dmg)
		local player = resolve_attacker_player(puncher)
		if not player then
			return
		end
		local mob_id = resolve_mob_id(mob_self)
		if not mob_id then
			return
		end
		local advanced, new_tier = x_mobs.bestiary.storage.record_encounter(player, mob_id, tonumber(dmg) or 0)
		if advanced then
			x_mobs.bestiary.hud.show_unlock_toast(player, mob_id, new_tier, false)
		end
	end)

	-- 3. Vanquishing / Mastery: Player lands the killing blow on a mob
	x_mob_core.events.listen("on_mob_death", function(mob_self, killer)
		local player = resolve_attacker_player(killer or (mob_self and mob_self._killer))
		if not player then
			return
		end
		local mob_id = resolve_mob_id(mob_self)
		if not mob_id then
			return
		end
		local advanced, new_tier, _, newly_mastered_all = x_mobs.bestiary.storage.record_kill(player, mob_id)
		if advanced or newly_mastered_all then
			x_mobs.bestiary.hud.show_unlock_toast(player, mob_id, new_tier, newly_mastered_all)
		end
	end)

	-- 4. Direct Right-Click with Bestiary Book on Mob
	x_mob_core.events.listen("on_mob_rightclick", function(mob_self, clicker, itemstack)
		if not core.is_player(clicker) then
			return
		end
		local wielded = itemstack or clicker:get_wielded_item()
		if wielded and wielded:get_name() == "x_mobs:bestiary" then
			local mob_id = resolve_mob_id(mob_self)
			if mob_id then
				local advanced, new_tier = x_mobs.bestiary.storage.record_encounter(clicker, mob_id, 0)
				if advanced then
					x_mobs.bestiary.hud.show_unlock_toast(clicker, mob_id, new_tier, false)
				end
				x_mobs.bestiary.ui.open(clicker, { selected_mob = mob_id })
			end
		end
	end)
end

return events
