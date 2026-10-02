--[[
	x_mobs - Monster Particle & Visual FX Factories
	Rich GLTF particle effects for Spider, Shaman, Minions, and bosses
]]

local SPIDER_CHITIN_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.5, 1.6},
		alpha_tween = {1.0, 0.5, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.5, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

local SPIDER_WEB_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {1.6, 0.7},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {1.8, 0.8},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {1.4, 0.6},
		alpha_tween = {0.85, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {1.7, 0.7},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {0.85, 0.0},
	},
}

local SPIDER_VENOM_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.6, 0.4},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.5, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {1.7, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.4, 0.35},
		alpha_tween = {1.0, 0.0, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.3, 0.4},
		alpha_tween = {1.0, 0.0, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.2, 0.25},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

local SPIDER_EYE_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.8, 0.3},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.5, 0.25},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,3",
		blend = "add",
		scale_tween = {1.3, 0.2},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

local SPIDER_POISON_CLOUD_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,3",
		blend = "alpha",
		scale_tween = {1.0, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.4, 3.4},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,3",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:7,3",
		blend = "alpha",
		scale_tween = {1.0, 2.5},
		alpha_tween = {0.8, 0.2, start = 0.4},
	},
}


--- Spawns silk web burst particles when spider shoots web
---@param pos Vector Starting position
---@param dir Vector Direction vector
function x_mobs.spawn_web_particles(pos, dir)
	local ndir = vector.normalize(dir or {x = 0, y = 0, z = 1})
	core.add_particlespawner({
		amount = 16,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.6, z = pos.z + 0.3},
		},
		vel = {
			min = {x = ndir.x * 4.0 - 0.8, y = ndir.y * 3.0 - 0.2, z = ndir.z * 4.0 - 0.8},
			max = {x = ndir.x * 7.0 + 0.8, y = ndir.y * 5.0 + 0.8, z = ndir.z * 7.0 + 0.8},
		},
		acc = {
			min = {x = -0.2, y = -3.0, z = -0.2},
			max = {x = 0.2, y = -1.0, z = 0.2},
		},
		drag = {
			min = {x = 0.8, y = 0.4, z = 0.8},
			max = {x = 1.6, y = 0.8, z = 1.6},
		},
		jitter = {
			min = {x = -0.25, y = -0.1, z = -0.25},
			max = {x = 0.25, y = 0.1, z = 0.25},
		},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.5, max = 1.0},
		glow = 4,
		collisiondetection = true,
		collision_removal = true,
		texpool = SPIDER_WEB_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y + 0.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.6, z = pos.z + 0.3},
		minvel = {x = ndir.x * 4.0 - 0.8, y = ndir.y * 3.0 - 0.2, z = ndir.z * 4.0 - 0.8},
		maxvel = {x = ndir.x * 7.0 + 0.8, y = ndir.y * 5.0 + 0.8, z = ndir.z * 7.0 + 0.8},
		minacc = {x = -0.2, y = -3.0, z = -0.2},
		maxacc = {x = 0.2, y = -1.0, z = 0.2},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns toxic green venom droplet particles upon bite
---@param pos Vector Impact position
---@param count? integer Particle count
function x_mobs.spawn_venom_particles(pos, count)
	local num = count or 12
	core.add_particlespawner({
		amount = num,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -1.2, y = 0.5, z = -1.2},
			max = {x = 1.2, y = 2.2, z = 1.2},
		},
		acc = {
			min = {x = -0.2, y = -6.0, z = -0.2},
			max = {x = 0.2, y = -4.0, z = 0.2},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		jitter = {
			min = {x = -0.3, y = -0.15, z = -0.3},
			max = {x = 0.3, y = 0.15, z = 0.3},
		},
		bounce = {min = 0.15, max = 0.35},
		size = {min = 2.2, max = 3.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 10,
		collisiondetection = true,
		collision_removal = true,
		texpool = SPIDER_VENOM_TEXPOOL,

		minpos = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.4, z = pos.z + 0.3},
		minvel = {x = -1.2, y = 0.5, z = -1.2},
		maxvel = {x = 1.2, y = 2.2, z = 1.2},
		minacc = {x = -0.2, y = -6.0, z = -0.2},
		maxacc = {x = 0.2, y = -4.0, z = 0.2},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns skittering silk puff particles under spider feet
---@param pos Vector Ground contact position
function x_mobs.spawn_spider_skitter(pos)
	core.add_particlespawner({
		amount = 3,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.15, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -0.4, y = 0.1, z = -0.4},
			max = {x = 0.4, y = 0.5, z = 0.4},
		},
		acc = {
			min = {x = -0.1, y = -0.8, z = -0.1},
			max = {x = 0.1, y = -0.2, z = 0.1},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.5, y = 0.6, z = 1.5},
		},
		jitter = {
			min = {x = -0.2, y = -0.1, z = -0.2},
			max = {x = 0.2, y = 0.1, z = 0.2},
		},
		size = {min = 0.8, max = 1.5},
		exptime = {min = 0.2, max = 0.45},
		glow = 2,
		collisiondetection = true,
		collision_removal = true,
		texpool = SPIDER_WEB_TEXPOOL,

		minpos = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.15, z = pos.z + 0.4},
		minvel = {x = -0.4, y = 0.1, z = -0.4},
		maxvel = {x = 0.4, y = 0.5, z = 0.4},
		minacc = {x = -0.1, y = -0.8, z = -0.1},
		maxacc = {x = 0.1, y = -0.2, z = 0.1},
		minsize = 0.8,
		maxsize = 1.5,
		minexptime = 0.2,
		maxexptime = 0.45,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns sharp fractured spider chitin shards, fangs, and leg segments bursting outward with bounce physics
---@param pos Vector Center death position
---@param count? integer Number of shards to spawn (default 16)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_chitin(pos, count, scale)
	local num = count or 16
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.1 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 0.5 * s, z = pos.z + 0.25 * s},
		},
		vel = {
			min = {x = -2.8 * s, y = 1.2 * s, z = -2.8 * s},
			max = {x = 2.8 * s, y = 4.2 * s, z = 2.8 * s},
		},
		acc = {
			min = {x = -0.4, y = -9.8, z = -0.4},
			max = {x = 0.4, y = -7.5, z = 0.4},
		},
		drag = {
			min = {x = 0.3, y = 0.1, z = 0.3},
			max = {x = 0.6, y = 0.2, z = 0.6},
		},
		bounce = {min = 0.35, max = 0.65},
		jitter = {
			min = {x = -0.3, y = -0.2, z = -0.3},
			max = {x = 0.3, y = 0.2, z = 0.3},
		},
		size = {min = 1.4 * s, max = 2.6 * s},
		exptime = {min = 0.9, max = 1.8},
		collisiondetection = true,
		collision_removal = false,
		texpool = SPIDER_CHITIN_TEXPOOL,

		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.1 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 0.5 * s, z = pos.z + 0.25 * s},
		minvel = {x = -2.8 * s, y = 1.2 * s, z = -2.8 * s},
		maxvel = {x = 2.8 * s, y = 4.2 * s, z = 2.8 * s},
		minacc = {x = -0.4, y = -9.8, z = -0.4},
		maxacc = {x = 0.4, y = -7.5, z = 0.4},
		minsize = 1.4 * s,
		maxsize = 2.6 * s,
		minexptime = 0.9,
		maxexptime = 1.8,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns high-velocity fountain of acidic venom and hemolymph droplets from the ruptured venom gland
