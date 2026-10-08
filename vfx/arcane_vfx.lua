--[[
	x_mobs - Arcane & Void Particle Systems (Spectrum & Elder)
	Void mist, energy trails, shadow orbs, claw strikes, elder fuse, explosions, and death bursts
--]]

local texpools = x_mobs.texpools
local SPECTRUM_SHROUD_TEXPOOL = texpools.SPECTRUM_SHROUD_TEXPOOL
local SPECTRUM_SPARK_TEXPOOL = texpools.SPECTRUM_SPARK_TEXPOOL
local SPECTRUM_GLYPH_TEXPOOL = texpools.SPECTRUM_GLYPH_TEXPOOL
local SPECTRUM_CLAW_TEXPOOL = texpools.SPECTRUM_CLAW_TEXPOOL
local SPECTRUM_SMOKE_TEXPOOL = texpools.SPECTRUM_SMOKE_TEXPOOL
local SPECTRUM_ORB_CORE_TEXPOOL = texpools.SPECTRUM_ORB_CORE_TEXPOOL
local SPECTRUM_WISP_TEXPOOL = texpools.SPECTRUM_WISP_TEXPOOL
local SPECTRUM_ASH_TEXPOOL = texpools.SPECTRUM_ASH_TEXPOOL
local ELDER_CLOTH_TEXPOOL = texpools.ELDER_CLOTH_TEXPOOL
local ELDER_CANE_TEXPOOL = texpools.ELDER_CANE_TEXPOOL
local ELDER_HAIR_TEXPOOL = texpools.ELDER_HAIR_TEXPOOL
local ELDER_SPARKS_TEXPOOL = texpools.ELDER_SPARKS_TEXPOOL
local ELDER_SMOKE_TEXPOOL = texpools.ELDER_SMOKE_TEXPOOL
local ELDER_BLAST_TEXPOOL = texpools.ELDER_BLAST_TEXPOOL
local ELDER_FLAME_TEXPOOL = texpools.ELDER_FLAME_TEXPOOL
local ELDER_DUST_TEXPOOL = texpools.ELDER_DUST_TEXPOOL

function x_mobs.spawn_spectrum_trail(pos)
	-- Ethereal rising wisps
	core.add_particlespawner({
		amount = 4,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y + 0.1, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.8, z = pos.z + 0.25},
		},
		vel = {min = {x = -0.15, y = 0.2, z = -0.15}, max = {x = 0.15, y = 0.6, z = 0.15}},
		acc = {min = {x = -0.05, y = 0.1, z = -0.05}, max = {x = 0.05, y = 0.3, z = 0.05}},
		jitter = {min = {x = -0.1, y = -0.05, z = -0.1}, max = {x = 0.1, y = 0.05, z = 0.1}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		size = {min = 1.2, max = 2.0},
		exptime = {min = 0.8, max = 1.4},
		glow = 6,
		texpool = SPECTRUM_WISP_TEXPOOL,
		minpos = {x = pos.x - 0.25, y = pos.y + 0.1, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.8, z = pos.z + 0.25},
		minvel = {x = -0.15, y = 0.2, z = -0.15},
		maxvel = {x = 0.15, y = 0.6, z = 0.15},
		minacc = {x = -0.05, y = 0.1, z = -0.05},
		maxacc = {x = 0.05, y = 0.3, z = 0.05},
		minsize = 1.2,
		maxsize = 2.0,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,6",
	})

	-- Glowing toxic lime demon sparks
	core.add_particlespawner({
		amount = 3,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.4, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 1.4, z = pos.z + 0.2},
		},
		vel = {min = {x = -0.2, y = 0.1, z = -0.2}, max = {x = 0.2, y = 0.5, z = 0.2}},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.2, z = 0}},
		size = {min = 1.0, max = 1.6},
		exptime = {min = 0.5, max = 0.9},
		glow = 12,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y + 0.4, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 1.4, z = pos.z + 0.2},
		minvel = {x = -0.2, y = 0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.5, z = 0.2},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.2, z = 0},
		minsize = 1.0,
		maxsize = 1.6,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns spell charge particles converging into the spectrum mob's hands
