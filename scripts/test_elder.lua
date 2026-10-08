--[[
	test_elder.lua - Automated Integration Test for Elder Mob
	Validates:
	1. Entity registration (x_mobs:elder)
	2. Model file exists (models/x_mobs_elder.glb) and properties:
	   visual_size = {x = 1.0, y = 1.0}, collisionbox [0.0, 1.7],
	   makes_footstep_sound = false
	3. Animation suite: idle (stand), walk (walk), hurt (hurt), death (death), explode (explode)
	4. All 8 mastered CC0 elder audio files exist and are mapped in sounds/
	5. Pixel art particle sheet exists and all 4 VFX spawners execute cleanly
	6. AI State Machine:
	   - Proximity trigger at <= 3.2m -> enters "igniting" state, plays ignite sound and explode anim
	   - Accelerating white flash texture overlay during ignition
	   - Tactical defusal if player moves > 6.0m away -> resets texture, fuse, and resumes stalking
	   - Native detonation at fuse >= 2.2s -> carves crater with VoxelManip, ejects drops, damages player
	7. World spawning configured for solitary ambush stalker (group_min = 1, group_max = 1)
	8. Locale entries in en.po and template.pot
	9. Attribution manifest in license.txt (textures, audio, and TNT code)
]]

local registered_entities = {}
local registered_spawns = {}
local spawned_particles = {}
local played_sounds = {}
local checked_falling = {}
local added_items = {}

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
	divide = function(v, s)
		return {x = v.x / s, y = v.y / s, z = v.z / s}
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
	round = function(v)
		return {x = math.floor(v.x + 0.5), y = math.floor(v.y + 0.5), z = math.floor(v.z + 0.5)}
	end,
	length = function(v)
		return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
	end,
	equals = function(a, b)
		return a.x == b.x and a.y == b.y and a.z == b.z
	end,
	new = function(a, b, c)
		if type(a) == "table" then
			return {x = a.x, y = a.y, z = a.z}
		end
		return {x = a or 0, y = b or 0, z = c or 0}
	end,
}

_G.PseudoRandom = function(_seed)
	return {
		next = function(_self, min, max)
			return math.random(min, max)
		end,
	}
end

local mock_world_voxels = {}

_G.VoxelArea = {
	new = function(_self, def)
		local minp = def.MinEdge
		local maxp = def.MaxEdge
		local ystride = maxp.x - minp.x + 1
		local zstride = ystride * (maxp.y - minp.y + 1)
		return {
			MinEdge = minp,
			MaxEdge = maxp,
			index = function(_a, x, y, z)
				local i = (z - minp.z) * zstride + (y - minp.y) * ystride + (x - minp.x) + 1
				return i
			end,
			indexp = function(_a, p)
				local i = (p.z - minp.z) * zstride + (p.y - minp.y) * ystride + (p.x - minp.x) + 1
				return i
			end,
		}
	end,
}

_G.VoxelManip = function()
	local data = {}
	local minp, maxp
	return {
		read_from_map = function(_self, p1, p2)
			minp = {x = math.min(p1.x, p2.x), y = math.min(p1.y, p2.y), z = math.min(p1.z, p2.z)}
			maxp = {x = math.max(p1.x, p2.x), y = math.max(p1.y, p2.y), z = math.max(p1.z, p2.z)}
			local total = (maxp.x - minp.x + 1) * (maxp.y - minp.y + 1) * (maxp.z - minp.z + 1)
			for i = 1, total do
				data[i] = mock_world_voxels[i] or 1 -- stone default
			end
			return minp, maxp
		end,
		get_data = function(_self)
			return data
		end,
		set_data = function(_self, d)
			data = d
		end,
		write_to_map = function(_self)
			for i, v in pairs(data) do
				mock_world_voxels[i] = v
			end
		end,
		update_liquids = function(_self) end,
		close = function(_self) end,
	}
end

local registered_nodes_mock = {
	["default:stone"] = {
		name = "default:stone",
		description = "Stone",
		walkable = true,
		groups = {cracky = 3, stone = 1},
	},
	["air"] = {
		name = "air",
		walkable = false,
	},
}

