--[[
	x_mobs - Crazy Mushroom & Fungus Particle Systems
	Mushroom hurt/death, fungus hurt/death, spore trails, spore bursts, and fungal summons
--]]

local texpools = x_mobs.texpools
local MUSHROOM_CAP_TEXPOOL = texpools.MUSHROOM_CAP_TEXPOOL
local MUSHROOM_STEM_TEXPOOL = texpools.MUSHROOM_STEM_TEXPOOL
local MUSHROOM_SPORE_TEXPOOL = texpools.MUSHROOM_SPORE_TEXPOOL
local MUSHROOM_BLOOM_TEXPOOL = texpools.MUSHROOM_BLOOM_TEXPOOL
local MUSHROOM_SLIME_TEXPOOL = texpools.MUSHROOM_SLIME_TEXPOOL
local MUSHROOM_SMOKE_TEXPOOL = texpools.MUSHROOM_SMOKE_TEXPOOL

function x_mobs.spawn_mushroom_hurt(pos, scale)
	local s = scale or 1.0

	-- 1. Red cap fragments
	core.add_particlespawner({
		amount = 10,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.35 * s, y = pos.y + 0.6 * s, z = pos.z - 0.35 * s},
			max = {x = pos.x + 0.35 * s, y = pos.y + 1.8 * s, z = pos.z + 0.35 * s},
		},
		vel = {
			min = {x = -2.2 * s, y = 1.0 * s, z = -2.2 * s},
			max = {x = 2.2 * s, y = 3.6 * s, z = 2.2 * s},
		},
		acc = {
			min = {x = -0.3, y = -9.0, z = -0.3},
			max = {x = 0.3, y = -7.0, z = 0.3},
		},
		bounce = {min = 0.25, max = 0.5},
		size = {min = 1.5 * s, max = 2.8 * s},
		exptime = {min = 0.6, max = 1.2},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_CAP_TEXPOOL,

		minpos = {x = pos.x - 0.35 * s, y = pos.y + 0.6 * s, z = pos.z - 0.35 * s},
		maxpos = {x = pos.x + 0.35 * s, y = pos.y + 1.8 * s, z = pos.z + 0.35 * s},
		minvel = {x = -2.2 * s, y = 1.0 * s, z = -2.2 * s},
		maxvel = {x = 2.2 * s, y = 3.6 * s, z = 2.2 * s},
		minacc = {x = -0.3, y = -9.0, z = -0.3},
		maxacc = {x = 0.3, y = -7.0, z = 0.3},
		minsize = 1.5 * s,
		maxsize = 2.8 * s,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,0",
	})

	-- 2. Violet glowing spore burst
	core.add_particlespawner({
		amount = 14,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.5 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 1.5 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.2 * s, y = 0.4 * s, z = -1.2 * s},
			max = {x = 1.2 * s, y = 2.0 * s, z = 1.2 * s},
		},
		acc = {
			min = {x = -0.1, y = -0.6, z = -0.1},
			max = {x = 0.1, y = 0.2, z = 0.1},
		},
		drag = {
			min = {x = 1.0, y = 0.5, z = 1.0},
			max = {x = 2.0, y = 1.0, z = 2.0},
		},
		size = {min = 1.6 * s, max = 3.2 * s},
		exptime = {min = 0.7, max = 1.4},
		glow = 11,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.5 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 1.5 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.2 * s, y = 0.4 * s, z = -1.2 * s},
		maxvel = {x = 1.2 * s, y = 2.0 * s, z = 1.2 * s},
		minacc = {x = -0.1, y = -0.6, z = -0.1},
		maxacc = {x = 0.1, y = 0.2, z = 0.1},
		minsize = 1.6 * s,
		maxsize = 3.2 * s,
		minexptime = 0.7,
		maxexptime = 1.4,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns complete multi-layered visceral fungal death rupture:
