--[[
	x_mobs - Suture Golem Particle Systems & Visual Effects
	Author: SaKeL
	License: MIT

	Necrotic bile splatters, putrid viscera shreds, rusted iron suture staples,
	bone splinters, virulent miasma gas, and restorative stitch weave effects.
--]]

local texpools = x_mobs.texpools
local BILE_TEXPOOL = texpools.SUTURE_GOLEM_BILE_TEXPOOL
local FLESH_TEXPOOL = texpools.SUTURE_GOLEM_FLESH_TEXPOOL
local BONE_TEXPOOL = texpools.SUTURE_GOLEM_BONE_TEXPOOL
local SUTURE_TEXPOOL = texpools.SUTURE_GOLEM_SUTURE_TEXPOOL
local GAS_TEXPOOL = texpools.SUTURE_GOLEM_GAS_TEXPOOL
local SPLAT_TEXPOOL = texpools.SUTURE_GOLEM_SPLAT_TEXPOOL
local HEAL_TEXPOOL = texpools.SUTURE_GOLEM_HEAL_TEXPOOL
local SLAG_TEXPOOL = texpools.SUTURE_GOLEM_SLAG_TEXPOOL

--- Spawns heavy fleshy footfall mud & bile flecks
---@param pos Vector Foot contact position
function x_mobs.spawn_suture_golem_step(pos)
	core.add_particlespawner({
		amount = 6,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.1, z = pos.z + 0.35},
		},
		vel = {
			min = {x = -0.6, y = 0.2, z = -0.6},
			max = {x = 0.6, y = 1.0, z = 0.6},
		},
		acc = {
			min = {x = -0.1, y = -7.0, z = -0.1},
			max = {x = 0.1, y = -5.0, z = 0.1},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.3, z = 1.0},
		},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.3, max = 0.65},
		glow = 2,
		collisiondetection = true,
		texpool = SLAG_TEXPOOL,

		minpos = {x = pos.x - 0.35, y = pos.y, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.1, z = pos.z + 0.35},
		minvel = {x = -0.6, y = 0.2, z = -0.6},
		maxvel = {x = 0.6, y = 1.0, z = 0.6},
		minacc = {x = -0.1, y = -7.0, z = -0.1},
		maxacc = {x = 0.1, y = -5.0, z = 0.1},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.3,
		maxexptime = 0.65,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,7",
	})
end

--- Spawns rusty iron hook cleave effects (flesh shreds, iron wire bits, bone chips)
---@param pos Vector Impact coordinate
---@param dir Vector Slash direction
function x_mobs.spawn_suture_golem_cleave(pos, dir)
	local d = dir or {x = 0, y = 0, z = 1}

	-- Viscera and flesh shreds
	core.add_particlespawner({
		amount = 14,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		},
		vel = {
			min = {x = d.x * 2.0 - 2.0, y = 1.0, z = d.z * 2.0 - 2.0},
			max = {x = d.x * 3.5 + 2.0, y = 3.5, z = d.z * 3.5 + 2.0},
		},
		acc = {
			min = {x = -0.2, y = -9.81, z = -0.2},
			max = {x = 0.2, y = -8.0, z = 0.2},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.9, y = 0.3, z = 0.9},
		},
		bounce = {min = 0.1, max = 0.3},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.4, max = 0.8},
		collisiondetection = true,
		collision_removal = false,
		texpool = FLESH_TEXPOOL,

		minpos = {x = pos.x - 0.25, y = pos.y - 0.25, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 0.25, z = pos.z + 0.25},
		minvel = {x = d.x * 2.0 - 2.0, y = 1.0, z = d.z * 2.0 - 2.0},
		maxvel = {x = d.x * 3.5 + 2.0, y = 3.5, z = d.z * 3.5 + 2.0},
		minacc = {x = -0.2, y = -9.81, z = -0.2},
		maxacc = {x = 0.2, y = -8.0, z = 0.2},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,1",
	})

	-- Bone chips and iron suture staples
	core.add_particlespawner({
		amount = 10,
		time = 0.06,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -2.5, y = 1.5, z = -2.5},
			max = {x = 2.5, y = 4.0, z = 2.5},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -9.81, z = 0}},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.3, max = 0.7},
		glow = 4,
		collisiondetection = true,
		texpool = SUTURE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -2.5, y = 1.5, z = -2.5},
		maxvel = {x = 2.5, y = 4.0, z = 2.5},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -9.81, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.3,
		maxexptime = 0.7,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns double-fist ground rupture & shockwave
