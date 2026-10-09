--[[
	x_mobs - Heated Sword Elemental Visual Effects & Particle Systems
	Author: SaKeL
	License: MIT

	Volcanic magma plumes, living flame tail respiration, infernal pyre spells,
	and seismic ground fissure explosions for the hovering Heated Sword Elemental.
--]]

local texpools = x_mobs.texpools
local EMBER_TEXPOOL = texpools.HEATED_SWORD_EMBER_TEXPOOL
local FLAME_TEXPOOL = texpools.HEATED_SWORD_FLAME_TEXPOOL
local LAVA_TEXPOOL = texpools.HEATED_SWORD_LAVA_TEXPOOL
local SMOKE_TEXPOOL = texpools.HEATED_SWORD_SMOKE_TEXPOOL
local OBSID_TEXPOOL = texpools.HEATED_SWORD_OBSIDIAN_TEXPOOL
local FISSURE_TEXPOOL = texpools.HEATED_SWORD_FISSURE_TEXPOOL
local SPELL_TEXPOOL = texpools.HEATED_SWORD_SPELL_TEXPOOL
local SLAG_TEXPOOL = texpools.HEATED_SWORD_SLAG_TEXPOOL

--- Spawns ambient living flame tail and rising embers for the hovering elemental
---@param pos Vector Center entity position
function x_mobs.spawn_heated_sword_trail(pos)
	-- Flame tail swirl underneath body
	core.add_particlespawner({
		amount = 4,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y + 0.1, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.6, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -0.3, y = 0.4, z = -0.3},
			max = {x = 0.3, y = 1.0, z = 0.3},
		},
		acc = {
			min = {x = -0.1, y = 0.8, z = -0.1},
			max = {x = 0.1, y = 1.6, z = 0.1},
		},
		drag = {
			min = {x = 0.3, y = 0.2, z = 0.3},
			max = {x = 0.6, y = 0.4, z = 0.6},
		},
		jitter = {
			min = {x = -0.2, y = -0.1, z = -0.2},
			max = {x = 0.2, y = 0.1, z = 0.2},
		},
		size = {min = 1.6, max = 2.8},
		exptime = {min = 0.4, max = 0.8},
		glow = 12,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y + 0.1, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.6, z = pos.z + 0.25},
		minvel = {x = -0.3, y = 0.4, z = -0.3},
		maxvel = {x = 0.3, y = 1.0, z = 0.3},
		minacc = {x = -0.1, y = 0.8, z = -0.1},
		maxacc = {x = 0.1, y = 1.6, z = 0.1},
		minsize = 1.6,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})

	-- Floating spark embers
	core.add_particlespawner({
		amount = 3,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -0.4, y = 0.6, z = -0.4},
			max = {x = 0.4, y = 1.4, z = 0.4},
		},
		acc = {
			min = {x = -0.1, y = 0.5, z = -0.1},
			max = {x = 0.1, y = 1.2, z = 0.1},
		},
		jitter = {
			min = {x = -0.25, y = -0.1, z = -0.25},
			max = {x = 0.25, y = 0.1, z = 0.25},
		},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 0.5, max = 1.0},
		glow = 14,
		collisiondetection = false,
		texpool = EMBER_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		minvel = {x = -0.4, y = 0.6, z = -0.4},
		maxvel = {x = 0.4, y = 1.4, z = 0.4},
		minacc = {x = -0.1, y = 0.5, z = -0.1},
		maxacc = {x = 0.1, y = 1.2, z = 0.1},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns blazing greatsword cleave horizontal flame sweep and spark spray