--- exploding cap debris, tearing stem tissue, toxic green slime splatter, and billowing spore cloud
---@param pos Vector Center death position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_mushroom_death(pos, scale)
	local s = scale or 1.0

	-- 1. Cap fragments blasting radially
	core.add_particlespawner({
		amount = 28,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4 * s, y = pos.y + 0.8 * s, z = pos.z - 0.4 * s},
			max = {x = pos.x + 0.4 * s, y = pos.y + 2.0 * s, z = pos.z + 0.4 * s},
		},
		vel = {
			min = {x = -3.8 * s, y = 1.8 * s, z = -3.8 * s},
			max = {x = 3.8 * s, y = 5.5 * s, z = 3.8 * s},
		},
		acc = {
			min = {x = -0.4, y = -9.8, z = -0.4},
			max = {x = 0.4, y = -7.5, z = 0.4},
		},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.8 * s, max = 3.4 * s},
		exptime = {min = 1.0, max = 2.0},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_CAP_TEXPOOL,

		minpos = {x = pos.x - 0.4 * s, y = pos.y + 0.8 * s, z = pos.z - 0.4 * s},
		maxpos = {x = pos.x + 0.4 * s, y = pos.y + 2.0 * s, z = pos.z + 0.4 * s},
		minvel = {x = -3.8 * s, y = 1.8 * s, z = -3.8 * s},
		maxvel = {x = 3.8 * s, y = 5.5 * s, z = 3.8 * s},
		minacc = {x = -0.4, y = -9.8, z = -0.4},
		maxacc = {x = 0.4, y = -7.5, z = 0.4},
		minsize = 1.8 * s,
		maxsize = 3.4 * s,
		minexptime = 1.0,
		maxexptime = 2.0,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,0",
	})

	-- 2. Stem fibrous tissue
	core.add_particlespawner({
		amount = 20,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 1.2 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -2.5 * s, y = 1.2 * s, z = -2.5 * s},
			max = {x = 2.5 * s, y = 3.8 * s, z = 2.5 * s},
		},
		acc = {
			min = {x = -0.3, y = -9.0, z = -0.3},
			max = {x = 0.3, y = -7.0, z = 0.3},
		},
		bounce = {min = 0.2, max = 0.45},
		size = {min = 1.6 * s, max = 2.8 * s},
		exptime = {min = 0.8, max = 1.6},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_STEM_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 1.2 * s, z = pos.z + 0.3 * s},
		minvel = {x = -2.5 * s, y = 1.2 * s, z = -2.5 * s},
		maxvel = {x = 2.5 * s, y = 3.8 * s, z = 2.5 * s},
		minacc = {x = -0.3, y = -9.0, z = -0.3},
		maxacc = {x = 0.3, y = -7.0, z = 0.3},
		minsize = 1.6 * s,
		maxsize = 2.8 * s,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,1",
	})

	-- 3. Toxic green slime splash
	core.add_particlespawner({
		amount = 16,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2 * s, y = pos.y + 0.4 * s, z = pos.z - 0.2 * s},
			max = {x = pos.x + 0.2 * s, y = pos.y + 1.4 * s, z = pos.z + 0.2 * s},
		},
		vel = {
			min = {x = -2.0 * s, y = 1.5 * s, z = -2.0 * s},
			max = {x = 2.0 * s, y = 4.0 * s, z = 2.0 * s},
		},
		acc = {
			min = {x = -0.2, y = -9.0, z = -0.2},
			max = {x = 0.2, y = -6.5, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.4 * s, max = 2.4 * s},
		exptime = {min = 0.7, max = 1.3},
		glow = 8,
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_SLIME_TEXPOOL,

		minpos = {x = pos.x - 0.2 * s, y = pos.y + 0.4 * s, z = pos.z - 0.2 * s},
		maxpos = {x = pos.x + 0.2 * s, y = pos.y + 1.4 * s, z = pos.z + 0.2 * s},
		minvel = {x = -2.0 * s, y = 1.5 * s, z = -2.0 * s},
		maxvel = {x = 2.0 * s, y = 4.0 * s, z = 2.0 * s},
		minacc = {x = -0.2, y = -9.0, z = -0.2},
		maxacc = {x = 0.2, y = -6.5, z = 0.2},
		minsize = 1.4 * s,
		maxsize = 2.4 * s,
		minexptime = 0.7,
		maxexptime = 1.3,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,4",
	})

	-- 4. Massive billowing violet spore cloud
	core.add_particlespawner({
		amount = 35,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.5 * s, y = pos.y + 0.3 * s, z = pos.z - 0.5 * s},
			max = {x = pos.x + 0.5 * s, y = pos.y + 1.8 * s, z = pos.z + 0.5 * s},
		},
		vel = {
			min = {x = -1.8 * s, y = 0.5 * s, z = -1.8 * s},
			max = {x = 1.8 * s, y = 2.4 * s, z = 1.8 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.1, z = -0.1},
			max = {x = 0.1, y = 0.5, z = 0.1},
		},
		drag = {
			min = {x = 1.2, y = 0.6, z = 1.2},
			max = {x = 2.2, y = 1.2, z = 2.2},
		},
		size = {min = 2.2 * s, max = 4.5 * s},
		exptime = {min = 1.4, max = 2.5},
		glow = 12,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.5 * s, y = pos.y + 0.3 * s, z = pos.z - 0.5 * s},
		maxpos = {x = pos.x + 0.5 * s, y = pos.y + 1.8 * s, z = pos.z + 0.5 * s},
		minvel = {x = -1.8 * s, y = 0.5 * s, z = -1.8 * s},
		maxvel = {x = 1.8 * s, y = 2.4 * s, z = 1.8 * s},
		minacc = {x = -0.1, y = 0.1, z = -0.1},
		maxacc = {x = 0.1, y = 0.5, z = 0.1},
		minsize = 2.2 * s,
		maxsize = 4.5 * s,
		minexptime = 1.4,
		maxexptime = 2.5,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})

	-- 5. Dissipating fungal smoke vapor
	core.add_particlespawner({
		amount = 18,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4 * s, y = pos.y + 0.1 * s, z = pos.z - 0.4 * s},
			max = {x = pos.x + 0.4 * s, y = pos.y + 1.0 * s, z = pos.z + 0.4 * s},
		},
		vel = {
			min = {x = -1.0 * s, y = 0.2 * s, z = -1.0 * s},
			max = {x = 1.0 * s, y = 1.2 * s, z = 1.0 * s},
		},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.5, z = 0}},
		drag = {
			min = {x = 1.0, y = 0.5, z = 1.0},
			max = {x = 2.0, y = 1.0, z = 2.0},
		},
		size = {min = 2.5 * s, max = 5.0 * s},
		exptime = {min = 1.2, max = 2.2},
		glow = 6,
		collisiondetection = false,
		texpool = MUSHROOM_SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.4 * s, y = pos.y + 0.1 * s, z = pos.z - 0.4 * s},
		maxpos = {x = pos.x + 0.4 * s, y = pos.y + 1.0 * s, z = pos.z + 0.4 * s},
		minvel = {x = -1.0 * s, y = 0.2 * s, z = -1.0 * s},
		maxvel = {x = 1.0 * s, y = 1.2 * s, z = 1.0 * s},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.5, z = 0},
		minsize = 2.5 * s,
		maxsize = 5.0 * s,
		minexptime = 1.2,
		maxexptime = 2.2,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns small stem fragments and a quick spore puff for fungus minion taking damage
