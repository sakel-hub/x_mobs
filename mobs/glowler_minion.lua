--[[
	x_mobs - Glowler Minion (Glow Bug)
	Author: SaKeL
	License: MIT

	Airborne bioluminescent swarm insect serving as retinue and protective
	interposing meat-shield for the Glowler dragon.
--]]

x_mob_core.register_mob("x_mobs:glowler_minion", {
	initial_properties = {
		hp_max = 16,
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 0.55, 0.35},
		mesh = "x_mobs_bug.glb",
		visual_size = {x = 0.6, y = 0.6},
		backface_culling = false,
		use_texture_alpha = true,
		textures = {
			"x_mobs_bug.png^[colorize:#00d9ff:65",
			"x_mobs_bug.png^[colorize:#00ffc4:55",
			"x_mobs_bug.png^[colorize:#19b3c9:70",
		},
		glow = 5,
	},

	factions = { "dragon", "glowler", "swarm", "insectoid" },
	armor_groups = { fleshy = 85 },
	attack_range = 1.6,
	damage = 3,
	is_floating = true,
	hover_offset = 1.3,
	walk_speed = 3.6,
	pursuit_speed = 5.2,
	flee_speed = 4.8,
	wander_speed = 2.0,
	wander_radius = 8.0,
	max_flee_distance = 16.0,
	death_duration = 1.6,
	can_flinch = false,

	health_regen = {
		flee_threshold = 5,
		return_threshold = 12,
		rate = 0.5,
		unlimited_flee = true,
		flee_speed = 4.8,
	},

	drops = {
		{ name = "farming:string",               min = 1, max = 2, chance = 0.65 },
		{ name = "default:flint",                min = 1, max = 1, chance = 0.45 },
		{ name = "default:clay_lump",            min = 1, max = 2, chance = 0.35 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 2, chance = 0.40 },
		{ name = "default:coal_lump",            min = 1, max = 1, chance = 0.30 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:glowler",
		leash_distance = 20.0,
		regroup_distance = 4.0,
	},

	pack_cowardice = { radius = 12.0, duration = 4.0 },

	sounds = {
		distance = 16.0,
		random = "x_mobs_armored_bug",
		attack = {name = "x_mobs_armored_bug_attack", gain = 0.7, pitch = 1.3},
		hurt   = {name = "x_mobs_armored_bug", gain = 0.8, pitch = 1.2},
		death  = {name = "x_mobs_armored_bug_death", gain = 1.0, pitch = 1.2},
	},

	vfx = {
		hurt = { type = "ichor_burst", count = 6, scale = 0.6 },
		death = {
			{ type = "chitin_shatter", count = 12, scale = 0.8 },
			{ type = "wing_shreds", count = 6, scale = 0.8 },
		},
	},

	melee = {
		range = 1.8,
		max_height_diff = 2.0,
		damage = 3,
		cooldown = 1.2,
		duration = 0.5,
		delay = 0.25,
		animation = "attack",
		sound = "attack",
		on_strike = function(self, target, _dir)
			if target and target:is_valid() then
				x_mob_core.apply_status_effect(target, {
					id = "glow_mark",
					type = "custom",
					chance = 0.25,
					duration = 6.0,
					envelop_texture = "x_mobs_swarm_envelop.png",
					hud_vignette = "x_mob_core_vignette.png^[colorize:#00ffff55",
					on_apply = function(victim)
						x_mob_core.broadcast_threat(self, victim, 32.0, 8)
					end,
				})
			end
		end,
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.2, loop = true},
		attack = {track = "attack", speed = 1.5, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body       = { pivot = { x = 0, y = 0, z = 0 } },
		Chest      = { pivot = { x = 0.49, y = 4.03, z = -0.07 } },
		Head       = { pivot = { x = 0.49, y = 6.07, z = -2.93 } },
		Arm_Left   = { pivot = { x = -1.5, y = 8.21, z = -0.07 } },
		Arm_Right  = { pivot = { x = 1.57, y = 8.21, z = -0.07 } },
		Leg_Left   = { pivot = { x = -0.95, y = 4.03, z = -0.07 } },
		Leg_Right  = { pivot = { x = 2.08, y = 4.03, z = -0.07 } },
		Tail       = { pivot = { x = 2.08, y = 6.21, z = 9.52 } },
	},

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

-- Register natural spawns via x_mob_core (roaming swarm minions)
x_mob_core.register_spawn("x_mobs:glowler_minion", {
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
	},
	chance = 2600,
	active_object_count = 5,
	group_min = 2,
	group_max = 4,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