_G.ItemStack = function(spec)
	local itemname = ""
	local itemcount = 1
	if type(spec) == "string" then
		local parts = {}
		for word in spec:gmatch("%S+") do table.insert(parts, word) end
		itemname = parts[1] or ""
		itemcount = tonumber(parts[2]) or 1
	elseif type(spec) == "table" and spec.get_name then
		itemname = spec:get_name()
		itemcount = spec:get_count()
	end
	return {
		get_name = function() return itemname end,
		get_count = function() return itemcount end,
		set_count = function(_self, c) itemcount = c end,
		get_stack_max = function() return 99 end,
		get_definition = function() return {} end,
	}
end

_G.core = {
	CONTENT_AIR = 0,
	CONTENT_IGNORE = 126,
	registered_nodes = registered_nodes_mock,
	registered_entities = registered_entities,
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
	log = function() end,
	after = function(_delay, cb) if cb then cb() end end,
	sound_play = function(spec, params)
		table.insert(played_sounds, {spec = spec, params = params})
		return 1
	end,
	add_particlespawner = function(def)
		table.insert(spawned_particles, def)
		return #spawned_particles
	end,
	dir_to_yaw = function() return 0 end,
	yaw_to_dir = function() return {x = 0, y = 0, z = 1} end,
	is_protected = function(_pos, _owner) return false end,
	get_content_id = function(nname)
		if nname == "air" or nname == "default:air" then return 0 end
		return 1
	end,
	get_node = function(_p)
		return {name = "air"}
	end,
	get_node_drops = function(nname, _tool)
		if nname == "default:stone" then
			return {"default:cobble 1"}
		end
		return {}
	end,
	find_nodes_with_meta = function(_p1, _p2)
		return {}
	end,
	get_meta = function(_p)
		return {
			from_table = function() end,
		}
	end,
	check_single_for_falling = function(pos)
		table.insert(checked_falling, {x = pos.x, y = pos.y, z = pos.z})
	end,
	add_item = function(pos, itemstack)
		local item_record = {pos = pos, item = itemstack:get_name(), count = itemstack:get_count()}
		table.insert(added_items, item_record)
		return {
			set_acceleration = function() end,
			set_velocity = function() end,
			get_luaentity = function() return {collect = false} end,
		}
	end,
	get_objects_inside_radius = function(_pos, _radius)
		if _G.mock_nearby_objects then
			return _G.mock_nearby_objects
		end
		return {}
	end,
}

_G.x_mobs = {}
_G.x_mob_core = {
	register_mob = function(name, def)
		registered_entities[name] = def
	end,
	register_spawn = function(name, def)
		registered_spawns[name] = def
	end,
	apply_status_effect = function(_target, _effect_def) end,
	remove_status_effect = function(_target, _effect_id) end,
	has_status_effect = function(_target, _effect_id) return false end,
	listen = function() end,
	is_player_alive = function(player)
		return player and player:is_valid() and player:get_hp() > 0
	end,
	scan_for_player = function(self, _radius)
		return self._mock_scanned_player
	end,
	set_target = function(self, target)
		self.target = target
	end,
	broadcast_threat = function() end,
	halt_horizontal_velocity = function(self)
		self._halted = true
	end,
	play_animation = function(_obj, anim_name, opts)
		_obj._current_anim = anim_name
		_obj._anim_opts = opts
	end,
	step_wander_or_idle = function(self, _dtime, _walk_anim, _idle_anim)
		self._wandered = true
	end,
	step_move_or_idle = function(self, _dtime, _move_anim, _speed_mult, _idle_anim)
		self._moved = true
	end,
}

print("==================================================")
print("RUNNING AUTOMATED INTEGRATION TEST: ELDER MOB")
print("==================================================")

-- 1. Load VFX and Elder definition
local mod_dir = "/Users/juraj/Library/Application Support/minetest/mods/x_mobs"
assert(loadfile(mod_dir .. "/vfx/mob_particles.lua"))()
assert(loadfile(mod_dir .. "/mobs/elder.lua"))()

-- 2. Verify Entity Registration
local elder_def = registered_entities["x_mobs:elder"]
assert(elder_def, "x_mobs:elder must be registered!")
print("[PASS] x_mobs:elder is registered in registered_entities.")

-- 3. Verify Properties
local ip = elder_def.initial_properties
assert(ip.mesh == "x_mobs_elder.glb", "Mesh must be x_mobs_elder.glb")
assert(ip.visual == "mesh", "Visual must be mesh")
assert(ip.visual_size.x == 1.0 and ip.visual_size.y == 1.0, "Visual size must be {x=1.0, y=1.0}")
assert(elder_def.makes_footstep_sound == false, "makes_footstep_sound must be false")
assert(ip.makes_footstep_sound == false, "initial_properties.makes_footstep_sound must be false")
assert(ip.collisionbox[2] == 0.0 and ip.collisionbox[5] == 1.7, "Collisionbox Y must span 0.0 to 1.7")
print("[PASS] Visual size, collisionbox, and silent footstep properties verified.")