---@param pos Vector Impact position
function x_mobs.spawn_fungus_hurt(pos)
	-- Stem fibers & spore puff
	core.add_particlespawner({
		amount = 6,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.7, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -1.4, y = 0.6, z = -1.4},
			max = {x = 1.4, y = 2.2, z = 1.4},
		},
		acc = {
			min = {x = -0.2, y = -7.0, z = -0.2},
			max = {x = 0.2, y = -5.0, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.0, max = 1.8},
		exptime = {min = 0.4, max = 0.8},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_STEM_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.7, z = pos.z + 0.2},
		minvel = {x = -1.4, y = 0.6, z = -1.4},
		maxvel = {x = 1.4, y = 2.2, z = 1.4},
		minacc = {x = -0.2, y = -7.0, z = -0.2},
		maxacc = {x = 0.2, y = -5.0, z = 0.2},
		minsize = 1.0,
		maxsize = 1.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,1",
	})

	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.3, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.8, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -0.8, y = 0.3, z = -0.8},
			max = {x = 0.8, y = 1.4, z = 0.8},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.3, z = 0}},
		drag = {min = {x = 1.0, y = 0.5, z = 1.0}, max = {x = 2.0, y = 1.0, z = 2.0}},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.5, max = 1.0},
		glow = 10,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y + 0.3, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.8, z = pos.z + 0.2},
		minvel = {x = -0.8, y = 0.3, z = -0.8},
		maxvel = {x = 0.8, y = 1.4, z = 0.8},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.3, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns quick popping rupture with stem bits, slime splat, and spore puff for fungus minion demise