---@param pos Vector Position between hands
---@param _obj ObjectRef Spectrum mob object
function x_mobs.spawn_spectrum_shoot_charge(pos, _obj)
	-- Inward converging void glyph runes
	core.add_particlespawner({
		amount = 16,
		time = 0.4,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y - 0.4, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 0.4, z = pos.z + 0.8},
		},
		vel = {min = {x = -1.2, y = -0.5, z = -1.2}, max = {x = 1.2, y = 0.5, z = 1.2}},
		drag = {x = 0.8, y = 0.8, z = 0.8},
		jitter = {min = {x = -0.3, y = -0.3, z = -0.3}, max = {x = 0.3, y = 0.3, z = 0.3}},
		size = {min = 1.8, max = 2.8},
		exptime = {min = 0.4, max = 0.6},
		glow = 12,
		texpool = SPECTRUM_GLYPH_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y - 0.4, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 0.4, z = pos.z + 0.8},
		minvel = {x = -1.2, y = -0.5, z = -1.2},
		maxvel = {x = 1.2, y = 0.5, z = 1.2},
		minsize = 1.8,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.6,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,2",
	})

	-- Intense neon green core motes
	core.add_particlespawner({
		amount = 20,
		time = 0.4,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.3, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.3, z = pos.z + 0.4},
		},
		vel = {min = {x = -0.6, y = -0.3, z = -0.6}, max = {x = 0.6, y = 0.3, z = 0.6}},
		size = {min = 1.4, max = 2.2},
		exptime = {min = 0.3, max = 0.5},
		glow = 14,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y - 0.3, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.3, z = pos.z + 0.4},
		minvel = {x = -0.6, y = -0.3, z = -0.6},
		maxvel = {x = 0.6, y = 0.3, z = 0.6},
		minsize = 1.4,
		maxsize = 2.2,
		minexptime = 0.3,
		maxexptime = 0.5,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns projectile trail behind flying ectoplasmic orb
---@param pos Vector Position
---@param vel Vector Velocity vector
function x_mobs.spawn_spectrum_orb_trail(pos, vel)
	local v_opp = vector.multiply(vector.normalize(vel or {x = 0, y = 0, z = 0}), -0.5)

	-- Void smoke trail
	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
			max = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		},
		drag = {x = 0.5, y = 0.5, z = 0.5},
		size = {min = 2.0, max = 3.2},
		exptime = {min = 0.4, max = 0.7},
		glow = 8,
		texpool = SPECTRUM_SMOKE_TEXPOOL,
		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
		maxvel = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		minsize = 2.0,
		maxsize = 3.2,
		minexptime = 0.4,
		maxexptime = 0.7,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,4",
	})

	-- Radiant green demon sparks
	core.add_particlespawner({
		amount = 3,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
			max = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		},
		vel = {
			min = {x = v_opp.x - 0.3, y = v_opp.y - 0.3, z = v_opp.z - 0.3},
			max = {x = v_opp.x + 0.3, y = v_opp.y + 0.3, z = v_opp.z + 0.3},
		},
		size = {min = 1.4, max = 2.0},
		exptime = {min = 0.3, max = 0.5},
		glow = 14,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
		maxpos = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		minvel = {x = v_opp.x - 0.3, y = v_opp.y - 0.3, z = v_opp.z - 0.3},
		maxvel = {x = v_opp.x + 0.3, y = v_opp.y + 0.3, z = v_opp.z + 0.3},
		minsize = 1.4,
		maxsize = 2.0,
		minexptime = 0.3,
		maxexptime = 0.5,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns ectoplasmic orb impact burst on hit
---@param pos Vector Position
function x_mobs.spawn_spectrum_orb_impact(pos)
	-- Explosive void smoke burst
	core.add_particlespawner({
		amount = 24,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {min = {x = -2.5, y = -1.5, z = -2.5}, max = {x = 2.5, y = 2.5, z = 2.5}},
		drag = {x = 1.2, y = 1.2, z = 1.2},
		jitter = {min = {x = -0.5, y = -0.5, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5}},
		size = {min = 2.5, max = 4.5},
		exptime = {min = 0.6, max = 1.1},
		glow = 10,
		texpool = SPECTRUM_SMOKE_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -2.5, y = -1.5, z = -2.5},
		maxvel = {x = 2.5, y = 2.5, z = 2.5},
		minsize = 2.5,
		maxsize = 4.5,
		minexptime = 0.6,
		maxexptime = 1.1,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,4",
	})

	-- Ectoplasmic shroud shards
	core.add_particlespawner({
		amount = 18,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {min = {x = -3.2, y = 0.5, z = -3.2}, max = {x = 3.2, y = 3.5, z = 3.2}},
		acc = {min = {x = 0, y = -6.0, z = 0}, max = {x = 0, y = -9.0, z = 0}},
		bounce = 0.3,
		size = {min = 1.8, max = 3.0},
		exptime = {min = 0.7, max = 1.2},
		glow = 8,
		texpool = SPECTRUM_SHROUD_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -3.2, y = 0.5, z = -3.2},
		maxvel = {x = 3.2, y = 3.5, z = 3.2},
		minacc = {x = 0, y = -6.0, z = 0},
		maxacc = {x = 0, y = -9.0, z = 0},
		minsize = 1.8,
		maxsize = 3.0,
		minexptime = 0.7,
		maxexptime = 1.2,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,0",
	})

	-- Dazzling lime demon sparks
	core.add_particlespawner({
		amount = 26,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {min = {x = -4.0, y = -1.0, z = -4.0}, max = {x = 4.0, y = 4.0, z = 4.0}},
		drag = {x = 1.5, y = 1.5, z = 1.5},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.4, max = 0.8},
		glow = 14,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = -4.0, y = -1.0, z = -4.0},
		maxvel = {x = 4.0, y = 4.0, z = 4.0},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})

	-- Core collapsing void singularity flash
	core.add_particlespawner({
		amount = 8,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
			max = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		},
		vel = {min = {x = -0.5, y = -0.5, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5}},
		size = {min = 2.2, max = 3.6},
		exptime = {min = 0.2, max = 0.5},
		glow = 14,
		texpool = SPECTRUM_ORB_CORE_TEXPOOL,
		minpos = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
		maxpos = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		minvel = {x = -0.5, y = -0.5, z = -0.5},
		maxvel = {x = 0.5, y = 0.5, z = 0.5},
		minsize = 2.2,
		maxsize = 3.6,
		minexptime = 0.2,
		maxexptime = 0.5,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,5",
	})
