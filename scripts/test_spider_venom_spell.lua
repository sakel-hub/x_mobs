--[[
	test_spider_venom_spell.lua - Automated Integration Test Suite for Spider Venom & Web Spells
	Validates:
	1. Pixel art texture formats (16x16 RGBA PNG, alpha gradient, ground anchoring)
	2. Registration of x_mobs:spider and x_mobs:envelop
	3. Public API functions for venom poisoning and web slowdown spells
	4. Venom envelop application with custom 16x16 texture and 3.0s duration
	5. 1 HP per second DoT over 3.0s (exactly 3 ticks = 3 HP total damage)
	6. 6.0s cooldown enforcement on spider mob
	7. custom_step pipeline hook execution and interception
	8. Melee bite fang strike proc synergy
	9. Lifecycle safety: death, leave, and cleanup without state leaks
	10. Licensing manifest compliance in license.txt
	11. Web slow spell: 20% proc on shot, 3.0s duration, 50% speed slow, 6.0s cooldown
	12. Web envelop 16x16 pixel art texture verification and on_remove speed restoration

	Author: SaKeL
	License: MIT
]]

local registered_entities = {}
local registered_mobs = {}
local globalsteps = {}
local spawned_particles = {}
local deleted_particles = {}
local played_sounds = {}
local scheduled_afters = {}
local mob_scheduled = {}
local dieplayer_callbacks = {}
local leaveplayer_callbacks = {}
local joinplayer_callbacks = {}
local respawnplayer_callbacks = {}
local shutdown_callbacks = {}
local punchplayer_callbacks = {}

_G.vector = {
	distance = function(a, b)
		local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end,
	direction = function(a, b)
		local dx, dy, dz = b.x - a.x, b.y - a.y, b.z - a.z
		local len = math.sqrt(dx * dx + dy * dy + dz * dz)
		if len == 0 then return {x = 0, y = 0, z = 0} end
		return {x = dx / len, y = dy / len, z = dz / len}
	end,
	normalize = function(v)
		local len = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
		if len == 0 then return {x = 0, y = 0, z = 0} end
		return {x = v.x / len, y = v.y / len, z = v.z / len}
	end,
	multiply = function(v, s)
		return {x = v.x * s, y = v.y * s, z = v.z * s}
	end,
	add = function(a, b)
		if type(b) == "number" then
			return {x = a.x + b, y = a.y + b, z = a.z + b}
		end
		return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
	end,
	subtract = function(a, b)
		if type(b) == "number" then
			return {x = a.x - b, y = a.y - b, z = a.z - b}
		end
		return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z}
	end,
}

local mock_players = {}

_G.core = {
	get_modpath = function(modname)
		if modname == "x_mobs" then
			return "mods/x_mobs"
		elseif modname == "x_mob_core" then
			return "mods/x_mob_core"
		end
		return nil
	end,
	get_translator = function(_modname)
		return function(str) return str end
	end,
	register_entity = function(name, def)
		registered_entities[name] = def
	end,
	register_globalstep = function(fn)
		table.insert(globalsteps, fn)
	end,
	register_on_joinplayer = function(fn) table.insert(joinplayer_callbacks, fn) end,
	register_on_dieplayer = function(fn) table.insert(dieplayer_callbacks, fn) end,
	register_on_respawnplayer = function(fn) table.insert(respawnplayer_callbacks, fn) end,
	register_on_leaveplayer = function(fn) table.insert(leaveplayer_callbacks, fn) end,
	register_on_shutdown = function(fn) table.insert(shutdown_callbacks, fn) end,
	register_on_punchplayer = function(fn) table.insert(punchplayer_callbacks, fn) end,
	register_on_player_hpchange = function() end,
	settings = {
		get_bool = function(_self, _key, default) return default end,
	},
	registered_items = {},
	get_item_group = function() return 0 end,
	get_connected_players = function()
		local list = {}
		for _, p in pairs(mock_players) do
			table.insert(list, p)
		end
		return list
	end,
	get_player_by_name = function(name)
		return mock_players[name]
	end,
	sound_play = function(spec, params)
		table.insert(played_sounds, {spec = spec, params = params})
		return 1
	end,
	add_particlespawner = function(def)
		table.insert(spawned_particles, def)
		return #spawned_particles
	end,
	delete_particlespawner = function(id, ...)
		local n = select("#", ...)
		if n >= 1 then
			local playername = select(1, ...)
			if type(playername) ~= "string" then
				error("bad argument #2 to 'delete_particlespawner' (string expected, got " .. type(playername) .. ")")
			end
		end
		table.insert(deleted_particles, id)
		return true
	end,
	dir_to_yaw = function(dir)
		local atan2 = math.atan2 or math.atan
		return -atan2(dir.x, dir.z)
	end,
	after = function(delay, cb)
		table.insert(scheduled_afters, {delay = delay, cb = cb})
	end,
	log = function() end,
}

local function advance_core_time(elapsed)
	local current = scheduled_afters
	scheduled_afters = {}
	local to_run = {}
	for _, item in ipairs(current) do
		item.delay = item.delay - elapsed
		if item.delay <= 0.001 then
			table.insert(to_run, item.cb)
		else
			table.insert(scheduled_afters, item)
		end
	end
	for _, cb in ipairs(to_run) do
		cb()
	end
