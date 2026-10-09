--[[
	x_mobs - Glowler Particle Systems & Visual FX
	Author: SaKeL
	License: MIT

	Modular particle systems for the Glowler dragon and its swarm minions:
	- Bioluminescent plasma projectile trails & radial impact explosions
	- Unique 20% Supernova Nova starbursts & solar flare blast shockwaves
	- Draconic summon / resurrection ritual runes & cocoon hatching bursts
	- Basalt obsidian scale shatter for damage taken
	- Ethereal soul wisp dissolution for mortal defeat
--]]

local texpools = x_mobs.texpools
local GLOWLER_PLASMA_TEXPOOL    = texpools.GLOWLER_PLASMA_TEXPOOL
local GLOWLER_RUNES_TEXPOOL     = texpools.GLOWLER_RUNES_TEXPOOL
local GLOWLER_FLAMES_TEXPOOL    = texpools.GLOWLER_FLAMES_TEXPOOL
local GLOWLER_SUPERNOVA_TEXPOOL = texpools.GLOWLER_SUPERNOVA_TEXPOOL
local GLOWLER_SCALE_TEXPOOL     = texpools.GLOWLER_SCALE_TEXPOOL
local GLOWLER_WISPS_TEXPOOL     = texpools.GLOWLER_WISPS_TEXPOOL
local GLOWLER_SHOCKWAVE_TEXPOOL = texpools.GLOWLER_SHOCKWAVE_TEXPOOL
local GLOWLER_COCOON_TEXPOOL    = texpools.GLOWLER_COCOON_TEXPOOL

--- Spawns draconic minion resurrection & hatching visual burst
---@param pos Vector Center ground/spawn position
function x_mobs.spawn_glowler_summon_burst(pos)
	-- 1. Expanding draconic summoning runes
	core.add_particlespawner({
		amount = 12,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.9, z = pos.z + 0.6},
		},
		vel = {min = {x = -0.6, y = 0.5, z = -0.6}, max = {x = 0.6, y = 1.6, z = 0.6}},
		acc = {min = {x = -0.1, y = 0.2, z = -0.1}, max = {x = 0.1, y = 0.5, z = 0.1}},
		jitter = {min = {x = -0.3, y = -0.2, z = -0.3}, max = {x = 0.3, y = 0.2, z = 0.3}},
		drag = {x = 0.3, y = 0.2, z = 0.3},
		size = {min = 1.8, max = 3.4},
		exptime = {min = 1.0, max = 1.8},
		glow = 14,
		texpool = GLOWLER_RUNES_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.9, z = pos.z + 0.6},
		minvel = {x = -0.6, y = 0.5, z = -0.6},
		maxvel = {x = 0.6, y = 1.6, z = 0.6},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.5, z = 0.1},
		minsize = 1.8,
		maxsize = 3.4,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,1",
	})

	-- 2. Hatching insectoid cocoon embers & spores
	core.add_particlespawner({
		amount = 16,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		},
		vel = {min = {x = -1.5, y = 1.0, z = -1.5}, max = {x = 1.5, y = 2.8, z = 1.5}},
		acc = {min = {x = 0, y = -5.0, z = 0}, max = {x = 0, y = -7.0, z = 0}},
		bounce = 0.4,
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.8, max = 1.4},
		glow = 10,
		texpool = GLOWLER_COCOON_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		minvel = {x = -1.5, y = 1.0, z = -1.5},
		maxvel = {x = 1.5, y = 2.8, z = 1.5},
		minacc = {x = 0, y = -5.0, z = 0},
		maxacc = {x = 0, y = -7.0, z = 0},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,7",
	})

	-- 3. Radiant ground shockwave flash
	core.add_particlespawner({
		amount = 6,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		},
		vel = {min = {x = -0.2, y = 0.1, z = -0.2}, max = {x = 0.2, y = 0.3, z = 0.2}},
		size = {min = 3.0, max = 5.0},
		exptime = {min = 0.6, max = 1.0},
		glow = 14,
		texpool = GLOWLER_SHOCKWAVE_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y + 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		minvel = {x = -0.2, y = 0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.3, z = 0.2},
		minsize = 3.0,
		maxsize = 5.0,
		minexptime = 0.6,
		maxexptime = 1.0,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns plasma fireball flight trail particles
---@param pos Vector Center projectile position
---@param vel? Vector Projectile velocity vector
function x_mobs.spawn_glowler_plasma_trail(pos, vel)
	local v_opp = vel and {x = -vel.x * 0.12, y = -vel.y * 0.12, z = -vel.z * 0.12} or {x = 0, y = 0, z = 0}

	-- Core plasma motes
	core.add_particlespawner({
		amount = 4,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.18, y = pos.y - 0.18, z = pos.z - 0.18},
			max = {x = pos.x + 0.18, y = pos.y + 0.18, z = pos.z + 0.18},
		},
		vel = {
			min = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
			max = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		},
		jitter = {min = {x = -0.2, y = -0.2, z = -0.2}, max = {x = 0.2, y = 0.2, z = 0.2}},
		drag = {x = 0.4, y = 0.4, z = 0.4},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.4, max = 0.8},
		glow = 14,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		minpos = {x = pos.x - 0.18, y = pos.y - 0.18, z = pos.z - 0.18},
		maxpos = {x = pos.x + 0.18, y = pos.y + 0.18, z = pos.z + 0.18},
		minvel = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
		maxvel = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	})

	-- Trailing flame puffs
	core.add_particlespawner({
		amount = 3,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = v_opp.x - 0.15, y = v_opp.y - 0.15, z = v_opp.z - 0.15},
			max = {x = v_opp.x + 0.15, y = v_opp.y + 0.15, z = v_opp.z + 0.15},
		},
		drag = {x = 0.5, y = 0.5, z = 0.5},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.5, max = 0.9},
		glow = 12,
		texpool = GLOWLER_FLAMES_TEXPOOL,
		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = v_opp.x - 0.15, y = v_opp.y - 0.15, z = v_opp.z - 0.15},
		maxvel = {x = v_opp.x + 0.15, y = v_opp.y + 0.15, z = v_opp.z + 0.15},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns plasma fireball detonation impact VFX
