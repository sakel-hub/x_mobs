--[[
	x_mobs - Skull Archer
]]

-- Register the Arrow Projectile
core.register_entity("x_mobs:archer_arrow", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "mesh",
		mesh = "x_mobs_arrow.glb",
		textures = {"x_mobs_arrow.png"},
		visual_size = {x = 8.9, y = 8.9},
		glow = 4,
		use_texture_alpha = true,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	on_activate = function(self, _staticdata, _dtime_s)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {0, 0, 0, 0, 0, 0},
			collide_with_objects = false,
		})
	end,
	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,
	on_rightclick = function(_self, _clicker)
	end,
	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			damage = 5,
			lifetime = 4.0,
		})
	end,
})

x_mob_core.register_mob("x_mobs:skull_archer", {
	initial_properties = {
		hp_max = 20,
		mesh = "x_mobs_skull_archers.glb",
		textures = {
			"x_mobs_skull_archers.png",
		},
		visual_size = {x = 8.9, y = 8.9},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.8, 0.35},
		glow = 2,
	},

	knockback_mult = 0.3,
	factions = { "undead", "skeleton" },
	walk_speed = 3.5,
	pursuit_speed = 4.0,
	wander_speed = 2.0,
	wander_radius = 8.0,
	attack_range = 16.0,
	health_regen = {
		flee_threshold = 0,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.8,
	damage_effect = { type = "none" },
	drops = {
		{ name = "default:stick",       min = 1, max = 3, chance = 0.75 },
		{ name = "farming:string",      min = 1, max = 2, chance = 0.35 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:skull_king",
		leash_distance = 24.0,
		regroup_distance = 6.0,
		on_leader_lost = "fight",
		swarm_alert = true,
	},

	swarm_alert = {
		radius = 20.0,
		max_allies = 6,
	},

	sounds = {
		gain = 0.9,
		distance = 24.0,
		shoot = "x_mobs_bow_shoot",
		attack = "x_mobs_bow_shoot",
		hurt = "x_mobs_skull_hurt",
		death = "x_mobs_skull_death",
		random = "x_mobs_skull_idle",
	},

	animations = {
		idle   = {track = "idle",  speed = 1.0, loop = true},
		walk   = {track = "walk",  speed = 1.0, loop = true},
		run    = {track = "run",   speed = 1.0, loop = true},
		attack = {track = "shoot", speed = 1.0, loop = false},
		shoot  = {track = "shoot", speed = 1.0, loop = false},
		death  = {track = "death", speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.81, z = 0 } },
		Head = { pivot = { x = 0, y = 0, z = 0 } },
		Arm_Left = { pivot = { x = -0.34, y = 1.48, z = 0 } },
		Arm_Right = { pivot = { x = 0.36, y = 1.48, z = 0 } },
		Wield_Item = { pivot = { x = 0.36, y = 0.32, z = 0.09 } },
		Leg_Left = { pivot = { x = -0.12, y = 0.79, z = 0 } },
		Leg_Right = { pivot = { x = 0.14, y = 0.79, z = 0 } },
	},


	vfx = {
		hurt = { type = "bone_dust" },
		death = { type = "bone_dust" },
		despawn = { type = "bone_dust" },
	},

	shooter = {
		projectile = "x_mobs:archer_arrow",
		velocity = 18.0,
		damage = 5,
		range = 16.0,
		min_range = 5.0,
		cooldown = 2.5,
		fire_duration = 0.8,
		fire_delay = 0.4,
		animation = "shoot",
		sound = "x_mobs_bow_shoot",
		predict_aim = true,
		retreat_speed = 3.5,
		shoot_while_retreating = true,
	},

})

-- Register natural spawns via x_mob_core (skeleton archer, spawns in dark caves and night surface)
x_mob_core.register_spawn("x_mobs:skull_archer", {
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
	chance = 2200,
	active_object_count = 3,
	group_min = 1,
	group_max = 2,
	min_light = 0,
	max_light = 15,
})