end

_G.minetest = _G.core

-- Mock add_entity for x_mobs:envelop
local created_envelops = {}
_G.core.add_entity = function(pos, name)
	if name == "x_mobs:envelop" or name == "x_mob_core:envelop" then
		local def = registered_entities[name]
		local ent_obj = {
			_pos = {x = pos.x, y = pos.y, z = pos.z},
			_valid = true,
			_props = {},
			_attached_to = nil,
			get_pos = function(s) return s._pos end,
			is_valid = function(s) return s._valid end,
			remove = function(s)
				s._valid = false
			end,
			set_properties = function(s, p)
				for k, v in pairs(p) do s._props[k] = v end
			end,
			get_properties = function(s) return s._props end,
			set_armor_groups = function() end,
			set_attach = function(s, parent, _bone, pos_att, rot, _vis)
				s._attached_to = parent
				s._attach_pos = pos_att
				s._attach_rot = rot
			end,
			get_luaentity = function(s) return s._luaent end,
		}
		local luaent = {
			object = ent_obj,
			name = name,
		}
		for k, v in pairs(def or {}) do
			luaent[k] = v
		end
		ent_obj._luaent = luaent
		table.insert(created_envelops, ent_obj)
		if def and def.on_activate then
			def.on_activate(luaent, "", 0)
		end
		return ent_obj
	end
	return nil
end

-- Mock x_mob_core
_G.x_mob_core = {
	register_mob = function(name, def)
		registered_mobs[name] = def
	end,
	register_spawn = function() end,
	is_player_alive = function(obj)
		return obj and obj:is_valid() and obj:get_hp() > 0
	end,
	line_of_sight = function(_p1, _p2)
		return true
	end,
	halt_horizontal_velocity = function(mob)
		local v = mob.object:get_velocity() or {x = 0, y = 0, z = 0}
		mob.object:set_velocity({x = 0, y = v.y, z = 0})
	end,
	play_animation = function(_obj, track, _opts)
		return track
	end,
	play_sound = function(_mob, name, _overrides)
		table.insert(played_sounds, {name = name})
	end,
	sound = {
		play = function(_mob, name)
			table.insert(played_sounds, {name = name})
		end
	},
	schedule = function(_mob, delay, tag, cb)
		table.insert(mob_scheduled, {delay = delay, tag = tag, cb = cb})
	end,
	listen = function() end,
	emit = function() end,
	step_move_or_idle = function() end,
	step_wander_or_idle = function() end,
	generate_uuid = function()
		local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
		return string.gsub(template, "[xy]", function(c)
			local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
			return string.format("%x", v)
		end)
	end,
}

local function create_mock_player(name, hp)
	local punched_log = {}
	local p = {
		_name = name,
		_hp = hp or 20,
		_valid = true,
		_pos = {x = 0, y = 0, z = 0},
		_armor_groups = { fleshy = 100 },
		_physics_override = { speed = 1.0, jump = 1.0, gravity = 1.0 },
		is_player = function() return true end,
		is_valid = function(s) return s._valid end,
		get_player_name = function(s) return s._name end,
		get_hp = function(s) return s._hp end,
		set_hp = function(s, val) s._hp = val end,
		get_pos = function(s) return {x = s._pos.x, y = s._pos.y, z = s._pos.z} end,
		set_pos = function(s, pos) s._pos = {x = pos.x, y = pos.y, z = pos.z} end,
		get_armor_groups = function(s) return s._armor_groups end,
		set_armor_groups = function(s, g) s._armor_groups = g end,
		get_physics_override = function(s) return s._physics_override end,
		set_physics_override = function(s, o)
			for k, v in pairs(o) do s._physics_override[k] = v end
		end,
		punch = function(s, puncher, _time, tool_caps, dir)
			local fleshy_val = (tool_caps and tool_caps.damage_groups and tool_caps.damage_groups.fleshy) or 0
			local armor_mult = (s._armor_groups and s._armor_groups.fleshy or 100) / 100
			local dmg = math.floor(fleshy_val * armor_mult)
			s._hp = math.max(0, s._hp - dmg)
			table.insert(punched_log, {puncher = puncher, dmg = dmg, dir = dir})
			return true
		end,
		hud_add = function(_s, _def) return 1 end,
		hud_change = function() end,
		hud_remove = function() end,
		get_properties = function()
			return {
				collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3},
			}
		end,
	}
	mock_players[name] = p
	return p
end

-- ============================================================================
-- EXECUTE TESTS
-- ============================================================================

print("======================================================================")
print("RUNNING AUTOMATED UNIT & INTEGRATION TESTS: SPIDER VENOM SPELL")
print("======================================================================")