---@param pos Vector Center impact position
---@param count? integer Droplet count (default 24)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_venom_splatter(pos, count, scale)
	local num = count or 24
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.2 * s, y = pos.y + 0.2 * s, z = pos.z - 0.2 * s},
			max = {x = pos.x + 0.2 * s, y = pos.y + 0.6 * s, z = pos.z + 0.2 * s},
		},
		vel = {
			min = {x = -2.4 * s, y = 1.5 * s, z = -2.4 * s},
			max = {x = 2.4 * s, y = 4.5 * s, z = 2.4 * s},
		},
		acc = {
			min = {x = -0.3, y = -9.0, z = -0.3},
			max = {x = 0.3, y = -6.5, z = 0.3},
		},
		drag = {
			min = {x = 0.5, y = 0.15, z = 0.5},
			max = {x = 1.0, y = 0.35, z = 1.0},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		bounce = {min = 0.2, max = 0.45},
		size = {min = 1.2 * s, max = 2.5 * s},
		exptime = {min = 0.6, max = 1.2},
		glow = 12,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPIDER_VENOM_TEXPOOL,

		minpos = {x = pos.x - 0.2 * s, y = pos.y + 0.2 * s, z = pos.z - 0.2 * s},
		maxpos = {x = pos.x + 0.2 * s, y = pos.y + 0.6 * s, z = pos.z + 0.2 * s},
		minvel = {x = -2.4 * s, y = 1.5 * s, z = -2.4 * s},
		maxvel = {x = 2.4 * s, y = 4.5 * s, z = 2.4 * s},
		minacc = {x = -0.3, y = -9.0, z = -0.3},
		maxacc = {x = 0.3, y = -6.5, z = 0.3},
		minsize = 1.2 * s,
		maxsize = 2.5 * s,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns floating torn silk webbing and ruptured spinneret clusters with aerodynamic drag
---@param pos Vector Center rupture position
---@param count? integer Filament count (default 18)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_silk_rupture(pos, count, scale)
	local num = count or 18
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.7 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.8 * s, y = 0.8 * s, z = -1.8 * s},
			max = {x = 1.8 * s, y = 3.0 * s, z = 1.8 * s},
		},
		acc = {
			min = {x = -0.1, y = -1.2, z = -0.1},
			max = {x = 0.1, y = -0.4, z = 0.1},
		},
		drag = {
			min = {x = 1.5, y = 0.8, z = 1.5},
			max = {x = 2.6, y = 1.4, z = 2.6},
		},
		jitter = {
			min = {x = -0.35, y = -0.15, z = -0.35},
			max = {x = 0.35, y = 0.15, z = 0.35},
		},
		size = {min = 1.8 * s, max = 3.6 * s},
		exptime = {min = 1.2, max = 2.4},
		glow = 5,
		collisiondetection = true,
		collision_removal = false,
		texpool = SPIDER_WEB_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.7 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.8 * s, y = 0.8 * s, z = -1.8 * s},
		maxvel = {x = 1.8 * s, y = 3.0 * s, z = 1.8 * s},
		minacc = {x = -0.1, y = -1.2, z = -0.1},
		maxacc = {x = 0.1, y = -0.4, z = 0.1},
		minsize = 1.8 * s,
		maxsize = 3.6 * s,
		minexptime = 1.2,
		maxexptime = 2.4,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns popping ruby-crimson spider eye glints and dying ocular sparks scattering upward
---@param pos Vector Center head position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_eye_shatter(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2 * s, y = pos.y + 0.2 * s, z = pos.z - 0.2 * s},
			max = {x = pos.x + 0.2 * s, y = pos.y + 0.5 * s, z = pos.z + 0.2 * s},
		},
		vel = {
			min = {x = -1.4 * s, y = 1.2 * s, z = -1.4 * s},
			max = {x = 1.4 * s, y = 3.2 * s, z = 1.4 * s},
		},
		acc = {
			min = {x = -0.2, y = -3.5, z = -0.2},
			max = {x = 0.2, y = -1.5, z = 0.2},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.5, z = 1.2},
		},
		jitter = {
			min = {x = -0.25, y = -0.15, z = -0.25},
			max = {x = 0.25, y = 0.15, z = 0.25},
		},
		size = {min = 1.2 * s, max = 2.4 * s},
		exptime = {min = 0.5, max = 1.1},
		glow = 14,
		collisiondetection = true,
		collision_removal = true,
		texpool = SPIDER_EYE_TEXPOOL,

		minpos = {x = pos.x - 0.2 * s, y = pos.y + 0.2 * s, z = pos.z - 0.2 * s},
		maxpos = {x = pos.x + 0.2 * s, y = pos.y + 0.5 * s, z = pos.z + 0.2 * s},
		minvel = {x = -1.4 * s, y = 1.2 * s, z = -1.4 * s},
		maxvel = {x = 1.4 * s, y = 3.2 * s, z = 1.4 * s},
		minacc = {x = -0.2, y = -3.5, z = -0.2},
		maxacc = {x = 0.2, y = -1.5, z = 0.2},
		minsize = 1.2 * s,
		maxsize = 2.4 * s,
		minexptime = 0.5,
		maxexptime = 1.1,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns expanding billowing cloud of necrotic acid mist and venom vapor rising from corpse
---@param pos Vector Center body position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_poison_mist(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 10,
		time = 0.22,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.1 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.45 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -0.6 * s, y = 0.2 * s, z = -0.6 * s},
			max = {x = 0.6 * s, y = 0.75 * s, z = 0.6 * s},
		},
		acc = {
			min = {x = -0.05, y = 0.15, z = -0.05},
			max = {x = 0.05, y = 0.35, z = 0.05},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.5, y = 0.6, z = 1.5},
		},
		jitter = {
			min = {x = -0.2, y = -0.1, z = -0.2},
			max = {x = 0.2, y = 0.1, z = 0.2},
		},
		size = {min = 1.8 * s, max = 3.0 * s},
		exptime = {min = 1.2, max = 2.0},
		glow = 13,
		collisiondetection = false,
		collision_removal = false,
		texpool = SPIDER_POISON_CLOUD_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.1 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.45 * s, z = pos.z + 0.3 * s},
		minvel = {x = -0.6 * s, y = 0.2 * s, z = -0.6 * s},
		maxvel = {x = 0.6 * s, y = 0.75 * s, z = 0.6 * s},
		minacc = {x = -0.05, y = 0.15, z = -0.05},
		maxacc = {x = 0.05, y = 0.35, z = 0.05},
		minsize = 1.8 * s,
		maxsize = 3.0 * s,
		minexptime = 1.2,
		maxexptime = 2.0,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:2,3",
	})
end

--- Spawns complete multi-layered visceral death burst for the spider:
--- chitin shards, venom fountain, ruptured silk, eye sparks, and toxic mist
---@param pos Vector Center death position
---@param scale? number Scale multiplier (default 1.0)
---@param rotation? number|Vector|ObjectRef|table Mob yaw in radians, rotation vector, ObjectRef, or entity table
function x_mobs.spawn_spider_death(pos, scale, rotation)
	local s = scale or 1.0

	-- Extract mob yaw angle in radians
	local yaw = 0
	if type(rotation) == "number" then
		yaw = rotation
	elseif type(rotation) == "table" then
		if (rotation.x and rotation.z) and (not rotation.y or rotation.y == 0) and (rotation.x ~= 0 or rotation.z ~= 0) then
			yaw = core.dir_to_yaw(rotation)
		elseif rotation.y then
			yaw = rotation.y
		elseif rotation._cur_rot and rotation._cur_rot.y then
			yaw = rotation._cur_rot.y
		elseif rotation.object and rotation.object:is_valid() then
			yaw = rotation.object:get_yaw() or 0
		end
	elseif type(rotation) == "userdata" and rotation:is_valid() then
		yaw = rotation:get_yaw() or 0
	end

	-- Forward vector: direction spider is facing
	local fwd = core.yaw_to_dir(yaw)
	if not fwd or (fwd.x == 0 and fwd.z == 0) then
		fwd = {x = -math.sin(yaw), y = 0, z = math.cos(yaw)}
	else
		fwd = {x = fwd.x, y = 0, z = fwd.z}
	end
	local fwd_len = math.sqrt(fwd.x * fwd.x + fwd.z * fwd.z)
	if fwd_len > 0.0001 then
		fwd.x = fwd.x / fwd_len
		fwd.z = fwd.z / fwd_len
	else
		fwd = {x = 0, y = 0, z = 1}
	end

	-- Anatomical burst origins: head (eyes & fangs) and abdomen (spinnerets & venom sac)
	local head_pos = {x = pos.x + fwd.x * 0.35 * s, y = pos.y + 0.3 * s, z = pos.z + fwd.z * 0.35 * s}
	local ab_pos = {x = pos.x - fwd.x * 0.45 * s, y = pos.y + 0.35 * s, z = pos.z - fwd.z * 0.45 * s}

	-- 1. Chitin exoskeleton and spiny legs shatter from center
	x_mobs.spawn_spider_chitin(pos, 18, s)

	-- 2. Acidic venom fountain erupts from abdomen
	x_mobs.spawn_spider_venom_splatter(ab_pos, 24, s)

	-- 3. Ruptured silk filaments burst from spinnerets
	x_mobs.spawn_spider_silk_rupture(ab_pos, 18, s)

	-- 4. Menacing ruby eye embers shatter from cephalothorax
	x_mobs.spawn_spider_eye_shatter(head_pos, s)
