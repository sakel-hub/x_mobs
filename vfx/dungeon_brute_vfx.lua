--[[
	x_mobs - Dungeon Brute Particle Systems & Visual Effects
	Author: SaKeL
	License: MIT

	Iron sparks, seismic tremor ground fissures, boulder shrapnel bursts,
	and concussive shockwaves for the ironclad Dungeon Brute juggernaut.
--]]

local texpools = x_mobs.texpools
local RUBBLE_TEXPOOL = texpools.DUNGEON_BRUTE_RUBBLE_TEXPOOL
local SPARK_TEXPOOL = texpools.DUNGEON_BRUTE_SPARK_TEXPOOL
local TREMOR_TEXPOOL = texpools.DUNGEON_BRUTE_TREMOR_TEXPOOL
local SHRAPNEL_TEXPOOL = texpools.DUNGEON_BRUTE_SHRAPNEL_TEXPOOL
local DUST_TEXPOOL = texpools.DUNGEON_BRUTE_DUST_TEXPOOL
local ARMOR_TEXPOOL = texpools.DUNGEON_BRUTE_ARMOR_TEXPOOL
local WARCRY_TEXPOOL = texpools.DUNGEON_BRUTE_WARCRY_TEXPOOL

--- Spawns heavy footfall impact dust and gravel flecks on step
---@param pos Vector Foot contact position
function x_mobs.spawn_dungeon_brute_step(pos)
	core.add_particlespawner({
		amount = 5,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.1, z = pos.z + 0.35},
		},
		vel = {
			min = {x = -0.8, y = 0.2, z = -0.8},
			max = {x = 0.8, y = 1.0, z = 0.8},
		},
		acc = {
			min = {x = -0.1, y = -6.0, z = -0.1},
			max = {x = 0.1, y = -4.0, z = 0.1},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.3, max = 0.6},
		glow = 1,
		collisiondetection = true,
		texpool = DUST_TEXPOOL,

		minpos = {x = pos.x - 0.35, y = pos.y, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.1, z = pos.z + 0.35},
		minvel = {x = -0.8, y = 0.2, z = -0.8},
		maxvel = {x = 0.8, y = 1.0, z = 0.8},
		minacc = {x = -0.1, y = -6.0, z = -0.1},
		maxacc = {x = 0.1, y = -4.0, z = 0.1},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns heavy iron knuckle strike impact effects (sparks, dust, armor fragments)
---@param pos Vector Strike impact coordinate
---@param dir Vector Punch forward direction vector
function x_mobs.spawn_dungeon_brute_punch_impact(pos, dir)
	local d = dir or {x = 0, y = 0, z = 1}
	-- Iron sparks
	core.add_particlespawner({
		amount = 16,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = d.x * 2.0 - 2.5, y = 1.0, z = d.z * 2.0 - 2.5},
			max = {x = d.x * 4.0 + 2.5, y = 4.0, z = d.z * 4.0 + 2.5},
		},
		acc = {
			min = {x = -0.2, y = -9.81, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.4, z = 1.0},
		},
		bounce = {min = 0.2, max = 0.5},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.3, max = 0.65},
		glow = 12,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPARK_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = d.x * 2.0 - 2.5, y = 1.0, z = d.z * 2.0 - 2.5},
		maxvel = {x = d.x * 4.0 + 2.5, y = 4.0, z = d.z * 4.0 + 2.5},
		minacc = {x = -0.2, y = -9.81, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.3,
		maxexptime = 0.65,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,1",
	})

	-- Crumbled stone and armor splinters
	core.add_particlespawner({
		amount = 12,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.15, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -1.8, y = 0.8, z = -1.8},
			max = {x = 1.8, y = 3.2, z = 1.8},
		},
		acc = {
			min = {x = -0.2, y = -9.81, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.5, max = 2.6},
		exptime = {min = 0.5, max = 1.0},
		glow = 3,
		collisiondetection = true,
		texpool = ARMOR_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.15, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = -1.8, y = 0.8, z = -1.8},
		maxvel = {x = 1.8, y = 3.2, z = 1.8},
		minacc = {x = -0.2, y = -9.81, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.5,
		maxsize = 2.6,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,5",
	})
end

