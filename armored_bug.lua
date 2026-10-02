--[[
	x_mobs - Armored Bug Swarm Entity
	Airborne swarm mob with glTF multi-track animation and leader coordination.
]]

x_mob_core.register_mob("x_mobs:armored_bug", {
	initial_properties = {
		hp_max = 35,
		collisionbox = {-0.25, 0.12, -0.35, 0.25, 0.64, 0.35},
		mesh = "x_mobs_armored_bug.glb",
		textures = {
			"x_mobs_armored_bug.png",
		},
		visual_size = {x = 4.8, y = 4.8},
		backface_culling = false,
	},

	factions = { "insectoid", "swarm" },
	armor_groups = { fleshy = 80 },
	attack_range = 1.6,
	damage = 2,
	is_floating = true,
	hover_offset = 1.4,
	walk_speed = 3.5,
	pursuit_speed = 5.2,
	wander_speed = 2.0,
	death_duration = 1.3,
	damage_effect = { type = "ichor", scale = 0.7 },
	drops = {
		{ name = "default:clay_lump",   min = 1, max = 3, chance = 0.75 },
		{ name = "default:flint",       min = 1, max = 1, chance = 0.45 },
		{ name = "default:steel_ingot", min = 1, max = 1, chance = 0.20 },
		{ name = "default:iron_lump",   min = 1, max = 2, chance = 0.40 },
		{ name = "default:coal_lump",   min = 1, max = 2, chance = 0.35 },
		{ name = "default:sand",        min = 1, max = 2, chance = 0.30 },
		{ name = "farming:string",      min = 1, max = 2, chance = 0.25 },
	},

	vfx = {
		hurt = { type = "ichor_burst", count = 8, scale = 0.6 },
		death = {
			{ type = "chitin_shatter", count = 16, scale = 1.0 },
			{ type = "ichor_burst", count = 28, scale = 1.0 },
			{ type = "wing_shreds", count = 8, scale = 1.0 },
		},
		despawn = { type = "ichor_dissolve", scale = 1.0 },
	},

	can_flinch = false,

	sounds = {
		distance = 16.0,
		attack = {name = "x_mobs_armored_bug_attack", gain = 0.7, pitch = 1.3},
		hurt = {name = "x_mobs_armored_bug", gain = 0.8, pitch = 1.2},
		death = {name = "x_mobs_armored_bug_death", gain = 1.0, pitch = 1.2},
	},

	swarm = {},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "walk",   speed = 1.3, loop = true},
		attack = {track = "attack", speed = 1.6, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},
})

-- Register natural spawns via x_mob_core (swarming mob, spawns 1 leader which spawns its pack)
x_mob_core.register_spawn("x_mobs:armored_bug", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:dirt",
		"default:desert_stone",
		"default:sand",
		"default:gravel",
		"everness:forsaken_desert_stone",
		"everness:coral_desert_stone",
		"everness:cursed_stone",
		"everness:crystal_stone",
	},
	chance = 6000,
	active_object_count = 3,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
})