---@param pos Vector Slam center coordinate
function x_mobs.spawn_suture_golem_ground_rupture(pos)
	-- Necrotic bile radial splats
	core.add_particlespawner({
		amount = 22,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.2, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -3.5, y = 1.0, z = -3.5},
			max = {x = 3.5, y = 3.0, z = 3.5},
		},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -6.0, z = 0}},
		drag = {min = {x = 0.6, y = 0.3, z = 0.6}, max = {x = 1.2, y = 0.5, z = 1.2}},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.4, max = 0.9},
		glow = 8,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPLAT_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.2, z = pos.z + 0.5},
		minvel = {x = -3.5, y = 1.0, z = -3.5},
		maxvel = {x = 3.5, y = 3.0, z = 3.5},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -6.0, z = 0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.4,
		maxexptime = 0.9,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,5",
	})

	-- Virulent poison miasma cloud
	core.add_particlespawner({
		amount = 16,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.5, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -1.2, y = 0.4, z = -1.2},
			max = {x = 1.2, y = 1.8, z = 1.2},
		},
		acc = {min = {x = -0.1, y = 0.1, z = -0.1}, max = {x = 0.1, y = 0.3, z = 0.1}},
		drag = {min = {x = 0.8, y = 0.4, z = 0.8}, max = {x = 1.4, y = 0.8, z = 1.4}},
		size = {min = 2.2, max = 4.5},
		exptime = {min = 0.8, max = 1.6},
		glow = 6,
		collisiondetection = false,
		texpool = GAS_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.5, z = pos.z + 0.4},
		minvel = {x = -1.2, y = 0.4, z = -1.2},
		maxvel = {x = 1.2, y = 1.8, z = 1.2},
		minacc = {x = -0.1, y = 0.1, z = -0.1},
		maxacc = {x = 0.1, y = 0.3, z = 0.1},
		minsize = 2.2,
		maxsize = 4.5,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns toxic bile projectile trail
---@param pos Vector Projectile current position
---@param vel Vector Projectile velocity
function x_mobs.spawn_suture_golem_bile_trail(pos, vel)
	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -vel.x * 0.2 - 0.3, y = -vel.y * 0.2 - 0.3, z = -vel.z * 0.2 - 0.3},
			max = {x = -vel.x * 0.1 + 0.3, y = -vel.y * 0.1 + 0.3, z = -vel.z * 0.1 + 0.3},
		},
		acc = {min = {x = 0, y = -4.0, z = 0}, max = {x = 0, y = -2.0, z = 0}},
		drag = {min = {x = 0.5, y = 0.5, z = 0.5}, max = {x = 1.0, y = 1.0, z = 1.0}},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.3, max = 0.6},
		glow = 10,
		collisiondetection = true,
		texpool = BILE_TEXPOOL,

		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -vel.x * 0.2 - 0.3, y = -vel.y * 0.2 - 0.3, z = -vel.z * 0.2 - 0.3},
		maxvel = {x = -vel.x * 0.1 + 0.3, y = -vel.y * 0.1 + 0.3, z = -vel.z * 0.1 + 0.3},
		minacc = {x = 0, y = -4.0, z = 0},
		maxacc = {x = 0, y = -2.0, z = 0},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns toxic bile projectile impact puddle explosion & noxious vapor
---@param pos Vector Detonation coordinate
function x_mobs.spawn_suture_golem_bile_impact(pos)
	-- Bile burst
	core.add_particlespawner({
		amount = 18,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -2.8, y = 1.2, z = -2.8},
			max = {x = 2.8, y = 3.8, z = 2.8},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {min = {x = 0.4, y = 0.2, z = 0.4}, max = {x = 0.8, y = 0.3, z = 0.8}},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.4, max = 0.85},
		glow = 12,
		collisiondetection = true,
		collision_removal = false,
		texpool = BILE_TEXPOOL,

		minpos = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		minvel = {x = -2.8, y = 1.2, z = -2.8},
		maxvel = {x = 2.8, y = 3.8, z = 2.8},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.4,
		maxexptime = 0.85,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,0",
	})

	-- Lingering poison gas cloud
	core.add_particlespawner({
		amount = 14,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -0.8, y = 0.3, z = -0.8},
			max = {x = 0.8, y = 1.2, z = 0.8},
		},
		acc = {min = {x = -0.05, y = 0.05, z = -0.05}, max = {x = 0.05, y = 0.15, z = 0.05}},
		drag = {min = {x = 0.6, y = 0.4, z = 0.6}, max = {x = 1.2, y = 0.6, z = 1.2}},
		size = {min = 2.0, max = 4.0},
		exptime = {min = 0.8, max = 1.8},
		glow = 8,
		collisiondetection = false,
		texpool = GAS_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		minvel = {x = -0.8, y = 0.3, z = -0.8},
		maxvel = {x = 0.8, y = 1.2, z = 0.8},
		minacc = {x = -0.05, y = 0.05, z = -0.05},
		maxacc = {x = 0.05, y = 0.15, z = 0.05},
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 0.8,
		maxexptime = 1.8,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns stitch regeneration weave rings & restorative luminescence