---@param pos Vector Strike location
---@param dir Vector Forward attack vector
function x_mobs.spawn_heated_sword_swing(pos, dir)
	local d = dir or {x = 0, y = 0, z = 1}

	-- Fire arc sweep
	core.add_particlespawner({
		amount = 16,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.3, z = pos.z + 0.4},
		},
		vel = {
			min = {x = d.x * 2.0 - 1.2, y = 0.3, z = d.z * 2.0 - 1.2},
			max = {x = d.x * 4.0 + 1.2, y = 1.5, z = d.z * 4.0 + 1.2},
		},
		acc = {
			min = {x = -0.2, y = 1.0, z = -0.2},
			max = {x = 0.2, y = 2.5, z = 0.2},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		size = {min = 2.0, max = 3.6},
		exptime = {min = 0.35, max = 0.65},
		glow = 14,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.3, z = pos.z + 0.4},
		minvel = {x = d.x * 2.0 - 1.2, y = 0.3, z = d.z * 2.0 - 1.2},
		maxvel = {x = d.x * 4.0 + 1.2, y = 1.5, z = d.z * 4.0 + 1.2},
		minacc = {x = -0.2, y = 1.0, z = -0.2},
		maxacc = {x = 0.2, y = 2.5, z = 0.2},
		minsize = 2.0,
		maxsize = 3.6,
		minexptime = 0.35,
		maxexptime = 0.65,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})

	-- Molten blade sparks
	core.add_particlespawner({
		amount = 14,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {
			min = {x = d.x * 3.0 - 2.0, y = 0.5, z = d.z * 3.0 - 2.0},
			max = {x = d.x * 5.0 + 2.0, y = 2.5, z = d.z * 5.0 + 2.0},
		},
		acc = {
			min = {x = -0.5, y = -4.0, z = -0.5},
			max = {x = 0.5, y = -1.0, z = 0.5},
		},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.3, max = 0.6},
		glow = 14,
		collisiondetection = true,
		texpool = EMBER_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = d.x * 3.0 - 2.0, y = 0.5, z = d.z * 3.0 - 2.0},
		maxvel = {x = d.x * 5.0 + 2.0, y = 2.5, z = d.z * 5.0 + 2.0},
		minacc = {x = -0.5, y = -4.0, z = -0.5},
		maxacc = {x = 0.5, y = -1.0, z = 0.5},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns volcanic ground fissure slam eruption (rupture flames, lava splashes, basalt slag)
---@param pos Vector Ground impact coordinate
function x_mobs.spawn_heated_sword_smash(pos)
	-- Erupting ground fissure flames
	core.add_particlespawner({
		amount = 26,
		time = 0.12,
		pos = {
			min = {x = pos.x - 1.2, y = pos.y, z = pos.z - 1.2},
			max = {x = pos.x + 1.2, y = pos.y + 0.2, z = pos.z + 1.2},
		},
		vel = {
			min = {x = -2.5, y = 3.5, z = -2.5},
			max = {x = 2.5, y = 7.0, z = 2.5},
		},
		acc = {
			min = {x = -0.5, y = -2.0, z = -0.5},
			max = {x = 0.5, y = 1.0, z = 0.5},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		size = {min = 2.6, max = 5.2},
		exptime = {min = 0.5, max = 1.0},
		glow = 14,
		collisiondetection = false,
		texpool = FISSURE_TEXPOOL,

		minpos = {x = pos.x - 1.2, y = pos.y, z = pos.z - 1.2},
		maxpos = {x = pos.x + 1.2, y = pos.y + 0.2, z = pos.z + 1.2},
		minvel = {x = -2.5, y = 3.5, z = -2.5},
		maxvel = {x = 2.5, y = 7.0, z = 2.5},
		minacc = {x = -0.5, y = -2.0, z = -0.5},
		maxacc = {x = 0.5, y = 1.0, z = 0.5},
		minsize = 2.6,
		maxsize = 5.2,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,5",
	})

	-- Molten lava droplets spraying upward
	core.add_particlespawner({
		amount = 20,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -3.5, y = 4.0, z = -3.5},
			max = {x = 3.5, y = 8.5, z = 3.5},
		},
		acc = {
			min = {x = -0.3, y = -9.81, z = -0.3},
			max = {x = 0.3, y = -8.0, z = 0.3},
		},
		bounce = {
			min = {x = 0.2, y = 0.4, z = 0.2},
			max = {x = 0.5, y = 0.7, z = 0.5},
		},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 13,
		collisiondetection = true,
		texpool = LAVA_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		minvel = {x = -3.5, y = 4.0, z = -3.5},
		maxvel = {x = 3.5, y = 8.5, z = 3.5},
		minacc = {x = -0.3, y = -9.81, z = -0.3},
		maxacc = {x = 0.3, y = -8.0, z = 0.3},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,2",
	})

	-- Scorched basalt slag & rock fragments
	core.add_particlespawner({
		amount = 16,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.2, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -4.0, y = 3.0, z = -4.0},
			max = {x = 4.0, y = 7.0, z = 4.0},
		},
		acc = {
			min = {x = -0.2, y = -11.0, z = -0.2},
			max = {x = 0.2, y = -9.0, z = 0.2},
		},
		bounce = {
			min = {x = 0.2, y = 0.3, z = 0.2},
			max = {x = 0.4, y = 0.5, z = 0.4},
		},
		size = {min = 1.4, max = 2.8},
		exptime = {min = 0.5, max = 0.9},
		glow = 8,
		collisiondetection = true,
		texpool = SLAG_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.2, z = pos.z + 0.6},
		minvel = {x = -4.0, y = 3.0, z = -4.0},
		maxvel = {x = 4.0, y = 7.0, z = 4.0},
		minacc = {x = -0.2, y = -11.0, z = -0.2},
		maxacc = {x = 0.2, y = -9.0, z = 0.2},
		minsize = 1.4,
		maxsize = 2.8,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,7",
	})