end

--- Spawns soft dissolving necrotic venom mist when the spider corpse despawns
---@param pos Vector Center ground position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_spider_dissolve(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 18,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.05 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.35 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.0 * s, y = 0.1 * s, z = -1.0 * s},
			max = {x = 1.0 * s, y = 0.8 * s, z = 1.0 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.2, z = -0.1},
			max = {x = 0.1, y = 0.6, z = 0.1},
		},
		drag = {
			min = {x = 1.5, y = 1.0, z = 1.5},
			max = {x = 2.5, y = 1.8, z = 2.5},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		size = {min = 2.5 * s, max = 5.0 * s},
		exptime = {min = 0.9, max = 1.6},
		glow = 12,
		collisiondetection = false,
		collision_removal = false,
		texpool = SPIDER_POISON_CLOUD_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.05 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.35 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.0 * s, y = 0.1 * s, z = -1.0 * s},
		maxvel = {x = 1.0 * s, y = 0.8 * s, z = 1.0 * s},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.6, z = 0.1},
		minsize = 2.5 * s,
		maxsize = 5.0 * s,
		minexptime = 0.9,
		maxexptime = 1.6,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:2,3",
	})
end


local DEATH_FLAME_TEXPOOL = {
	{
		name = "x_mobs_flame_sheet.png",
		blend = "add",
		scale_tween = {
			{x = 0.55, y = 1.0},
			{x = 0.55, y = 1.0},
		},
		animation = {
			type = "vertical_frames",
			aspect_w = 32,
			aspect_h = 64,
			length = 1.35,
		},
	},
}

local DEATH_FLAME_ANIMATION = {
	type = "vertical_frames",
	aspect_w = 32,
	aspect_h = 64,
	length = 1.35,
}

local DEATH_SPARK_ANIMATION = {
	type = "vertical_frames",
	aspect_w = 16,
	aspect_h = 16,
	length = 0.6,
}

local RESURRECT_AURA_ANIMATION = {
	type = "vertical_frames",
	aspect_w = 16,
	aspect_h = 16,
	length = 0.75,
}

local FIREBALL_ANIMATION = {
	type = "vertical_frames",
	aspect_w = 16,
	aspect_h = 16,
	length = 0.5,
}

local DEATH_SPARK_TEXPOOL = {
	{
		name = "x_mobs_fireball.png",
		blend = "add",
		animation = DEATH_SPARK_ANIMATION,
	},
}


--- Spawns tall animated incinerating flame sheets and rising fire sparks covering where a mob body lies upon death
---@param pos Vector Center foot position of the dying mob
---@param scale? number Visual scale factor (e.g., 1.0 for minion, 1.4 for shaman)
---@param rotation? number|Vector|ObjectRef|table Mob yaw in radians, rotation vector, ObjectRef, or entity table
function x_mobs.spawn_death_flame(pos, scale, rotation)
	local s = scale or 1.0

	-- Extract mob yaw angle in radians
	local yaw = 0
	if type(rotation) == "number" then
		yaw = rotation
	elseif type(rotation) == "table" then
		if (rotation.x and rotation.z) and (not rotation.y or rotation.y == 0) and (rotation.x ~= 0 or rotation.z ~= 0) then
			-- Direction vector passed
			yaw = core.dir_to_yaw(rotation)
		elseif rotation.y then
			yaw = rotation.y
		elseif rotation._cur_rot and rotation._cur_rot.y then
			yaw = rotation._cur_rot.y
		elseif rotation.object and rotation.object:is_valid() then
			yaw = rotation.object:get_yaw() or 0
		end
	elseif type(rotation) == "userdata" and rotation:is_valid() then
		yaw = rotation:get_yaw() or 0
	end

	-- Forward vector: direction in which the mob faces and falls down onto the ground
	local fwd = core.yaw_to_dir(yaw)
	if not fwd or (fwd.x == 0 and fwd.z == 0) then
		fwd = {x = -math.sin(yaw), y = 0, z = math.cos(yaw)}
	else
		fwd = {x = fwd.x, y = 0, z = fwd.z}
	end
	local fwd_len = math.sqrt(fwd.x * fwd.x + fwd.z * fwd.z)
	if fwd_len > 0.0001 then
		fwd.x = fwd.x / fwd_len
		fwd.z = fwd.z / fwd_len
	else
		fwd = {x = 0, y = 0, z = 1}
	end

	-- Lateral vector: perpendicular to forward direction across the width of the fallen body
	local lat = {x = -fwd.z, y = 0, z = fwd.x}

	-- Distribution stations along the horizontal space of the fallen body (feet to head)
	local body_segments = {
		{dist = 0.15 * s, side =  0.00 * s, size = 10.5 * s}, -- Feet / ankles
		{dist = 0.42 * s, side = -0.10 * s, size = 12.5 * s}, -- Knees / lower legs
		{dist = 0.68 * s, side =  0.16 * s, size = 15.0 * s}, -- Pelvis / lower torso (right)
		{dist = 0.80 * s, side = -0.16 * s, size = 15.0 * s}, -- Torso / mid-body (left)
		{dist = 1.00 * s, side =  0.06 * s, size = 13.5 * s}, -- Chest / shoulders
		{dist = 1.25 * s, side = -0.04 * s, size = 11.0 * s}, -- Head / neck
	}

	local r = 0.06 * s

	for i = 1, #body_segments do
		local seg = body_segments[i]
		local sp_x = pos.x + fwd.x * seg.dist + lat.x * seg.side
		local sp_z = pos.z + fwd.z * seg.dist + lat.z * seg.side
		local flame_h = seg.size
		local flame_y = pos.y + (flame_h * 0.05) - 0.05

		core.add_particlespawner({
			amount = 1,
			time = 0.15,
			pos = {
				min = {x = sp_x - r, y = flame_y, z = sp_z - r},
				max = {x = sp_x + r, y = flame_y + 0.04, z = sp_z + r},
			},
			vel = {
				min = {x = -0.03, y = 0.04, z = -0.03},
				max = {x = 0.03, y = 0.10, z = 0.03},
			},
			acc = {
				min = {x = 0, y = 0.01, z = 0},
				max = {x = 0, y = 0.02, z = 0},
			},
			drag = {
				min = {x = 0.2, y = 0.1, z = 0.2},
				max = {x = 0.4, y = 0.2, z = 0.4},
			},
			jitter = {
				min = {x = -0.04, y = 0, z = -0.04},
				max = {x = 0.04, y = 0.02, z = 0.04},
			},
			size = flame_h,
			exptime = 1.35,
			glow = 14,
			collisiondetection = false,
			collision_removal = false,
			vertical = true,
			texpool = DEATH_FLAME_TEXPOOL,
			texture = "x_mobs_flame_sheet.png",
			animation = DEATH_FLAME_ANIMATION,

			minpos = {x = sp_x - r, y = flame_y, z = sp_z - r},
			maxpos = {x = sp_x + r, y = flame_y + 0.04, z = sp_z + r},
			minvel = {x = -0.03, y = 0.04, z = -0.03},
			maxvel = {x = 0.03, y = 0.10, z = 0.03},
			minacc = {x = 0, y = 0.01, z = 0},
			maxacc = {x = 0, y = 0.02, z = 0},
			minsize = flame_h,
			maxsize = flame_h,
			minexptime = 1.35,
			maxexptime = 1.35,
		})
	end

	-- Rising incinerating fire sparks drifting upwards from across the fallen body
	local head_x = pos.x + fwd.x * (1.3 * s)
	local head_z = pos.z + fwd.z * (1.3 * s)
	local min_x = math.min(pos.x, head_x) - 0.25 * s
	local max_x = math.max(pos.x, head_x) + 0.25 * s
	local min_z = math.min(pos.z, head_z) - 0.25 * s
	local max_z = math.max(pos.z, head_z) + 0.25 * s

	core.add_particlespawner({
		amount = math.floor(12 * s),
		time = 0.35,
		pos = {
			min = {x = min_x, y = pos.y + 0.05, z = min_z},
			max = {x = max_x, y = pos.y + 0.35, z = max_z},
		},
		vel = {
			min = {x = -0.15, y = 0.5, z = -0.15},
			max = {x = 0.15, y = 1.4, z = 0.15},
		},
		acc = {
			min = {x = -0.05, y = 0.1, z = -0.05},
			max = {x = 0.05, y = 0.3, z = 0.05},
		},
		drag = {
			min = {x = 0.3, y = 0.1, z = 0.3},
			max = {x = 0.6, y = 0.2, z = 0.6},
		},
		jitter = {
			min = {x = -0.3, y = -0.1, z = -0.3},
			max = {x = 0.3, y = 0.1, z = 0.3},
		},
		size = {min = 1.2 * s, max = 2.4 * s},
		exptime = {min = 0.8, max = 1.3},
		glow = 14,
		collisiondetection = false,
		collision_removal = false,
		texture = "x_mobs_fireball.png",
		animation = DEATH_SPARK_ANIMATION,
		texpool = DEATH_SPARK_TEXPOOL,

		minpos = {x = min_x, y = pos.y + 0.05, z = min_z},
		maxpos = {x = max_x, y = pos.y + 0.35, z = max_z},
		minvel = {x = -0.15, y = 0.5, z = -0.15},
		maxvel = {x = 0.15, y = 1.4, z = 0.15},
		minacc = {x = -0.05, y = 0.1, z = -0.05},
		maxacc = {x = 0.05, y = 0.3, z = 0.05},
		minsize = 1.2 * s,
		maxsize = 2.4 * s,
		minexptime = 0.8,
		maxexptime = 1.3,
	})