---@param pos Vector Mob center coordinate
function x_mobs.spawn_suture_golem_regen(pos)
	core.add_particlespawner({
		amount = 16,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.8, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -0.3, y = 0.4, z = -0.3},
			max = {x = 0.3, y = 1.2, z = 0.3},
		},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.5, z = 0}},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.6, max = 1.2},
		glow = 14,
		collisiondetection = false,
		texpool = HEAL_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.8, z = pos.z + 0.4},
		minvel = {x = -0.3, y = 0.4, z = -0.3},
		maxvel = {x = 0.3, y = 1.2, z = 0.3},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.5, z = 0},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns massive necrotic death burst (viscera shreds, bone splinters, iron wires, bile splash)
---@param pos Vector Mob corpse center coordinate
function x_mobs.spawn_suture_golem_death(pos)
	-- Flesh chunks
	core.add_particlespawner({
		amount = 26,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.4, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -3.5, y = 2.0, z = -3.5},
			max = {x = 3.5, y = 5.5, z = 3.5},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {min = {x = 0.4, y = 0.2, z = 0.4}, max = {x = 0.8, y = 0.3, z = 0.8}},
		bounce = {min = 0.1, max = 0.3},
		size = {min = 1.8, max = 3.4},
		exptime = {min = 0.6, max = 1.2},
		collisiondetection = true,
		collision_removal = false,
		texpool = FLESH_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.4, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.4, z = pos.z + 0.4},
		minvel = {x = -3.5, y = 2.0, z = -3.5},
		maxvel = {x = 3.5, y = 5.5, z = 3.5},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.8,
		maxsize = 3.4,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,1",
	})

	-- Bone & iron wire spray
	core.add_particlespawner({
		amount = 18,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.5, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -4.0, y = 2.5, z = -4.0},
			max = {x = 4.0, y = 6.0, z = 4.0},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -9.81, z = 0}},
		bounce = {min = 0.3, max = 0.6},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.5, max = 1.0},
		glow = 6,
		collisiondetection = true,
		texpool = BONE_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.5, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.2, z = pos.z + 0.3},
		minvel = {x = -4.0, y = 2.5, z = -4.0},
		maxvel = {x = 4.0, y = 6.0, z = 4.0},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -9.81, z = 0},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,2",
	})

	-- Dying miasma gas cloud
	core.add_particlespawner({
		amount = 20,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -1.5, y = 0.2, z = -1.5},
			max = {x = 1.5, y = 1.5, z = 1.5},
		},
		acc = {min = {x = -0.1, y = 0.05, z = -0.1}, max = {x = 0.1, y = 0.2, z = 0.1}},
		drag = {min = {x = 0.7, y = 0.4, z = 0.7}, max = {x = 1.3, y = 0.7, z = 1.3}},
		size = {min = 2.5, max = 5.0},
		exptime = {min = 1.0, max = 2.2},
		glow = 8,
		collisiondetection = false,
		texpool = GAS_TEXPOOL,

		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		minvel = {x = -1.5, y = 0.2, z = -1.5},
		maxvel = {x = 1.5, y = 1.5, z = 1.5},
		minacc = {x = -0.1, y = 0.05, z = -0.1},
		maxacc = {x = 0.1, y = 0.2, z = 0.1},
		minsize = 2.5,
		maxsize = 5.0,
		minexptime = 1.0,
		maxexptime = 2.2,
		texture = "x_mobs_suture_golem_particles.png^[sheet:8x8:0,4",
	})
end