---@param pos Vector Center death position
function x_mobs.spawn_fungus_death(pos)
	-- Stem fibers popping outward
	core.add_particlespawner({
		amount = 14,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y + 0.15, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.8, z = pos.z + 0.25},
		},
		vel = {
			min = {x = -2.2, y = 1.2, z = -2.2},
			max = {x = 2.2, y = 3.5, z = 2.2},
		},
		acc = {
			min = {x = -0.3, y = -9.0, z = -0.3},
			max = {x = 0.3, y = -7.0, z = 0.3},
		},
		bounce = {min = 0.25, max = 0.5},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.7, max = 1.3},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_STEM_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y + 0.15, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.8, z = pos.z + 0.25},
		minvel = {x = -2.2, y = 1.2, z = -2.2},
		maxvel = {x = 2.2, y = 3.5, z = 2.2},
		minacc = {x = -0.3, y = -9.0, z = -0.3},
		maxacc = {x = 0.3, y = -7.0, z = 0.3},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.7,
		maxexptime = 1.3,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,1",
	})

	-- Slime splash
	core.add_particlespawner({
		amount = 10,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.7, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -1.6, y = 1.0, z = -1.6},
			max = {x = 1.6, y = 2.8, z = 1.6},
		},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -6.0, z = 0}},
		bounce = {min = 0.2, max = 0.35},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 0.5, max = 1.0},
		glow = 8,
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_SLIME_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y + 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.7, z = pos.z + 0.2},
		minvel = {x = -1.6, y = 1.0, z = -1.6},
		maxvel = {x = 1.6, y = 2.8, z = 1.6},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -6.0, z = 0},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,4",
	})

	-- Violet spore puff
	core.add_particlespawner({
		amount = 16,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.9, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -1.2, y = 0.3, z = -1.2},
			max = {x = 1.2, y = 1.8, z = 1.2},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.4, z = 0}},
		drag = {min = {x = 1.0, y = 0.5, z = 1.0}, max = {x = 2.0, y = 1.0, z = 2.0}},
		size = {min = 1.5, max = 3.0},
		exptime = {min = 0.8, max = 1.5},
		glow = 11,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.9, z = pos.z + 0.3},
		minvel = {x = -1.2, y = 0.3, z = -1.2},
		maxvel = {x = 1.2, y = 1.8, z = 1.2},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.4, z = 0},
		minsize = 1.5,
		maxsize = 3.0,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns billowing dissipating fungal smoke vapor and spore puff when mushroom corpse despawns
