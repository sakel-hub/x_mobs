--[[
	x_mobs - Chasm Weaver Particle Systems & Visual Effects
	Author: SaKeL
	License: MIT

	Silk bolt trails, iridescent jewel spore detonation, urticating setae bursts,
	and predatory subterranean arachnid VFX.
--]]

local texpools = x_mobs.texpools
local SPIDER_CHITIN_TEXPOOL = texpools.SPIDER_CHITIN_TEXPOOL
local SPIDER_WEB_TEXPOOL = texpools.SPIDER_WEB_TEXPOOL

--- Spawns high-velocity silk bolt projectile trail motes
---@param pos Vector Current projectile position
---@param vel Vector Current projectile velocity
function x_mobs.spawn_chasm_silk_bolt_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	core.add_particlespawner({
		amount = 4,
		time = 0.04,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -v.x * 0.1 - 0.3, y = -v.y * 0.1 - 0.2, z = -v.z * 0.1 - 0.3},
			max = {x = -v.x * 0.05 + 0.3, y = -v.y * 0.05 + 0.2, z = -v.z * 0.05 + 0.3},
		},
		acc = {
			min = {x = -0.1, y = -0.5, z = -0.1},
			max = {x = 0.1, y = 0.1, z = 0.1},
		},
		drag = {
			min = {x = 0.5, y = 0.3, z = 0.5},
			max = {x = 1.0, y = 0.6, z = 1.0},
		},
		jitter = {
			min = {x = -0.2, y = -0.1, z = -0.2},
			max = {x = 0.2, y = 0.1, z = 0.2},
		},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 0.25, max = 0.5},
		glow = 6,
		collisiondetection = false,
		texpool = SPIDER_WEB_TEXPOOL,

		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -v.x * 0.1 - 0.3, y = -v.y * 0.1 - 0.2, z = -v.z * 0.1 - 0.3},
		maxvel = {x = -v.x * 0.05 + 0.3, y = -v.y * 0.05 + 0.2, z = -v.z * 0.05 + 0.3},
		minacc = {x = -0.1, y = -0.5, z = -0.1},
		maxacc = {x = 0.1, y = 0.1, z = 0.1},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 0.25,
		maxexptime = 0.5,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns impact burst for standard silk bolt (webbing, venom droplets, chitin flecks)
---@param pos Vector Impact coordinate
function x_mobs.spawn_chasm_silk_bolt_impact(pos)
	-- Web burst
	core.add_particlespawner({
		amount = 18,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y - 0.2, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.4, z = pos.z + 0.35},
		},
		vel = {
			min = {x = -2.5, y = 0.5, z = -2.5},
			max = {x = 2.5, y = 3.5, z = 2.5},
		},
		acc = {
			min = {x = -0.3, y = -6.0, z = -0.3},
			max = {x = 0.3, y = -4.0, z = 0.3},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		jitter = {
			min = {x = -0.3, y = -0.1, z = -0.3},
			max = {x = 0.3, y = 0.1, z = 0.3},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 5,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPIDER_WEB_TEXPOOL,

		minpos = {x = pos.x - 0.35, y = pos.y - 0.2, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.4, z = pos.z + 0.35},
		minvel = {x = -2.5, y = 0.5, z = -2.5},
		maxvel = {x = 2.5, y = 3.5, z = 2.5},
		minacc = {x = -0.3, y = -6.0, z = -0.3},
		maxacc = {x = 0.3, y = -4.0, z = 0.3},
		minsize = 1.8,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	})

	-- Venom splatters
	x_mobs.spawn_venom_particles(pos, 14)
end