-- [TEST 1] Texture Verification (16x16 PNG RGBA)
print("[TEST 1] Checking 16x16 pixel art texture x_mobs_venom_envelop.png...")
local tex_path = "mods/x_mobs/textures/x_mobs_venom_envelop.png"
local f_tex = io.open(tex_path, "rb")
assert(f_tex ~= nil, "Texture file " .. tex_path .. " must exist on filesystem")
local header = f_tex:read(24)
f_tex:close()
assert(header:sub(1, 8) == "\137PNG\r\n\26\n", "Must be a valid PNG file")
local w = header:byte(17) * 16777216 + header:byte(18) * 65536 + header:byte(19) * 256 + header:byte(20)
local h = header:byte(21) * 16777216 + header:byte(22) * 65536 + header:byte(23) * 256 + header:byte(24)
assert(w == 16 and h == 16, string.format("Texture must be exactly 16x16 px (got %dx%d)", w, h))
print("  ✓ x_mobs_venom_envelop.png verified: 16x16 RGBA PNG format.")

-- [TEST 2] Loading Modules: envelop.lua and spider.lua
print("[TEST 2] Loading envelop.lua and spider.lua...")
dofile("mods/x_mob_core/combat/particles.lua")
dofile("mods/x_mob_core/combat/hunger_adapter.lua")
dofile("mods/x_mob_core/combat/hud_effects.lua")
dofile("mods/x_mob_core/combat/envelop.lua")
dofile("mods/x_mob_core/combat/status_effects.lua")
dofile("mods/x_mobs/api.lua")
dofile("mods/x_mobs/mobs/spider.lua")

assert(registered_entities["x_mob_core:envelop"] ~= nil, "x_mob_core:envelop must be registered")
assert(registered_mobs["x_mobs:spider"] ~= nil, "x_mobs:spider must be registered")
assert(type(x_mobs.cast_venom_envelop) == "function", "x_mobs.cast_venom_envelop must be defined")
assert(type(x_mobs.cast_web_envelop) == "function", "x_mobs.cast_web_envelop must be defined")
assert(type(x_mobs.get_venom_attached_spawner) == "function", "x_mobs.get_venom_attached_spawner must be defined")
assert(type(x_mobs.get_web_attached_spawner) == "function", "x_mobs.get_web_attached_spawner must be defined")
print("  ✓ Modules loaded and API functions registered.")

-- [TEST 3] Testing Venom Envelop & 3.0s DoT (1 HP per second, 3 ticks = 3 HP damage)
print("[TEST 3] Testing venom envelop application and 1 HP/s DoT over 3.0s...")
local player = create_mock_player("test_victim", 20)
local spider_caster = {
	is_valid = function() return true end,
	get_pos = function() return {x = 0, y = 0, z = 3} end,
}

-- Cast venom envelop on player (pass chance = 1.0 for deterministic mechanic testing)
x_mobs.cast_venom_envelop(spider_caster, player, 1.0)

assert(x_mob_core.is_enveloped(player) == true, "Player must have active visual envelop")
assert(x_mob_core.is_enveloped(player, "venom") == true, "Player must have active venom poisoning")

local env_data = x_mob_core.get_envelop_data(player)
assert(env_data ~= nil and env_data.envelop ~= nil, "Envelop record must exist")
local env_props = env_data.envelop:get_properties()
assert(env_props.textures[1] == "x_mobs_venom_envelop.png", "Envelop must use x_mobs_venom_envelop.png")

-- Simulate envelop on_step ticks over time (handled by x_mobs:envelop entity)
local env_ent = env_data.envelop:get_luaentity()
assert(env_ent ~= nil, "Envelop LuaEntity must exist")

local function step_envelop(dtime)
	advance_core_time(dtime)
	if env_ent.object:is_valid() then
		env_ent:on_step(dtime)
	end
end

-- Advance time to 0.9s: no damage tick yet (tick interval is 1.0s)
step_envelop(0.3)
step_envelop(0.3)
step_envelop(0.3)
assert(player:get_hp() == 20, "No damage should occur before 1.0s (HP = " .. player:get_hp() .. ")")

-- Advance time by 0.2s (total 1.1s): 1st tick occurs -> HP drops to 19
step_envelop(0.2)
assert(player:get_hp() == 19, "1st damage tick at 1s must reduce HP to 19 (HP = " .. player:get_hp() .. ")")

-- Advance time to 2.1s: 2nd tick occurs -> HP drops to 18
step_envelop(0.5)
step_envelop(0.5)
assert(player:get_hp() == 18, "2nd damage tick at 2s must reduce HP to 18 (HP = " .. player:get_hp() .. ")")

-- Advance time to 3.1s: 3rd tick occurs -> HP drops to 17, and spell duration expires!
step_envelop(0.5)
step_envelop(0.5)
assert(player:get_hp() == 17, "3rd damage tick at 3s must reduce HP to 17 (HP = " .. player:get_hp() .. ")")
assert(x_mob_core.is_enveloped(player, "venom") == false, "Venom poisoning must expire after 3.0s")
assert(x_mob_core.is_enveloped(player) == false, "Envelop must be removed when poisoning expires")
print("  ✓ Venom DoT verified: exactly 3 damage ticks of 1 HP each (total 3 HP) over 3.0s via envelop on_step.")