end

--- Spawns a rising fiery channeling aura around the Shaman during minion resurrection
---@param pos Vector Center position of the Shaman
function x_mobs.spawn_shaman_resurrect_particles(pos)
	core.add_particlespawner({
		amount = 20,
		time = 1.2,
		pos = {
			min = {x = pos.x - 1.0, y = pos.y, z = pos.z - 1.0},
			max = {x = pos.x + 1.0, y = pos.y + 1.0, z = pos.z + 1.0},
		},
		vel = {
			min = {x = -0.2, y = 1.0, z = -0.2},
			max = {x = 0.2, y = 2.0, z = 0.2},
		},
		acc = {
			min = {x = -0.1, y = 0.2, z = -0.1},
			max = {x = 0.1, y = 0.5, z = 0.1},
		},
		drag = {
			min = {x = 0.4, y = 0.1, z = 0.4},
			max = {x = 0.8, y = 0.2, z = 0.8},
		},
		jitter = {
			min = {x = -0.3, y = -0.1, z = -0.3},
			max = {x = 0.3, y = 0.1, z = 0.3},
		},
		exptime = {min = 0.5, max = 1.0},
		size = {min = 2, max = 4},
		glow = 14,
		collisiondetection = false,
		collision_removal = false,
		texpool = DEATH_SPARK_TEXPOOL,
		texture = "x_mobs_fireball.png",
		animation = RESURRECT_AURA_ANIMATION,

		minpos = {x = pos.x - 1.0, y = pos.y, z = pos.z - 1.0},
		maxpos = {x = pos.x + 1.0, y = pos.y + 1.0, z = pos.z + 1.0},
		minvel = {x = -0.2, y = 1.0, z = -0.2},
		maxvel = {x = 0.2, y = 2.0, z = 0.2},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.5, z = 0.1},
		minexptime = 0.5,
		maxexptime = 1.0,
		minsize = 2,
		maxsize = 4,
	})
end
x_mobs.spawn_resurrect_particles = x_mobs.spawn_shaman_resurrect_particles

--- Spawns an explosive fiery summoning eruption burst when a resurrected minion spawns
---@param pos Vector Center ground spawn position of the minion
function x_mobs.spawn_shaman_resurrect_burst(pos)
	core.add_particlespawner({
		amount = 30,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -2.0, y = 2.0, z = -2.0},
			max = {x = 2.0, y = 4.0, z = 2.0},
		},
		acc = {
			min = {x = -0.2, y = 0.5, z = -0.2},
			max = {x = 0.2, y = 1.5, z = 0.2},
		},
		drag = {
			min = {x = 0.8, y = 0.3, z = 0.8},
			max = {x = 1.6, y = 0.6, z = 1.6},
		},
		jitter = {
			min = {x = -0.5, y = -0.2, z = -0.5},
			max = {x = 0.5, y = 0.2, z = 0.5},
		},
		bounce = {min = 0.15, max = 0.35},
		exptime = {min = 0.4, max = 0.8},
		size = {min = 2, max = 5},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texpool = DEATH_SPARK_TEXPOOL,
		texture = "x_mobs_fireball.png",
		animation = DEATH_SPARK_ANIMATION,

		minpos = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.0, z = pos.z + 0.5},
		minvel = {x = -2.0, y = 2.0, z = -2.0},
		maxvel = {x = 2.0, y = 4.0, z = 2.0},
		minacc = {x = -0.2, y = 0.5, z = -0.2},
		maxacc = {x = 0.2, y = 1.5, z = 0.2},
		minexptime = 0.4,
		maxexptime = 0.8,
		minsize = 2,
		maxsize = 5,
	})
end
x_mobs.spawn_resurrect_burst = x_mobs.spawn_shaman_resurrect_burst

--- Spawns an erratic fiery spell disruption burst when the Shaman is struck during resurrection
---@param pos Vector Center position of the Shaman
function x_mobs.spawn_shaman_interrupted_burst(pos)
	core.add_particlespawner({
		amount = 40,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.5, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 1.8, z = pos.z + 0.8},
		},
		vel = {
			min = {x = -4.0, y = 0.5, z = -4.0},
			max = {x = 4.0, y = 3.0, z = 4.0},
		},
		acc = {
			min = {x = -0.5, y = -1.0, z = -0.5},
			max = {x = 0.5, y = -0.2, z = 0.5},
		},
		drag = {
			min = {x = 1.0, y = 0.4, z = 1.0},
			max = {x = 2.0, y = 0.8, z = 2.0},
		},
		jitter = {
			min = {x = -0.6, y = -0.3, z = -0.6},
			max = {x = 0.6, y = 0.3, z = 0.6},
		},
		bounce = {min = 0.1, max = 0.3},
		exptime = {min = 0.3, max = 0.7},
		size = {min = 3, max = 6},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texpool = DEATH_SPARK_TEXPOOL,
		texture = "x_mobs_fireball.png",
		animation = DEATH_SPARK_ANIMATION,

		minpos = {x = pos.x - 0.8, y = pos.y + 0.5, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 1.8, z = pos.z + 0.8},
		minvel = {x = -4.0, y = 0.5, z = -4.0},
		maxvel = {x = 4.0, y = 3.0, z = 4.0},
		minacc = {x = -0.5, y = -1.0, z = -0.5},
		maxacc = {x = 0.5, y = -0.2, z = 0.5},
		minexptime = 0.3,
		maxexptime = 0.7,
		minsize = 3,
		maxsize = 6,
	})
end
x_mobs.spawn_interrupted_burst = x_mobs.spawn_shaman_interrupted_burst

--- Spawns a floating particle ember behind a flying fireball projectile
---@param pos Vector Current world position of the fireball
function x_mobs.spawn_fireball_trail(pos)
	local vx = math.random() - 0.5
	local vy = math.random() - 0.5
	local vz = math.random() - 0.5
	core.add_particle({
		pos = pos,
		velocity = {x = vx, y = vy, z = vz},
		acceleration = {x = 0, y = 1.5, z = 0},
		expirationtime = 0.5,
		size = math.random(2, 4),
		collisiondetection = false,
		texture = "x_mobs_fireball.png",
		animation = FIREBALL_ANIMATION,
		glow = 14,
	})
end

--- Spawns an explosive fiery impact burst when a Shaman fireball detonates
---@param pos Vector Impact coordinate
function x_mobs.spawn_fireball_impact(pos)
	core.add_particlespawner({
		amount = 25,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		},
		vel = {
			min = {x = -2.5, y = -1.0, z = -2.5},
			max = {x = 2.5, y = 3.0, z = 2.5},
		},
		acc = {
			min = {x = -0.5, y = -2.0, z = -0.5},
			max = {x = 0.5, y = 1.0, z = 0.5},
		},
		drag = {
			min = {x = 1.0, y = 0.4, z = 1.0},
			max = {x = 2.0, y = 0.8, z = 2.0},
		},
		jitter = {
			min = {x = -0.5, y = -0.2, z = -0.5},
			max = {x = 0.5, y = 0.2, z = 0.5},
		},
		bounce = {min = 0.15, max = 0.35},
		exptime = {min = 0.3, max = 0.6},
		size = {min = 2, max = 5},
		glow = 14,
		collisiondetection = true,
		collision_removal = false,
		texpool = DEATH_SPARK_TEXPOOL,
		texture = "x_mobs_fireball.png",
		animation = FIREBALL_ANIMATION,

		minpos = {x = pos.x - 0.4, y = pos.y - 0.4, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		minvel = {x = -2.5, y = -1.0, z = -2.5},
		maxvel = {x = 2.5, y = 3.0, z = 2.5},
		minacc = {x = -0.5, y = -2.0, z = -0.5},
		maxacc = {x = 0.5, y = 1.0, z = 0.5},
		minexptime = 0.3,
		maxexptime = 0.6,
		minsize = 2,
		maxsize = 5,
	})
