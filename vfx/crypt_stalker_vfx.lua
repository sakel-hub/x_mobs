--[[
	x_mobs - Crypt Stalker Particle Systems & Visual Effects
	Author: SaKeL
	License: MIT

	Shadow gloom auras, supersonic banshee screech trails, sonic resonance bursts,
	and razor claw laceration VFX for the subterranean Crypt Stalker.
--]]

local texpools = x_mobs.texpools
local SHADOW_TEXPOOL = texpools.CRYPT_STALKER_SHADOW_TEXPOOL
local SONIC_TEXPOOL = texpools.CRYPT_STALKER_SONIC_TEXPOOL
local BLOOD_TEXPOOL = texpools.CRYPT_STALKER_BLOOD_TEXPOOL
local SOUL_TEXPOOL = texpools.CRYPT_STALKER_SOUL_TEXPOOL
local BONE_TEXPOOL = texpools.CRYPT_STALKER_BONE_TEXPOOL
local PULSE_TEXPOOL = texpools.CRYPT_STALKER_SHRIEK_PULSE_TEXPOOL

--- Spawns subterranean shadow gloom mist around the stalker
---@param pos Vector Center entity position
function x_mobs.spawn_crypt_stalker_shadow_aura(pos)
	core.add_particlespawner({
		amount = 6,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.4, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -0.2, y = 0.1, z = -0.2},
			max = {x = 0.2, y = 0.5, z = 0.2},
		},
		acc = {
			min = {x = -0.05, y = 0.05, z = -0.05},
			max = {x = 0.05, y = 0.15, z = 0.05},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		jitter = {
			min = {x = -0.15, y = -0.05, z = -0.15},
			max = {x = 0.15, y = 0.05, z = 0.15},
		},
		size = {min = 1.6, max = 3.0},
		exptime = {min = 0.6, max = 1.1},
		glow = 2,
		collisiondetection = false,
		texpool = SHADOW_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.4, z = pos.z + 0.4},
		minvel = {x = -0.2, y = 0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.5, z = 0.2},
		minacc = {x = -0.05, y = 0.05, z = -0.05},
		maxacc = {x = 0.05, y = 0.15, z = 0.05},
		minsize = 1.6,
		maxsize = 3.0,
		minexptime = 0.6,
		maxexptime = 1.1,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns razor claw rend slash effects
---@param pos Vector Strike location
---@param dir Vector Slash direction vector
function x_mobs.spawn_crypt_stalker_slash(pos, dir)
	local d = dir or {x = 0, y = 0, z = 1}
	-- Blood spray & rend streaks
	core.add_particlespawner({
		amount = 14,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.2, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.3, z = pos.z + 0.25},
		},
		vel = {
			min = {x = d.x * 2.0 - 1.2, y = 0.5, z = d.z * 2.0 - 1.2},
			max = {x = d.x * 3.5 + 1.2, y = 2.5, z = d.z * 3.5 + 1.2},
		},
		acc = {
			min = {x = -0.2, y = -7.0, z = -0.2},
			max = {x = 0.2, y = -5.0, z = 0.2},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.4, z = 1.0},
		},
		bounce = {min = 0.1, max = 0.3},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.4, max = 0.8},
		glow = 4,
		collisiondetection = true,
		collision_removal = true,
		texpool = BLOOD_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.2, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.3, z = pos.z + 0.25},
		minvel = {x = d.x * 2.0 - 1.2, y = 0.5, z = d.z * 2.0 - 1.2},
		maxvel = {x = d.x * 3.5 + 1.2, y = 2.5, z = d.z * 3.5 + 1.2},
		minacc = {x = -0.2, y = -7.0, z = -0.2},
		maxacc = {x = 0.2, y = -5.0, z = 0.2},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,2",
	})

	-- Bone/chitin chips
	core.add_particlespawner({
		amount = 8,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -1.5, y = 1.0, z = -1.5},
			max = {x = 1.5, y = 3.0, z = 1.5},
		},
		acc = {
			min = {x = -0.2, y = -9.0, z = -0.2},
			max = {x = 0.2, y = -7.0, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.5},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.5, max = 1.0},
		glow = 2,
		collisiondetection = true,
		texpool = BONE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -1.5, y = 1.0, z = -1.5},
		maxvel = {x = 1.5, y = 3.0, z = 1.5},
		minacc = {x = -0.2, y = -9.0, z = -0.2},
		maxacc = {x = 0.2, y = -7.0, z = 0.2},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns twin mantis X-slash critical rend burst