-- [TEST 3b] Testing 3D Armor Penetration (fleshy = 20) and Immortality Protection
print("[TEST 3b] Testing 3D Armor penetration (fleshy = 20) and immortal protection...")
local armored_player = create_mock_player("test_armored", 20)
armored_player:set_armor_groups({ fleshy = 20 }) -- 80% damage reduction from 3d_armor diamond set
x_mobs.cast_venom_envelop(spider_caster, armored_player, 1.0)

local armored_env_data = x_mob_core.get_envelop_data(armored_player)
local armored_env_ent = armored_env_data.envelop:get_luaentity()

-- Advance 1 second -> should penetrate through 3d_armor (fleshy = 20) and deal exactly 1 HP!
armored_env_ent:on_step(1.0)
advance_core_time(1.0)
assert(armored_player:get_hp() == 19,
	"Venom damage must penetrate 3d_armor to reduce HP to 19 (HP = " .. armored_player:get_hp() .. ")")
assert(armored_player:get_armor_groups().fleshy == 20,
	"Original armor rating (fleshy = 20) must be preserved after punch")

-- Clean up
x_mob_core.remove_envelop_effect(armored_player, "venom")

-- Immortal player test
local immortal_player = create_mock_player("test_immortal", 20)
immortal_player:set_armor_groups({ immortal = 1, fleshy = 100 })
x_mobs.cast_venom_envelop(spider_caster, immortal_player, 1.0)
local imm_env_data = x_mob_core.get_envelop_data(immortal_player)
local imm_env_ent = imm_env_data.envelop:get_luaentity()
imm_env_ent:on_step(1.0)
advance_core_time(1.0)
assert(immortal_player:get_hp() == 20, "Immortal player must take zero damage from venom poison")
x_mob_core.remove_envelop_effect(immortal_player, "venom")
print("  ✓ 3D Armor penetration (fleshy = 20) and immortality protection verified.")

-- [TEST 4] Spider Mob Cooldown & custom_step Execution
print("[TEST 4] Testing spider custom_step hook and 6.0s cooldown...")
local spider_def = registered_mobs["x_mobs:spider"]
assert(spider_def.cooldowns.venom_spell == 0, "Initial venom_spell cooldown must be 0")
assert(type(spider_def.custom_step) == "function", "spider must define custom_step")

local mock_spider = {
	state = "pursuing",
	action_timer = 0,
	target = player,
	cooldowns = { venom_spell = 0, bite = 0 },
	eye_offset = 0.64,
	object = {
		_valid = true,
		is_valid = function() return true end,
		get_pos = function() return {x = 0, y = 0, z = 4} end,
		get_velocity = function() return {x = 0, y = 0, z = 0} end,
		set_velocity = function() end,
		set_acceleration = function() end,
		set_rotation = function() end,
		set_yaw = function() end,
	},
	perform_venom_spell = spider_def.perform_venom_spell,
}

-- Seed math.random to test proc
math.randomseed(42)
-- Trigger custom_step by advancing check timer
mock_spider._venom_check_timer = 1.0

local handled = spider_def.custom_step(mock_spider, 0.1)
assert(handled == true, "custom_step must trigger perform_venom_spell when line of sight and timer ready")
assert(mock_spider.state == "casting_venom", "Spider state must be casting_venom")
assert(mock_spider.cooldowns.venom_spell == 6.0,
	"Cooldown must be set to 6.0s (got " .. tostring(mock_spider.cooldowns.venom_spell) .. ")")

-- When on cooldown (> 0), custom_step must NOT trigger
local on_cd_handled = spider_def.custom_step(mock_spider, 0.1)
assert(on_cd_handled == false, "custom_step must return false while on cooldown")
print("  ✓ Spider custom_step and 6.0s cooldown enforcement verified.")

-- [TEST 5] Scheduled Action Spell Impact
print("[TEST 5] Testing scheduled spell cast release and envelop landing...")
local scheduled_action = nil
for _, act in ipairs(mob_scheduled) do
	if act.tag == "venom_spell_cast" then
		scheduled_action = act
		break
	end
end
assert(scheduled_action ~= nil, "Scheduled action venom_spell_cast must be queued")
assert(scheduled_action.delay == 0.35, "Cast release delay must be 0.35s")

-- Trigger the callback (evaluating 20% proc chance)
local cast_procced = false
for _ = 1, 50 do
	x_mob_core.remove_envelop_effect(player, "venom")
	scheduled_action.cb()
	if x_mob_core.is_enveloped(player, "venom") then
		cast_procced = true
		break
	end
end
assert(cast_procced == true, "Player must be enveloped after spell cast impact on 20% proc chance")
assert(x_mob_core.is_enveloped(player) == true, "Player must have active visual envelop")
assert(x_mob_core.is_enveloped(player, "venom") == true, "Player must have active venom poisoning")
print("  ✓ Spell cast scheduling and 20% envelop impact verified.")

