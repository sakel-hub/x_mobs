--[[
	x_mobs - Void Strider Particle Systems & Visual Effects
	Author: SaKeL
	License: MIT

	Cosmic rift sparks, ethereal void tendrils, dimensional fracture shards,
	singularity accretion rings, spatial warp glitch blocks, and concussive void beams.
--]]

local texpools = x_mobs.texpools
local SPARK_TEXPOOL = texpools.VOID_STRIDER_SPARK_TEXPOOL
local TENDRIL_TEXPOOL = texpools.VOID_STRIDER_TENDRIL_TEXPOOL
local SHARD_TEXPOOL = texpools.VOID_STRIDER_SHARD_TEXPOOL
local NEBULA_TEXPOOL = texpools.VOID_STRIDER_NEBULA_TEXPOOL
local RING_TEXPOOL = texpools.VOID_STRIDER_RING_TEXPOOL
local GLITCH_TEXPOOL = texpools.VOID_STRIDER_GLITCH_TEXPOOL
local WAVE_TEXPOOL = texpools.VOID_STRIDER_WAVE_TEXPOOL
local VORTEX_TEXPOOL = texpools.VOID_STRIDER_VORTEX_TEXPOOL

--- Spawns eerie ambient levitation stardust and gravity sparks beneath Void Strider
---@param pos Vector Mob base coordinate
function x_mobs.spawn_void_strider_hover(pos)
	core.add_particlespawner({
		amount = 4,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.8, z = pos.z + 0.35},
		},
		vel = {
			min = {x = -0.2, y = -0.3, z = -0.2},
			max = {x = 0.2, y = 0.3, z = 0.2},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.3, z = 0}},
		drag = {min = {x = 0.8, y = 0.8, z = 0.8}, max = {x = 1.2, y = 1.2, z = 1.2}},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.6, max = 1.2},
		glow = 12,
		collisiondetection = false,
		texpool = NEBULA_TEXPOOL,

		minpos = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.8, z = pos.z + 0.35},
		minvel = {x = -0.2, y = -0.3, z = -0.2},
		maxvel = {x = 0.2, y = 0.3, z = 0.2},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.3, z = 0},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns razor dimensional scissor slash (crystals, void tendrils, glitch noise)
---@param pos Vector Impact coordinate
---@param dir Vector Slash forward vector
function x_mobs.spawn_void_strider_scissor_slash(pos, dir)
	local d = dir or {x = 0, y = 0, z = 1}

	-- Dimensional crystal shards
	core.add_particlespawner({
		amount = 14,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = d.x * 2.0 - 2.5, y = 1.0, z = d.z * 2.0 - 2.5},
			max = {x = d.x * 3.5 + 2.5, y = 3.5, z = d.z * 3.5 + 2.5},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {min = {x = 0.3, y = 0.2, z = 0.3}, max = {x = 0.7, y = 0.3, z = 0.7}},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.6, max = 2.8},
		exptime = {min = 0.35, max = 0.75},
		glow = 13,
		collisiondetection = true,
		collision_removal = false,
		texpool = SHARD_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = d.x * 2.0 - 2.5, y = 1.0, z = d.z * 2.0 - 2.5},
		maxvel = {x = d.x * 3.5 + 2.5, y = 3.5, z = d.z * 3.5 + 2.5},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.6,
		maxsize = 2.8,
		minexptime = 0.35,
		maxexptime = 0.75,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,2",
	})

	-- Spatial glitch fragments
	core.add_particlespawner({
		amount = 10,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -1.8, y = 0.5, z = -1.8},
			max = {x = 1.8, y = 2.5, z = 1.8},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		drag = {min = {x = 1.0, y = 1.0, z = 1.0}, max = {x = 1.5, y = 1.5, z = 1.5}},
		size = {min = 1.5, max = 2.6},
		exptime = {min = 0.25, max = 0.55},
		glow = 14,
		collisiondetection = false,
		texpool = GLITCH_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = -1.8, y = 0.5, z = -1.8},
		maxvel = {x = 1.8, y = 2.5, z = 1.8},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.5,
		maxsize = 2.6,
		minexptime = 0.25,
		maxexptime = 0.55,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,5",
	})

	-- Ethereal void tendrils
	core.add_particlespawner({
		amount = 8,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		},
		vel = {
			min = {x = d.x * 1.5 - 1.2, y = 0.2, z = d.z * 1.5 - 1.2},
			max = {x = d.x * 2.5 + 1.2, y = 1.8, z = d.z * 2.5 + 1.2},
		},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.5, z = 0}},
		drag = {min = {x = 0.8, y = 0.8, z = 0.8}, max = {x = 1.2, y = 1.2, z = 1.2}},
		jitter = {min = {x = -0.5, y = -0.5, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5}},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 0.3, max = 0.65},
		glow = 13,
		collisiondetection = false,
		texpool = TENDRIL_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		minvel = {x = d.x * 1.5 - 1.2, y = 0.2, z = d.z * 1.5 - 1.2},
		maxvel = {x = d.x * 2.5 + 1.2, y = 1.8, z = d.z * 2.5 + 1.2},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.5, z = 0},
		minsize = 1.8,
		maxsize = 3.2,
		minexptime = 0.3,
		maxexptime = 0.65,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns concussive void beam windup / energy gathering at jaw