end

-- =========================================================================
-- ARMORED BUG PARTICLES & EFFECTS
-- =========================================================================

local CHITIN_SHATTER_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
}

local WING_SHRED_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.95, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
}

local ICHOR_BURST_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.2, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.4, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {2.2, 1.0},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.5, 0.9},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
}

local ICHOR_DISSOLVE_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.0, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.4, 3.4},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.8, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.5},
	},
}

--- Spawns sharp fractured chitin armor plate shards bursting outward with physical bounce
---@param pos Vector Center impact position
---@param count? integer Number of shards to spawn (default 16)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_chitin_shards(pos, count, scale)
	local num = count or 16
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.15 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 0.55 * s, z = pos.z + 0.25 * s},
		},
		vel = {
			min = {x = -3.2 * s, y = 1.2 * s, z = -3.2 * s},
			max = {x = 3.2 * s, y = 4.5 * s, z = 3.2 * s},
		},
		acc = {
			min = {x = -0.5, y = -9.81, z = -0.5},
			max = {x = 0.5, y = -9.81, z = 0.5},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		bounce = {min = 0.25, max = 0.45},
		size = {min = 1.9 * s, max = 3.4 * s},
		exptime = {min = 1.6, max = 2.6},
		glow = 2,
		collisiondetection = true,
		collision_removal = false,
		texpool = CHITIN_SHATTER_TEXPOOL,

		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.15 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 0.55 * s, z = pos.z + 0.25 * s},
		minvel = {x = -3.2 * s, y = 1.2 * s, z = -3.2 * s},
		maxvel = {x = 3.2 * s, y = 4.5 * s, z = 3.2 * s},
		minacc = {x = -0.5, y = -9.81, z = -0.5},
		maxacc = {x = 0.5, y = -9.81, z = 0.5},
		minsize = 1.9 * s,
		maxsize = 3.4 * s,
		minexptime = 1.6,
		maxexptime = 2.6,
		texture = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns pressurized toxic bioluminescent ichor droplet particles upon armor rupture
---@param pos Vector Center impact position
---@param count? integer Number of droplets to spawn (default 20)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_ichor_burst(pos, count, scale)
	local num = count or 20
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.10 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 0.50 * s, z = pos.z + 0.25 * s},
		},
		vel = {
			min = {x = -2.8 * s, y = 0.8 * s, z = -2.8 * s},
			max = {x = 2.8 * s, y = 3.6 * s, z = 2.8 * s},
		},
		acc = {
			min = {x = -0.3, y = -7.5, z = -0.3},
			max = {x = 0.3, y = -6.0, z = 0.3},
		},
		drag = {
			min = {x = 0.8, y = 0.4, z = 0.8},
			max = {x = 1.6, y = 0.8, z = 1.6},
		},
		jitter = {
			min = {x = -0.3, y = -0.15, z = -0.3},
			max = {x = 0.3, y = 0.15, z = 0.3},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.3 * s, max = 2.4 * s},
		exptime = {min = 0.8, max = 1.5},
		glow = 14,
		collisiondetection = true,
		collision_removal = true,
		texpool = ICHOR_BURST_TEXPOOL,

		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.10 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 0.50 * s, z = pos.z + 0.25 * s},
		minvel = {x = -2.8 * s, y = 0.8 * s, z = -2.8 * s},
		maxvel = {x = 2.8 * s, y = 3.6 * s, z = 2.8 * s},
		minacc = {x = -0.3, y = -7.5, z = -0.3},
		maxacc = {x = 0.3, y = -6.0, z = 0.3},
		minsize = 1.3 * s,
		maxsize = 2.4 * s,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns delicate fluttering translucent wing membrane scraps drifting downwards with drag
---@param pos Vector Center impact position
---@param count? integer Number of wing shreds to spawn (default 8)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_wing_shreds(pos, count, scale)
	local num = count or 8
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.6 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.2 * s, y = 0.2 * s, z = -1.2 * s},
			max = {x = 1.2 * s, y = 1.4 * s, z = 1.2 * s},
		},
		acc = {
			min = {x = -0.2, y = -1.5, z = -0.2},
			max = {x = 0.2, y = -0.6, z = 0.2},
		},
		drag = {
			min = {x = 2.0, y = 1.2, z = 2.0},
			max = {x = 3.5, y = 2.0, z = 3.5},
		},
		jitter = {
			min = {x = -1.5, y = -0.4, z = -1.5},
			max = {x = 1.5, y = 0.4, z = 1.5},
		},
		size = {min = 2.1 * s, max = 3.8 * s},
		exptime = {min = 2.2, max = 3.4},
		glow = 4,
		collisiondetection = true,
		collision_removal = false,
		texpool = WING_SHRED_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.2 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.6 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.2 * s, y = 0.2 * s, z = -1.2 * s},
		maxvel = {x = 1.2 * s, y = 1.4 * s, z = 1.2 * s},
		minacc = {x = -0.2, y = -1.5, z = -0.2},
		maxacc = {x = 0.2, y = -0.6, z = 0.2},
		minsize = 2.1 * s,
		maxsize = 3.8 * s,
		minexptime = 2.2,
		maxexptime = 3.4,
		texture = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns an expanding caustic acidic mist puff when the armored bug corpse despawns
---@param pos Vector Center ground/air coordinate
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_ichor_dissolve(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 18,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.3 * s, y = pos.y + 0.05 * s, z = pos.z - 0.3 * s},
			max = {x = pos.x + 0.3 * s, y = pos.y + 0.35 * s, z = pos.z + 0.3 * s},
		},
		vel = {
			min = {x = -1.0 * s, y = 0.1 * s, z = -1.0 * s},
			max = {x = 1.0 * s, y = 0.8 * s, z = 1.0 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.2, z = -0.1},
			max = {x = 0.1, y = 0.6, z = 0.1},
		},
		drag = {
			min = {x = 1.5, y = 1.0, z = 1.5},
			max = {x = 2.5, y = 1.8, z = 2.5},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		size = {min = 2.5 * s, max = 5.0 * s},
		exptime = {min = 0.9, max = 1.6},
		glow = 12,
		collisiondetection = false,
		collision_removal = false,
		texpool = ICHOR_DISSOLVE_TEXPOOL,

		minpos = {x = pos.x - 0.3 * s, y = pos.y + 0.05 * s, z = pos.z - 0.3 * s},
		maxpos = {x = pos.x + 0.3 * s, y = pos.y + 0.35 * s, z = pos.z + 0.3 * s},
		minvel = {x = -1.0 * s, y = 0.1 * s, z = -1.0 * s},
		maxvel = {x = 1.0 * s, y = 0.8 * s, z = 1.0 * s},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.6, z = 0.1},
		minsize = 2.5 * s,
		maxsize = 5.0 * s,
		minexptime = 0.9,
		maxexptime = 1.6,
		texture = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns complete multi-layered death explosion for the armored bug: shards, ichor, and wings
---@param pos Vector Center death position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_armored_bug_death(pos, scale)
	local s = scale or 1.0
	x_mobs.spawn_chitin_shards(pos, 16, s)
	x_mobs.spawn_ichor_burst(pos, 28, s)
	x_mobs.spawn_wing_shreds(pos, 8, s)
end

-- =========================================================================
-- FLYING INSECT PARTICLES & EFFECTS (Unarmored)
-- =========================================================================

local BUG_CARAPACE_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.7, 1.0},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
}

local BUG_WING_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.95, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.9, 1.1},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.7, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.6, 0.9},
		alpha_tween = {0.90, 0.30, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
}

local BUG_ICHOR_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.0, 0.8},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.2, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.2, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {1.9, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,2",
		blend = "alpha",
		scale_tween = {1.7, 0.7},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
}