end

--- Spawns phantom claw strike slash visual
---@param pos Vector Impact position
---@param dir Vector Attack direction
function x_mobs.spawn_spectrum_claw_strike(pos, dir)
	local d = vector.normalize(dir or {x = 0, y = 0, z = 1})

	-- Phantom crescent slash trails
	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		},
		vel = {
			min = {x = d.x * 2.0 - 0.8, y = -0.5, z = d.z * 2.0 - 0.8},
			max = {x = d.x * 3.5 + 0.8, y = 0.8, z = d.z * 3.5 + 0.8},
		},
		drag = {x = 1.0, y = 1.0, z = 1.0},
		size = {min = 3.0, max = 4.5},
		exptime = {min = 0.25, max = 0.45},
		glow = 12,
		texpool = SPECTRUM_CLAW_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		minvel = {x = d.x * 2.0 - 0.8, y = -0.5, z = d.z * 2.0 - 0.8},
		maxvel = {x = d.x * 3.5 + 0.8, y = 0.8, z = d.z * 3.5 + 0.8},
		minsize = 3.0,
		maxsize = 4.5,
		minexptime = 0.25,
		maxexptime = 0.45,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,3",
	})

	-- Toxic green slash embers
	core.add_particlespawner({
		amount = 12,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.3, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 1.1, z = pos.z + 0.2},
		},
		vel = {
			min = {x = d.x * 1.5 - 1.2, y = -0.6, z = d.z * 1.5 - 1.2},
			max = {x = d.x * 2.5 + 1.2, y = 0.9, z = d.z * 2.5 + 1.2},
		},
		size = {min = 1.4, max = 2.4},
		exptime = {min = 0.3, max = 0.6},
		glow = 14,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y + 0.3, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 1.1, z = pos.z + 0.2},
		minvel = {x = d.x * 1.5 - 1.2, y = -0.6, z = d.z * 1.5 - 1.2},
		maxvel = {x = d.x * 2.5 + 1.2, y = 0.9, z = d.z * 2.5 + 1.2},
		minsize = 1.4,
		maxsize = 2.4,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns kinetic damage flinch burst on spectrum mob