---@param pos Vector Impact coordinate
function x_mobs.spawn_glowler_plasma_impact(pos)
	-- Radial plasma explosion
	core.add_particlespawner({
		amount = 16,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {min = {x = -2.4, y = -1.2, z = -2.4}, max = {x = 2.4, y = 2.6, z = 2.4}},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -4.0, z = 0}},
		drag = {x = 0.4, y = 0.4, z = 0.4},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 14,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = -2.4, y = -1.2, z = -2.4},
		maxvel = {x = 2.4, y = 2.6, z = 2.4},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -4.0, z = 0},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	})

	-- Shockwave ring
	core.add_particlespawner({
		amount = 6,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
			max = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		},
		vel = {min = {x = -0.2, y = -0.1, z = -0.2}, max = {x = 0.2, y = 0.2, z = 0.2}},
		size = {min = 3.0, max = 5.2},
		exptime = {min = 0.5, max = 0.9},
		glow = 14,
		texpool = GLOWLER_SHOCKWAVE_TEXPOOL,
		minpos = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
		maxpos = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		minvel = {x = -0.2, y = -0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.2, z = 0.2},
		minsize = 3.0,
		maxsize = 5.2,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns flight trail for the unique 20% Supernova Nova projectile
---@param pos Vector Center projectile position
---@param vel? Vector Projectile velocity vector
function x_mobs.spawn_glowler_supernova_trail(pos, vel)
	local v_opp = vel and {x = -vel.x * 0.10, y = -vel.y * 0.10, z = -vel.z * 0.10} or {x = 0, y = 0, z = 0}

	-- Brilliant radiant solar starburst rays
	core.add_particlespawner({
		amount = 6,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.28, y = pos.y - 0.28, z = pos.z - 0.28},
			max = {x = pos.x + 0.28, y = pos.y + 0.28, z = pos.z + 0.28},
		},
		vel = {
			min = {x = v_opp.x - 0.3, y = v_opp.y - 0.3, z = v_opp.z - 0.3},
			max = {x = v_opp.x + 0.3, y = v_opp.y + 0.3, z = v_opp.z + 0.3},
		},
		jitter = {min = {x = -0.3, y = -0.3, z = -0.3}, max = {x = 0.3, y = 0.3, z = 0.3}},
		drag = {x = 0.3, y = 0.3, z = 0.3},
		size = {min = 2.4, max = 4.2},
		exptime = {min = 0.6, max = 1.1},
		glow = 14,
		texpool = GLOWLER_SUPERNOVA_TEXPOOL,
		minpos = {x = pos.x - 0.28, y = pos.y - 0.28, z = pos.z - 0.28},
		maxpos = {x = pos.x + 0.28, y = pos.y + 0.28, z = pos.z + 0.28},
		minvel = {x = v_opp.x - 0.3, y = v_opp.y - 0.3, z = v_opp.z - 0.3},
		maxvel = {x = v_opp.x + 0.3, y = v_opp.y + 0.3, z = v_opp.z + 0.3},
		minsize = 2.4,
		maxsize = 4.2,
		minexptime = 0.6,
		maxexptime = 1.1,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,3",
	})

	-- Intense inner plasma corona
	core.add_particlespawner({
		amount = 5,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
			max = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		},
		size = {min = 1.8, max = 3.0},
		exptime = {min = 0.4, max = 0.8},
		glow = 14,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = v_opp.x - 0.2, y = v_opp.y - 0.2, z = v_opp.z - 0.2},
		maxvel = {x = v_opp.x + 0.2, y = v_opp.y + 0.2, z = v_opp.z + 0.2},
		minsize = 1.8,
		maxsize = 3.0,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns massive Supernova Nova detonation impact VFX