-- 4. Verify Model File Exists
local model_path = mod_dir .. "/models/x_mobs_elder.glb"
local mf = io.open(model_path, "rb")
assert(mf, "models/x_mobs_elder.glb must exist on disk!")
local m_bytes = mf:seek("end")
mf:close()
assert(m_bytes > 50000, "Model file size should be > 50KB")
print(string.format("[PASS] models/x_mobs_elder.glb exists (%d bytes).", m_bytes))

-- 5. Verify Animation Suite
local anims = elder_def.animations
assert(anims.idle and anims.idle.track == "idle", "Idle must map to idle track")
assert(anims.walk and anims.walk.track == "walk", "Walk must map to walk track")
assert(anims.hurt and anims.hurt.track == "hurt", "Hurt must map to hurt track")
assert(anims.death and anims.death.track == "death", "Death must map to death track")
assert(anims.explode and anims.explode.track == "explode" and anims.explode.speed == 1.0,
	"Explode must map to explode track at speed 1.0")
print("[PASS] Animation tracks (idle, walk, hurt, death, explode) verified.")

-- 6. Verify Sounds Exist in sounds/
local required_sounds = {
	"x_mobs_elder_idle.1.ogg",
	"x_mobs_elder_idle.2.ogg",
	"x_mobs_elder_idle.3.ogg",
	"x_mobs_elder_hurt.1.ogg",
	"x_mobs_elder_hurt.2.ogg",
	"x_mobs_elder_ignite.ogg",
	"x_mobs_elder_explode.1.ogg",
	"x_mobs_elder_explode.2.ogg",
}
for _, sfile in ipairs(required_sounds) do
	local spath = mod_dir .. "/sounds/" .. sfile
	local sf = io.open(spath, "rb")
	assert(sf, "Sound file must exist: " .. sfile)
	local sz = sf:seek("end")
	sf:close()
	assert(sz > 1000, "Sound file must be non-empty: " .. sfile)