---@param pos Vector Position
function x_mobs.spawn_spectrum_hurt(pos)
	-- Ectoplasmic shroud tears
	core.add_particlespawner({
		amount = 12,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.3, z = pos.z + 0.3},
		},
		vel = {min = {x = -1.8, y = 0.4, z = -1.8}, max = {x = 1.8, y = 2.2, z = 1.8}},
		acc = {min = {x = 0, y = -4.0, z = 0}, max = {x = 0, y = -7.0, z = 0}},
		drag = {x = 0.6, y = 0.6, z = 0.6},
		size = {min = 1.6, max = 2.6},
		exptime = {min = 0.5, max = 0.9},
		glow = 8,
		texpool = SPECTRUM_SHROUD_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.3, z = pos.z + 0.3},
		minvel = {x = -1.8, y = 0.4, z = -1.8},
		maxvel = {x = 1.8, y = 2.2, z = 1.8},
		minacc = {x = 0, y = -4.0, z = 0},
		maxacc = {x = 0, y = -7.0, z = 0},
		minsize = 1.6,
		maxsize = 2.6,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,0",
	})

	-- Toxic pain embers
	core.add_particlespawner({
		amount = 14,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.4, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 1.2, z = pos.z + 0.2},
		},
		vel = {min = {x = -2.0, y = -0.5, z = -2.0}, max = {x = 2.0, y = 2.5, z = 2.0}},
		size = {min = 1.3, max = 2.2},
		exptime = {min = 0.35, max = 0.65},
		glow = 12,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y + 0.4, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 1.2, z = pos.z + 0.2},
		minvel = {x = -2.0, y = -0.5, z = -2.0},
		maxvel = {x = 2.0, y = 2.5, z = 2.0},
		minsize = 1.3,
		maxsize = 2.2,
		minexptime = 0.35,
		maxexptime = 0.65,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns dissolution death vortex when spectrum mob is slain
---@param pos Vector Position
function x_mobs.spawn_spectrum_death(pos)
	-- Ascending dissolution soul remnants & ash
	core.add_particlespawner({
		amount = 35,
		time = 1.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.5, z = pos.z + 0.4},
		},
		vel = {min = {x = -0.6, y = 1.2, z = -0.6}, max = {x = 0.6, y = 3.0, z = 0.6}},
		acc = {min = {x = -0.2, y = 0.4, z = -0.2}, max = {x = 0.2, y = 0.8, z = 0.2}},
		jitter = {min = {x = -0.3, y = -0.1, z = -0.3}, max = {x = 0.3, y = 0.1, z = 0.3}},
		size = {min = 2.2, max = 3.8},
		exptime = {min = 1.2, max = 2.2},
		glow = 10,
		texpool = SPECTRUM_ASH_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.5, z = pos.z + 0.4},
		minvel = {x = -0.6, y = 1.2, z = -0.6},
		maxvel = {x = 0.6, y = 3.0, z = 0.6},
		minacc = {x = -0.2, y = 0.4, z = -0.2},
		maxacc = {x = 0.2, y = 0.8, z = 0.2},
		minsize = 2.2,
		maxsize = 3.8,
		minexptime = 1.2,
		maxexptime = 2.2,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,7",
	})

	-- Dissolving void smoke cloud
	core.add_particlespawner({
		amount = 25,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		},
		vel = {min = {x = -0.8, y = 0.4, z = -0.8}, max = {x = 0.8, y = 1.8, z = 0.8}},
		drag = {x = 0.5, y = 0.5, z = 0.5},
		size = {min = 3.0, max = 5.5},
		exptime = {min = 1.0, max = 1.8},
		glow = 6,
		texpool = SPECTRUM_SMOKE_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		minvel = {x = -0.8, y = 0.4, z = -0.8},
		maxvel = {x = 0.8, y = 1.8, z = 0.8},
		minsize = 3.0,
		maxsize = 5.5,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,4",
	})

	-- Fading green soul sparks
	core.add_particlespawner({
		amount = 20,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.4, z = pos.z + 0.3},
		},
		vel = {min = {x = -1.2, y = 0.8, z = -1.2}, max = {x = 1.2, y = 2.5, z = 1.2}},
		size = {min = 1.4, max = 2.4},
		exptime = {min = 0.8, max = 1.5},
		glow = 14,
		texpool = SPECTRUM_SPARK_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.4, z = pos.z + 0.3},
		minvel = {x = -1.2, y = 0.8, z = -1.2},
		maxvel = {x = 1.2, y = 2.5, z = 1.2},
		minsize = 1.4,
		maxsize = 2.4,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	})
