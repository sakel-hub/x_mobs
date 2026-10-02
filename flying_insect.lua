--[[
	x_mobs - Flying Insect Swarm Entity
	Airborne swarm insect mob with multi-track glTF animations, zero armor,
	and dynamic HSL color variations.
]]

x_mob_core.register_mob("x_mobs:flying_insect", {
	initial_properties = {
		hp_max = 24,
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 0.55, 0.35},
		mesh = "x_mobs_bug.glb",
		visual_size = {x = 0.6, y = 0.6},
		backface_culling = false,
		use_texture_alpha = true,
		-- Native Luanti HSL texture modifier variants (^[hsl:<hue>:<saturation>:<lightness>)
		-- Preserves alpha channel while providing distinct, muted phenotypes on natural chitin base.
		textures = {
			"x_mobs_bug.png^[hsl:24:15:10",   -- Golden Amber / Honey Hornet
			"x_mobs_bug.png^[hsl:-22:10:-12", -- Deep Blood Mahogany
			"x_mobs_bug.png^[hsl:5:-25:-35",  -- Obsidian Umber Chitin
			"x_mobs_bug.png^[hsl:20:-30:20",  -- Pale Desert Sand Locust
			"x_mobs_bug.png^[hsl:60:-10:-6",  -- Olive Bronze Mantis
			"x_mobs_bug.png^[hsl:-10:20:2",   -- Burnt Copper / Rust
			"x_mobs_bug.png^[hsl:0:-5:-8",    -- Woodland Chestnut
		},
	},

	factions = { "insectoid", "swarm" },
	attack_range = 1.5,
	damage = 1,
	is_floating = true,
	hover_offset = 1.4,
	walk_speed = 3.6,
	pursuit_speed = 5.4,
	wander_speed = 2.0,
	death_duration = 1.7,
	damage_effect = { type = "ichor", scale = 0.6 },
	drops = {
		{ name = "farming:string",    min = 1, max = 2, chance = 0.55 },
		{ name = "default:clay_lump", min = 1, max = 2, chance = 0.40 },
		{ name = "default:flint",     min = 1, max = 1, chance = 0.25 },
		{ name = "default:sand",      min = 1, max = 2, chance = 0.25 },
	},

	vfx = {
		hurt = { type = "bug_ichor_burst", count = 8, scale = 0.6 },
		death = {
			{ type = "bug_carapace", count = 12, scale = 1.0 },
			{ type = "bug_ichor_burst", count = 20, scale = 1.0 },
			{ type = "bug_wing_shreds", count = 8, scale = 1.0 },
		},
		despawn = { type = "bug_dissolve", scale = 1.0 },
	},

	can_flinch = false,

	-- Audio re-used from armored bug
	sounds = {
		distance = 16.0,
		attack = {name = "x_mobs_armored_bug_attack", gain = 0.7, pitch = 1.3},
		hurt = {name = "x_mobs_armored_bug", gain = 0.8, pitch = 1.2},
		death = {name = "x_mobs_armored_bug_death", gain = 1.0, pitch = 1.2},
	},

	swarm = {},

	-- All multi-track glTF animations mapped
	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		stand  = {track = "stand",  speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.2, loop = true},
		attack = {track = "attack", speed = 1.5, loop = false},
		death  = {track = "die",    speed = 1.0, loop = false},
		die    = {track = "die",    speed = 1.0, loop = false},
	},
})

-- Register natural spawns via x_mob_core (swarming mob, spawns 1 leader which spawns its pack)
x_mob_core.register_spawn("x_mobs:flying_insect", {
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
	chance = 6500,
	active_object_count = 3,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
})