--- Spawns massive seismic tremor ground slam (3.5 node radial shockwave and rubble eruption)
---@param pos Vector Slam center ground coordinate
function x_mobs.spawn_dungeon_brute_tremor_slam(pos)
	-- Seismic ground fissure shockwave rings
	core.add_particlespawner({
		amount = 26,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -5.0, y = 0.2, z = -5.0},
			max = {x = 5.0, y = 1.5, z = 5.0},
		},
		acc = {
			min = {x = -0.8, y = -2.0, z = -0.8},
			max = {x = 0.8, y = -0.5, z = 0.8},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.6, y = 0.6, z = 1.6},
		},
		size = {min = 2.8, max = 5.5},
		exptime = {min = 0.6, max = 1.2},
		glow = 4,
		collisiondetection = true,
		texpool = TREMOR_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		minvel = {x = -5.0, y = 0.2, z = -5.0},
		maxvel = {x = 5.0, y = 1.5, z = 5.0},
		minacc = {x = -0.8, y = -2.0, z = -0.8},
		maxacc = {x = 0.8, y = -0.5, z = 0.8},
		minsize = 2.8,
		maxsize = 5.5,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,2",
	})

	-- Heavy erupting granite boulder chunks
	core.add_particlespawner({
		amount = 22,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -3.5, y = 3.0, z = -3.5},
			max = {x = 3.5, y = 7.0, z = 3.5},
		},
		acc = {
			min = {x = -0.3, y = -14.0, z = -0.3},
			max = {x = 0.3, y = -11.0, z = 0.3},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 2.0, max = 4.0},
		exptime = {min = 0.8, max = 1.6},
		glow = 2,
		collisiondetection = true,
		texpool = RUBBLE_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		minvel = {x = -3.5, y = 3.0, z = -3.5},
		maxvel = {x = 3.5, y = 7.0, z = 3.5},
		minacc = {x = -0.3, y = -14.0, z = -0.3},
		maxacc = {x = 0.3, y = -11.0, z = 0.3},
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,0",
	})

	-- Concussive dust plume
	core.add_particlespawner({
		amount = 20,
		time = 0.18,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.4, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -2.5, y = 0.8, z = -2.5},
			max = {x = 2.5, y = 2.8, z = 2.5},
		},
		acc = {
			min = {x = -0.1, y = -1.0, z = -0.1},
			max = {x = 0.1, y = -0.2, z = 0.1},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.4, z = 1.0},
		},
		size = {min = 2.2, max = 4.5},
		exptime = {min = 0.9, max = 1.8},
		glow = 1,
		collisiondetection = false,
		texpool = DUST_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.4, z = pos.z + 0.5},
		minvel = {x = -2.5, y = 0.8, z = -2.5},
		maxvel = {x = 2.5, y = 2.8, z = 2.5},
		minacc = {x = -0.1, y = -1.0, z = -0.1},
		maxacc = {x = 0.1, y = -0.2, z = 0.1},
		minsize = 2.2,
		maxsize = 4.5,
		minexptime = 0.9,
		maxexptime = 1.8,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns rock debris and dust trail for the hurled boulder projectile
---@param pos Vector Projectile position
---@param vel Vector Projectile velocity
function x_mobs.spawn_dungeon_brute_boulder_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	core.add_particlespawner({
		amount = 5,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -v.x * 0.1 - 0.4, y = -v.y * 0.1 - 0.3, z = -v.z * 0.1 - 0.4},
			max = {x = -v.x * 0.05 + 0.4, y = -v.y * 0.05 + 0.3, z = -v.z * 0.05 + 0.4},
		},
		acc = {
			min = {x = -0.1, y = -3.0, z = -0.1},
			max = {x = 0.1, y = -1.5, z = 0.1},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		size = {min = 1.5, max = 2.8},
		exptime = {min = 0.4, max = 0.8},
		glow = 2,
		collisiondetection = true,
		texpool = SHRAPNEL_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = -v.x * 0.1 - 0.4, y = -v.y * 0.1 - 0.3, z = -v.z * 0.1 - 0.4},
		maxvel = {x = -v.x * 0.05 + 0.4, y = -v.y * 0.05 + 0.3, z = -v.z * 0.05 + 0.4},
		minacc = {x = -0.1, y = -3.0, z = -0.1},
		maxacc = {x = 0.1, y = -1.5, z = 0.1},
		minsize = 1.5,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns shattering boulder impact explosion