end


function x_mobs.spawn_elder_hurt(pos, scale)
	local s = scale or 1.0

	-- Cane splinters
	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.3 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 1.2 * s, z = pos.z + 0.25 * s},
		},
		vel = {min = {x = -2.2 * s, y = 1.0 * s, z = -2.2 * s}, max = {x = 2.2 * s, y = 3.5 * s, z = 2.2 * s}},
		acc = {min = {x = -0.2, y = -9.8, z = -0.2}, max = {x = 0.2, y = -9.8, z = 0.2}},
		drag = {x = 0.3, y = 0.1, z = 0.3},
		bounce = 0.25,
		size = {min = 1.0 * s, max = 2.2 * s},
		exptime = {min = 0.6, max = 1.2},
		collisiondetection = true,
		texpool = ELDER_CANE_TEXPOOL,
		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.3 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 1.2 * s, z = pos.z + 0.25 * s},
		minvel = {x = -2.2 * s, y = 1.0 * s, z = -2.2 * s},
		maxvel = {x = 2.2 * s, y = 3.5 * s, z = 2.2 * s},
		minacc = {x = -0.2, y = -9.8, z = -0.2},
		maxacc = {x = 0.2, y = -9.8, z = 0.2},
		minsize = 1.0 * s,
		maxsize = 2.2 * s,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,1",
	})

	-- Robe cloth fragments
	core.add_particlespawner({
		amount = 6,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2 * s, y = pos.y + 0.4 * s, z = pos.z - 0.2 * s},
			max = {x = pos.x + 0.2 * s, y = pos.y + 1.1 * s, z = pos.z + 0.2 * s},
		},
		vel = {min = {x = -1.5 * s, y = 0.8 * s, z = -1.5 * s}, max = {x = 1.5 * s, y = 2.4 * s, z = 1.5 * s}},
		acc = {min = {x = -0.1, y = -4.0, z = -0.1}, max = {x = 0.1, y = -2.0, z = 0.1}},
		drag = {x = 0.6, y = 0.4, z = 0.6},
		size = {min = 1.2 * s, max = 2.0 * s},
		exptime = {min = 0.8, max = 1.4},
		texpool = ELDER_CLOTH_TEXPOOL,
		minpos = {x = pos.x - 0.2 * s, y = pos.y + 0.4 * s, z = pos.z - 0.2 * s},
		maxpos = {x = pos.x + 0.2 * s, y = pos.y + 1.1 * s, z = pos.z + 0.2 * s},
		minvel = {x = -1.5 * s, y = 0.8 * s, z = -1.5 * s},
		maxvel = {x = 1.5 * s, y = 2.4 * s, z = 1.5 * s},
		minacc = {x = -0.1, y = -4.0, z = -0.1},
		maxacc = {x = 0.1, y = -2.0, z = 0.1},
		minsize = 1.2 * s,
		maxsize = 2.0 * s,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,0",
	})

	-- Soft beard tufts
	core.add_particlespawner({
		amount = 4,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.15 * s, y = pos.y + 1.0 * s, z = pos.z - 0.15 * s},
			max = {x = pos.x + 0.15 * s, y = pos.y + 1.5 * s, z = pos.z + 0.15 * s},
		},
		vel = {min = {x = -0.8 * s, y = 0.4 * s, z = -0.8 * s}, max = {x = 0.8 * s, y = 1.5 * s, z = 0.8 * s}},
		acc = {min = {x = -0.1, y = -1.5, z = -0.1}, max = {x = 0.1, y = -0.5, z = 0.1}},
		drag = {x = 0.8, y = 0.6, z = 0.8},
		size = {min = 1.2 * s, max = 1.8 * s},
		exptime = {min = 1.0, max = 1.8},
		texpool = ELDER_HAIR_TEXPOOL,
		minpos = {x = pos.x - 0.15 * s, y = pos.y + 1.0 * s, z = pos.z - 0.15 * s},
		maxpos = {x = pos.x + 0.15 * s, y = pos.y + 1.5 * s, z = pos.z + 0.15 * s},
		minvel = {x = -0.8 * s, y = 0.4 * s, z = -0.8 * s},
		maxvel = {x = 0.8 * s, y = 1.5 * s, z = 0.8 * s},
		minacc = {x = -0.1, y = -1.5, z = -0.1},
		maxacc = {x = 0.1, y = -0.5, z = 0.1},
		minsize = 1.2 * s,
		maxsize = 1.8 * s,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns fuse sparks and rising sulfur smoke puffs during ignition countdown