---@param pos Vector Impact coordinate
function x_mobs.spawn_glowler_supernova_impact(pos)
	-- 1. Colossal expanding solar starbursts
	core.add_particlespawner({
		amount = 28,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		},
		vel = {min = {x = -4.0, y = -1.5, z = -4.0}, max = {x = 4.0, y = 4.5, z = 4.0}},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -4.0, z = 0}},
		drag = {x = 0.35, y = 0.35, z = 0.35},
		size = {min = 3.2, max = 6.0},
		exptime = {min = 0.8, max = 1.6},
		glow = 14,
		texpool = GLOWLER_SUPERNOVA_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		minvel = {x = -4.0, y = -1.5, z = -4.0},
		maxvel = {x = 4.0, y = 4.5, z = 4.0},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -4.0, z = 0},
		minsize = 3.2,
		maxsize = 6.0,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,3",
	})

	-- 2. Expanding shockwave ring
	core.add_particlespawner({
		amount = 12,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {min = {x = -0.4, y = 0, z = -0.4}, max = {x = 0.4, y = 0.3, z = 0.4}},
		size = {min = 4.5, max = 8.5},
		exptime = {min = 0.7, max = 1.2},
		glow = 14,
		texpool = GLOWLER_SHOCKWAVE_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -0.4, y = 0, z = -0.4},
		maxvel = {x = 0.4, y = 0.3, z = 0.4},
		minsize = 4.5,
		maxsize = 8.5,
		minexptime = 0.7,
		maxexptime = 1.2,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,6",
	})

	-- 3. Billowing residual plasma embers
	core.add_particlespawner({
		amount = 18,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y - 0.3, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5},
		},
		vel = {min = {x = -2.0, y = 0.5, z = -2.0}, max = {x = 2.0, y = 3.0, z = 2.0}},
		drag = {x = 0.5, y = 0.3, z = 0.5},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 1.0, max = 2.0},
		glow = 13,
		texpool = GLOWLER_FLAMES_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y - 0.3, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5},
		minvel = {x = -2.0, y = 0.5, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 1.0,
		maxexptime = 2.0,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns obsidian scale shards on hit
---@param pos Vector Center body position
function x_mobs.spawn_glowler_hurt_burst(pos)
	-- Basalt & obsidian scale debris
	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.2, z = pos.z + 0.4},
		},
		vel = {min = {x = -1.6, y = 0.8, z = -1.6}, max = {x = 1.6, y = 2.5, z = 1.6}},
		acc = {min = {x = 0, y = -7.0, z = 0}, max = {x = 0, y = -9.81, z = 0}},
		bounce = 0.3,
		size = {min = 1.0, max = 2.0},
		exptime = {min = 0.6, max = 1.2},
		glow = 6,
		texpool = GLOWLER_SCALE_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.2, z = pos.z + 0.4},
		minvel = {x = -1.6, y = 0.8, z = -1.6},
		maxvel = {x = 1.6, y = 2.5, z = 1.6},
		minacc = {x = 0, y = -7.0, z = 0},
		maxacc = {x = 0, y = -9.81, z = 0},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,4",
	})

	-- Bioluminescent plasma splatter
	core.add_particlespawner({
		amount = 6,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.5, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.1, z = pos.z + 0.3},
		},
		vel = {min = {x = -1.2, y = 0.4, z = -1.2}, max = {x = 1.2, y = 1.8, z = 1.2}},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 14,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.5, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.1, z = pos.z + 0.3},
		minvel = {x = -1.2, y = 0.4, z = -1.2},
		maxvel = {x = 1.2, y = 1.8, z = 1.2},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns death dissipation particles (soul wisps & scale collapse)