end

--- Spawns converging fire and magma motes during fireball charge
---@param pos Vector Charge location
---@param _obj ObjectRef Caster entity reference
function x_mobs.spawn_heated_sword_shoot_charge(pos, _obj)
	core.add_particlespawner({
		amount = 14,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.7, y = pos.y + 0.9, z = pos.z - 0.7},
			max = {x = pos.x + 0.7, y = pos.y + 1.9, z = pos.z + 0.7},
		},
		vel = {
			min = {x = -1.2, y = -0.5, z = -1.2},
			max = {x = 1.2, y = 0.5, z = 1.2},
		},
		acc = {
			min = {x = -1.5, y = -0.8, z = -1.5},
			max = {x = 1.5, y = 0.8, z = 1.5},
		},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.3, max = 0.6},
		glow = 14,
		collisiondetection = false,
		texpool = EMBER_TEXPOOL,

		minpos = {x = pos.x - 0.7, y = pos.y + 0.9, z = pos.z - 0.7},
		maxpos = {x = pos.x + 0.7, y = pos.y + 1.9, z = pos.z + 0.7},
		minvel = {x = -1.2, y = -0.5, z = -1.2},
		maxvel = {x = 1.2, y = 0.5, z = 1.2},
		minacc = {x = -1.5, y = -0.8, z = -1.5},
		maxacc = {x = 1.5, y = 0.8, z = 1.5},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns fiery smoke and ember trail behind magma fireball in flight
---@param pos Vector Current projectile position
---@param vel Vector Projectile velocity vector
function x_mobs.spawn_heated_sword_fireball_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	local back_vx = -v.x * 0.15
	local back_vy = -v.y * 0.15
	local back_vz = -v.z * 0.15

	-- Core flames
	core.add_particlespawner({
		amount = 5,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = back_vx - 0.4, y = back_vy - 0.2, z = back_vz - 0.4},
			max = {x = back_vx + 0.4, y = back_vy + 0.6, z = back_vz + 0.4},
		},
		acc = {
			min = {x = -0.1, y = 0.4, z = -0.1},
			max = {x = 0.1, y = 1.2, z = 0.1},
		},
		size = {min = 1.6, max = 2.8},
		exptime = {min = 0.25, max = 0.5},
		glow = 14,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = back_vx - 0.4, y = back_vy - 0.2, z = back_vz - 0.4},
		maxvel = {x = back_vx + 0.4, y = back_vy + 0.6, z = back_vz + 0.4},
		minacc = {x = -0.1, y = 0.4, z = -0.1},
		maxacc = {x = 0.1, y = 1.2, z = 0.1},
		minsize = 1.6,
		maxsize = 2.8,
		minexptime = 0.25,
		maxexptime = 0.5,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})

	-- Trailing volcanic smoke
	core.add_particlespawner({
		amount = 3,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {
			min = {x = back_vx - 0.3, y = back_vy + 0.2, z = back_vz - 0.3},
			max = {x = back_vx + 0.3, y = back_vy + 0.8, z = back_vz + 0.3},
		},
		size = {min = 1.8, max = 3.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 3,
		collisiondetection = false,
		texpool = SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = back_vx - 0.3, y = back_vy + 0.2, z = back_vz - 0.3},
		maxvel = {x = back_vx + 0.3, y = back_vy + 0.8, z = back_vz + 0.3},
		minacc = {x = -0.05, y = 0.2, z = -0.05},
		maxacc = {x = 0.05, y = 0.6, z = 0.05},
		minsize = 1.8,
		maxsize = 3.4,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns explosive fireball detonation effects
---@param pos Vector Detonation coordinate
function x_mobs.spawn_heated_sword_fireball_impact(pos)
	-- Explosive burst
	core.add_particlespawner({
		amount = 22,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -3.5, y = -1.0, z = -3.5},
			max = {x = 3.5, y = 4.5, z = 3.5},
		},
		acc = {
			min = {x = -0.5, y = 0.5, z = -0.5},
			max = {x = 0.5, y = 2.0, z = 0.5},
		},
		drag = {
			min = {x = 0.5, y = 0.3, z = 0.5},
			max = {x = 1.0, y = 0.6, z = 1.0},
		},
		size = {min = 2.4, max = 4.6},
		exptime = {min = 0.4, max = 0.75},
		glow = 14,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -3.5, y = -1.0, z = -3.5},
		maxvel = {x = 3.5, y = 4.5, z = 3.5},
		minacc = {x = -0.5, y = 0.5, z = -0.5},
		maxacc = {x = 0.5, y = 2.0, z = 0.5},
		minsize = 2.4,
		maxsize = 4.6,
		minexptime = 0.4,
		maxexptime = 0.75,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})

	-- Magma droplets
	core.add_particlespawner({
		amount = 14,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -4.0, y = 1.0, z = -4.0},
			max = {x = 4.0, y = 5.0, z = 4.0},
		},
		acc = {
			min = {x = -0.3, y = -9.81, z = -0.3},
			max = {x = 0.3, y = -8.0, z = 0.3},
		},
		bounce = {
			min = {x = 0.2, y = 0.4, z = 0.2},
			max = {x = 0.5, y = 0.6, z = 0.5},
		},
		size = {min = 1.4, max = 2.8},
		exptime = {min = 0.5, max = 1.0},
		glow = 13,
		collisiondetection = true,
		texpool = LAVA_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -4.0, y = 1.0, z = -4.0},
		maxvel = {x = 4.0, y = 5.0, z = 4.0},
		minacc = {x = -0.3, y = -9.81, z = -0.3},
		maxacc = {x = 0.3, y = -8.0, z = 0.3},
		minsize = 1.4,
		maxsize = 2.8,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns infernal spell pyre rings and expanding sigils around the caster