---@param pos Vector Center body position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_elder_fuse(pos, scale)
	local s = scale or 1.0

	-- High-intensity sparks
	core.add_particlespawner({
		amount = 6,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.6 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 1.4 * s, z = pos.z + 0.25 * s},
		},
		vel = {min = {x = -1.8 * s, y = 0.5 * s, z = -1.8 * s}, max = {x = 1.8 * s, y = 2.8 * s, z = 1.8 * s}},
		acc = {min = {x = -0.2, y = -5.0, z = -0.2}, max = {x = 0.2, y = -2.0, z = 0.2}},
		jitter = {min = {x = -0.5, y = -0.5, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5}},
		size = {min = 1.2 * s, max = 2.4 * s},
		exptime = {min = 0.35, max = 0.75},
		glow = 14,
		texpool = ELDER_SPARKS_TEXPOOL,
		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.6 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 1.4 * s, z = pos.z + 0.25 * s},
		minvel = {x = -1.8 * s, y = 0.5 * s, z = -1.8 * s},
		maxvel = {x = 1.8 * s, y = 2.8 * s, z = 1.8 * s},
		minacc = {x = -0.2, y = -5.0, z = -0.2},
		maxacc = {x = 0.2, y = -2.0, z = 0.2},
		minsize = 1.2 * s,
		maxsize = 2.4 * s,
		minexptime = 0.35,
		maxexptime = 0.75,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,3",
	})

	-- Rising sulfur smoke wisps
	core.add_particlespawner({
		amount = 4,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.2 * s, y = pos.y + 0.8 * s, z = pos.z - 0.2 * s},
			max = {x = pos.x + 0.2 * s, y = pos.y + 1.5 * s, z = pos.z + 0.2 * s},
		},
		vel = {min = {x = -0.4 * s, y = 0.8 * s, z = -0.4 * s}, max = {x = 0.4 * s, y = 1.8 * s, z = 0.4 * s}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		size = {min = 1.8 * s, max = 3.2 * s},
		exptime = {min = 0.8, max = 1.5},
		glow = 4,
		texpool = ELDER_SMOKE_TEXPOOL,
		minpos = {x = pos.x - 0.2 * s, y = pos.y + 0.8 * s, z = pos.z - 0.2 * s},
		maxpos = {x = pos.x + 0.2 * s, y = pos.y + 1.5 * s, z = pos.z + 0.2 * s},
		minvel = {x = -0.4 * s, y = 0.8 * s, z = -0.4 * s},
		maxvel = {x = 0.4 * s, y = 1.8 * s, z = 0.4 * s},
		minsize = 1.8 * s,
		maxsize = 3.2 * s,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns massive layered detonation VFX: central shockwave flash, expanding fireball, smoke, and debris
---@param pos Vector Center explosion position
---@param radius? number Blast radius (default: 3.0)
function x_mobs.spawn_elder_explode(pos, radius)
	local r = radius or 3.0

	-- 1. Blinding core shockwave flash
	core.add_particlespawner({
		amount = 12,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.0, z = pos.z + 0.3},
		},
		vel = {min = {x = -1.0, y = -0.5, z = -1.0}, max = {x = 1.0, y = 1.5, z = 1.0}},
		size = {min = r * 3.5, max = r * 6.0},
		exptime = {min = 0.25, max = 0.55},
		glow = 15,
		texpool = ELDER_BLAST_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.0, z = pos.z + 0.3},
		minvel = {x = -1.0, y = -0.5, z = -1.0},
		maxvel = {x = 1.0, y = 1.5, z = 1.0},
		minsize = r * 3.5,
		maxsize = r * 6.0,
		minexptime = 0.25,
		maxexptime = 0.55,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,5",
	})

	-- 2. Expanding fiery fireball debris
	core.add_particlespawner({
		amount = 32,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.4, z = pos.z + 0.5},
		},
		vel = {min = {x = -4.5, y = 1.0, z = -4.5}, max = {x = 4.5, y = 6.0, z = 4.5}},
		acc = {min = {x = -0.5, y = -6.0, z = -0.5}, max = {x = 0.5, y = -3.0, z = 0.5}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		size = {min = 2.2, max = 4.0},
		exptime = {min = 0.5, max = 1.2},
		glow = 14,
		texpool = ELDER_FLAME_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.4, z = pos.z + 0.5},
		minvel = {x = -4.5, y = 1.0, z = -4.5},
		maxvel = {x = 4.5, y = 6.0, z = 4.5},
		minacc = {x = -0.5, y = -6.0, z = -0.5},
		maxacc = {x = 0.5, y = -3.0, z = 0.5},
		minsize = 2.2,
		maxsize = 4.0,
		minexptime = 0.5,
		maxexptime = 1.2,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,6",
	})

	-- 3. Billowing dense smoke explosion cloud
	core.add_particlespawner({
		amount = 45,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.1, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 1.2, z = pos.z + 0.8},
		},
		vel = {min = {x = -3.5, y = 0.8, z = -3.5}, max = {x = 3.5, y = 4.5, z = 3.5}},
		acc = {min = {x = -0.2, y = 0.2, z = -0.2}, max = {x = 0.2, y = 0.8, z = 0.2}},
		drag = {x = 0.8, y = 0.5, z = 0.8},
		size = {min = 3.5, max = 6.5},
		exptime = {min = 1.4, max = 2.6},
		glow = 5,
		texpool = ELDER_SMOKE_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + 0.1, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 1.2, z = pos.z + 0.8},
		minvel = {x = -3.5, y = 0.8, z = -3.5},
		maxvel = {x = 3.5, y = 4.5, z = 3.5},
		minacc = {x = -0.2, y = 0.2, z = -0.2},
		maxacc = {x = 0.2, y = 0.8, z = 0.2},
		minsize = 3.5,
		maxsize = 6.5,
		minexptime = 1.4,
		maxexptime = 2.6,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,4",
	})

	-- 4. Flying earth dust and cane shards
	core.add_particlespawner({
		amount = 25,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		},
		vel = {min = {x = -5.0, y = 2.0, z = -5.0}, max = {x = 5.0, y = 7.0, z = 5.0}},
		acc = {min = {x = 0, y = -10.0, z = 0}, max = {x = 0, y = -10.0, z = 0}},
		bounce = 0.3,
		size = {min = 1.2, max = 2.6},
		exptime = {min = 1.0, max = 2.0},
		collisiondetection = true,
		texpool = ELDER_DUST_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		minvel = {x = -5.0, y = 2.0, z = -5.0},
		maxvel = {x = 5.0, y = 7.0, z = 5.0},
		minacc = {x = 0, y = -10.0, z = 0},
		maxacc = {x = 0, y = -10.0, z = 0},
		minsize = 1.2,
		maxsize = 2.6,
		minexptime = 1.0,
		maxexptime = 2.0,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,7",
	})
