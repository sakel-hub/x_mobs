--[[
	test_arrow_builtin_pass_through.lua - Verification Test Suite
	Verifies that archer arrows pass through __builtin:item entities, falling nodes,
	and other non-target entities, while correctly impacting enemies and solid nodes.
]]

local registered_entities = {}
local registered_nodes = {
	["air"] = { walkable = false },
	["default:stone"] = { walkable = true },
}

local x_mob_core_prefix = "../x_mob_core"
local test_core_f = io.open(x_mob_core_prefix .. "/combat/factions.lua", "r")
if test_core_f then
	test_core_f:close()
else
	x_mob_core_prefix = "mods/x_mob_core"
end

_G.core = {
	registered_entities = registered_entities,
	registered_nodes = registered_nodes,
	register_entity = function(name, def)
		registered_entities[name] = def
	end,
	get_node = function(pos)
		if pos.y <= 0 then
			return { name = "default:stone" }
		end
		return { name = "air" }
	end,
	after = function(_delay, func)
		func()
	end,
	sound_play = function() end,
	add_particlespawner = function() end,
	get_modpath = function(mod)
		if mod == "x_mob_core" then
			return x_mob_core_prefix
		end
		return "."
	end,
}

_G.vector = {
	direction = function(p1, p2)
		local dx = p2.x - p1.x
		local dy = p2.y - p1.y
		local dz = p2.z - p1.z
		local len = math.sqrt(dx * dx + dy * dy + dz * dz)
		if len == 0 then return {x = 0, y = 0, z = 0} end
		return {x = dx / len, y = dy / len, z = dz / len}
	end,
	dir_to_rotation = function(_dir)
		return {x = 0, y = 0, z = 0}
	end,
}

local factions = dofile(x_mob_core_prefix .. "/combat/factions.lua")
local shooter_module = dofile(x_mob_core_prefix .. "/combat/shooter.lua")

_G.x_mob_core = {
	register_mob = function() end,
	register_spawn = function() end,
	step_projectile = shooter_module.step_projectile,
	is_valid_projectile_target = shooter_module.is_valid_target,
	are_allies = factions.are_allies,
}

-- Load skull_archer.lua
local archer_path = "./mobs/skull_archer.lua"
local test_archer = io.open(archer_path, "r")
if test_archer then
	test_archer:close()
else
	archer_path = "mods/x_mobs/mobs/skull_archer.lua"
end
dofile(archer_path)

local arrow_def = registered_entities["x_mobs:archer_arrow"]
assert(arrow_def, "x_mobs:archer_arrow must be registered")

local test_count = 0
local pass_count = 0

local function assert_eq(actual, expected, desc)
	test_count = test_count + 1
	if actual == expected then
		pass_count = pass_count + 1
		print(string.format("  [PASS] %s", desc))
	else
		print(string.format("  [FAIL] %s - Expected: %s, Got: %s", desc, tostring(expected), tostring(actual)))
	end
end

local function assert_true(actual, desc)
	assert_eq(actual == true, true, desc)
end

local function assert_false(actual, desc)
	assert_eq(actual == false or actual == nil, true, desc)
end

print("==================================================")
print("  Running Archer Arrow Builtin Pass-Through Tests")
print("==================================================")

-- Helper to create mock ObjectRef
local function create_mock_object(name, is_player, is_valid, faction)
	local valid = (is_valid ~= false)
	local punched = false
	local removed = false
	local pos = {x = 0, y = 5, z = 0}

	local lua_ent = nil
	if not is_player then
		lua_ent = {
			name = name,
			faction = faction,
		}
	end

	local obj = {}
	obj.is_valid = function() return valid end
	obj.is_player = function() return is_player == true end
	obj.get_luaentity = function() return lua_ent end
	obj.get_pos = function() return pos end
	obj.punch = function() punched = true end
	obj.remove = function() removed = true end
	obj.get_velocity = function() return {x = 10, y = 0, z = 0} end
	obj.set_velocity = function() end
	obj.set_rotation = function() end
	obj.was_punched = function() return punched end
	obj.was_removed = function() return removed end
	return obj
end

-- 1. Test Raycast passing through __builtin:item
do
	local shooter = create_mock_object("x_mobs:skull_archer", false, true, "undead")
	local arrow_obj = create_mock_object("x_mobs:archer_arrow", false, true)
	local arrow_inst = {
		object = arrow_obj,
		_shooter = shooter,
		_damage = 5,
		_old_pos = {x = 0, y = 5, z = 0},
		timer = 0,
	}

	-- Mock raycast returning a dropped item on the path
	local item_obj = create_mock_object("__builtin:item", false, true)
	_G.core.raycast = function()
		local pts = {
			{ type = "object", ref = item_obj },
		}
		local idx = 0
		return function()
			idx = idx + 1
			return pts[idx]
		end
	end
	_G.core.get_objects_inside_radius = function() return {} end

	arrow_obj.get_pos = function() return {x = 2, y = 5, z = 0} end
	arrow_def.on_step(arrow_inst, 0.1)

	assert_false(item_obj.was_punched(), "arrow does not punch __builtin:item")
	assert_false(arrow_obj.was_removed(), "arrow is not removed when passing through __builtin:item")