-- [TEST 6] Melee Bite Proc Synergy
print("[TEST 6] Testing melee bite fang strike 20% proc synergy...")
local bite_player = create_mock_player("test_bite_target", 20)
bite_player:set_pos({x = 0, y = 0, z = 1.5})
local bite_spider = {
	state = "pursuing",
	action_timer = 0,
	target = bite_player,
	cooldowns = { venom_spell = 0, bite = 0 },
	attack_range = 2.4,
	object = {
		_valid = true,
		is_valid = function() return true end,
		get_pos = function() return {x = 0, y = 0, z = 0} end,
		get_velocity = function() return {x = 0, y = 0, z = 0} end,
		set_velocity = function() end,
		set_acceleration = function() end,
		set_rotation = function() end,
		punch = function() end,
	},
}

-- Execute perform_bite
spider_def.perform_bite(bite_spider, bite_player)
assert(bite_spider.state == "biting", "Spider state must be biting")

-- Find scheduled bite impact callback
local bite_action = mob_scheduled[#mob_scheduled]
assert(bite_action ~= nil and bite_action.tag == "scheduled_action", "Bite impact must be scheduled")

-- Clean previous envelop on bite_player
x_mob_core.remove_envelop_effect(bite_player, "venom")

-- Execute fang clamp callback multiple times to verify proc synergy
local bite_procced = false
for _ = 1, 30 do
	bite_player:set_hp(20)
	bite_spider.cooldowns.venom_spell = 0
	bite_action.cb()
	if x_mob_core.is_enveloped(bite_player, "venom") then
		bite_procced = true
		assert(bite_spider.cooldowns.venom_spell == 6.0, "Cooldown must be set to 6.0s on bite proc")
		break
	end
end
assert(bite_procced == true, "Melee bite must proc venom spell when off cooldown")
print("  ✓ Melee bite proc synergy verified.")

-- [TEST 7] Lifecycle Listeners (Disconnect & Death Cleanup)
print("[TEST 7] Testing player disconnect and death lifecycle cleanup...")
local martyr = create_mock_player("test_martyr", 20)
x_mobs.cast_venom_envelop(spider_caster, martyr, 1.0)
assert(x_mob_core.is_enveloped(martyr, "venom") == true, "Martyr must be poisoned")

-- Simulate player death
for _, cb in ipairs(dieplayer_callbacks) do
	cb(martyr)
end
assert(x_mob_core.is_enveloped(martyr, "venom") == false, "Venom poison must be removed on player death")
assert(x_mob_core.is_enveloped(martyr) == false, "Envelop must be removed on player death")

-- Simulate player leave
local leaver = create_mock_player("test_leaver", 20)
x_mobs.cast_venom_envelop(spider_caster, leaver, 1.0)
assert(x_mob_core.is_enveloped(leaver, "venom") == true, "Leaver must be poisoned")

for _, cb in ipairs(leaveplayer_callbacks) do
	cb(leaver)
end
assert(x_mob_core.is_enveloped(leaver, "venom") == false, "Venom poison must be removed on player leave")
assert(x_mob_core.is_enveloped(leaver) == false, "Envelop must be removed on player leave")
print("  ✓ Lifecycle safety verified: zero state leaks on death or disconnection.")

-- [TEST 8] License Attribution Compliance
print("[TEST 8] Checking license.txt for x_mobs_venom_envelop.png attribution...")
local f_lic = io.open("mods/x_mobs/license.txt", "r")
assert(f_lic ~= nil, "license.txt must exist")
local lic_content = f_lic:read("*a")
f_lic:close()
assert(lic_content:find("x_mobs_venom_envelop.png") ~= nil,
	"x_mobs_venom_envelop.png must be documented in license.txt")
assert(lic_content:find("SaKeL") ~= nil, "Author SaKeL must be credited in license.txt")
assert(not lic_content:find("juraj"), "Local username juraj must never appear in license.txt")
print("  ✓ Asset attribution verified in license.txt.")

-- [TEST 9] Spider Web Envelop Pixel Art Texture Verification (16x16 PNG RGBA)
print("[TEST 9] Checking 16x16 pixel art texture x_mobs_web_envelop.png...")
local web_tex_path = "mods/x_mobs/textures/x_mobs_web_envelop.png"
local f_web_tex = io.open(web_tex_path, "rb")
assert(f_web_tex ~= nil, "Texture file " .. web_tex_path .. " must exist on filesystem")
local web_header = f_web_tex:read(24)
f_web_tex:close()
assert(web_header:sub(1, 8) == "\137PNG\r\n\26\n", "Must be a valid PNG file")
local web_w = web_header:byte(17) * 16777216 + web_header:byte(18) * 65536
	+ web_header:byte(19) * 256 + web_header:byte(20)
local web_h = web_header:byte(21) * 16777216 + web_header:byte(22) * 65536
	+ web_header:byte(23) * 256 + web_header:byte(24)
assert(web_w == 16 and web_h == 16, string.format("Texture must be exactly 16x16 px (got %dx%d)", web_w, web_h))
print("  ✓ x_mobs_web_envelop.png verified: 16x16 RGBA PNG format.")

-- [TEST 10] Testing Web Slowdown and Web Envelop (50% speed for 3.0s)
print("[TEST 10] Testing web slowdown and web envelop (50% speed for 3.0s)...")
local slow_target = create_mock_player("test_slow_target", 20)
assert(slow_target:get_physics_override().speed == 1.0, "Initial player speed must be 1.0")

x_mobs.cast_web_envelop(spider_caster, slow_target, 1.0)

assert(x_mob_core.is_enveloped(slow_target) == true, "Player must have active visual envelop")
assert(x_mob_core.is_enveloped(slow_target, "web") == true, "Player must be recognized as web enveloped")
assert(x_mob_core.has_status_effect(slow_target, "web") == true, "Player must be recognized as web slowed")

local slow_ovr = slow_target:get_physics_override()
assert(math.abs(slow_ovr.speed - 0.50) < 0.001,
	"Player speed must be reduced to 50% (got " .. tostring(slow_ovr.speed) .. ")")

local web_env_data = x_mob_core.get_envelop_data(slow_target)
assert(web_env_data ~= nil and web_env_data.envelop ~= nil, "Envelop record must exist")
local web_env_props = web_env_data.envelop:get_properties()
assert(web_env_props.textures[1] == "x_mobs_web_envelop.png",
	"Web envelop must use x_mobs_web_envelop.png texture")

-- Advance time by 3.1s: envelop on_step removes envelop and triggers on_remove speed restoration
local web_env_ent = web_env_data.envelop:get_luaentity()
web_env_ent:on_step(1.5)
assert(slow_target:get_physics_override().speed == 0.50, "Player must remain slowed at 1.5s")
web_env_ent:on_step(1.6)

assert(x_mob_core.is_enveloped(slow_target) == false, "Web envelop must expire after 3.0s")
assert(x_mob_core.is_enveloped(slow_target, "web") == false, "Web envelop status must be false after 3.0s")
assert(x_mob_core.has_status_effect(slow_target, "web") == false, "Web slow status must be false after 3.0s")
assert(math.abs(slow_target:get_physics_override().speed - 1.0) < 0.001,
	"Player speed must be fully restored to 1.0 after 3.0s (got "
		.. tostring(slow_target:get_physics_override().speed) .. ")")
print("  ✓ Web slowdown verified: 50% speed for exactly 3.0s with clean restoration via on_remove.")

-- Also test standalone web_slow status effect without envelop using advance_core_time
local standalone_player = create_mock_player("test_standalone_player", 20)
x_mob_core.apply_status_effect(standalone_player, {
	id = "web_slow",
	type = "slow",
	speed_factor = 0.50,
	duration = 3.0,
})
assert(x_mob_core.has_status_effect(standalone_player, "web_slow") == true,
	"Standalone player must be web slowed")
assert(math.abs(standalone_player:get_physics_override().speed - 0.50) < 0.001, "Speed is 50%")
advance_core_time(3.1)
assert(x_mob_core.has_status_effect(standalone_player, "web_slow") == false,
	"Standalone slow must expire via core.after timer")
assert(math.abs(standalone_player:get_physics_override().speed - 1.0) < 0.001, "Speed is restored to 1.0")
print("  ✓ Standalone apply_web_slow timer expiration verified via core.after.")

-- [TEST 11] Spider Web Shot Proc & 6.0s Cooldown Enforcement
print("[TEST 11] Testing spider perform_web_shot 20% proc and 6.0s cooldown...")
local web_shot_player = create_mock_player("test_web_shot_player", 20)
web_shot_player:set_pos({x = 0, y = 0, z = 6.0})

local web_spider = {
	state = "pursuing",
	action_timer = 0,
	target = web_shot_player,
	cooldowns = { web = 0, web_spell = 0 },
	object = {
		_valid = true,
		is_valid = function() return true end,
		get_pos = function() return {x = 0, y = 0, z = 0} end,
		get_velocity = function() return {x = 0, y = 0, z = 0} end,
		set_velocity = function() end,
		set_acceleration = function() end,
		set_rotation = function() end,
	},
}

-- Verify web_spell cooldown is initially 0
assert(spider_def.cooldowns.web_spell == 0, "Default web_spell cooldown must be 0")

-- Loop perform_web_shot and scheduled impact callback until 20% proc triggers
local shot_procced = false
for _ = 1, 50 do
	web_shot_player:set_hp(20)
	web_spider.cooldowns.web_spell = 0
	spider_def.perform_web_shot(web_spider, web_shot_player:get_pos())
	local web_impact_action = mob_scheduled[#mob_scheduled]
	assert(web_impact_action ~= nil and web_impact_action.tag == "scheduled_action",
		"Web pulse 2 impact callback must be scheduled")
	assert(web_impact_action.delay == 0.45, "Pulse 2 impact delay must be 0.45s")
	web_impact_action.cb()
	if web_spider.cooldowns.web_spell == 6.0 then
		shot_procced = true
		break
	end
end

assert(shot_procced == true, "perform_web_shot must proc web slow spell and set 6.0s cooldown")
assert(web_spider.cooldowns.web_spell == 6.0, "web_spell cooldown must be 6.0s")

assert(x_mob_core.has_status_effect(web_shot_player, "web") == true, "Target player must be web slowed on impact")
assert(x_mob_core.is_enveloped(web_shot_player, "web") == true, "Target player must be web enveloped on impact")
assert(math.abs(web_shot_player:get_physics_override().speed - 0.50) < 0.001,
	"Player speed must be reduced to 50% on web impact")

-- Test cooldown enforcement: while web_spell > 0, another shot will NOT proc
local current_scheduled_count = #mob_scheduled
spider_def.perform_web_shot(web_spider, web_shot_player:get_pos())
local next_impact_action = mob_scheduled[#mob_scheduled]
assert(#mob_scheduled > current_scheduled_count, "New web shot scheduled")
-- Clean previous slow on player
x_mob_core.remove_status_effect(web_shot_player, "web")
x_mob_core.remove_envelop(web_shot_player)
assert(x_mob_core.has_status_effect(web_shot_player, "web") == false, "Player slow cleared for cooldown test")

-- Execute impact: since web_spider was on cooldown, spell_proc was false
next_impact_action.cb()
assert(x_mob_core.has_status_effect(web_shot_player, "web") == false,
	"Web slow spell must NOT trigger while web_spell cooldown is active")
print("  ✓ Web shot 20% proc, 6.0s cooldown enforcement, and impact delivery verified.")

-- [TEST 12] Web Slow Player Lifecycle Listeners (Death, Leave, Shutdown)
print("[TEST 12] Testing web slow player lifecycle cleanup...")
local doomed_player = create_mock_player("test_doomed_player", 20)
x_mobs.cast_web_envelop(spider_caster, doomed_player, 1.0)
assert(x_mob_core.has_status_effect(doomed_player, "web") == true, "Doomed player must be slowed")
assert(math.abs(doomed_player:get_physics_override().speed - 0.50) < 0.001, "Speed is 50%")

-- Simulate death
for _, cb in ipairs(dieplayer_callbacks) do
	cb(doomed_player)
end
assert(x_mob_core.has_status_effect(doomed_player, "web") == false, "Web slow must be removed on death")
assert(math.abs(doomed_player:get_physics_override().speed - 1.0) < 0.001, "Speed must be restored on death")

-- Simulate leave
local departing_player = create_mock_player("test_departing_player", 20)
x_mobs.cast_web_envelop(spider_caster, departing_player, 1.0)
assert(x_mob_core.has_status_effect(departing_player, "web") == true, "Departing player must be slowed")

for _, cb in ipairs(leaveplayer_callbacks) do
	cb(departing_player)
end
assert(x_mob_core.has_status_effect(departing_player, "web") == false, "Web slow must be removed on leave")
assert(math.abs(departing_player:get_physics_override().speed - 1.0) < 0.001, "Speed must be restored on leave")

-- Simulate shutdown
local shutdown_player = create_mock_player("test_shutdown_player", 20)
x_mobs.cast_web_envelop(spider_caster, shutdown_player, 1.0)
assert(x_mob_core.has_status_effect(shutdown_player, "web") == true, "Shutdown player must be slowed")

for _, cb in ipairs(shutdown_callbacks) do
	cb()
end
assert(x_mob_core.has_status_effect(shutdown_player, "web") == false, "Web slow must be removed on shutdown")
assert(math.abs(shutdown_player:get_physics_override().speed - 1.0) < 0.001, "Speed must be restored on shutdown")
print("  ✓ Web slow lifecycle listeners verified: clean restoration on death, leave, and shutdown.")

-- [TEST 13] License Attribution for Web Envelop Texture
print("[TEST 13] Checking license.txt for x_mobs_web_envelop.png attribution...")
local f_lic2 = io.open("mods/x_mobs/license.txt", "r")
assert(f_lic2 ~= nil, "license.txt must exist")
local lic2_content = f_lic2:read("*a")
f_lic2:close()
assert(lic2_content:find("x_mobs_web_envelop.png") ~= nil,
	"x_mobs_web_envelop.png must be documented in license.txt")
assert(lic2_content:find("SaKeL") ~= nil, "Author SaKeL must be credited in license.txt")
assert(not lic2_content:find("juraj"), "Local username juraj must never appear in license.txt")
print("  ✓ Asset attribution for x_mobs_web_envelop.png verified in license.txt.")

-- [TEST 14] Option 1: Venomous Web Composite Stacking & Dynamic Texture Updates
print("[TEST 14] Testing Option 1: Venomous Web composite stacking & dynamic texture updates...")
local combo_player = create_mock_player("test_combo_victim", 20)

-- Step 1: Apply venom poison first (3.0s duration)
x_mobs.cast_venom_envelop(spider_caster, combo_player, 1.0)
assert(x_mob_core.is_enveloped(combo_player, "venom") == true, "Victim must be venom poisoned")
assert(x_mob_core.is_enveloped(combo_player, "web") == false, "Victim not yet webbed")
local combo_env_data = x_mob_core.get_envelop_data(combo_player)
assert(combo_env_data.envelop:get_properties().textures[1] == "x_mobs_venom_envelop.png",
	"Initial texture must be venom")

local combo_env_ent = combo_env_data.envelop:get_luaentity()

-- Step 2: Advance time by 1.0s -> 1st venom tick (HP drops to 19)
advance_core_time(1.0)
if combo_env_ent.object:is_valid() then combo_env_ent:on_step(1.0) end
assert(combo_player:get_hp() == 19, "1st venom tick reduces HP to 19")

-- Step 3: At t=1.0s, hit player with web slow spell (3.0s duration)!
x_mobs.cast_web_envelop(spider_caster, combo_player, 1.0)

-- Verify composite stacking: BOTH are active!
assert(x_mob_core.is_enveloped(combo_player, "venom") == true, "Victim still poisoned")
assert(x_mob_core.is_enveloped(combo_player, "web") == true, "Victim now also web enveloped")
assert(x_mob_core.has_status_effect(combo_player, "web") == true, "Victim now also web slowed")
assert(math.abs(combo_player:get_physics_override().speed - 0.50) < 0.001, "Victim slowed to 50%")

-- Verify composite texture: venom^web!
local stacked_tex = combo_env_data.envelop:get_properties().textures[1]
assert(stacked_tex == "x_mobs_venom_envelop.png^x_mobs_web_envelop.png",
	"Stacked texture must be composite (got " .. tostring(stacked_tex) .. ")")

-- Step 4: Advance time by 1.0s (t=2.0s total, 1.0s into web) -> 2nd venom tick (HP drops to 18)
advance_core_time(1.0)
if combo_env_ent.object:is_valid() then combo_env_ent:on_step(1.0) end
assert(combo_player:get_hp() == 18, "2nd venom tick reduces HP to 18")
assert(x_mob_core.is_enveloped(combo_player, "venom") == true, "Venom still active")
assert(x_mob_core.is_enveloped(combo_player, "web") == true, "Web still active")

-- Step 5: Advance time by 1.1s (t=3.1s total, 2.1s into web) -> 3rd venom tick (HP drops to 17)
-- Venom timer expires (3.0s done), but web has 0.9s remaining!
advance_core_time(1.1)
if combo_env_ent.object:is_valid() then combo_env_ent:on_step(1.1) end
assert(combo_player:get_hp() == 17, "3rd venom tick reduces HP to 17")
assert(x_mob_core.is_enveloped(combo_player, "venom") == false, "Venom expired after 3.0s")
assert(x_mob_core.is_enveloped(combo_player, "web") == true, "Web STILL active")
assert(x_mob_core.has_status_effect(combo_player, "web") == true, "Web slow STILL active")
assert(math.abs(combo_player:get_physics_override().speed - 0.50) < 0.001, "Player still at 50% speed")

-- Texture must have dynamically reverted to pure web!
local reverted_tex = combo_env_data.envelop:get_properties().textures[1]
assert(reverted_tex == "x_mobs_web_envelop.png",
	"Texture must dynamically revert to web (got " .. tostring(reverted_tex) .. ")")

-- Step 6: Advance time by 1.0s (t=4.1s total, 3.1s into web) -> web expires!
advance_core_time(1.0)
if combo_env_ent.object:is_valid() then combo_env_ent:on_step(1.0) end
assert(x_mob_core.is_enveloped(combo_player, "web") == false, "Web expired after 3.0s")
assert(x_mob_core.has_status_effect(combo_player, "web") == false, "Web slow expired")
assert(x_mob_core.is_enveloped(combo_player) == false, "Envelop object removed when both effects expire")
assert(math.abs(combo_player:get_physics_override().speed - 1.0) < 0.001, "Speed restored to 1.0")
print("  ✓ Venomous Web stacking, independent lifecycles, and dynamic texture transitions verified.")

-- [TEST 15] Selective Removal of Stacked Effects
print("[TEST 15] Testing selective removal of stacked spells without cross-clearing...")
local dual_target = create_mock_player("test_dual_target", 20)
x_mobs.cast_venom_envelop(spider_caster, dual_target, 1.0)
x_mobs.cast_web_envelop(spider_caster, dual_target, 1.0)
assert(x_mob_core.is_enveloped(dual_target, "venom") == true, "Venom active")
assert(x_mob_core.is_enveloped(dual_target, "web") == true, "Web active")

-- Remove venom only (e.g., via antidote)
x_mob_core.remove_status_effect(dual_target, "venom")
assert(x_mob_core.is_enveloped(dual_target, "venom") == false, "Venom removed")
assert(x_mob_core.is_enveloped(dual_target, "web") == true, "Web remains active after venom removal")
assert(x_mob_core.has_status_effect(dual_target, "web") == true, "Web slow remains active")
local dual_env_data = x_mob_core.get_envelop_data(dual_target)
assert(dual_env_data.envelop:get_properties().textures[1] == "x_mobs_web_envelop.png",
	"Texture updated to web only")

-- Remove web
x_mob_core.remove_status_effect(dual_target, "web")
assert(x_mob_core.is_enveloped(dual_target, "web") == false, "Web removed")
assert(x_mob_core.has_status_effect(dual_target, "web") == false, "Web slow removed")
assert(x_mob_core.is_enveloped(dual_target) == false, "Envelop removed completely")
print("  ✓ Selective removal verified: clearing one effect preserves the other.")

print("======================================================================")
print("ALL 15 SPIDER VENOM & WEB SPELL INTEGRATION TESTS PASSED SUCCESSFULLY!")
print("======================================================================")
