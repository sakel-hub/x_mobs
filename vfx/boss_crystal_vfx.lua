--[[
	x_mobs - Crystal Guardian Boss Particle Systems
	Crystal shard damage, ground smash wave, charge aura, regeneration sparkles, and death nova
--]]

local texpools = x_mobs.texpools
local CRYSTAL_SHARD_TEXPOOL = texpools.CRYSTAL_SHARD_TEXPOOL
local CRYSTAL_SMASH_WAVE_TEXPOOL = texpools.CRYSTAL_SMASH_WAVE_TEXPOOL
local CRYSTAL_ROCK_TEXPOOL = texpools.CRYSTAL_ROCK_TEXPOOL
local CRYSTAL_SPARKLE_TEXPOOL = texpools.CRYSTAL_SPARKLE_TEXPOOL
local CRYSTAL_DUST_TEXPOOL = texpools.CRYSTAL_DUST_TEXPOOL

local get_node_tile_texture = x_mobs.get_node_tile_texture

function x_mobs.spawn_crystal_damage(pos, count)
	if not pos then return end
	local num = count or 14
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -3.2, y = 1.0, z = -3.2},
			max = {x = 3.2, y = 4.2, z = 3.2},
		},
		acc = {
			min = {x = 0, y = -9.81, z = 0},
			max = {x = 0, y = -12.0, z = 0},
		},
		jitter = {
			min = {x = -0.5, y = -0.2, z = -0.5},
			max = {x = 0.5, y = 0.2, z = 0.5},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.5, max = 0.9},
		glow = 12,
		collisiondetection = true,
		collision_removal = false,
		texpool = CRYSTAL_SHARD_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		minvel = {x = -3.2, y = 1.0, z = -3.2},
		maxvel = {x = 3.2, y = 4.2, z = 3.2},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -12.0, z = 0},
		minexptime = 0.5,
		maxexptime = 0.9,
		minsize = 1.6,
		maxsize = 3.2,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,0",
	})
end


