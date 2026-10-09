--[[
	test_skull_king.lua - Automated Integration Test
	Validates Skull King mob configuration, bone rig definitions,
	summoning logic, and animation playback integrity in models/x_mobs_skull_king.glb.
]]

local registered_entities = {}
local registered_spawns = {}
local scheduled_callbacks = {}
local spawned_particles = {}
local played_sounds = {}

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
	round = function(v)
		return {x = math.floor(v.x + 0.5), y = math.floor(v.y + 0.5), z = math.floor(v.z + 0.5)}
	end,
}

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
	register_alias = function() end,
	log = function() end,
	after = function(_delay, cb)
		table.insert(scheduled_callbacks, cb)
	end,
	sound_play = function(spec, params)
		table.insert(played_sounds, {spec = spec, params = params})
		return 1
	end,
	add_particlespawner = function(def)
		table.insert(spawned_particles, def)
		return #spawned_particles
	end,
	dir_to_yaw = function(_dir) return 0 end,
	serialize = function(_t) return "" end,
	deserialize = function(_s) return {} end,
	add_entity = function() return nil end,
}
_G.minetest = _G.core

_G.x_mob_core = {
	registered_mobs = registered_entities,
	register_mob = function(name, def)
		registered_entities[name] = def
	end,
	register_spawn = function(name, def)
		registered_spawns[name] = def
	end,
	clean_followers = function(_self)
		return 0, {}
	end,
	adopt_nearby_orphans = function() end,
	avoid_solid_nodes = function(pos) return pos end,
	add_follower = function() end,
	apply_status_effect = function() end,
	rally_followers = function() end,
	play_sound = function() end,
	play_animation = function() end,
	halt_horizontal_velocity = function() end,
	set_armor_groups = function() end,
	is_player_alive = function() return true end,
}

_G.x_mobs = {
	spawn_magic_summon = function() end,
	spawn_bone_dust = function() end,
	spawn_regen_particles = function() end,
}

print("1. Loading Skull King definition...")
dofile("mods/x_mobs/mobs/skull_king.lua")

local def = registered_entities["x_mobs:skull_king"]
assert(def, "Skull King entity must be registered")

print("2. Validating initial properties...")
assert(def.initial_properties.mesh == "x_mobs_skull_king.glb", "Mesh must be x_mobs_skull_king.glb")
assert(def.initial_properties.hp_max == 120, "HP must be 120")
assert(def.initial_properties.visual_size.x == 8, "Visual size must be 8")
assert(def.initial_properties.collisionbox, "Collisionbox must be set")

print("3. Validating bone configurations...")
assert(type(def.bones) == "table", "Bones must be a table")
local expected_bones = {
	"Body", "Head", "Arm_Left", "Hand_Left", "Arm_Right", "Hand_Right",
	"Wield_Item", "Leg_Left", "Foot_Left", "Leg_Right", "Foot_Right"
}
for _, bname in ipairs(expected_bones) do
	assert(def.bones[bname], "Missing bone: " .. bname)
	assert(def.bones[bname].pivot, "Bone " .. bname .. " must define a pivot")
end

print("4. Validating animations configuration...")
assert(def.animations, "Animations must be defined")
local expected_tracks = {"idle", "walk", "run", "attack", "punch", "punch2", "shoot", "death"}
for _, tname in ipairs(expected_tracks) do
	assert(def.animations[tname], "Missing animation config for: " .. tname)
	assert(def.animations[tname].track, "Animation " .. tname .. " must define a track")
end

print("5. Validating GLB 3D model animation tracks directly...")
local glb_file = io.open("mods/x_mobs/models/x_mobs_skull_king.glb", "rb")
assert(glb_file, "Unable to open models/x_mobs_skull_king.glb")
local glb_content = glb_file:read("*all")
glb_file:close()

-- Extract JSON chunk from GLB
local json_len = string.byte(glb_content, 13) +
	string.byte(glb_content, 14) * 256 +
	string.byte(glb_content, 15) * 65536 +
	string.byte(glb_content, 16) * 16777216
local json_str = string.sub(glb_content, 21, 20 + json_len)

-- Basic JSON parser for anim names and accessor counts
local anim_names = {}
for anim_match in string.gmatch(json_str, '"name"%s*:%s*"([^"]+)"') do
	table.insert(anim_names, anim_match)
end

local canonical_glb_anims = {"idle", "walk", "run", "punch", "punch2", "shoot", "death"}
for _, canim in ipairs(canonical_glb_anims) do
	local found = false
	for _, a in ipairs(anim_names) do
		if a == canim then
			found = true
			break
		end
	end
	assert(found, "Canonical animation '" .. canim .. "' missing from GLB model")
end

print("6. Validating melee and custom step abilities...")
assert(def.melee and #def.melee.attacks >= 2, "Skull King must have at least 2 melee attacks")
assert(def.custom_step, "Skull King must define custom_step for necromancy summons")

local mock_self = {
	state = "walk",
	action_timer = 0,
	target = {
		is_player = function() return true end,
		get_pos = function() return {x = 0, y = 0, z = 5} end,
	},
	object = {
		get_pos = function() return {x = 0, y = 0, z = 0} end,
		set_yaw = function() end,
	},
	cooldowns = {summon = 0},
	summons_count = 0,
	max_total_summons = 24,
	pack_max_followers = 3,
}

local summoned = def.custom_step(mock_self, 0.1)
assert(summoned == true, "Skull King should trigger summon when minions depleted")
assert(mock_self.state == "summoning", "State should transition to summoning")

print("7. Validating spawn registration...")
assert(registered_spawns["x_mobs:skull_king"], "Skull King natural spawn must be registered")

print("\n=== ALL SKULL KING TESTS PASSED SUCCESSFULLY! ===")