---@param pos Vector Caster position
function x_mobs.spawn_heated_sword_spell_cast(pos)
	core.add_particlespawner({
		amount = 16,
		time = 0.4,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 1.8, z = pos.z + 0.8},
		},
		vel = {
			min = {x = -0.5, y = 0.5, z = -0.5},
			max = {x = 0.5, y = 2.2, z = 0.5},
		},
		size = {min = 2.5, max = 5.0},
		exptime = {min = 0.6, max = 1.2},
		glow = 14,
		collisiondetection = false,
		texpool = SPELL_TEXPOOL,

		minpos = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 1.8, z = pos.z + 0.8},
		minvel = {x = -0.5, y = 0.5, z = -0.5},
		maxvel = {x = 0.5, y = 2.2, z = 0.5},
		minacc = {x = -0.1, y = 0.5, z = -0.1},
		maxacc = {x = 0.1, y = 1.5, z = 0.1},
		minsize = 2.5,
		maxsize = 5.0,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns roaring pillar of fire engulfing the target of Infernal Pyre Envelop
---@param pos Vector Target position
function x_mobs.spawn_heated_sword_spell_ignite(pos)
	-- Swirling flame pillar
	core.add_particlespawner({
		amount = 28,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -0.8, y = 3.5, z = -0.8},
			max = {x = 0.8, y = 7.0, z = 0.8},
		},
		acc = {
			min = {x = -0.2, y = 1.5, z = -0.2},
			max = {x = 0.2, y = 3.5, z = 0.2},
		},
		drag = {
			min = {x = 0.3, y = 0.1, z = 0.3},
			max = {x = 0.6, y = 0.3, z = 0.6},
		},
		size = {min = 2.2, max = 4.4},
		exptime = {min = 0.5, max = 1.1},
		glow = 14,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		minvel = {x = -0.8, y = 3.5, z = -0.8},
		maxvel = {x = 0.8, y = 7.0, z = 0.8},
		minacc = {x = -0.2, y = 1.5, z = -0.2},
		maxacc = {x = 0.2, y = 3.5, z = 0.2},
		minsize = 2.2,
		maxsize = 4.4,
		minexptime = 0.5,
		maxexptime = 1.1,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})
end

--- Returns attached fire particlespawner definition for status effect envelop
---@return table spawner_def Particle definition table
function x_mobs.get_fire_attached_spawner()
	return {
		amount = 12,
		time = 0,
		minpos = {x = -0.35, y = 0.2, z = -0.35},
		maxpos = {x = 0.35, y = 1.4, z = 0.35},
		minvel = {x = -0.3, y = 0.8, z = -0.3},
		maxvel = {x = 0.3, y = 2.2, z = 0.3},
		minacc = {x = -0.1, y = 0.5, z = -0.1},
		maxacc = {x = 0.1, y = 1.2, z = 0.1},
		minexptime = 0.4,
		maxexptime = 0.8,
		minsize = 1.8,
		maxsize = 3.2,
		glow = 13,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	}
end