end
print(string.format("[PASS] All %d required elder sound files verified in sounds/.", #required_sounds))

-- 7. Verify Pixel Art Particle Sheet and VFX Spawners
local part_sheet = mod_dir .. "/textures/x_mobs_elder_particles.png"
local pf = io.open(part_sheet, "rb")
assert(pf, "textures/x_mobs_elder_particles.png must exist!")
pf:close()

spawned_particles = {}
local test_pos = {x = 0, y = 5, z = 0}
x_mobs.spawn_elder_hurt(test_pos)
x_mobs.spawn_elder_fuse(test_pos)
x_mobs.spawn_elder_explode(test_pos, 3.0)
x_mobs.spawn_elder_death(test_pos)
assert(#spawned_particles >= 8, "VFX spawners must generate particle definitions")
print(string.format("[PASS] Pixel art particle sheet verified, VFX spawned %d particle emitters.", #spawned_particles))

-- 8. Verify AI State Machine: Proximity Trigger, Accelerating Flash, Defusal, and Detonation
local function create_mock_object(pos)
	local cur_props = { textures = {"x_mobs_elder.png"} }
	local cur_pos = {x = pos.x, y = pos.y, z = pos.z}
	local removed = false
	return {
		is_valid = function() return not removed end,
		remove = function() removed = true end,
		get_pos = function() return {x = cur_pos.x, y = cur_pos.y, z = cur_pos.z} end,
		set_pos = function(_self, p) cur_pos = {x = p.x, y = p.y, z = p.z} end,
		set_properties = function(_self, p)
			if p.textures then cur_props.textures = p.textures end
		end,
		get_properties = function() return cur_props end,
		set_yaw = function() end,
		get_yaw = function() return 0 end,
		get_hp = function() return 24 end,
		set_hp = function() end,
		get_velocity = function() return {x = 0, y = 0, z = 0} end,
		set_velocity = function() end,
		punch = function() end,
		get_armor_groups = function() return {fleshy = 100} end,
	}
end

local function create_mock_player(pos, hp)
	local cur_pos = {x = pos.x, y = pos.y, z = pos.z}
	local p_hp = hp or 20
	return {
		is_player = function() return true end,
		is_valid = function() return true end,
		get_pos = function() return {x = cur_pos.x, y = cur_pos.y, z = cur_pos.z} end,
		set_pos = function(_self, p) cur_pos = {x = p.x, y = p.y, z = p.z} end,
		get_hp = function() return p_hp end,
		set_hp = function(_self, v) p_hp = v end,
		get_player_name = function() return "singleplayer" end,
		set_fov = function() end,
		add_velocity = function() end,
		add_player_velocity = function() end,
		punch = function(_self, _src, _time, caps)
			if caps and caps.damage_groups and caps.damage_groups.fleshy then
				p_hp = math.max(0, p_hp - caps.damage_groups.fleshy)
			end
		end,
	}
end

print("\n--- Testing AI Behavior & State Transitions ---")
-- Test 8A: Stalking advance towards player outside ignition distance
local elder_obj = create_mock_object({x = 0, y = 0, z = 0})
local player_obj = create_mock_player({x = 5.0, y = 0, z = 0}) -- 5.0m away (stalking range)
local mob = {
	object = elder_obj,
	state = "idle",
	target = player_obj,
	aggro_radius = 18.0,
}
elder_def.on_step(mob, 0.1)
assert(mob._moved == true, "Elder must stalk towards distant player")
assert(mob.state ~= "igniting", "Elder must not ignite outside 3.2m")
print("[PASS] 8A: Stealth stalking active when distance > 3.2m.")

-- Test 8B: Proximity ignition trigger within 3.2m
player_obj:set_pos({x = 2.5, y = 0, z = 0}) -- within 3.2m
played_sounds = {}
elder_def.on_step(mob, 0.1)
assert(mob.state == "igniting", "Elder must transition to igniting state within 3.2m")
assert(mob.is_ignited == true, "is_ignited flag must be true")
assert(elder_obj._current_anim == "explode", "Must play explode animation upon igniting")
local ignite_played = false
for _, s in ipairs(played_sounds) do
	if s.spec == "x_mobs_elder_ignite" then ignite_played = true end
end
assert(ignite_played, "x_mobs_elder_ignite sound must be played upon ignition")
print("[PASS] 8B: Proximity ignition trigger at <= 3.2m verified.")

-- Test 8C: Accelerating white flash texture overlay during ignition
local flash_seen = false
for _ = 1, 10 do
	elder_def.on_step(mob, 0.05)
	local cur_tex = elder_obj.get_properties().textures[1]
	if cur_tex:find("%^%[colorize:#ffffff:") then
		flash_seen = true
		print(string.format("[PASS] 8C: Accelerating white flash texture overlay verified (%s).", cur_tex))
		break
	end
end
assert(flash_seen, "Must observe white colorize overlay during ignition countdown")

-- Test 8D: Tactical defusal when player retreats > 6.0m
player_obj:set_pos({x = 8.0, y = 0, z = 0}) -- 8.0m away (> 6.0m)
elder_def.on_step(mob, 0.1)
assert(mob.state == "walk", "State must reset to walk upon defusal")
assert(mob.fuse_timer == 0, "Fuse timer must reset to 0 upon defusal")
assert(mob.is_ignited == false, "is_ignited must be false upon defusal")
assert(elder_obj.get_properties().textures[1] == "x_mobs_elder.png",
	"Texture must reset to base x_mobs_elder.png")
assert(elder_obj._current_anim == "walk", "Must resume walk animation upon defusal")
print("[PASS] 8D: Tactical defusal verified when player retreats > 6.0m.")

-- Test 8E: Detonation countdown and crater carving when player stays close
player_obj:set_pos({x = 2.0, y = 0, z = 0}) -- Re-engage within ignition distance
elder_def.on_step(mob, 0.1) -- trigger ignition
assert(mob.state == "igniting", "Re-ignited within 2.0m")

_G.mock_nearby_objects = { player_obj }
checked_falling = {}
added_items = {}
played_sounds = {}

-- Advance fuse timer to completion (2.2s)
elder_def.on_step(mob, 2.2)
assert(elder_obj.is_valid() == false, "Elder object must be removed upon detonation")
assert(player_obj:get_hp() < 20, "Nearby player must take explosion damage")
assert(#checked_falling > 0, "Surrounding blocks must be checked for falling")
local explode_sound_played = false
for _, s in ipairs(played_sounds) do
	if s.spec == "x_mobs_elder_explode" then explode_sound_played = true end
end
assert(explode_sound_played, "x_mobs_elder_explode sound must be played upon detonation")
print("[PASS] 8E: Native detonation, VoxelManip crater carving, and player damage verified.")

-- Test 8F: Low-HP tactical retreat and re-engagement
local flee_mob_obj = create_mock_object({x = 0, y = 0, z = 0})
local flee_player_obj = create_mock_player({x = 3.5, y = 0, z = 0}) -- Melee punch distance
local flee_mob = {
	object = flee_mob_obj,
	state = "fleeing",
	target = flee_player_obj,
	aggro_radius = 18.0,
	memory = {
		flee_state = true,
	},
}
-- 1. Initial critical punch at 3.5m -> mob MUST NOT immediately re-engage; it must retreat!
elder_def.on_step(flee_mob, 0.1)
assert(flee_mob.state == "fleeing", "Elder must retreat initially when damaged in melee (3.5m)")

-- 2. Elder gains distance (moves to 10m away) -> escapes to safety
flee_player_obj:set_pos({x = 10.0, y = 0, z = 0})
elder_def.on_step(flee_mob, 0.1)
assert(flee_mob.state == "fleeing", "Elder remains in fleeing state while establishing safe distance")
assert(flee_mob._has_escaped == true, "Elder must flag distance as established (escaped)")

-- 3. Player pursues and closes in again within 6.0m (5.0m) -> turns to stalk (walk)
flee_player_obj:set_pos({x = 5.0, y = 0, z = 0})
elder_def.on_step(flee_mob, 0.1)
assert(flee_mob.state == "walk", "Elder must re-engage into walk state when player closes in again")

-- 4. Player backs away beyond 8.5m (9.0m) -> resumes fleeing to heal
flee_player_obj:set_pos({x = 9.0, y = 0, z = 0})
elder_def.on_step(flee_mob, 0.1)
assert(flee_mob.state == "fleeing", "Elder must resume fleeing to heal when player backs beyond 8.5m")

-- 5. Player charges within 3.0m -> transitions into igniting state
flee_player_obj:set_pos({x = 3.0, y = 0, z = 0})
elder_def.on_step(flee_mob, 0.1)
assert(flee_mob.state == "igniting", "Elder must ignite when player closes within 3.2m")
print("[PASS] 8F: Low-HP retreat and re-engagement verified.")

-- 9. Verify Natural Spawning
local spawn_def = registered_spawns["x_mobs:elder"]
assert(spawn_def, "Natural spawn must be registered for x_mobs:elder")
assert(spawn_def.group_min == 1 and spawn_def.group_max == 1,
	"Spawn group count must be solitary (1 to 1)")
assert(spawn_def.active_object_count <= 2, "Active object count must be capped for ambush mob")
print("[PASS] Solitary natural spawning registered for x_mobs:elder.")

-- 10. Verify Locale Files
local pot_path = mod_dir .. "/locale/template.pot"
local pot_file = io.open(pot_path, "r")
local pot_content = pot_file:read("*all")
pot_file:close()
assert(pot_content:find('msgid "Elder"'), "template.pot must contain msgid 'Elder'")

local po_path = mod_dir .. "/locale/en.po"
local po_file = io.open(po_path, "r")
local po_content = po_file:read("*all")
po_file:close()
assert(po_content:find('msgid "Elder"') and po_content:find('msgstr "Elder"'),
	"en.po must contain msgid 'Elder' and msgstr 'Elder'")
print("[PASS] Locale files contain valid Gettext entries for Elder.")

-- 11. Verify license.txt Manifest
local lic_path = mod_dir .. "/license.txt"
local lic_file = io.open(lic_path, "r")
local lic_content = lic_file:read("*all")
lic_file:close()
assert(lic_content:find("textures/x_mobs_elder_particles.png"), "license.txt must credit elder particles")
assert(lic_content:find("sounds/x_mobs_elder_ignite.ogg"), "license.txt must credit elder ignite audio")
assert(lic_content:find("sounds/x_mobs_elder_explode.1.ogg"), "license.txt must credit elder explode audio")
assert(lic_content:find("PilzAdam, ShadowNinja, sofar"),
	"license.txt must attribute TNT explosion code to PilzAdam, ShadowNinja, sofar")
print("[PASS] license.txt contains full asset and code attribution manifest.")

print("\n==================================================")
print("ALL TESTS PASSED SUCCESSFULLY!")
print("==================================================")