---@param pos Vector Center body position
function x_mobs.spawn_glowler_death_vfx(pos)
	-- Ascending ethereal soul wisps
	core.add_particlespawner({
		amount = 22,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.7, y = pos.y + 0.1, z = pos.z - 0.7},
			max = {x = pos.x + 0.7, y = pos.y + 1.2, z = pos.z + 0.7},
		},
		vel = {min = {x = -0.5, y = 0.8, z = -0.5}, max = {x = 0.5, y = 2.2, z = 0.5}},
		jitter = {min = {x = -0.3, y = -0.2, z = -0.3}, max = {x = 0.3, y = 0.2, z = 0.3}},
		drag = {x = 0.2, y = 0.1, z = 0.2},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 1.2, max = 2.4},
		glow = 14,
		texpool = GLOWLER_WISPS_TEXPOOL,
		minpos = {x = pos.x - 0.7, y = pos.y + 0.1, z = pos.z - 0.7},
		maxpos = {x = pos.x + 0.7, y = pos.y + 1.2, z = pos.z + 0.7},
		minvel = {x = -0.5, y = 0.8, z = -0.5},
		maxvel = {x = 0.5, y = 2.2, z = 0.5},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 1.2,
		maxexptime = 2.4,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,5",
	})

	-- Ground scale settling debris
	core.add_particlespawner({
		amount = 16,
		time = 0.4,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.8, z = pos.z + 0.6},
		},
		vel = {min = {x = -1.2, y = 0.2, z = -1.2}, max = {x = 1.2, y = 1.4, z = 1.2}},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -9.81, z = 0}},
		bounce = 0.3,
		size = {min = 1.2, max = 2.2},
		exptime = {min = 1.0, max = 1.8},
		glow = 8,
		texpool = GLOWLER_SCALE_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.8, z = pos.z + 0.6},
		minvel = {x = -1.2, y = 0.2, z = -1.2},
		maxvel = {x = 1.2, y = 1.4, z = 1.2},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -9.81, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,4",
	})
end

--- Ambient bioluminescent hovering particles
---@param pos Vector Center body position
function x_mobs.spawn_glowler_ambient_aura(pos)
	core.add_particlespawner({
		amount = 2,
		time = 0.3,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.3, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.1, z = pos.z + 0.5},
		},
		vel = {min = {x = -0.15, y = -0.1, z = -0.15}, max = {x = 0.15, y = 0.2, z = 0.15}},
		jitter = {min = {x = -0.1, y = -0.1, z = -0.1}, max = {x = 0.1, y = 0.1, z = 0.1}},
		drag = {x = 0.2, y = 0.2, z = 0.2},
		size = {min = 1.0, max = 1.8},
		exptime = {min = 0.8, max = 1.5},
		glow = 12,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.3, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.1, z = pos.z + 0.5},
		minvel = {x = -0.15, y = -0.1, z = -0.15},
		maxvel = {x = 0.15, y = 0.2, z = 0.15},
		minsize = 1.0,
		maxsize = 1.8,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	})
end

--- Returns continuous attached particle spawner definition for supernova blaze burn DoT
---@param scale? number Optional scale multiplier (default 1.0)
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_supernova_blaze_attached_spawner(scale)
	local s = scale or 1.0
	return {
		amount = math.floor(10 * s),
		time = 0,
		minpos = {x = -0.3 * s, y = 0.2 * s, z = -0.3 * s},
		maxpos = {x = 0.3 * s, y = 1.3 * s, z = 0.3 * s},
		minvel = {x = -0.2, y = 0.4, z = -0.2},
		maxvel = {x = 0.2, y = 1.2, z = 0.2},
		minacc = {x = -0.1, y = 0.3, z = -0.1},
		maxacc = {x = 0.1, y = 0.8, z = 0.1},
		minexptime = 0.4,
		maxexptime = 0.9,
		minsize = 1.6 * s,
		maxsize = 2.8 * s,
		collisiondetection = false,
		glow = 14,
		texpool = GLOWLER_SUPERNOVA_TEXPOOL,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,2",
	}
end

--- Returns continuous attached particle spawner definition for Glowler dragon ambient hovering aura
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_glowler_ambient_spawner()
	return {
		amount = 3,
		time = 0,
		minpos = {x = -0.4, y = 0.3, z = -0.4},
		maxpos = {x = 0.4, y = 1.1, z = 0.4},
		minvel = {x = -0.15, y = -0.1, z = -0.15},
		maxvel = {x = 0.15, y = 0.2, z = 0.15},
		jitter = {min = {x = -0.1, y = -0.1, z = -0.1}, max = {x = 0.1, y = 0.1, z = 0.1}},
		drag = {x = 0.2, y = 0.2, z = 0.2},
		size = {min = 1.0, max = 1.8},
		exptime = {min = 0.8, max = 1.5},
		glow = 12,
		collisiondetection = false,
		texpool = GLOWLER_PLASMA_TEXPOOL,
		texture = "x_mobs_glowler_particles.png^[sheet:8x8:0,0",
	}
end