--- Spawns trail motes for the 20% Iridescent Jewel Spore projectile
---@param pos Vector Current projectile position
---@param vel Vector Current projectile velocity
function x_mobs.spawn_chasm_jewel_spore_trail(pos, vel)
	local v = vel or {x = 0, y = 0, z = 0}
	core.add_particlespawner({
		amount = 8,
		time = 0.04,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = -v.x * 0.15 - 0.5, y = -v.y * 0.15 - 0.4, z = -v.z * 0.15 - 0.5},
			max = {x = -v.x * 0.08 + 0.5, y = -v.y * 0.08 + 0.4, z = -v.z * 0.08 + 0.5},
		},
		acc = {
			min = {x = -0.2, y = -0.8, z = -0.2},
			max = {x = 0.2, y = 0.2, z = 0.2},
		},
		drag = {
			min = {x = 0.4, y = 0.2, z = 0.4},
			max = {x = 0.8, y = 0.4, z = 0.8},
		},
		jitter = {
			min = {x = -0.3, y = -0.2, z = -0.3},
			max = {x = 0.3, y = 0.2, z = 0.3},
		},
		size = {min = 1.4, max = 2.8},
		exptime = {min = 0.3, max = 0.7},
		glow = 12,
		collisiondetection = false,
		texture = "x_mob_core_sparkle.png^[colorize:#23deba:200",

		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -v.x * 0.15 - 0.5, y = -v.y * 0.15 - 0.4, z = -v.z * 0.15 - 0.5},
		maxvel = {x = -v.x * 0.08 + 0.5, y = -v.y * 0.08 + 0.4, z = -v.z * 0.08 + 0.5},
		minacc = {x = -0.2, y = -0.8, z = -0.2},
		maxacc = {x = 0.2, y = 0.2, z = 0.2},
		minsize = 1.4,
		maxsize = 2.8,
		minexptime = 0.3,
		maxexptime = 0.7,
	})
end

--- Spawns detonation shockwave and acid-silk cloud for the Iridescent Jewel Spore
---@param pos Vector Detonation coordinate
function x_mobs.spawn_chasm_jewel_spore_impact(pos)
	-- Shimmering jewel cloud burst
	core.add_particlespawner({
		amount = 28,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y - 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.8, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -3.8, y = 0.8, z = -3.8},
			max = {x = 3.8, y = 4.8, z = 3.8},
		},
		acc = {
			min = {x = -0.4, y = -7.0, z = -0.4},
			max = {x = 0.4, y = -4.5, z = 0.4},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.5, y = 0.6, z = 1.5},
		},
		bounce = {min = 0.3, max = 0.5},
		size = {min = 2.2, max = 4.0},
		exptime = {min = 0.8, max = 1.5},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texture = "x_mob_core_sparkle.png^[colorize:#f51b52:220",

		minpos = {x = pos.x - 0.5, y = pos.y - 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.8, z = pos.z + 0.5},
		minvel = {x = -3.8, y = 0.8, z = -3.8},
		maxvel = {x = 3.8, y = 4.8, z = 3.8},
		minacc = {x = -0.4, y = -7.0, z = -0.4},
		maxacc = {x = 0.4, y = -4.5, z = 0.4},
		minsize = 2.2,
		maxsize = 4.0,
		minexptime = 0.8,
		maxexptime = 1.5,
	})

	-- Web & venom secondary layer
	x_mobs.spawn_venom_particles(pos, 20)
	x_mobs.spawn_spider_venom_splatter(pos, 22, 1.2)
end

--- Spawns cloud of fine irritating tarantula urticating setae
---@param pos Vector Center emitter position
function x_mobs.spawn_chasm_urticating_setae(pos)
	core.add_particlespawner({
		amount = 22,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.7, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -1.8, y = 0.5, z = -1.8},
			max = {x = 1.8, y = 2.4, z = 1.8},
		},
		acc = {
			min = {x = -0.1, y = -1.2, z = -0.1},
			max = {x = 0.1, y = -0.4, z = 0.1},
		},
		drag = {
			min = {x = 0.8, y = 0.4, z = 0.8},
			max = {x = 1.6, y = 0.8, z = 1.6},
		},
		jitter = {
			min = {x = -0.35, y = -0.2, z = -0.35},
			max = {x = 0.35, y = 0.2, z = 0.35},
		},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 0.8, max = 1.6},
		glow = 4,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPIDER_CHITIN_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.7, z = pos.z + 0.4},
		minvel = {x = -1.8, y = 0.5, z = -1.8},
		maxvel = {x = 1.8, y = 2.4, z = 1.8},
		minacc = {x = -0.1, y = -1.2, z = -0.1},
		maxacc = {x = 0.1, y = -0.4, z = 0.1},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,0",
	})
end