--- Spawns full ground smash wave with plane attractor and terrain debris mapping across radial area
---@param pos Vector Center ground impact position
---@param ground_node? table Optional sampled ground node {name = string, param2 = integer}
---@param radius? number Optional blast radius (default: 5.0)
function x_mobs.spawn_crystal_smash_wave(pos, ground_node, radius)
	if not pos then return end

	local rad = radius or 5.0
	local rad_factor = math.max(0.8, rad / 3.0)
	local h_vel = 4.8 * math.min(rad_factor, 1.45)

	local node_info = ground_node or x_mobs.sample_ground_node(pos)
	local node_name = (node_info and node_info.name) or "default:stone"
	local node_param2 = (node_info and node_info.param2) or 0
	local tile_tex = get_node_tile_texture(node_name)

	-- 1. Expanding Ground Shockwave Disc (Attracted to Ground Plane)
	core.add_particlespawner({
		amount = math.floor(48 * (rad_factor > 1.0 and 1.25 or 1.0)),
		time = 0.22,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.05, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.2, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -h_vel, y = 0.02, z = -h_vel},
			max = {x = h_vel, y = 0.25, z = h_vel},
		},
		acc = {
			min = {x = 0, y = -1.0, z = 0},
			max = {x = 0, y = -2.0, z = 0},
		},
		attract = {
			kind = "plane",
			origin = {x = pos.x, y = pos.y + 0.05, z = pos.z},
			direction = {x = 0, y = 1, z = 0},
			strength = 5.0,
			die_on_contact = false,
		},
		drag = {
			min = {x = 0.3, y = 0.1, z = 0.3},
			max = {x = 0.6, y = 0.2, z = 0.6},
		},
		size = {min = 2.4, max = 4.6},
		exptime = {min = 0.65, max = 0.85},
		glow = 14,
		collisiondetection = false,
		texpool = CRYSTAL_SMASH_WAVE_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.05, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.2, z = pos.z + 0.4},
		minvel = {x = -h_vel, y = 0.02, z = -h_vel},
		maxvel = {x = h_vel, y = 0.25, z = h_vel},
		minacc = {x = 0, y = -1.0, z = 0},
		maxacc = {x = 0, y = -2.0, z = 0},
		minexptime = 0.65,
		maxexptime = 0.85,
		minsize = 2.4,
		maxsize = 4.6,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,1",
	})

	-- 2. Heavy Erupting Basalt Debris and Amethyst Spikes (Upward Kinetic Pop with Bounce)
	core.add_particlespawner({
		amount = 35,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -3.8, y = 3.2, z = -3.8},
			max = {x = 3.8, y = 6.8, z = 3.8},
		},
		acc = {
			min = {x = 0, y = -11.0, z = 0},
			max = {x = 0, y = -14.0, z = 0},
		},
		jitter = {
			min = {x = -0.8, y = -0.4, z = -0.8},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		bounce = {min = 0.2, max = 0.45},
		size = {min = 2.0, max = 4.2},
		exptime = {min = 0.7, max = 1.2},
		glow = 12,
		collisiondetection = true,
		collision_removal = false,
		texpool = CRYSTAL_ROCK_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5},
		minvel = {x = -3.8, y = 3.2, z = -3.8},
		maxvel = {x = 3.8, y = 6.8, z = 3.8},
		minacc = {x = 0, y = -11.0, z = 0},
		maxacc = {x = 0, y = -14.0, z = 0},
		minexptime = 0.7,
		maxexptime = 1.2,
		minsize = 2.0,
		maxsize = 4.2,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,2",
	})

	-- 3. Terrain Debris Mapping (Physical Node Fragments Erupting from Struck Ground)
	core.add_particlespawner({
		amount = 40,
		time = 0.22,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.35, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -4.2, y = 3.6, z = -4.2},
			max = {x = 4.2, y = 7.2, z = 4.2},
		},
		acc = {
			min = {x = 0, y = -12.0, z = 0},
			max = {x = 0, y = -16.0, z = 0},
		},
		jitter = {
			min = {x = -0.8, y = -0.4, z = -0.8},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		bounce = {min = 0.25, max = 0.50},
		size = {min = 1.8, max = 3.8},
		exptime = {min = 0.75, max = 1.3},
		glow = 6,
		collisiondetection = true,
		collision_removal = false,
		node = {name = node_name, param2 = node_param2},
		node_tile = 1,
		texture = tile_tex,
		texpool = {
			{
				name = tile_tex,
				scale_tween = {1.2, 0.45},
				alpha_tween = {1.0, 0.0, start = 0.65},
			},
		},

		minpos = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.35, z = pos.z + 0.5},
		minvel = {x = -4.2, y = 3.6, z = -4.2},
		maxvel = {x = 4.2, y = 7.2, z = 4.2},
		minacc = {x = 0, y = -12.0, z = 0},
		maxacc = {x = 0, y = -16.0, z = 0},
		minexptime = 0.75,
		maxexptime = 1.3,
		minsize = 1.8,
		maxsize = 3.8,
	})

	-- 4. Billowing Ground Shock Dust Clouds along Perimeter
	core.add_particlespawner({
		amount = 26,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.1, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 0.4, z = pos.z + 0.8},
		},
		vel = {
			min = {x = -3.5, y = 0.4, z = -3.5},
			max = {x = 3.5, y = 1.4, z = 3.5},
		},
		acc = {
			min = {x = 0, y = -0.5, z = 0},
			max = {x = 0, y = -1.2, z = 0},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.4, y = 0.5, z = 1.4},
		},
		size = {min = 3.0, max = 5.5},
		exptime = {min = 0.8, max = 1.3},
		glow = 8,
		collisiondetection = false,
		texpool = CRYSTAL_DUST_TEXPOOL,

		minpos = {x = pos.x - 0.8, y = pos.y + 0.1, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 0.4, z = pos.z + 0.8},
		minvel = {x = -3.5, y = 0.4, z = -3.5},
		maxvel = {x = 3.5, y = 1.4, z = 3.5},
		minacc = {x = 0, y = -0.5, z = 0},
		maxacc = {x = 0, y = -1.2, z = 0},
		minexptime = 0.8,
		maxexptime = 1.3,
		minsize = 3.0,
		maxsize = 5.5,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,4",
	})

	-- 5. Epicenter Radiant Amethyst Flash
	core.add_particlespawner({
		amount = 12,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.6, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -1.0, y = 0.5, z = -1.0},
			max = {x = 1.0, y = 2.0, z = 1.0},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		size = {min = 3.5, max = 6.0},
		exptime = {min = 0.35, max = 0.55},
		glow = 14,
		collisiondetection = false,
		texpool = CRYSTAL_SPARKLE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.6, z = pos.z + 0.2},
		minvel = {x = -1.0, y = 0.5, z = -1.0},
		maxvel = {x = 1.0, y = 2.0, z = 1.0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 0.35,
		maxexptime = 0.55,
		minsize = 3.5,
		maxsize = 6.0,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns charging crystal motes converging on fists during ground smash windup
---@param pos Vector Fist/chest charge center
---@param obj? ObjectRef Guardian entity
function x_mobs.spawn_crystal_smash_charge(pos, obj)
	if not pos then return end
	core.add_particlespawner({
		amount = 20,
		time = 0.8,
		attached = obj,
		pos = {
			min = {x = -1.2, y = 1.2, z = -1.2},
			max = {x = 1.2, y = 2.4, z = 1.2},
		},
		vel = {
			min = {x = -0.5, y = -0.2, z = -0.5},
			max = {x = 0.5, y = 0.2, z = 0.5},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		attract = {
			kind = "point",
			origin = {x = 0, y = 1.8, z = 0.4},
			origin_attached = obj,
			strength = 3.5,
			die_on_contact = false,
		},
		jitter = {
			min = {x = -0.6, y = -0.6, z = -0.6},
			max = {x = 0.6, y = 0.6, z = 0.6},
		},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.5, max = 0.8},
		glow = 14,
		collisiondetection = false,
		texpool = CRYSTAL_SPARKLE_TEXPOOL,

		minpos = {x = -1.2, y = 1.2, z = -1.2},
		maxpos = {x = 1.2, y = 2.4, z = 1.2},
		minvel = {x = -0.5, y = -0.2, z = -0.5},
		maxvel = {x = 0.5, y = 0.2, z = 0.5},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 0.5,
		maxexptime = 0.8,
		minsize = 1.5,
		maxsize = 2.8,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns soothing amethyst crystal sparkles rising around entity during health regeneration
---@param obj ObjectRef Guardian object reference
function x_mobs.spawn_crystal_regen(obj)
	if not obj or not obj:is_valid() then return end
	local p_min = {x = -0.6, y = 0.4, z = -0.6}
	local p_max = {x = 0.6, y = 1.8, z = 0.6}
	local v_min = {x = -0.15, y = 0.35, z = -0.15}
	local v_max = {x = 0.15, y = 0.85, z = 0.15}
	core.add_particlespawner({
		amount = 5,
		time = 0.3,
		attached = obj,
		pos = {min = p_min, max = p_max},
		vel = {min = v_min, max = v_max},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.3, z = 0}},
		jitter = {min = {x = -0.3, y = -0.1, z = -0.3}, max = {x = 0.3, y = 0.1, z = 0.3}},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 1.0, max = 1.5},
		glow = 12,
		collisiondetection = false,
		texpool = CRYSTAL_SPARKLE_TEXPOOL,

		minpos = p_min,
		maxpos = p_max,
		minvel = v_min,
		maxvel = v_max,
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.3, z = 0},
		minexptime = 1.0,
		maxexptime = 1.5,
		minsize = 1.8,
		maxsize = 3.2,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns massive death shatter of basalt boulders, crystal shards, and resonant dust
---@param pos Vector Center death position
function x_mobs.spawn_crystal_death(pos)
	if not pos then return end

	-- 1. Exploding Basalt Stone Chunks (Heavy debris with gravity and bounce)
	core.add_particlespawner({
		amount = 45,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.3, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 1.8, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -4.5, y = 2.0, z = -4.5},
			max = {x = 4.5, y = 6.5, z = 4.5},
		},
		acc = {
			min = {x = 0, y = -10.0, z = 0},
			max = {x = 0, y = -14.0, z = 0},
		},
		bounce = {min = 0.25, max = 0.5},
		size = {min = 2.5, max = 4.8},
		exptime = {min = 1.2, max = 2.0},
		glow = 8,
		collisiondetection = true,
		collision_removal = false,
		texpool = CRYSTAL_ROCK_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y + 0.3, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 1.8, z = pos.z + 0.6},
		minvel = {x = -4.5, y = 2.0, z = -4.5},
		maxvel = {x = 4.5, y = 6.5, z = 4.5},
		minacc = {x = 0, y = -10.0, z = 0},
		maxacc = {x = 0, y = -14.0, z = 0},
		minexptime = 1.2,
		maxexptime = 2.0,
		minsize = 2.5,
		maxsize = 4.8,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,2",
	})

	-- 2. Shimmering Crystal Shard Nova
	core.add_particlespawner({
		amount = 40,
		time = 0.3,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -5.0, y = 1.5, z = -5.0},
			max = {x = 5.0, y = 5.5, z = 5.0},
		},
		acc = {
			min = {x = 0, y = -8.0, z = 0},
			max = {x = 0, y = -11.0, z = 0},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 2.0, max = 3.8},
		exptime = {min = 1.0, max = 1.8},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texpool = CRYSTAL_SHARD_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		minvel = {x = -5.0, y = 1.5, z = -5.0},
		maxvel = {x = 5.0, y = 5.5, z = 5.0},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -11.0, z = 0},
		minexptime = 1.0,
		maxexptime = 1.8,
		minsize = 2.0,
		maxsize = 3.8,
		texture = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,0",
	})

	-- 3. Billowing Death Vapor & Crystalline Dust Poof
	core.add_particlespawner({
		amount = 30,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 1.5, z = pos.z + 0.8},
		},
		vel = {
			min = {x = -2.2, y = 0.5, z = -2.2},
			max = {x = 2.2, y = 2.0, z = 2.2},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.4, z = 0}},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		size = {min = 3.5, max = 6.0},
		exptime = {min = 1.2, max = 2.2},
		glow = 10,
		collisiondetection = false,
		texpool = CRYSTAL_DUST_TEXPOOL,

		minpos = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 1.5, z = pos.z + 0.8},
		minvel = {x = -2.2, y = 0.5, z = -2.2},
		maxvel = {x = 2.2, y = 2.0, z = 2.2},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.4, z = 0},
		minexptime = 1.2,
		maxexptime = 2.2,
		minsize = 3.5,
		maxsize = 6.0,
	})
end

