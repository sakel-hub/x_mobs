--[[
	x_mobs - Skull Lancer
]]

x_mob_core.register_mob("x_mobs:skull_lancer", {
	initial_properties = {
		hp_max = 25,
		mesh = "x_mobs_skull_lancer.glb",
		textures = {
			"x_mobs_skull_lancer.png",
		},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.85, 0.35},
		glow = 2,
	},

	knockback_mult = 0.3,
	factions = { "undead", "skeleton" },
	walk_speed = 3.8,
	pursuit_speed = 5.2,
	wander_speed = 2.0,
	wander_radius = 8.0,
	attack_range = 2.5,
	damage = 5,
	health_regen = {
		flee_threshold = 0,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.8,
	damage_effect = { type = "none" },
	drops = {
		{ name = "default:stick",       min = 1, max = 3, chance = 0.75 },
		{ name = "default:coal_lump",   min = 1, max = 1, chance = 0.35 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:skull_king",
		leash_distance = 18.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
		swarm_alert = true,
	},

	swarm_alert = {
		radius = 20.0,
		max_allies = 6,
	},

	sounds = {
		gain = 0.85,
		distance = 24.0,
		attack = "x_mobs_lancer_attack",
		hurt = "x_mobs_skull_hurt",
		death = "x_mobs_skull_death",
		random = "x_mobs_skull_idle",
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "attack", speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Root = { pivot = { x = 0, y = 0, z = 0 } },
		Head = { pivot = { x = 0, y = 13.35, z = 0 } },
		Arm_Left = { pivot = { x = -2.95, y = 13.54, z = 0 } },
		Arm_Right = { pivot = { x = 2.86, y = 13.62, z = 0 } },
		Wield_Item = { pivot = { x = 2.86, y = 7.88, z = 0 } },
		Wield_Item_2 = { pivot = { x = -4.42, y = 6.93, z = 1.44 } },
		Leg_Left = { pivot = { x = -1.65, y = 7.0, z = 0 } },
		Leg_Right = { pivot = { x = 1.48, y = 7.08, z = 0 } },
	},


	vfx = {
		hurt = { type = "bone_dust" },
		death = { type = "bone_dust" },
		despawn = { type = "bone_dust" },
	},

	melee = {
		range = 2.5,
		damage = 5,
		cooldown = 1.2,
		duration = 0.5,
		delay = 0.25,
		animation = "attack",
		anim_speed = 1.3,
		sound = "attack",
	},
})

-- Register natural spawns via x_mob_core (skeleton lancer vanguard, patrols in small units)
x_mob_core.register_spawn("x_mobs:skull_lancer", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:desert_stone",
		"default:dirt",
		"default:gravel",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:cursed_stone_carved",
		"everness:coral_bones_block",
		"everness:coral_bones_brick",
		"everness:forsaken_desert_stone",
		"everness:forsaken_tundra_dirt_with_grass",
	},
	chance = 2000,
	active_object_count = 4,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 15,
})
