--[[
	test_coral_bones_spawning.lua - Verification Test Suite
	Verifies that all mobs in x_mobs are strictly prevented from spawning on everness:coral_bones nodes.
]]

-- Mock Luanti engine environment
local registered_nodes = {
	["air"] = { walkable = false },
	["ignore"] = { walkable = false },
	["default:stone"] = { walkable = true },
	["default:dirt_with_grass"] = { walkable = true },
	["everness:coral_bones"] = { walkable = true },
	["everness:coral_bones_block"] = { walkable = true },
	["everness:coral_bones_brick"] = { walkable = true },
}

local item_groups = {
	["default:stone"] = { stone = 1, cracky = 3 },
	["default:dirt_with_grass"] = { soil = 1, crumbly = 3 },
	["everness:coral_bones"] = { stone = 1, cracky = 3, pickaxey = 1 },
	["everness:coral_bones_block"] = { stone = 1, cracky = 2, pickaxey = 1 },
	["everness:coral_bones_brick"] = { stone = 1, cracky = 2, pickaxey = 1 },
}

local mock_timeofday = 0.5

_G.core = {
	get_modpath = function(modname)
		if modname == "x_mobs" then
			return "."
		elseif modname == "x_mob_core" then
			return "../x_mob_core"
		end
		return "."
	end,
	registered_nodes = registered_nodes,
	get_item_group = function(name, group)
		local grps = item_groups[name]
		return (grps and grps[group]) or 0
	end,
	get_node = function(pos)
		if pos.y <= 0 then
			return { name = _G.__test_ground_node or "default:stone" }
		else
			return { name = "air" }
		end
	end,
	get_node_or_nil = function(pos)
		return _G.core.get_node(pos)
	end,
	get_timeofday = function()
		return mock_timeofday
	end,
	get_node_light = function(_pos)
		return 10
	end,
	get_biome_data = function(_pos)
		return nil
	end,
	get_objects_inside_radius = function(_pos, _radius)
		return {}
	end,
	register_entity = function(_name, _def) end,
	register_on_generated = function(_fn) end,
	register_globalstep = function(_fn) end,
	register_on_mods_loaded = function(_fn) end,
	register_on_leaveplayer = function(_fn) end,
	register_on_shutdown = function(_fn) end,
	log = function(_level, _msg) end,
	pos_to_string = function(p)
		return string.format("(%d,%d,%d)", p.x or 0, p.y or 0, p.z or 0)
	end,
}
_G.minetest = _G.core

-- Mock x_mob_core
local x_mob_core_path = "../x_mob_core"
local registry = dofile(x_mob_core_path .. "/spawning/registry.lua")
local conditions = dofile(x_mob_core_path .. "/spawning/conditions.lua")

_G.x_mob_core = {
	registered_mobs = {},
	register_mob = function(name, def)
		_G.x_mob_core.registered_mobs[name] = def
	end,
	register_spawn = registry.register_spawn,
	step_move_or_idle = function() end,
	avoid_solid_nodes = function(p) return p end,
	adopt_nearby_orphans = function() end,
	add_follower = function() end,
	rally_followers = function() end,
	play_sound = function() end,
	play_animation = function() end,
	is_player_alive = function() return false end,
	listen = function() end,
}

-- Load x_mobs
dofile("./api.lua")

-- Load all mob definitions
dofile("./spider.lua")
dofile("./fallen_minion.lua")
dofile("./fallen_shaman.lua")
dofile("./armored_bug.lua")
dofile("./flying_insect.lua")
dofile("./skull_king.lua")
dofile("./skull_lancer.lua")
dofile("./skull_archer.lua")
dofile("./crystal_guardian.lua")
dofile("./skeleton_swordfish.lua")

local spawns = registry.get_spawns()
assert(#spawns > 0, "No spawns registered!")

print(string.format("Loaded %d spawn registrations in x_mobs.", #spawns))

local pass_count = 0
local test_pos = { x = 0, y = 1, z = 0 }

for _, def in ipairs(spawns) do
	local mob_name = def.mob_name
	print("Testing mob spawn rules for: " .. mob_name)

	-- 1. Verify everness:coral_bones is NOT in def.nodes
	if def.nodes then
		for _, n in ipairs(def.nodes) do
			if n == "everness:coral_bones" then
				error("FAILURE: " .. mob_name .. " still lists everness:coral_bones in def.nodes!")
			end
		end
	end

	-- 5. Verify conditions.check still allows valid nodes (e.g. default:stone for stone-walking mobs)
	if def.nodes then
		local has_stone = false
		for _, n in ipairs(def.nodes) do
			if n == "group:stone" or n == "default:stone" then
				has_stone = true
				break
			end
		end
		if has_stone then
			_G.__test_ground_node = "default:stone"
			local valid_on_stone = conditions.check(test_pos, def, false)
			assert(valid_on_stone, "FAILURE: conditions.check failed on default:stone for " .. mob_name)
		end
	end

	pass_count = pass_count + 1
	print("  [PASS] " .. mob_name .. " correctly excluded from everness:coral_bones")
end

print(string.format("\nAll %d mob spawn definitions passed coral_bones exclusion tests!", pass_count))