---@param pos Vector Jaw coordinate
function x_mobs.spawn_void_strider_beam_charge(pos)
	core.add_particlespawner({
		amount = 14,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y - 0.4, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -0.5, y = -0.3, z = -0.5},
			max = {x = 0.5, y = 0.3, z = 0.5},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.3, max = 0.6},
		glow = 14,
		collisiondetection = false,
		texpool = RING_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y - 0.4, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		minvel = {x = -0.5, y = -0.3, z = -0.5},
		maxvel = {x = 0.5, y = 0.3, z = 0.5},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns directed linear concussive void beam discharge
---@param start_pos Vector Beam origin
---@param dir Vector Beam trajectory
---@param dist number Trajectory length in nodes
function x_mobs.spawn_void_strider_beam_burst(start_pos, dir, dist)
	local d = vector.normalize(dir)
	local steps = math.floor(dist * 2.5)

	for i = 1, steps do
		local p = vector.add(start_pos, vector.multiply(d, (i / 2.5)))
		core.add_particlespawner({
			amount = 3,
			time = 0.05,
			pos = {
				min = {x = p.x - 0.15, y = p.y - 0.15, z = p.z - 0.15},
				max = {x = p.x + 0.15, y = p.y + 0.15, z = p.z + 0.15},
			},
			vel = {
				min = {x = d.x * 2.0 - 0.3, y = d.y * 2.0 - 0.3, z = d.z * 2.0 - 0.3},
				max = {x = d.x * 3.5 + 0.3, y = d.y * 3.5 + 0.3, z = d.z * 3.5 + 0.3},
			},
			acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
			size = {min = 2.0, max = 4.2},
			exptime = {min = 0.25, max = 0.55},
			glow = 14,
			collisiondetection = false,
			texpool = WAVE_TEXPOOL,

			minpos = {x = p.x - 0.15, y = p.y - 0.15, z = p.z - 0.15},
			maxpos = {x = p.x + 0.15, y = p.y + 0.15, z = p.z + 0.15},
			minvel = {x = d.x * 2.0 - 0.3, y = d.y * 2.0 - 0.3, z = d.z * 2.0 - 0.3},
			maxvel = {x = d.x * 3.5 + 0.3, y = d.y * 3.5 + 0.3, z = d.z * 3.5 + 0.3},
			minacc = {x = 0, y = 0, z = 0},
			maxacc = {x = 0, y = 0, z = 0},
			minsize = 2.0,
			maxsize = 4.2,
			minexptime = 0.25,
			maxexptime = 0.55,
			texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,6",
		})
	end
end

--- Spawns void beam impact explosion & dimensional distortion
---@param pos Vector Impact coordinate
function x_mobs.spawn_void_strider_beam_impact(pos)
	-- Accretion rings
	core.add_particlespawner({
		amount = 16,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -3.0, y = 0.5, z = -3.0},
			max = {x = 3.0, y = 3.5, z = 3.0},
		},
		acc = {min = {x = 0, y = -4.0, z = 0}, max = {x = 0, y = -2.0, z = 0}},
		drag = {min = {x = 0.6, y = 0.3, z = 0.6}, max = {x = 1.0, y = 0.5, z = 1.0}},
		size = {min = 2.2, max = 4.6},
		exptime = {min = 0.4, max = 0.9},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texpool = RING_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y + 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		minvel = {x = -3.0, y = 0.5, z = -3.0},
		maxvel = {x = 3.0, y = 3.5, z = 3.0},
		minacc = {x = 0, y = -4.0, z = 0},
		maxacc = {x = 0, y = -2.0, z = 0},
		minsize = 2.2,
		maxsize = 4.6,
		minexptime = 0.4,
		maxexptime = 0.9,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,4",
	})

	-- Expanding cosmic nebula
	core.add_particlespawner({
		amount = 18,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.6, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -1.5, y = 0.3, z = -1.5},
			max = {x = 1.5, y = 1.5, z = 1.5},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.2, z = 0}},
		drag = {min = {x = 0.8, y = 0.5, z = 0.8}, max = {x = 1.4, y = 0.8, z = 1.4}},
		size = {min = 2.5, max = 5.2},
		exptime = {min = 0.8, max = 1.8},
		glow = 12,
		collisiondetection = false,
		texpool = NEBULA_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.6, z = pos.z + 0.3},
		minvel = {x = -1.5, y = 0.3, z = -1.5},
		maxvel = {x = 1.5, y = 1.5, z = 1.5},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.2, z = 0},
		minsize = 2.5,
		maxsize = 5.2,
		minexptime = 0.8,
		maxexptime = 1.8,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns void warp step departure (black hole implosion vortex)