---@param pos Vector Strike location
---@param dir Vector Slash direction vector
function x_mobs.spawn_crypt_stalker_xslash(pos, dir)
	x_mobs.spawn_crypt_stalker_slash(pos, dir)
	-- Ethereal soul sparks on critical pierce
	core.add_particlespawner({
		amount = 12,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -2.0, y = 0.5, z = -2.0},
			max = {x = 2.0, y = 3.0, z = 2.0},
		},
		acc = {
			min = {x = -0.1, y = -2.0, z = -0.1},
			max = {x = 0.1, y = 0.5, z = 0.1},
		},
		drag = {
			min = {x = 0.6, y = 0.3, z = 0.6},
			max = {x = 1.2, y = 0.6, z = 1.2},
		},
		jitter = {
			min = {x = -0.2, y = -0.2, z = -0.2},
			max = {x = 0.2, y = 0.2, z = 0.2},
		},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.4, max = 0.8},
		glow = 10,
		collisiondetection = false,
		texpool = SOUL_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		minvel = {x = -2.0, y = 0.5, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minacc = {x = -0.1, y = -2.0, z = -0.1},
		maxacc = {x = 0.1, y = 0.5, z = 0.1},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns supersonic banshee screech projectile trail
---@param pos Vector Current projectile position
---@param vel Vector Current projectile velocity
function x_mobs.spawn_crypt_shriek_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	-- Sonic ripple waves
	core.add_particlespawner({
		amount = 4,
		time = 0.04,
		pos = {
			min = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
			max = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		},
		vel = {
			min = {x = -v.x * 0.08 - 0.3, y = -v.y * 0.08 - 0.2, z = -v.z * 0.08 - 0.3},
			max = {x = -v.x * 0.03 + 0.3, y = -v.y * 0.03 + 0.2, z = -v.z * 0.03 + 0.3},
		},
		acc = {
			min = {x = -0.1, y = -0.2, z = -0.1},
			max = {x = 0.1, y = 0.2, z = 0.1},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.25, max = 0.55},
		glow = 8,
		collisiondetection = false,
		texpool = SONIC_TEXPOOL,

		minpos = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
		maxpos = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		minvel = {x = -v.x * 0.08 - 0.3, y = -v.y * 0.08 - 0.2, z = -v.z * 0.08 - 0.3},
		maxvel = {x = -v.x * 0.03 + 0.3, y = -v.y * 0.03 + 0.2, z = -v.z * 0.03 + 0.3},
		minacc = {x = -0.1, y = -0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.2, z = 0.1},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.25,
		maxexptime = 0.55,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,1",
	})

	-- Trailing void gloom
	core.add_particlespawner({
		amount = 3,
		time = 0.04,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -0.2, y = -0.1, z = -0.2},
			max = {x = 0.2, y = 0.2, z = 0.2},
		},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.3, max = 0.6},
		glow = 3,
		collisiondetection = false,
		texpool = SHADOW_TEXPOOL,

		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -0.2, y = -0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.2, z = 0.2},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns supersonic banshee screech impact detonation
---@param pos Vector Detonation coordinate
function x_mobs.spawn_crypt_shriek_impact(pos)
	-- Sonic pulse expansion ring
	core.add_particlespawner({
		amount = 16,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -3.5, y = -0.5, z = -3.5},
			max = {x = 3.5, y = 1.5, z = 3.5},
		},
		acc = {
			min = {x = -0.5, y = -0.5, z = -0.5},
			max = {x = 0.5, y = 0.5, z = 0.5},
		},
		drag = {
			min = {x = 0.8, y = 0.4, z = 0.8},
			max = {x = 1.5, y = 0.8, z = 1.5},
		},
		size = {min = 2.5, max = 5.0},
		exptime = {min = 0.5, max = 0.9},
		glow = 12,
		collisiondetection = false,
		texpool = PULSE_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -3.5, y = -0.5, z = -3.5},
		maxvel = {x = 3.5, y = 1.5, z = 3.5},
		minacc = {x = -0.5, y = -0.5, z = -0.5},
		maxacc = {x = 0.5, y = 0.5, z = 0.5},
		minsize = 2.5,
		maxsize = 5.0,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,6",
	})

	-- Residual spectral soul motes
	core.add_particlespawner({
		amount = 14,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -2.0, y = 0.8, z = -2.0},
			max = {x = 2.0, y = 3.0, z = 2.0},
		},
		acc = {
			min = {x = -0.1, y = -2.0, z = -0.1},
			max = {x = 0.1, y = 0.0, z = 0.1},
		},
		jitter = {
			min = {x = -0.3, y = -0.1, z = -0.3},
			max = {x = 0.3, y = 0.1, z = 0.3},
		},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.6, max = 1.2},
		glow = 8,
		collisiondetection = false,
		texpool = SOUL_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		minvel = {x = -2.0, y = 0.8, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minacc = {x = -0.1, y = -2.0, z = -0.1},
		maxacc = {x = 0.1, y = 0.0, z = 0.1},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns Crypt Stalker death burst (shadow gloom dissipation and bone fragments)
---@param pos Vector Center entity position
function x_mobs.spawn_crypt_stalker_death(pos)
	-- Void gloom explosion
	core.add_particlespawner({
		amount = 28,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -1.8, y = 0.2, z = -1.8},
			max = {x = 1.8, y = 2.0, z = 1.8},
		},
		acc = {
			min = {x = -0.1, y = -0.5, z = -0.1},
			max = {x = 0.1, y = 0.2, z = 0.1},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.5, z = 1.0},
		},
		size = {min = 2.2, max = 4.2},
		exptime = {min = 0.8, max = 1.6},
		glow = 4,
		collisiondetection = false,
		texpool = SHADOW_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		minvel = {x = -1.8, y = 0.2, z = -1.8},
		maxvel = {x = 1.8, y = 2.0, z = 1.8},
		minacc = {x = -0.1, y = -0.5, z = -0.1},
		maxacc = {x = 0.1, y = 0.2, z = 0.1},
		minsize = 2.2,
		maxsize = 4.2,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,0",
	})

	-- Bone/chitin scatter
	core.add_particlespawner({
		amount = 16,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.3, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.0, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -2.2, y = 1.5, z = -2.2},
			max = {x = 2.2, y = 4.0, z = 2.2},
		},
		acc = {
			min = {x = -0.2, y = -9.81, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.5},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 1.0, max = 1.8},
		glow = 2,
		collisiondetection = true,
		texpool = BONE_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.3, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.0, z = pos.z + 0.4},
		minvel = {x = -2.2, y = 1.5, z = -2.2},
		maxvel = {x = 2.2, y = 4.0, z = 2.2},
		minacc = {x = -0.2, y = -9.81, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,4",
	})
end
