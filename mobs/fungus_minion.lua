--[[
	x_mobs - Fungus Minion
	Aggressive, fast fungal vanguard minion that protects and rallies around the Crazy Mushroom boss.
]]

x_mob_core.register_mob("x_mobs:fungus_minion", {
	initial_properties = {
		hp_max = 24,
		mesh = "x_mobs_fungus_minion.glb",
		textures = {
			"x_mobs_fungus_minion.png",
		},
		visual_size = {x = 9, y = 9},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 0.9, 0.35},
		glow = 2,
	},

	armor_groups = { fleshy = 100 },
	knockback_mult = 0.5,
	factions = { "fungal" },
	walk_speed = 3.6,
	pursuit_speed = 5.2,
	wander_speed = 1.8,
	wander_radius = 8.0,
	attack_range = 2.0,
	damage = 2,
	health_regen = {
		flee_threshold = 0,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.5,
	damage_effect = { type = "none" },
	drops = {
		{ name = "flowers:mushroom_red",   min = 1, max = 2, chance = 0.50 },
		{ name = "flowers:mushroom_brown", min = 1, max = 2, chance = 0.50 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:crazy_mushroom",
		leash_distance = 20.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	sounds = {
		gain = 0.85,
		distance = 24.0,
		attack = "x_mobs_fungus_attack",
		hurt = "x_mobs_fungus_hurt",
		death = "x_mobs_fungus_death",
		random = "x_mobs_fungus_idle",
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "punch",  speed = 1.3, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.5, z = 0 } },
		Head = { pivot = { x = 0, y = 0.33, z = 0 } },
		Leg_Left = { pivot = { x = -0.15, y = 0.25, z = 0 } },
		Leg_Right = { pivot = { x = 0.15, y = 0.25, z = 0 } },
	},


	vfx = {
		hurt = { type = "fungus_hurt" },
		death = { type = "fungus_death" },
		despawn = { type = "fungus_dissolve", scale = 0.85 },
	},

	on_death = function(self, _killer)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			local nearby = core.get_objects_inside_radius(pos, 3.0)
			for i = 1, #nearby do
				local obj = nearby[i]
				local is_attached = obj.get_attach and obj:get_attach() ~= nil
				if obj ~= self.object and not is_attached and ((obj:is_player() and x_mob_core.is_player_alive(obj))
						or (not obj:is_player() and not x_mob_core.are_allies(self.object, obj))) then
					x_mob_core.apply_status_effect(obj, {
						id = "spores",
						type = "debuff",
						duration = 4.0,
						speed_factor = 0.7,
						jump_factor = 0.8,
						gravity_factor = 0.75,
						drain_hunger = 0.5,
						envelop_texture = "x_mobs_spore_envelop.png",
						hud_vignette = true,
					})
				end
			end
		end
	end,

	melee = {
		range = 2.0,
		damage = 4,
		cooldown = 1.0,
		duration = 0.5,
		delay = 0.25,
		animation = "attack",
		anim_speed = 1.3,
		sound = "attack",
		on_strike = function(_self, target, _dir)
			x_mob_core.apply_status_effect(target, {
				id = "spores",
				type = "debuff",
				chance = 0.20,
				duration = 3.5,
				speed_factor = 0.75,
				jump_factor = 0.85,
				gravity_factor = 0.8,
				drain_hunger = 0.5,
				envelop_texture = "x_mobs_spore_envelop.png",
				hud_vignette = true,
				particles = {
					amount = 6,
					time = 0,
					minpos = {x = -0.25, y = 0.2, z = -0.25},
					maxpos = {x = 0.25, y = 0.8, z = 0.25},
					minvel = {x = -0.15, y = 0.2, z = -0.15},
					maxvel = {x = 0.15, y = 0.6, z = 0.15},
					texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,5",
					glow = 6,
				},
			})
		end,
	},
})

-- Register natural spawns via x_mob_core
x_mob_core.register_spawn("x_mobs:fungus_minion", {
	nodes = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt",
		"group:soil",
		"group:stone",
	},
	chance = 2000,
	active_object_count = 5,
	group_min = 3,
	group_max = 5,
	min_light = 0,
	max_light = 12,
})
