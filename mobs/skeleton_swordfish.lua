--[[
	x_mobs - Skeleton Swordfish Shoal Entity
	Aquatic skeletal predator mob utilizing x_mob_core fish schooling architecture
	with Leader-Follower Anchor Steering, 3D obstacle avoidance, multi-track glTF
	animations, and democratic leader succession.
]]

x_mob_core.register_mob("x_mobs:skeleton_swordfish", {
	initial_properties = {
		hp_max = 40,
		collisionbox = {-0.85, -0.3, -0.85, 0.85, 0.35, 0.85},
		selectionbox = {-0.85, -0.3, -0.85, 0.85, 0.35, 0.85},
		mesh = "x_mobs_skeleton_swordfish.glb",
		textures = {
			"x_mobs_skeleton_swordfish.png",                -- Aged Aquatic Bone (Base)
			"x_mobs_skeleton_swordfish.png^[hsl:0:-8:8",    -- Bleached Sunken Bone
			"x_mobs_skeleton_swordfish.png^[hsl:-15:-6:-6",  -- Abyssal Silt Shadow
			"x_mobs_skeleton_swordfish.png^[hsl:18:6:-2",    -- Kelp Brine / Sea Moss
			"x_mobs_skeleton_swordfish.png^[hsl:-25:-10:6",  -- Ocean Salt / Pale Brine
			"x_mobs_skeleton_swordfish.png^[hsl:-8:12:-4",   -- Ancient Calcified Amber
		},
		visual_size = {x = 1.0, y = 1.0},
		backface_culling = false,
		glow = 4,
		collide_with_objects = false,
	},

	factions = { "undead", "aquatic", "shoal" },
	armor_groups = { fleshy = 85 },
	aggro_radius = 16.0,
	eye_offset = 0.2,
	attack_range = 2.2,
	damage = 4,
	is_floating = true,
	walk_speed = 3.2,
	pursuit_speed = 5.6,
	wander_speed = 2.6,
	death_duration = 1.4,
	damage_effect = { type = "none" },
	drops = {
		{ name = "default:stick", min = 1, max = 2, chance = 0.50 },
		{ name = "default:flint", min = 1, max = 1, chance = 0.40 },
	},

	vfx = {
		hurt = { type = "bone_dust", count = 8, scale = 0.6 },
		death = {
			{ type = "bone_dust", count = 24, scale = 1.0 },
		},
	},

	can_flinch = false,

	sounds = {
		distance = 16.0,
		random = {name = "x_mobs_skeleton_swordfish_random", gain = 0.7, min_interval = 6.0, max_interval = 18.0},
		attack = {name = "x_mobs_skeleton_swordfish_attack", gain = 0.85},
		hurt = {name = "x_mobs_skeleton_swordfish_hurt", gain = 0.9},
		death = {name = "x_mobs_skeleton_swordfish_death", gain = 1.0},
	},

	shoal = {
		size = 6,
		spacing_x = 2.2,
		spacing_z = 1.8,
		spacing_y = 0.6,
		repulsion_radius = 1.8,
		repulsion_strength = 2.0,
		wander_radius = 24.0,
		cull_distance = 64.0,
		predator = true,
		on_strike = function(_self, target, _dir)
			if target and target:is_valid() then
				-- Waterlogged: liquid drag, accelerated downward sinking, drains player breath
				x_mob_core.apply_status_effect(target, {
					id = "waterlogged",
					type = "custom",
					chance = 0.20,
					duration = 4.0,
					speed_factor = 0.4,
					gravity_factor = 1.6,
					interval = 1.0,
					envelop_texture = "x_mobs_brine_envelop.png",
					hud_vignette = "x_mob_core_vignette.png^[colorize:#00336690",
					on_apply = function(victim)
						if victim:is_player() then
							local b = victim:get_breath()
							if b and b > 0 then
								victim:set_breath(math.max(0, b - 2))
							end
						end
					end,
					on_tick = function(victim)
						if victim:is_player() then
							local b = victim:get_breath()
							if b and b > 0 then
								victim:set_breath(math.max(0, b - 2))
							end
						end
					end,
				})
			end
		end,
	},

	despawn_timer = 45.0,

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.3, loop = true},
		attack = {track = "attack", speed = 1.5, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = -0.49, y = -11.14, z = 6.85 } },
		Head = { pivot = { x = -0.49, y = 1.81, z = 1.99 } },
		["Head.001"] = { pivot = { x = -0.49, y = 1.81, z = 1.99 } },
		Sword_Back = { pivot = { x = -0.49, y = 3.37, z = -2.32 } },
		Sword_Front = { pivot = { x = -0.49, y = 3.46, z = -6.45 } },
		Arm_Left = { pivot = { x = -1.73, y = 0.34, z = 4.92 } },
		Arm_Right = { pivot = { x = 0.62, y = 0.26, z = 4.92 } },
		Leg_Left = { pivot = { x = -0.49, y = 1.26, z = 10.98 } },
		Leg_Right = { pivot = { x = -0.58, y = 2.91, z = 15.18 } },
	},
})


-- Register natural oceanic aquatic spawns via x_mob_core
x_mob_core.register_spawn("x_mobs:skeleton_swordfish", {
	nodes = {
		"group:water",
	},
	exclude_nodes = {
		"default:river_water_source",
		"default:river_water_flowing",
	},
	exclude_groups = {
		"river_water",
	},
	chance = 2400,
	active_object_count = 3,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
	max_elevation = 128,
	min_elevation = -128,
})