---@param pos Vector Departure position
function x_mobs.spawn_void_strider_teleport_out(pos)
	core.add_particlespawner({
		amount = 20,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 2.2, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -0.5, y = -0.5, z = -0.5},
			max = {x = 0.5, y = 0.5, z = 0.5},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		drag = {min = {x = 1.2, y = 1.2, z = 1.2}, max = {x = 1.8, y = 1.8, z = 1.8}},
		size = {min = 2.4, max = 4.8},
		exptime = {min = 0.35, max = 0.75},
		glow = 14,
		collisiondetection = false,
		texpool = VORTEX_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 2.2, z = pos.z + 0.5},
		minvel = {x = -0.5, y = -0.5, z = -0.5},
		maxvel = {x = 0.5, y = 0.5, z = 0.5},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 2.4,
		maxsize = 4.8,
		minexptime = 0.35,
		maxexptime = 0.75,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,7",
	})
end

--- Spawns void warp step arrival (spatial flash & shockwave ring)
---@param pos Vector Arrival position
function x_mobs.spawn_void_strider_teleport_in(pos)
	core.add_particlespawner({
		amount = 16,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.8, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -2.5, y = -0.5, z = -2.5},
			max = {x = 2.5, y = 2.0, z = 2.5},
		},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -1.0, z = 0}},
		drag = {min = {x = 0.6, y = 0.4, z = 0.6}, max = {x = 1.0, y = 0.6, z = 1.0}},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.3, max = 0.65},
		glow = 14,
		collisiondetection = false,
		texpool = SPARK_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.8, z = pos.z + 0.3},
		minvel = {x = -2.5, y = -0.5, z = -2.5},
		maxvel = {x = 2.5, y = 2.0, z = 2.5},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -1.0, z = 0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.3,
		maxexptime = 0.65,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns cosmic death collapse (singularity implosion, crystal shatter, fading nebula)
---@param pos Vector Mob corpse position
function x_mobs.spawn_void_strider_death(pos)
	-- Crystal shards shattering
	core.add_particlespawner({
		amount = 24,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 2.0, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -3.5, y = 1.5, z = -3.5},
			max = {x = 3.5, y = 4.5, z = 3.5},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {min = {x = 0.3, y = 0.2, z = 0.3}, max = {x = 0.7, y = 0.3, z = 0.7}},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 13,
		collisiondetection = true,
		collision_removal = false,
		texpool = SHARD_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 2.0, z = pos.z + 0.4},
		minvel = {x = -3.5, y = 1.5, z = -3.5},
		maxvel = {x = 3.5, y = 4.5, z = 3.5},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,2",
	})

	-- Deep void collapse vortex
	core.add_particlespawner({
		amount = 20,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 2.2, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -0.8, y = -0.5, z = -0.8},
			max = {x = 0.8, y = 0.5, z = 0.8},
		},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		drag = {min = {x = 1.2, y = 1.2, z = 1.2}, max = {x = 1.8, y = 1.8, z = 1.8}},
		size = {min = 2.6, max = 5.5},
		exptime = {min = 0.8, max = 1.6},
		glow = 14,
		collisiondetection = false,
		texpool = VORTEX_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 2.2, z = pos.z + 0.6},
		minvel = {x = -0.8, y = -0.5, z = -0.8},
		maxvel = {x = 0.8, y = 0.5, z = 0.8},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 2.6,
		maxsize = 5.5,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_void_strider_particles.png^[sheet:8x8:0,7",
	})
end