end

-- 2. Test Proximity fallback passing through __builtin:item
do
	local shooter = create_mock_object("x_mobs:skull_archer", false, true, "undead")
	local arrow_obj = create_mock_object("x_mobs:archer_arrow", false, true)
	local arrow_inst = {
		object = arrow_obj,
		_shooter = shooter,
		_damage = 5,
		_old_pos = {x = 0, y = 5, z = 0},
		timer = 0,
	}

	local item_obj = create_mock_object("__builtin:item", false, true)
	_G.core.raycast = function()
		return function() return nil end
	end
	_G.core.get_objects_inside_radius = function()
		return { item_obj }
	end

	arrow_obj.get_pos = function() return {x = 0.5, y = 5, z = 0} end
	arrow_def.on_step(arrow_inst, 0.1)

	assert_false(item_obj.was_punched(), "proximity fallback ignores __builtin:item")
	assert_false(arrow_obj.was_removed(), "arrow is not removed in proximity of __builtin:item")
end

-- 3. Test Raycast passing through other projectiles & health bars
do
	local shooter = create_mock_object("x_mobs:skull_archer", false, true, "undead")
	local arrow_obj = create_mock_object("x_mobs:archer_arrow", false, true)
	local arrow_inst = {
		object = arrow_obj,
		_shooter = shooter,
		_damage = 5,
		_old_pos = {x = 0, y = 5, z = 0},
		timer = 0,
	}

	local other_arrow = create_mock_object("x_mobs:archer_arrow", false, true)
	local health_bar = create_mock_object("x_mob_core:health_bar", false, true)
	local falling_node = create_mock_object("__builtin:falling_node", false, true)
	_G.core.raycast = function()
		local pts = {
			{ type = "object", ref = other_arrow },
			{ type = "object", ref = health_bar },
			{ type = "object", ref = falling_node },
		}
		local idx = 0
		return function()
			idx = idx + 1
			return pts[idx]
		end
	end
	_G.core.get_objects_inside_radius = function() return {} end

	arrow_obj.get_pos = function() return {x = 2, y = 5, z = 0} end
	arrow_def.on_step(arrow_inst, 0.1)

	assert_false(arrow_obj.was_removed(), "arrow passes through other arrows, health bars, and falling nodes")
end

-- 4. Test Raycast impacting Player enemy
do
	local shooter = create_mock_object("x_mobs:skull_archer", false, true, "undead")
	local arrow_obj = create_mock_object("x_mobs:archer_arrow", false, true)
	local arrow_inst = {
		object = arrow_obj,
		_shooter = shooter,
		_damage = 5,
		_old_pos = {x = 0, y = 5, z = 0},
		timer = 0,
	}

	local item_obj = create_mock_object("__builtin:item", false, true)
	local player_obj = create_mock_object("singleplayer", true, true)
	_G.core.raycast = function()
		local pts = {
			{ type = "object", ref = item_obj }, -- Should be ignored
			{ type = "object", ref = player_obj }, -- Should hit
		}
		local idx = 0
		return function()
			idx = idx + 1
			return pts[idx]
		end
	end
	_G.core.get_objects_inside_radius = function() return {} end

	arrow_obj.get_pos = function() return {x = 2, y = 5, z = 0} end
	arrow_def.on_step(arrow_inst, 0.1)

	assert_true(player_obj.was_punched(), "arrow impacts player even if item was in flight path")
	assert_true(arrow_obj.was_removed(), "arrow removes itself on impact with player")
end

-- 5. Test Raycast ignoring allies
do
	local shooter = create_mock_object("x_mobs:skull_archer", false, true, "undead")
	local arrow_obj = create_mock_object("x_mobs:archer_arrow", false, true)
	local arrow_inst = {
		object = arrow_obj,
		_shooter = shooter,
		_damage = 5,
		_old_pos = {x = 0, y = 5, z = 0},
		timer = 0,
	}

	local ally_obj = create_mock_object("x_mobs:skull_lancer", false, true, "undead")
	_G.core.raycast = function()
		local pts = {
			{ type = "object", ref = ally_obj },
		}
		local idx = 0
		return function()
			idx = idx + 1
			return pts[idx]
		end
	end
	_G.core.get_objects_inside_radius = function() return {} end

	arrow_obj.get_pos = function() return {x = 2, y = 5, z = 0} end
	arrow_def.on_step(arrow_inst, 0.1)

	assert_false(ally_obj.was_punched(), "arrow does not hit allied undead mob")
	assert_false(arrow_obj.was_removed(), "arrow continues flying through allied undead mob")
end

print("==================================================")
print(string.format("  Test Summary: %d / %d Passed (%.1f%%)", pass_count, test_count, (pass_count / test_count) * 100))
print("==================================================")

if pass_count == test_count then
	print("All arrow builtin pass-through tests passed successfully!")
else
	error("Some arrow builtin pass-through tests failed!")
end