---@param pos Vector Center ground position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_mushroom_dissolve(pos, scale)
	local s = scale or 1.0

	-- Billowing fungal smoke vapor puff camouflaging entity removal
	core.add_particlespawner({
		amount = math.floor(22 * (s >= 1.5 and 1.5 or 1.0)),
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.45 * s, y = pos.y + 0.05 * s, z = pos.z - 0.45 * s},
			max = {x = pos.x + 0.45 * s, y = pos.y + 0.6 * s, z = pos.z + 0.45 * s},
		},
		vel = {
			min = {x = -1.6 * s, y = 0.2 * s, z = -1.6 * s},
			max = {x = 1.6 * s, y = 1.5 * s, z = 1.6 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.15, z = -0.1},
			max = {x = 0.1, y = 0.45, z = 0.1},
		},
		drag = {
			min = {x = 1.2, y = 0.8, z = 1.2},
			max = {x = 2.2, y = 1.4, z = 2.2},
		},
		jitter = {
			min = {x = -0.3, y = -0.1, z = -0.3},
			max = {x = 0.3, y = 0.2, z = 0.3},
		},
		size = {min = 2.8 * s, max = 5.2 * s},
		exptime = {min = 0.9, max = 1.8},
		glow = 8,
		collisiondetection = false,
		collision_removal = false,
		texpool = MUSHROOM_SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.45 * s, y = pos.y + 0.05 * s, z = pos.z - 0.45 * s},
		maxpos = {x = pos.x + 0.45 * s, y = pos.y + 0.6 * s, z = pos.z + 0.45 * s},
		minvel = {x = -1.6 * s, y = 0.2 * s, z = -1.6 * s},
		maxvel = {x = 1.6 * s, y = 1.5 * s, z = 1.6 * s},
		minacc = {x = -0.1, y = 0.15, z = -0.1},
		maxacc = {x = 0.1, y = 0.45, z = 0.1},
		minsize = 2.8 * s,
		maxsize = 5.2 * s,
		minexptime = 0.9,
		maxexptime = 1.8,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,6",
	})

	-- Expanding violet and amber spore burst
	core.add_particlespawner({
		amount = math.floor(18 * (s >= 1.5 and 1.5 or 1.0)),
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.35 * s, y = pos.y + 0.1 * s, z = pos.z - 0.35 * s},
			max = {x = pos.x + 0.35 * s, y = pos.y + 0.5 * s, z = pos.z + 0.35 * s},
		},
		vel = {
			min = {x = -2.0 * s, y = 0.4 * s, z = -2.0 * s},
			max = {x = 2.0 * s, y = 2.0 * s, z = 2.0 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.1, z = -0.1},
			max = {x = 0.1, y = 0.3, z = 0.1},
		},
		drag = {
			min = {x = 1.5, y = 0.8, z = 1.5},
			max = {x = 2.5, y = 1.5, z = 2.5},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		size = {min = 1.8 * s, max = 3.6 * s},
		exptime = {min = 0.7, max = 1.4},
		glow = 12,
		collisiondetection = false,
		collision_removal = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.35 * s, y = pos.y + 0.1 * s, z = pos.z - 0.35 * s},
		maxpos = {x = pos.x + 0.35 * s, y = pos.y + 0.5 * s, z = pos.z + 0.35 * s},
		minvel = {x = -2.0 * s, y = 0.4 * s, z = -2.0 * s},
		maxvel = {x = 2.0 * s, y = 2.0 * s, z = 2.0 * s},
		minacc = {x = -0.1, y = 0.1, z = -0.1},
		maxacc = {x = 0.1, y = 0.3, z = 0.1},
		minsize = 1.8 * s,
		maxsize = 3.6 * s,
		minexptime = 0.7,
		maxexptime = 1.4,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})

	-- Scattered residual cap debris dissolving into soil
	core.add_particlespawner({
		amount = math.floor(10 * (s >= 1.5 and 1.5 or 1.0)),
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.1 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.4 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.2 * s, y = 0.8 * s, z = -1.2 * s},
			max = {x = 1.2 * s, y = 2.2 * s, z = 1.2 * s},
		},
		acc = {
			min = {x = -0.2, y = -7.0, z = -0.2},
			max = {x = 0.2, y = -5.0, z = 0.2},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.2 * s, max = 2.2 * s},
		exptime = {min = 0.5, max = 0.9},
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_CAP_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.1 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.4 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.2 * s, y = 0.8 * s, z = -1.2 * s},
		maxvel = {x = 1.2 * s, y = 2.2 * s, z = 1.2 * s},
		minacc = {x = -0.2, y = -7.0, z = -0.2},
		maxacc = {x = 0.2, y = -5.0, z = 0.2},
		minsize = 1.2 * s,
		maxsize = 2.2 * s,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns floating glowing violet spore trail behind flying spore ball projectile
---@param pos Vector Projectile position
---@param vel? Vector Projectile velocity
function x_mobs.spawn_spore_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -v.x * 0.15 - 0.3, y = -v.y * 0.15 - 0.2, z = -v.z * 0.15 - 0.3},
			max = {x = -v.x * 0.15 + 0.3, y = -v.y * 0.15 + 0.3, z = -v.z * 0.15 + 0.3},
		},
		acc = {min = {x = 0, y = 0.1, z = 0}, max = {x = 0, y = 0.3, z = 0}},
		drag = {min = {x = 1.0, y = 0.6, z = 1.0}, max = {x = 2.0, y = 1.2, z = 2.0}},
		size = {min = 1.4, max = 2.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 12,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -v.x * 0.15 - 0.3, y = -v.y * 0.15 - 0.2, z = -v.z * 0.15 - 0.3},
		maxvel = {x = -v.x * 0.15 + 0.3, y = -v.y * 0.15 + 0.3, z = -v.z * 0.15 + 0.3},
		minacc = {x = 0, y = 0.1, z = 0},
		maxacc = {x = 0, y = 0.3, z = 0},
		minsize = 1.4,
		maxsize = 2.4,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns expanding spore nova and toxic splat upon projectile impact