end

--- Spawns defeat collapse debris: dropped cane splinters and cloth scraps
---@param pos Vector Center body position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_elder_death(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 12,
		time = 0.5,
		pos = {
			min = {x = pos.x - 0.4 * s, y = pos.y + 0.1 * s, z = pos.z - 0.4 * s},
			max = {x = pos.x + 0.4 * s, y = pos.y + 0.8 * s, z = pos.z + 0.4 * s},
		},
		vel = {min = {x = -0.8 * s, y = 0.2 * s, z = -0.8 * s}, max = {x = 0.8 * s, y = 1.2 * s, z = 0.8 * s}},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		bounce = 0.2,
		size = {min = 1.2 * s, max = 2.2 * s},
		exptime = {min = 1.2, max = 2.2},
		collisiondetection = true,
		texpool = ELDER_CLOTH_TEXPOOL,
		minpos = {x = pos.x - 0.4 * s, y = pos.y + 0.1 * s, z = pos.z - 0.4 * s},
		maxpos = {x = pos.x + 0.4 * s, y = pos.y + 0.8 * s, z = pos.z + 0.4 * s},
		minvel = {x = -0.8 * s, y = 0.2 * s, z = -0.8 * s},
		maxvel = {x = 0.8 * s, y = 1.2 * s, z = 0.8 * s},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.2 * s,
		maxsize = 2.2 * s,
		minexptime = 1.2,
		maxexptime = 2.2,
		texture = "x_mobs_elder_particles.png^[sheet:8x8:0,0",
	})
end
