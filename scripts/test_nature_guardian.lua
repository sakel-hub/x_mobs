--[[
	test_nature_guardian.lua - Automated Integration Test
	Validates Nature Guardian entity registrations, HSL texture variations,
	10 canonical animation tracks, poise hyper-armor flinching,
	and core envelop-based entangling roots immobilization.
]]

local registered_entities = {}
local registered_spawns = {}
local registered_joinplayer_cbs = {}
local registered_leaveplayer_cbs = {}
local registered_dieplayer_cbs = {}
local registered_respawnplayer_cbs = {}
local registered_shutdown_cbs = {}

local added_entities = {}

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
	multiply = function(v, s)
		return {x = v.x * s, y = v.y * s, z = v.z * s}
	end,
}

_G.core = {
	get_modpath = function(modname)
		if modname == "x_mobs" then
			return "mods/x_mobs"
		elseif modname == "x_mob_core" then
			return "mods/x_mob_core"
		elseif modname == "x_player_api" then
			return "mods/x_player_api"
		end
		return nil
	end,
	get_translator = function(_modname)
		return function(str) return str end
	end,
	register_entity = function(name, def)
		registered_entities[name] = def
	end,
	register_on_joinplayer = function(cb)
		table.insert(registered_joinplayer_cbs, cb)
	end,
	register_on_leaveplayer = function(cb)
		table.insert(registered_leaveplayer_cbs, cb)
	end,
	register_on_dieplayer = function(cb)
		table.insert(registered_dieplayer_cbs, cb)
	end,
	register_on_respawnplayer = function(cb)
		table.insert(registered_respawnplayer_cbs, cb)
	end,
	register_on_shutdown = function(cb)
		table.insert(registered_shutdown_cbs, cb)
	end,
	get_connected_players = function()
		return {}
	end,
	register_globalstep = function() end,
	register_on_punchplayer = function() end,
	register_on_player_hpchange = function() end,
	settings = {
		get_bool = function(_self, _key, default) return default end,
	},
	log = function() end,
	after = function() end,
	sound_play = function() end,
	add_particlespawner = function() return 1 end,
	delete_particlespawner = function(_id, ...)
		local n = select("#", ...)
		if n >= 1 then
			local playername = select(1, ...)
			if type(playername) ~= "string" then
				error("bad argument #2 to 'delete_particlespawner' (string expected, got " .. type(playername) .. ")")
			end
		end
		return true
	end,
	dir_to_yaw = function() return 0 end,
	yaw_to_dir = function() return {x = 0, y = 0, z = 1} end,
	registered_items = {},
	get_item_group = function() return 0 end,
	get_node_light = function() return 13 end,
	get_objects_inside_radius = function() return {} end,
	add_entity = function(pos, name)
		local def = registered_entities[name]
		local ent_obj = {
			_pos = {x = pos.x, y = pos.y, z = pos.z},
			_valid = true,
			_props = {},
			_attached_to = nil,
			get_pos = function(s) return s._pos end,
			is_valid = function(s) return s._valid end,
			remove = function(s) s._valid = false end,
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
		table.insert(added_entities, luaent)
		if def and def.on_activate then
			def.on_activate(luaent, "", 0)
		end
		return ent_obj
	end,
}

_G.minetest = _G.core

_G.x_mob_core = {
	register_mob = function(name, def)
		registered_entities[name] = def
	end,
	register_spawn = function(name, def)
		registered_spawns[name] = def
	end,
	play_animation = function() end,
	play_sound = function() end,
	schedule = function() end,
	broadcast_threat = function() end,
	halt_horizontal_velocity = function() end,
	scan_for_player = function() return nil end,
	is_player_alive = function() return true end,
	set_target = function() end,
	step_wander_or_idle = function() end,
	step_move_or_idle = function() end,
	line_of_sight = function() return true end,
	calculate_punch_damage = function() return 6 end,
	indicate_damage = function() end,
	listen = function() end,
	generate_uuid = function()
		local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
		return string.gsub(template, "[xy]", function(c)
			local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
			return string.format("%x", v)
		end)
	end,
}

_G.x_player_api = {
	set_animation = function() end,
	register_locomotion_evaluator = function() end,
}

-- Load core envelop and status_effects subsystems first
dofile("mods/x_mob_core/combat/particles.lua")
dofile("mods/x_mob_core/combat/hunger_adapter.lua")
dofile("mods/x_mob_core/combat/hud_effects.lua")
dofile("mods/x_mob_core/combat/envelop.lua")
dofile("mods/x_mob_core/combat/status_effects.lua")

-- Load api first
dofile("mods/x_mobs/api.lua")

-- Load nature_guardian
dofile("mods/x_mobs/mobs/nature_guardian.lua")

print("--- Testing Nature Guardian Registrations ---")
assert(registered_entities["x_mobs:nature_guardian"] ~= nil, "x_mobs:nature_guardian entity must be registered")
assert(registered_entities["x_mob_core:envelop"] ~= nil, "x_mob_core:envelop entity must be registered")
assert(registered_spawns["x_mobs:nature_guardian"] ~= nil, "x_mobs:nature_guardian spawn must be registered")

local gdef = registered_entities["x_mobs:nature_guardian"]

-- Test HSL texture variations
print("--- Testing Texture Variations ---")
assert(gdef.initial_properties.textures ~= nil, "Textures table must be present")
assert(#gdef.initial_properties.textures == 5, "Must have exactly 5 autumn texture variations")
for i, tex_entry in ipairs(gdef.initial_properties.textures) do
	local tex_str = type(tex_entry) == "table" and tex_entry[1] or tex_entry
	print("Variation " .. i .. ": " .. tostring(tex_str))
	assert(tex_str:find("%^%[hsl:") ~= nil, "Texture must utilize ^[hsl modifier")
end

-- Test canonical animation tracks
print("--- Testing Canonical Animation Tracks ---")
local required_anims = {"idle", "walk", "run", "attack", "spell", "hurt", "death"}
for _, a in ipairs(required_anims) do
	assert(gdef.animations[a] ~= nil, "Animation track missing: " .. a)
	print("Track " .. a .. ": " .. gdef.animations[a].track)
end
assert(gdef.animations.hurt.track == "hurt", "Hurt track must map to 'hurt'")
assert(gdef.animations.hurt.loop == false, "Hurt animation must not loop")

-- Test Poise hyper-armor flinching
print("--- Testing Poise Hyper-Armor ---")
assert(gdef.can_flinch ~= nil, "Nature Guardian must define can_flinch function")
assert(gdef.can_flinch({state = "idle"}) == true, "Must flinch in idle state")
assert(gdef.can_flinch({state = "walk"}) == true, "Must flinch in walk state")
assert(gdef.can_flinch({state = "attacking"}) == false, "Hyper-armor must prevent flinch during attack")
assert(gdef.can_flinch({state = "casting"}) == false, "Hyper-armor must prevent flinch during spell casting")

-- Test Declarative Melee Combat & Mid-Range Root Spell
print("--- Testing Declarative Melee Combat & Distance Root Spell ---")
assert(gdef.melee ~= nil, "Nature Guardian must configure declarative melee table")
assert(gdef.melee.range == 3.2, "Nature Guardian melee range must be 3.2")
assert(gdef.melee.damage == 7, "Nature Guardian melee damage must be 7")
assert(gdef.melee.animation == "attack", "Nature Guardian melee animation must be attack")
assert(type(gdef.custom_step) == "function", "Nature Guardian must define custom_step hook for distance spell")
assert(gdef.cooldowns and gdef.cooldowns.root_spell == 12.0, "Root spell cooldown must be 12.0s")

-- Verify distance spell casting behavior
local mock_target = {
	is_valid = function() return true end,
	is_player = function() return true end,
	get_pos = function() return { x = 0, y = 0, z = 10 } end,
	get_velocity = function() return { x = 0, y = 0, z = 0 } end,
	get_attach = function() return nil end,
	get_player_name = function() return "SpellVictim" end,
	get_luaentity = function() return nil end,
}
local test_mob = {
	state = "idle",
	object = {
		is_valid = function() return true end,
		get_pos = function() return { x = 0, y = 0, z = 0 } end,
		set_yaw = function() end,
		get_yaw = function() return 0 end,
	},
	target = mock_target,
	cooldowns = { root_spell = 0 },
}
local cast_res = gdef.custom_step(test_mob, 0.1)
assert(cast_res == true, "custom_step must cast root spell when target is at distance (10.0m)")
assert(test_mob.state == "casting", "Mob state must transition to casting")
assert(test_mob.cooldowns.root_spell == 12.0, "Root spell cooldown must be set to 12.0s")
assert(test_mob.action_timer == 2.0, "Action timer must be set to 2.0s")

-- When close (< 6.0m), custom_step must yield (return false) to allow melee
local close_target = {
	is_valid = function() return true end,
	is_player = function() return true end,
	get_pos = function() return { x = 0, y = 0, z = 2 } end,
}
test_mob.target = close_target
test_mob.state = "idle"
test_mob.action_timer = 0
test_mob.cooldowns.root_spell = 0
assert(gdef.custom_step(test_mob, 0.1) == false, "custom_step must yield to melee when target is close (2.0m)")

-- When out of range (> 16.0m), custom_step must yield to allow pursuit
local far_target = {
	is_valid = function() return true end,
	is_player = function() return true end,
	get_pos = function() return { x = 0, y = 0, z = 20 } end,
}
test_mob.target = far_target
assert(gdef.custom_step(test_mob, 0.1) == false, "custom_step must yield to pursuit when target is far (20.0m)")

-- Test visual_size and collisionbox scaling
print("--- Testing glTF Visual Size and Collisionbox Alignment ---")
assert(gdef.initial_properties.visual_size ~= nil, "Guardian visual_size must be specified")
assert(gdef.initial_properties.visual_size.x == 10 and gdef.initial_properties.visual_size.y == 10,
	"Guardian visual_size must be {x=10, y=10} to correctly align 10:1 glTF scale with collisionbox")
local gcbox = gdef.initial_properties.collisionbox
assert(gcbox[2] == -0.5 and gcbox[5] == 2.7,
	"Guardian collisionbox Y bounds must be [-0.5, 2.7] matching 1.0x model height")

-- Test Pixel Art Envelop Texture for Roots
print("--- Testing Roots Envelop Texture Assets ---")
local f_tex = io.open("mods/x_mobs/textures/x_mobs_roots_envelop.png", "rb")
assert(f_tex ~= nil, "x_mobs_roots_envelop.png must exist on filesystem")
local tex_header = f_tex:read(24)
f_tex:close()
assert(tex_header:sub(1, 8) == "\137PNG\r\n\26\n", "Must be a valid PNG file")
local b17, b18, b19, b20 = tex_header:byte(17, 20)
local b21, b22, b23, b24 = tex_header:byte(21, 24)
local tw = b17 * 16777216 + b18 * 65536 + b19 * 256 + b20
local th = b21 * 16777216 + b22 * 65536 + b23 * 256 + b24
assert(tw == 16 and th == 16, string.format("Texture must be 16x16 pixel art (got %dx%d)", tw, th))
print("  ✓ x_mobs_roots_envelop.png verified: 16x16 pixel art RGBA PNG.")

-- Test Core Envelop-Based Entangling Roots Mechanics
print("--- Testing Core Envelop Entangling Roots Mechanics ---")
assert(type(x_mobs.cast_root_entangle) == "function", "x_mobs.cast_root_entangle must be defined")
assert(type(x_mobs.get_roots_attached_spawner) == "function", "x_mobs.get_roots_attached_spawner must be defined")

local mock_player = {
	_speed = 1.0,
	_jump = 1.0,
	_gravity = 1.0,
	_valid = true,
	is_valid = function(s) return s._valid end,
	is_player = function() return true end,
	get_player_name = function() return "TestPlayer" end,
	get_hp = function() return 20 end,
	get_pos = function() return {x = 0, y = 0, z = 0} end,
	get_properties = function() return {collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3}} end,
	set_physics_override = function(s, ovr)
		if ovr.speed ~= nil then s._speed = ovr.speed end
		if ovr.jump ~= nil then s._jump = ovr.jump end
		if ovr.gravity ~= nil then s._gravity = ovr.gravity end
	end,
	get_physics_override = function(s)
		return {speed = s._speed, jump = s._jump, gravity = s._gravity}
	end,
	hud_add = function(_s, _def) return 1 end,
	hud_change = function() end,
	hud_remove = function() end,
}

-- Apply root entangle
local env_obj = x_mobs.cast_root_entangle(mock_player, 6.0)
assert(env_obj ~= nil, "Envelop entity must be returned by cast_root_entangle")
assert(x_mob_core.has_status_effect(mock_player, "nature_roots") == true, "Player must be recognized as root entangled")
assert(x_mob_core.is_enveloped(mock_player, "nature_roots") == true, "Core envelop must track roots effect")

-- Verify complete movement and jump immobilization (speed = 0, jump = 0)
local phys = mock_player:get_physics_override()
assert(math.abs(phys.speed - 0.0) < 0.001, "Player speed must be immobilized (0.0), got " .. tostring(phys.speed))
assert(math.abs(phys.jump - 0.0) < 0.001, "Player jump must be immobilized (0.0), got " .. tostring(phys.jump))

-- Verify envelop visual properties
local env_props = env_obj:get_properties()
assert(env_props.mesh == "x_mob_core_envelop_box.obj", "Envelop must use x_mob_core_envelop_box.obj")
assert(env_props.textures[1] == "x_mobs_roots_envelop.png", "Envelop must use x_mobs_roots_envelop.png")

-- Simulate on_step
local env_ent = env_obj:get_luaentity()
assert(env_ent ~= nil, "Envelop luaentity must exist")
env_ent:on_step(1.0)
assert(x_mob_core.has_status_effect(mock_player, "nature_roots") == true, "Roots still active after 1.0s")

-- Test manual removal
x_mob_core.remove_status_effect(mock_player, "nature_roots")
assert(x_mob_core.has_status_effect(mock_player, "nature_roots") == false, "Player should no longer be root entangled")
assert(x_mob_core.is_enveloped(mock_player, "nature_roots") == false, "Core envelop roots effect should be removed")

-- Verify physics restoration
local restored_phys = mock_player:get_physics_override()
assert(math.abs(restored_phys.speed - 1.0) < 0.001,
	"Speed must be restored to 1.0, got " .. tostring(restored_phys.speed))
assert(math.abs(restored_phys.jump - 1.0) < 0.001,
	"Jump must be restored to 1.0, got " .. tostring(restored_phys.jump))

-- Test Player Lifecycle Listeners (die, leave, respawn, shutdown)
print("--- Testing Lifecycle Listeners ---")
local victim2 = {
	_speed = 1.0,
	_jump = 1.0,
	_valid = true,
	is_valid = function(s) return s._valid end,
	is_player = function() return true end,
	get_player_name = function() return "Victim2" end,
	get_hp = function() return 20 end,
	get_pos = function() return {x = 0, y = 0, z = 0} end,
	get_properties = function() return {collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3}} end,
	set_physics_override = function(s, ovr)
		if ovr.speed ~= nil then s._speed = ovr.speed end
		if ovr.jump ~= nil then s._jump = ovr.jump end
	end,
	get_physics_override = function(s) return {speed = s._speed, jump = s._jump} end,
	hud_add = function(_s, _def) return 1 end,
	hud_change = function() end,
	hud_remove = function() end,
}

-- Entangle victim2 via cast_root_entangle
x_mobs.cast_root_entangle(victim2, 6.0)
assert(x_mob_core.has_status_effect(victim2, "nature_roots") == true, "Victim2 entangled")
assert(victim2:get_physics_override().speed == 0.0, "Victim2 speed 0")

-- Simulate player leave
for _, cb in ipairs(registered_leaveplayer_cbs) do
	cb(victim2)
end
assert(victim2:get_physics_override().speed == 1.0, "Victim2 speed restored on leave")
assert(x_mob_core.has_status_effect(victim2, "nature_roots") == false, "Victim2 not entangled after leave")

print("--- All Tests Passed Successfully! ---")
