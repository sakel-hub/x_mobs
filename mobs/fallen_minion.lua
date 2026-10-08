--[[
	x_mobs - Fallen Minion
]]

x_mob_core.register_mob("x_mobs:fallen_minion", {
	initial_properties = {
		hp_max = 15,
		mesh = "x_mobs_fallen_minion.glb",
		textures = {
			"x_mobs_fallen_minion.png",
		},
		visual_size = {x = 6, y = 6},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.2, 0.35},
		glow = 2,
	},

	factions = { "fallen", "cultist" },
	walk_speed = 3.5,
	pursuit_speed = 5.0,
	flee_speed = 4.8,
	wander_speed = 2.0,
	wander_radius = 8.0,
	max_flee_distance = 15.0,
	health_regen = {
		flee_threshold = 5,
		return_threshold = 12,
		rate = 0.5,
		unlimited_flee = true,
		flee_speed = 4.8,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.4,
	drops = {
		{ name = "default:stick",       min = 1, max = 3, chance = 0.75 },
		{ name = "default:torch",       min = 1, max = 2, chance = 0.35 },
		{ name = "default:flint",       min = 1, max = 1, chance = 0.40 },
		{ name = "default:coal_lump",   min = 1, max = 1, chance = 0.35 },
		{ name = "default:clay_lump",   min = 1, max = 2, chance = 0.30 },
		{ name = "default:gravel",      min = 1, max = 2, chance = 0.25 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:fallen_shaman",
		leash_distance = 18.0,
		regroup_distance = 4.0,
	},

	sounds = {
		gain = 0.85,
		hurt = "x_mobs_minion",
		death = "x_mobs_minion_death",
		random = "x_mobs_minion",
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		attack = {track = "attack", speed = 1.0, loop = false},
		flee   = {track = "flee",   speed = 1.2, loop = true},
		hurt   = {track = "hurt",   speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.6, z = 0 } },
		Head = { pivot = { x = 0, y = 1.8, z = 0 } },
		Arm_Left = { pivot = { x = -0.55, y = 1.6, z = 0 } },
		Arm_Right = { pivot = { x = 0.55, y = 1.6, z = 0 } },
		Wield_Item = { pivot = { x = 0.55, y = 0.7, z = 0 } },
		Leg_Left = { pivot = { x = -0.2, y = 1.0, z = 0 } },
		Leg_Right = { pivot = { x = 0.2, y = 1.0, z = 0 } },
	},


	attack_range = 2.0,
	damage = 4,
	melee = {
		range = 2.0,
		max_height_diff = 1.5,
		damage = 4,
		cooldown = 1.5,
		duration = 0.5,
		delay = 0.25,
		animation = "attack",
	},

	vfx = {
		death = { type = "flame", scale = 1.0 },
	},

	pack_cowardice = { radius = 12.0, duration = 4.0 },

	on_return_to_fight = function(self)
		local fpos = x_mob_core.mob_memory.get_fight_pos(self)
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "walk"
		elseif fpos then
			self.state = "returning"
			self.nav_target_pos = fpos
		elseif self.leader_obj and self.leader_obj:is_valid() then
			self.state = "regrouping"
			self.target = nil
		else
			self.state = "idle"
			self.target = nil
		end
	end,
})

-- Register natural spawns via x_mob_core (fallen cultist minions roaming in small packs)
x_mob_core.register_spawn("x_mobs:fallen_minion", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:dirt",
		"default:desert_stone",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:cursed_stone_carved",
	},
	chance = 2400,
	active_object_count = 5,
	group_min = 2,
	group_max = 4,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