local BUG_DISSOLVE_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,3",
		blend = "alpha",
		scale_tween = {1.0, 2.6},
		alpha_tween = {0.80, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.2, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.0, 2.5},
		alpha_tween = {0.80, 0.2, start = 0.45},
	},
}

--- Spawns organic insect carapace shards and leg segments
---@param pos Vector Center impact position
---@param count? integer Number of shards to spawn (default 12)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_bug_carapace_shards(pos, count, scale)
	local num = count or 12
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.22 * s, y = pos.y + 0.12 * s, z = pos.z - 0.22 * s},
			max = {x = pos.x + 0.22 * s, y = pos.y + 0.45 * s, z = pos.z + 0.22 * s},
		},
		vel = {
			min = {x = -2.8 * s, y = 1.0 * s, z = -2.8 * s},
			max = {x = 2.8 * s, y = 3.8 * s, z = 2.8 * s},
		},
		acc = {
			min = {x = -0.4, y = -9.81, z = -0.4},
			max = {x = 0.4, y = -9.81, z = 0.4},
		},
		drag = {
			min = {x = 0.6, y = 0.2, z = 0.6},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		jitter = {
			min = {x = -0.4, y = -0.2, z = -0.4},
			max = {x = 0.4, y = 0.2, z = 0.4},
		},
		bounce = {min = 0.2, max = 0.4},
		size = {min = 1.6 * s, max = 2.8 * s},
		exptime = {min = 1.4, max = 2.4},
		glow = 2,
		collisiondetection = true,
		collision_removal = false,
		texpool = BUG_CARAPACE_TEXPOOL,

		minpos = {x = pos.x - 0.22 * s, y = pos.y + 0.12 * s, z = pos.z - 0.22 * s},
		maxpos = {x = pos.x + 0.22 * s, y = pos.y + 0.45 * s, z = pos.z + 0.22 * s},
		minvel = {x = -2.8 * s, y = 1.0 * s, z = -2.8 * s},
		maxvel = {x = 2.8 * s, y = 3.8 * s, z = 2.8 * s},
		minacc = {x = -0.4, y = -9.81, z = -0.4},
		maxacc = {x = 0.4, y = -9.81, z = 0.4},
		minsize = 1.6 * s,
		maxsize = 2.8 * s,
		minexptime = 1.4,
		maxexptime = 2.4,
		texture = "x_mobs_bug_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns fluttering translucent wing shreds for the flying insect
---@param pos Vector Center impact position
---@param count? integer Number of wing shreds (default 8)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_bug_wing_shreds(pos, count, scale)
	local num = count or 8
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.20 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 0.50 * s, z = pos.z + 0.25 * s},
		},
		vel = {
			min = {x = -2.2 * s, y = 0.8 * s, z = -2.2 * s},
			max = {x = 2.2 * s, y = 2.8 * s, z = 2.2 * s},
		},
		acc = {
			min = {x = -0.8, y = -3.2, z = -0.8},
			max = {x = 0.8, y = -1.8, z = 0.8},
		},
		drag = {
			min = {x = 1.2, y = 0.8, z = 1.2},
			max = {x = 2.2, y = 1.6, z = 2.2},
		},
		jitter = {
			min = {x = -1.2, y = -0.4, z = -1.2},
			max = {x = 1.2, y = 0.4, z = 1.2},
		},
		size = {min = 1.6 * s, max = 2.6 * s},
		exptime = {min = 1.6, max = 2.8},
		glow = 1,
		collisiondetection = true,
		collision_removal = false,
		texpool = BUG_WING_TEXPOOL,

		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.20 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 0.50 * s, z = pos.z + 0.25 * s},
		minvel = {x = -2.2 * s, y = 0.8 * s, z = -2.2 * s},
		maxvel = {x = 2.2 * s, y = 2.8 * s, z = 2.2 * s},
		minacc = {x = -0.8, y = -3.2, z = -0.8},
		maxacc = {x = 0.8, y = -1.8, z = 0.8},
		minsize = 1.6 * s,
		maxsize = 2.6 * s,
		minexptime = 1.6,
		maxexptime = 2.8,
		texture = "x_mobs_bug_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns amber/emerald hemolymph droplets
---@param pos Vector Center impact position
---@param count? integer Number of droplets (default 16)
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_bug_ichor_burst(pos, count, scale)
	local num = count or 16
	local s = scale or 1.0
	core.add_particlespawner({
		amount = num,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.20 * s, y = pos.y + 0.10 * s, z = pos.z - 0.20 * s},
			max = {x = pos.x + 0.20 * s, y = pos.y + 0.45 * s, z = pos.z + 0.20 * s},
		},
		vel = {
			min = {x = -2.4 * s, y = 0.8 * s, z = -2.4 * s},
			max = {x = 2.4 * s, y = 3.2 * s, z = 2.4 * s},
		},
		acc = {
			min = {x = -0.3, y = -8.0, z = -0.3},
			max = {x = 0.3, y = -6.5, z = 0.3},
		},
		drag = {
			min = {x = 0.5, y = 0.2, z = 0.5},
			max = {x = 1.0, y = 0.3, z = 1.0},
		},
		bounce = {min = 0.1, max = 0.3},
		size = {min = 1.4 * s, max = 2.4 * s},
		exptime = {min = 1.2, max = 2.0},
		glow = 2,
		collisiondetection = true,
		collision_removal = false,
		texpool = BUG_ICHOR_TEXPOOL,

		minpos = {x = pos.x - 0.20 * s, y = pos.y + 0.10 * s, z = pos.z - 0.20 * s},
		maxpos = {x = pos.x + 0.20 * s, y = pos.y + 0.45 * s, z = pos.z + 0.20 * s},
		minvel = {x = -2.4 * s, y = 0.8 * s, z = -2.4 * s},
		maxvel = {x = 2.4 * s, y = 3.2 * s, z = 2.4 * s},
		minacc = {x = -0.3, y = -8.0, z = -0.3},
		maxacc = {x = 0.3, y = -6.5, z = 0.3},
		minsize = 1.4 * s,
		maxsize = 2.4 * s,
		minexptime = 1.2,
		maxexptime = 2.0,
		texture = "x_mobs_bug_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns dissolve vapor for the flying insect
---@param pos Vector Center impact position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_bug_dissolve(pos, scale)
	local s = scale or 1.0
	core.add_particlespawner({
		amount = 12,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.25 * s, y = pos.y + 0.15 * s, z = pos.z - 0.25 * s},
			max = {x = pos.x + 0.25 * s, y = pos.y + 0.45 * s, z = pos.z + 0.25 * s},
		},
		vel = {
			min = {x = -0.8 * s, y = 0.3 * s, z = -0.8 * s},
			max = {x = 0.8 * s, y = 0.9 * s, z = 0.8 * s},
		},
		acc = {
			min = {x = -0.1, y = 0.2, z = -0.1},
			max = {x = 0.1, y = 0.5, z = 0.1},
		},
		drag = {
			min = {x = 0.8, y = 0.5, z = 0.8},
			max = {x = 1.5, y = 1.0, z = 1.5},
		},
		size = {min = 2.2 * s, max = 4.2 * s},
		exptime = {min = 0.8, max = 1.5},
		glow = 2,
		collisiondetection = false,
		texpool = BUG_DISSOLVE_TEXPOOL,

		minpos = {x = pos.x - 0.25 * s, y = pos.y + 0.15 * s, z = pos.z - 0.25 * s},
		maxpos = {x = pos.x + 0.25 * s, y = pos.y + 0.45 * s, z = pos.z + 0.25 * s},
		minvel = {x = -0.8 * s, y = 0.3 * s, z = -0.8 * s},
		maxvel = {x = 0.8 * s, y = 0.9 * s, z = 0.8 * s},
		minacc = {x = -0.1, y = 0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.5, z = 0.1},
		minsize = 2.2 * s,
		maxsize = 4.2 * s,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_bug_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns complete death effect for flying insect
---@param pos Vector Center death position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_flying_insect_death(pos, scale)
	local s = scale or 1.0
	x_mobs.spawn_bug_carapace_shards(pos, 12, s)
	x_mobs.spawn_bug_ichor_burst(pos, 20, s)
	x_mobs.spawn_bug_wing_shreds(pos, 8, s)
end

-- =========================================================================
-- DECLARATIVE VFX DISPATCHER & EVENT LISTENERS
-- =========================================================================