---@param pos Vector Center impact position
function x_mobs.spawn_spore_burst(pos)
	-- Radial spore blast
	core.add_particlespawner({
		amount = 22,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -2.8, y = -0.5, z = -2.8},
			max = {x = 2.8, y = 2.8, z = 2.8},
		},
		acc = {min = {x = 0, y = -1.0, z = 0}, max = {x = 0, y = 0.5, z = 0}},
		drag = {min = {x = 1.2, y = 0.6, z = 1.2}, max = {x = 2.4, y = 1.2, z = 2.4}},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.6, max = 1.4},
		glow = 13,
		collisiondetection = false,
		texpool = MUSHROOM_SPORE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -2.8, y = -0.5, z = -2.8},
		maxvel = {x = 2.8, y = 2.8, z = 2.8},
		minacc = {x = 0, y = -1.0, z = 0},
		maxacc = {x = 0, y = 0.5, z = 0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.6,
		maxexptime = 1.4,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
	})

	-- Acidic slime droplets splashing
	core.add_particlespawner({
		amount = 12,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -2.0, y = 1.0, z = -2.0},
			max = {x = 2.0, y = 3.0, z = 2.0},
		},
		acc = {min = {x = 0, y = -9.0, z = 0}, max = {x = 0, y = -7.0, z = 0}},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.5, max = 1.0},
		glow = 8,
		collisiondetection = true,
		collision_removal = false,
		texpool = MUSHROOM_SLIME_TEXPOOL,

		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -2.0, y = 1.0, z = -2.0},
		maxvel = {x = 2.0, y = 3.0, z = 2.0},
		minacc = {x = 0, y = -9.0, z = 0},
		maxacc = {x = 0, y = -7.0, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,4",
	})

	-- Smoke puff
	core.add_particlespawner({
		amount = 8,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -0.8, y = 0.2, z = -0.8},
			max = {x = 0.8, y = 1.0, z = 0.8},
		},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.5, z = 0}},
		drag = {min = {x = 1.0, y = 0.5, z = 1.0}, max = {x = 1.8, y = 0.8, z = 1.8}},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.8, max = 1.5},
		glow = 5,
		collisiondetection = false,
		texpool = MUSHROOM_SMOKE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		minvel = {x = -0.8, y = 0.2, z = -0.8},
		maxvel = {x = 0.8, y = 1.0, z = 0.8},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.5, z = 0},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns mystical golden/amber mycelial bloom swirling upward when fungus minions are summoned
---@param pos Vector Center ground summon position
function x_mobs.spawn_fungal_summon(pos)
	-- Swirling luminescent golden bloom
	core.add_particlespawner({
		amount = 26,
		time = 0.45,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.05, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -0.6, y = 1.2, z = -0.6},
			max = {x = 0.6, y = 2.8, z = 0.6},
		},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.8, z = 0}},
		drag = {min = {x = 0.8, y = 0.4, z = 0.8}, max = {x = 1.5, y = 0.8, z = 1.5}},
		size = {min = 1.8, max = 3.8},
		exptime = {min = 1.0, max = 1.8},
		glow = 13,
		collisiondetection = false,
		texpool = MUSHROOM_BLOOM_TEXPOOL,

		minpos = {x = pos.x - 0.6, y = pos.y + 0.05, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.4, z = pos.z + 0.6},
		minvel = {x = -0.6, y = 1.2, z = -0.6},
		maxvel = {x = 0.6, y = 2.8, z = 0.6},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.8, z = 0},
		minsize = 1.8,
		maxsize = 3.8,
		minexptime = 1.0,
		maxexptime = 1.8,
		texture = "x_mobs_mushroom_particles.png^[sheet:8x8:0,3",
	})
end