---@param pos Vector Impact coordinate
function x_mobs.spawn_dungeon_brute_boulder_impact(pos)
	-- Boulder fragmentation shrapnel
	core.add_particlespawner({
		amount = 24,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -4.0, y = 1.5, z = -4.0},
			max = {x = 4.0, y = 5.5, z = 4.0},
		},
		acc = {
			min = {x = -0.3, y = -12.0, z = -0.3},
			max = {x = 0.3, y = -9.0, z = 0.3},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.6, max = 1.4},
		glow = 3,
		collisiondetection = true,
		texpool = SHRAPNEL_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		minvel = {x = -4.0, y = 1.5, z = -4.0},
		maxvel = {x = 4.0, y = 5.5, z = 4.0},
		minacc = {x = -0.3, y = -12.0, z = -0.3},
		maxacc = {x = 0.3, y = -9.0, z = 0.3},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.6,
		maxexptime = 1.4,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,3",
	})

	-- Concussive dust burst
	core.add_particlespawner({
		amount = 16,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -2.0, y = 0.5, z = -2.0},
			max = {x = 2.0, y = 2.5, z = 2.0},
		},
		drag = {
			min = {x = 0.6, y = 0.3, z = 0.6},
			max = {x = 1.2, y = 0.5, z = 1.2},
		},
		size = {min = 2.0, max = 4.0},
		exptime = {min = 0.6, max = 1.3},
		glow = 1,
		collisiondetection = false,
		texpool = DUST_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -2.0, y = 0.5, z = -2.0},
		maxvel = {x = 2.0, y = 2.5, z = 2.0},
		minacc = {x = 0, y = -1.0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 0.6,
		maxexptime = 1.3,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns staggering war cry acoustic tremor shockwave radiating outward
---@param pos Vector Center entity position
function x_mobs.spawn_dungeon_brute_warcry(pos)
	core.add_particlespawner({
		amount = 20,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 1.0, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -4.5, y = -0.5, z = -4.5},
			max = {x = 4.5, y = 1.5, z = 4.5},
		},
		acc = {
			min = {x = -0.5, y = -0.5, z = -0.5},
			max = {x = 0.5, y = 0.5, z = 0.5},
		},
		drag = {
			min = {x = 0.6, y = 0.3, z = 0.6},
			max = {x = 1.2, y = 0.6, z = 1.2},
		},
		size = {min = 2.5, max = 5.5},
		exptime = {min = 0.5, max = 0.9},
		glow = 10,
		collisiondetection = false,
		texpool = WARCRY_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 1.0, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		minvel = {x = -4.5, y = -0.5, z = -4.5},
		maxvel = {x = 4.5, y = 1.5, z = 4.5},
		minacc = {x = -0.5, y = -0.5, z = -0.5},
		maxacc = {x = 0.5, y = 0.5, z = 0.5},
		minsize = 2.5,
		maxsize = 5.5,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns Dungeon Brute death collapse (iron armor crash and heavy stone debris)
---@param pos Vector Center entity position
function x_mobs.spawn_dungeon_brute_death(pos)
	-- Iron plate armor crash
	core.add_particlespawner({
		amount = 22,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -2.5, y = 1.2, z = -2.5},
			max = {x = 2.5, y = 3.5, z = 2.5},
		},
		acc = {
			min = {x = -0.2, y = -10.0, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.8, max = 1.6},
		glow = 3,
		collisiondetection = true,
		texpool = ARMOR_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		minvel = {x = -2.5, y = 1.2, z = -2.5},
		maxvel = {x = 2.5, y = 3.5, z = 2.5},
		minacc = {x = -0.2, y = -10.0, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,5",
	})

	-- Heavy rubble burst
	core.add_particlespawner({
		amount = 20,
		time = 0.18,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -2.0, y = 1.0, z = -2.0},
			max = {x = 2.0, y = 3.0, z = 2.0},
		},
		acc = {
			min = {x = -0.2, y = -11.0, z = -0.2},
			max = {x = 0.2, y = -8.5, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.5},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.7, max = 1.5},
		glow = 2,
		collisiondetection = true,
		texpool = RUBBLE_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		minvel = {x = -2.0, y = 1.0, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minacc = {x = -0.2, y = -11.0, z = -0.2},
		maxacc = {x = 0.2, y = -8.5, z = 0.2},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.7,
		maxexptime = 1.5,
		texture = "x_mobs_dungeon_brute_particles.png^[sheet:8x8:0,0",
	})
end