--- Dispatches a single particle effect specification
---@param pos Vector Base world position
---@param rot number Yaw rotation in radians
---@param spec string|table Particle effect descriptor
local function play_single_vfx(pos, rot, spec)
	if not spec or not pos then return end
	local vtype = (type(spec) == "string" and spec) or spec.type
	if not vtype then return end

	if vtype == "flame" then
		x_mobs.spawn_death_flame(pos, (type(spec) == "table" and spec.scale) or 1.0, rot)
	elseif vtype == "venom" then
		x_mobs.spawn_venom_particles(pos, (type(spec) == "table" and spec.count) or 8)
	elseif vtype == "web" then
		x_mobs.spawn_web_particles(pos, (type(spec) == "table" and spec.dir) or {x = 0, y = 1, z = 0})
	elseif vtype == "spider_skitter" then
		x_mobs.spawn_spider_skitter(pos)
	elseif vtype == "spider_death" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_death(pos, scale, rot)
	elseif vtype == "spider_chitin" then
		local count = (type(spec) == "table" and spec.count) or 16
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_chitin(pos, count, scale)
	elseif vtype == "spider_venom_splatter" then
		local count = (type(spec) == "table" and spec.count) or 24
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_venom_splatter(pos, count, scale)
	elseif vtype == "spider_silk_rupture" then
		local count = (type(spec) == "table" and spec.count) or 18
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_silk_rupture(pos, count, scale)
	elseif vtype == "spider_eye_shatter" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_eye_shatter(pos, scale)
	elseif vtype == "spider_poison_mist" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_poison_mist(pos, scale)
	elseif vtype == "spider_dissolve" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_dissolve(pos, scale)
	elseif vtype == "chitin_shatter" or vtype == "chitin_shards" then
		local count = (type(spec) == "table" and spec.count) or 16
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_chitin_shards(pos, count, scale)
	elseif vtype == "ichor_burst" or vtype == "ichor" then
		local count = (type(spec) == "table" and spec.count) or 28
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_ichor_burst(pos, count, scale)
	elseif vtype == "wing_shreds" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_wing_shreds(pos, count, scale)
	elseif vtype == "ichor_dissolve" then
		x_mobs.spawn_ichor_dissolve(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "armored_bug_death" then
		x_mobs.spawn_armored_bug_death(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "bug_carapace" or vtype == "bug_shards" then
		local count = (type(spec) == "table" and spec.count) or 12
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_bug_carapace_shards(pos, count, scale)
	elseif vtype == "bug_ichor_burst" or vtype == "bug_ichor" then
		local count = (type(spec) == "table" and spec.count) or 16
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_bug_ichor_burst(pos, count, scale)
	elseif vtype == "bug_wing_shreds" or vtype == "bug_wings" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_bug_wing_shreds(pos, count, scale)
	elseif vtype == "bug_dissolve" then
		x_mobs.spawn_bug_dissolve(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "flying_insect_death" then
		x_mobs.spawn_flying_insect_death(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "shaman_resurrect" then
		x_mobs.spawn_shaman_resurrect_particles(pos)
	elseif vtype == "shaman_resurrect_burst" then
		x_mobs.spawn_shaman_resurrect_burst(pos)
	elseif vtype == "shaman_interrupted" then
		x_mobs.spawn_shaman_interrupted_burst(pos)
	elseif vtype == "fireball_trail" then
		x_mobs.spawn_fireball_trail(pos)
	elseif vtype == "fireball_impact" then
		x_mobs.spawn_fireball_impact(pos)
	elseif vtype == "bone_dust" then
		x_mobs.spawn_bone_dust(pos)
	elseif vtype == "magic_summon" then
		x_mobs.spawn_magic_summon(pos)
	elseif vtype == "mushroom_dissolve" or vtype == "fungus_dissolve" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_dissolve(pos, scale)
	elseif vtype == "mushroom_hurt" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_hurt(pos, scale)
	elseif vtype == "mushroom_death" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_death(pos, scale)
	elseif vtype == "fungus_hurt" then
		x_mobs.spawn_fungus_hurt(pos)
	elseif vtype == "fungus_death" then
		x_mobs.spawn_fungus_death(pos)
	end
end

--- Dispatches visual effects defined in a mob's declarative vfx table
---@param mob table Mob entity instance
---@param stage "hurt"|"death"|"despawn" Visual effect stage
function x_mobs.play_vfx(mob, stage)
	if not mob or not mob.vfx then return end
	local spec = mob.vfx[stage]
	if not spec or not mob.object then return end

	local pos = mob.object:get_pos()
	if not pos then return end
	local rot = (mob._cur_rot and mob._cur_rot.y) or (mob.object:is_valid() and mob.object:get_yaw()) or 0

	if type(spec) == "table" and spec[1] then
		for i = 1, #spec do
			play_single_vfx(pos, rot, spec[i])
		end
	else
		play_single_vfx(pos, rot, spec)
	end
end

-- Automatic lifecycle listeners for declarative mob VFX
x_mob_core.listen("on_mob_hurt", function(mob, _puncher, _dmg)
	x_mobs.play_vfx(mob, "hurt")
end)

x_mob_core.listen("on_mob_death", function(mob, _puncher)
	x_mobs.play_vfx(mob, "death")
end)

x_mob_core.listen("on_mob_despawn", function(mob)
	x_mobs.play_vfx(mob, "despawn")
end)

function x_mobs.spawn_bone_dust(pos)
	local p_min = vector.subtract(pos, 0.5)
	local p_max = vector.add(pos, 0.5)
	local v_min = {x = -1, y = 0.5, z = -1}
	local v_max = {x = 1, y = 3, z = 1}
	local a_vec = {x = 0, y = -4, z = 0}
	core.add_particlespawner({
		amount = 16,
		time = 0.2,
		-- Modern syntax
		pos = {min = p_min, max = p_max},
		vel = {min = v_min, max = v_max},
		acc = {min = a_vec, max = a_vec},
		exptime = {min = 0.6, max = 1.2},
		size = {min = 3, max = 6},
		collisiondetection = true,
		collision_removal = true,
		texture = "x_mobs_bone_dust.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = -1},
		-- Legacy fallback
		minpos = p_min,
		maxpos = p_max,
		minvel = v_min,
		maxvel = v_max,
		minacc = a_vec,
		maxacc = a_vec,
		minexptime = 0.6,
		maxexptime = 1.2,
		minsize = 3,
		maxsize = 6,
	})
end

--- Spawns summoning magic rune particles at a location or attached to an entity
---@param pos? Vector World position (required if attached is nil)
---@param attached? ObjectRef Optional object reference to attach particles to
---@return integer|nil spawner_id Particle spawner identifier
function x_mobs.spawn_magic_summon(pos, attached)
	local v_min = {x = 0, y = 0.2, z = 0}
	local v_max = {x = 0, y = 0.5, z = 0}
	local p_min = attached and {x = -0.3, y = 0.8, z = -0.3} or (pos or {x = 0, y = 0, z = 0})
	local p_max = attached and {x = 0.3, y = 1.6, z = 0.3} or (pos or {x = 0, y = 0, z = 0})
	return core.add_particlespawner({
		amount = 1,
		time = 0.1,
		attached = attached,
		-- Modern syntax
		pos = {min = p_min, max = p_max},
		vel = {min = v_min, max = v_max},
		acc = {min = {x = 0, y = 0, z = 0}, max = {x = 0, y = 0, z = 0}},
		exptime = {min = 1.5, max = 1.5},
		size = {min = 16, max = 18},
		texture = "x_mobs_skull_magic.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = -1},
		glow = 8,
		-- Legacy fallback
		minpos = p_min,
		maxpos = p_max,
		minvel = v_min,
		maxvel = v_max,
		minexptime = 1.5,
		maxexptime = 1.5,
		minsize = 16,
		maxsize = 18,
	})
end

--- Spawns mystical health regeneration runes attached to a mob entity
---@param obj ObjectRef Mob object reference
---@return integer|nil spawner_id Particle spawner identifier
function x_mobs.spawn_regen_particles(obj)
	if not obj or not obj:is_valid() then return nil end
	local p_min = {x = -0.35, y = 0.6, z = -0.35}
	local p_max = {x = 0.35, y = 1.8, z = 0.35}
	local v_min = {x = -0.1, y = 0.4, z = -0.1}
	local v_max = {x = 0.1, y = 0.8, z = 0.1}
	local a_min = {x = 0, y = 0.1, z = 0}
	local a_max = {x = 0, y = 0.2, z = 0}
	return core.add_particlespawner({
		amount = 2,
		time = 0.2,
		attached = obj,
		-- Modern syntax
		pos = {min = p_min, max = p_max},
		vel = {min = v_min, max = v_max},
		acc = {min = a_min, max = a_max},
		jitter = {min = {x = -0.2, y = -0.1, z = -0.2}, max = {x = 0.2, y = 0.1, z = 0.2}},
		drag = {min = {x = 0.1, y = 0.05, z = 0.1}, max = {x = 0.2, y = 0.1, z = 0.2}},
		exptime = {min = 1.2, max = 1.6},
		size = {min = 8, max = 11},
		texture = "x_mobs_skull_magic.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = -1},
		glow = 10,
		-- Legacy fallback
		minpos = p_min,
		maxpos = p_max,
		minvel = v_min,
		maxvel = v_max,
		minacc = a_min,
		maxacc = a_max,
		minexptime = 1.2,
		maxexptime = 1.6,
		minsize = 8,
		maxsize = 11,
	})
end

-- ============================================================================
-- Crystal Guardian Particle Pools (Amethyst Shards, Ground Shockwave, Basalt Rocks, Sparkles, Dust)
-- ============================================================================

local CRYSTAL_SHARD_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,0",
		blend = "add",
		scale_tween = {1.6, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,0",
		blend = "add",
		scale_tween = {1.8, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,0",
		blend = "add",
		scale_tween = {2.0, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,0",
		blend = "add",
		scale_tween = {1.4, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,0",
		blend = "add",
		scale_tween = {1.7, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,0",
		blend = "add",
		scale_tween = {1.5, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:7,0",
		blend = "add",
		scale_tween = {1.6, 0.3},
		alpha_tween = {1.0, 0.0},
	},
}

local CRYSTAL_SMASH_WAVE_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,1",
		blend = "add",
		scale_tween = {1.0, 3.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,1",
		blend = "add",
		scale_tween = {1.2, 3.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,1",
		blend = "add",
		scale_tween = {1.4, 3.0},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,1",
		blend = "add",
		scale_tween = {1.3, 3.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,1",
		blend = "add",
		scale_tween = {1.5, 3.6},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,1",
		blend = "add",
		scale_tween = {1.1, 3.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:6,1",
		blend = "add",
		scale_tween = {1.4, 4.0},
		alpha_tween = {1.0, 0.0},
	},
}

local CRYSTAL_ROCK_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {1.5, 0.8},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
}

local CRYSTAL_SPARKLE_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.5, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.6, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,3",
		blend = "add",
		scale_tween = {1.4, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,3",
		blend = "add",
		scale_tween = {1.3, 0.15},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,3",
		blend = "add",
		scale_tween = {1.8, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:7,3",
		blend = "add",
		scale_tween = {1.5, 0.2},
		alpha_tween = {1.0, 0.0},
	},
}

local CRYSTAL_DUST_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.8, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {1.5, 3.6},
		alpha_tween = {0.75, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {1.3, 3.0},
		alpha_tween = {0.85, 0.0, start = 0.35},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,4",
		blend = "alpha",
		scale_tween = {1.6, 3.8},
		alpha_tween = {0.8, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,4",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.7, 0.0, start = 0.4},
	},
}

--- Spawns sharp amethyst crystal shards and basalt chips on hit
---@param pos Vector World impact position
---@param count? integer Number of particles (default: 14)
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

local node_tile_cache = {}

--- Retrieves the primary tile texture name for a given node for particle fallback
---@param node_name string Name of the node
---@return string texture Name of the texture or fallback
local function get_node_tile_texture(node_name)
	if not node_name or node_name == "" or node_name == "air" or node_name == "ignore" then
		return "default_stone.png"
	end
	local cached = node_tile_cache[node_name]
	if cached then
		return cached
	end

	local tex = ""
	local ndef = core.registered_nodes[node_name]
	if ndef and ndef.tiles then
		local t = ndef.tiles[1]
		if type(t) == "string" then
			tex = t
		elseif type(t) == "table" and t.name then
			tex = t.name
		end
	end
	if tex == "" then
		tex = "default_stone.png"
	end
	node_tile_cache[node_name] = tex
	return tex
end

--- Samples the solid surface node directly under an impact position
---@param pos Vector Impact coordinate
---@return table node Node table with name and param2
function x_mobs.sample_ground_node(pos)
	if not pos then return { name = "default:stone", param2 = 0 } end
	local p = vector.round(pos)
	for dy = 0, -2, -1 do
		local check_p = { x = p.x, y = p.y + dy, z = p.z }
		local node = core.get_node_or_nil(check_p)
		if node and node.name ~= "air" and node.name ~= "ignore" then
			local ndef = core.registered_nodes[node.name]
			if ndef and ndef.walkable ~= false and ndef.drawtype ~= "airlike" then
				return node
			end
		end
	end
	local below = core.get_node_or_nil({ x = p.x, y = p.y - 1, z = p.z })
	if below and below.name ~= "air" and below.name ~= "ignore" then
		return below
	end
	return { name = "default:stone", param2 = 0 }
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

		minpos = {x = pos.x - 1.0, y = pos.y + 1.0, z = pos.z - 1.0},
		maxpos = {x = pos.x + 1.0, y = pos.y + 2.2, z = pos.z + 1.0},
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

-- ============================================================================
-- Crazy Mushroom & Fungus Minion Particle Pools & Visual Effects
-- ============================================================================

local MUSHROOM_CAP_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.5, 1.6},
		alpha_tween = {1.0, 0.5, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.5, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

local MUSHROOM_STEM_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.9, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {2.1, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {2.0, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.7, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,1",
		blend = "alpha",
		scale_tween = {1.6, 0.8},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

local MUSHROOM_SPORE_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
		blend = "add",
		scale_tween = {1.5, 2.6},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,2",
		blend = "add",
		scale_tween = {1.4, 2.8},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,2",
		blend = "add",
		scale_tween = {1.6, 2.7},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,2",
		blend = "add",
		scale_tween = {1.3, 2.5},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,2",
		blend = "add",
		scale_tween = {1.7, 3.0},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,2",
		blend = "add",
		scale_tween = {1.2, 2.4},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,2",
		blend = "add",
		scale_tween = {1.5, 2.9},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,2",
		blend = "add",
		scale_tween = {1.4, 2.5},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

local MUSHROOM_BLOOM_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.2, 3.0},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.4, 3.2},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,3",
		blend = "add",
		scale_tween = {1.1, 2.8},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,3",
		blend = "add",
		scale_tween = {1.5, 3.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,3",
		blend = "add",
		scale_tween = {1.3, 3.1},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,3",
		blend = "add",
		scale_tween = {1.0, 2.6},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,3",
		blend = "add",
		scale_tween = {1.4, 3.3},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,3",
		blend = "add",
		scale_tween = {1.2, 2.9},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
}

local MUSHROOM_SLIME_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {1.6, 0.7},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {1.4, 0.5},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,4",
		blend = "alpha",
		scale_tween = {1.7, 0.65},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,4",
		blend = "alpha",
		scale_tween = {1.3, 0.5},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,4",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,4",
		blend = "alpha",
		scale_tween = {1.2, 0.45},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,4",
		blend = "alpha",
		scale_tween = {1.4, 0.55},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
}

local MUSHROOM_SMOKE_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,6",
		blend = "alpha",
		scale_tween = {1.6, 3.2},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,6",
		blend = "alpha",
		scale_tween = {1.8, 3.5},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,6",
		blend = "alpha",
		scale_tween = {1.5, 3.0},
		alpha_tween = {0.75, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,6",
		blend = "alpha",
		scale_tween = {1.9, 3.6},
		alpha_tween = {0.85, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,6",
		blend = "alpha",
		scale_tween = {1.4, 2.9},
		alpha_tween = {0.75, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,6",
		blend = "alpha",
		scale_tween = {1.7, 3.3},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,6",
		blend = "alpha",
		scale_tween = {1.3, 2.7},
		alpha_tween = {0.7, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,6",
		blend = "alpha",
		scale_tween = {1.5, 3.1},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
}

--- Spawns scattered cap debris, stem fibers, and a violet spore burst upon mushroom taking damage
---@param pos Vector Impact position
---@param scale? number Scale multiplier (default 1.0)
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