--- Returns continuous attached particle spawner definition for Heated Sword ambient flame aura
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_heated_sword_ambient_spawner()
	return {
		amount = 3,
		time = 0,
		minpos = {x = -0.25, y = 0.2, z = -0.25},
		maxpos = {x = 0.25, y = 1.4, z = 0.25},
		minvel = {x = -0.3, y = 0.4, z = -0.3},
		maxvel = {x = 0.3, y = 1.0, z = 0.3},
		acc = {min = {x = -0.1, y = 0.5, z = -0.1}, max = {x = 0.1, y = 1.2, z = 0.1}},
		drag = {x = 0.3, y = 0.2, z = 0.3},
		size = {min = 1.4, max = 2.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 12,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	}
end

--- Spawns shattering fire burst when envelop ends
---@param pos Vector Position where envelop broke
function x_mobs.spawn_heated_sword_spell_burst(pos)
	core.add_particlespawner({
		amount = 20,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.3, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.2, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -2.5, y = -0.5, z = -2.5},
			max = {x = 2.5, y = 3.5, z = 2.5},
		},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.35, max = 0.7},
		glow = 14,
		collisiondetection = false,
		texpool = FLAME_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.3, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.2, z = pos.z + 0.4},
		minvel = {x = -2.5, y = -0.5, z = -2.5},
		maxvel = {x = 2.5, y = 3.5, z = 2.5},
		minacc = {x = -0.2, y = 0.5, z = -0.2},
		maxacc = {x = 0.2, y = 1.5, z = 0.2},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.35,
		maxexptime = 0.7,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns steam hiss, basalt chips, and incandescent sparks from parry / hurt
---@param pos Vector Impact coordinate
function x_mobs.spawn_heated_sword_hurt(pos)
	-- Obsidian shards from blade parry
	core.add_particlespawner({
		amount = 8,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.8, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.5, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -2.0, y = 0.5, z = -2.0},
			max = {x = 2.0, y = 3.0, z = 2.0},
		},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.3, max = 0.6},
		glow = 10,
		collisiondetection = true,
		texpool = OBSID_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.8, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.5, z = pos.z + 0.3},
		minvel = {x = -2.0, y = 0.5, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minacc = {x = -0.2, y = -9.81, z = -0.2},
		maxacc = {x = 0.2, y = -7.0, z = 0.2},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,4",
	})

	-- Steam / smoke hiss
	core.add_particlespawner({
		amount = 6,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y + 0.9, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 1.4, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -0.8, y = 1.0, z = -0.8},
			max = {x = 0.8, y = 2.5, z = 0.8},
		},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.3, max = 0.6},
		glow = 4,
		collisiondetection = false,
		texpool = SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y + 0.9, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 1.4, z = pos.z + 0.25},
		minvel = {x = -0.8, y = 1.0, z = -0.8},
		maxvel = {x = 0.8, y = 2.5, z = 0.8},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.6, z = 0.1},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns fatal core extinguishing collapse (smoke billows, obsidian splinters, dying embers)
---@param pos Vector Center death position
function x_mobs.spawn_heated_sword_death(pos)
	-- Billowing volcanic smoke plume
	core.add_particlespawner({
		amount = 26,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.0, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -1.2, y = 1.2, z = -1.2},
			max = {x = 1.2, y = 3.5, z = 1.2},
		},
		acc = {
			min = {x = -0.1, y = 0.3, z = -0.1},
			max = {x = 0.1, y = 0.9, z = 0.1},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		size = {min = 2.5, max = 5.5},
		exptime = {min = 1.0, max = 2.2},
		glow = 4,
		collisiondetection = false,
		texpool = SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.0, z = pos.z + 0.4},
		minvel = {x = -1.2, y = 1.2, z = -1.2},
		maxvel = {x = 1.2, y = 3.5, z = 1.2},
		minacc = {x = -0.1, y = 0.3, z = -0.1},
		maxacc = {x = 0.1, y = 0.9, z = 0.1},
		minsize = 2.5,
		maxsize = 5.5,
		minexptime = 1.0,
		maxexptime = 2.2,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,3",
	})

	-- Obsidian and basalt armor clatter
	core.add_particlespawner({
		amount = 18,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -2.5, y = 1.0, z = -2.5},
			max = {x = 2.5, y = 4.0, z = 2.5},
		},
		acc = {
			min = {x = -0.2, y = -10.0, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		bounce = {
			min = {x = 0.2, y = 0.3, z = 0.2},
			max = {x = 0.4, y = 0.5, z = 0.4},
		},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.8, max = 1.4},
		glow = 5,
		collisiondetection = true,
		texpool = OBSID_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		minvel = {x = -2.5, y = 1.0, z = -2.5},
		maxvel = {x = 2.5, y = 4.0, z = 2.5},
		minacc = {x = -0.2, y = -10.0, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_heated_sword_particles.png^[sheet:8x8:0,4",
	})
end
