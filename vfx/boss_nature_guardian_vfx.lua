--[[
	x_mobs - Nature Guardian Boss Particle Systems
	Wood punches, attacks, cast charge, entangling roots bursts, trapped roots, root shatter, hurt, and death
--]]

local texpools = x_mobs.texpools
local NATURE_LEAF_TEXPOOL = texpools.NATURE_LEAF_TEXPOOL
local NATURE_BARK_TEXPOOL = texpools.NATURE_BARK_TEXPOOL
local NATURE_RUNE_TEXPOOL = texpools.NATURE_RUNE_TEXPOOL
local NATURE_SOIL_TEXPOOL = texpools.NATURE_SOIL_TEXPOOL
local NATURE_ROOT_TEXPOOL = texpools.NATURE_ROOT_TEXPOOL
local NATURE_MOTE_TEXPOOL = texpools.NATURE_MOTE_TEXPOOL
local NATURE_CRACK_TEXPOOL = texpools.NATURE_CRACK_TEXPOOL
local NATURE_SLASH_TEXPOOL = texpools.NATURE_SLASH_TEXPOOL

function x_mobs.spawn_nature_guardian_punch(pos, dir)
	local p_dir = dir or {x = 0, y = 0.5, z = 0}
	core.add_particlespawner({
		amount = 12,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = p_dir.x * 2.0 - 0.8, y = p_dir.y * 1.5 + 0.2, z = p_dir.z * 2.0 - 0.8},
			max = {x = p_dir.x * 3.5 + 0.8, y = p_dir.y * 2.5 + 1.2, z = p_dir.z * 3.5 + 0.8},
		},
		acc = {min = {x = 0, y = -5.0, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		size = {min = 1.6, max = 3.0},
		exptime = {min = 0.6, max = 1.2},
		glow = 8,
		collisiondetection = true,
		texpool = NATURE_LEAF_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = p_dir.x * 2.0 - 0.8, y = p_dir.y * 1.5 + 0.2, z = p_dir.z * 2.0 - 0.8},
		maxvel = {x = p_dir.x * 3.5 + 0.8, y = p_dir.y * 2.5 + 1.2, z = p_dir.z * 3.5 + 0.8},
		minacc = {x = 0, y = -5.0, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.6,
		maxsize = 3.0,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,0",
	})
	core.add_particlespawner({
		amount = 10,
		time = 0.08,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {min = {x = -1.5, y = 0.5, z = -1.5}, max = {x = 1.5, y = 2.5, z = 1.5}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -9.8, z = 0}},
		size = {min = 1.4, max = 2.6},
		exptime = {min = 0.5, max = 0.9},
		collisiondetection = true,
		texpool = NATURE_BARK_TEXPOOL,
		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -1.5, y = 0.5, z = -1.5},
		maxvel = {x = 1.5, y = 2.5, z = 1.5},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -9.8, z = 0},
		minsize = 1.4,
		maxsize = 2.6,
		minexptime = 0.5,
		maxexptime = 0.9,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,1",
	})
	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
			max = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		},
		vel = {min = {x = -0.5, y = -0.5, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5}},
		size = {min = 1.8, max = 3.0},
		exptime = {min = 0.2, max = 0.4},
		glow = 12,
		texpool = NATURE_SLASH_TEXPOOL,
		minpos = {x = pos.x - 0.1, y = pos.y - 0.1, z = pos.z - 0.1},
		maxpos = {x = pos.x + 0.1, y = pos.y + 0.1, z = pos.z + 0.1},
		minvel = {x = -0.5, y = -0.5, z = -0.5},
		maxvel = {x = 0.5, y = 0.5, z = 0.5},
		minsize = 1.8,
		maxsize = 3.0,
		minexptime = 0.2,
		maxexptime = 0.4,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,7",
	})
end

--- Spawns heavy overhead trunk slam shockwave with flying autumn foliage and bark chunks
---@param pos Vector Impact world coordinates
---@param dir? Vector Attack strike vector
function x_mobs.spawn_nature_guardian_attack(pos, dir)
	local p_dir = dir or {x = 0, y = 0, z = 0}
	core.add_particlespawner({
		amount = 28,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		},
		vel = {
			min = {x = p_dir.x - 2.8, y = 1.5, z = p_dir.z - 2.8},
			max = {x = p_dir.x + 2.8, y = 4.2, z = p_dir.z + 2.8},
		},
		acc = {min = {x = 0, y = -6.0, z = 0}, max = {x = 0, y = -8.5, z = 0}},
		drag = {min = {x = 0.5, y = 0.2, z = 0.5}, max = {x = 1.0, y = 0.4, z = 1.0}},
		size = {min = 2.0, max = 4.2},
		exptime = {min = 1.0, max = 2.0},
		glow = 10,
		collisiondetection = true,
		texpool = NATURE_LEAF_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		minvel = {x = p_dir.x - 2.8, y = 1.5, z = p_dir.z - 2.8},
		maxvel = {x = p_dir.x + 2.8, y = 4.2, z = p_dir.z + 2.8},
		minacc = {x = 0, y = -6.0, z = 0},
		maxacc = {x = 0, y = -8.5, z = 0},
		minsize = 2.0,
		maxsize = 4.2,
		minexptime = 1.0,
		maxexptime = 2.0,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,0",
	})
	core.add_particlespawner({
		amount = 18,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.05, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 0.2, z = pos.z + 0.8},
		},
		vel = {min = {x = -3.2, y = 0.2, z = -3.2}, max = {x = 3.2, y = 1.0, z = 3.2}},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -4.0, z = 0}},
		size = {min = 2.2, max = 3.8},
		exptime = {min = 0.6, max = 1.2},
		collisiondetection = true,
		texpool = NATURE_CRACK_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + 0.05, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 0.2, z = pos.z + 0.8},
		minvel = {x = -3.2, y = 0.2, z = -3.2},
		maxvel = {x = 3.2, y = 1.0, z = 3.2},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -4.0, z = 0},
		minsize = 2.2,
		maxsize = 3.8,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns swirling golden/verdant nature motes converging during spell channeling
---@param pos Vector World position around Guardian
---@param _obj? ObjectRef Guardian entity
function x_mobs.spawn_nature_guardian_cast_charge(pos, _obj)
	core.add_particlespawner({
		amount = 32,
		time = 0.9,
		pos = {
			min = {x = pos.x - 1.2, y = pos.y + 0.5, z = pos.z - 1.2},
			max = {x = pos.x + 1.2, y = pos.y + 2.8, z = pos.z + 1.2},
		},
		vel = {min = {x = -0.5, y = 0.5, z = -0.5}, max = {x = 0.5, y = 1.8, z = 0.5}},
		acc = {min = {x = -0.2, y = 0.5, z = -0.2}, max = {x = 0.2, y = 1.2, z = 0.2}},
		size = {min = 2.0, max = 3.8},
		exptime = {min = 0.8, max = 1.5},
		glow = 14,
		collisiondetection = false,
		texpool = NATURE_RUNE_TEXPOOL,
		minpos = {x = pos.x - 1.2, y = pos.y + 0.5, z = pos.z - 1.2},
		maxpos = {x = pos.x + 1.2, y = pos.y + 2.8, z = pos.z + 1.2},
		minvel = {x = -0.5, y = 0.5, z = -0.5},
		maxvel = {x = 0.5, y = 1.8, z = 0.5},
		minacc = {x = -0.2, y = 0.5, z = -0.2},
		maxacc = {x = 0.2, y = 1.2, z = 0.2},
		minsize = 2.0,
		maxsize = 3.8,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns soil eruption debris, climbing root tendrils, and leaf spray when entangling roots spawn
---@param pos Vector Ground spawn position
function x_mobs.spawn_nature_roots_burst(pos)
	core.add_particlespawner({
		amount = 26,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		},
		vel = {min = {x = -2.0, y = 2.5, z = -2.0}, max = {x = 2.0, y = 4.5, z = 2.0}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -12.0, z = 0}},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.8, max = 1.6},
		collisiondetection = true,
		texpool = NATURE_SOIL_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.3, z = pos.z + 0.5},
		minvel = {x = -2.0, y = 2.5, z = -2.0},
		maxvel = {x = 2.0, y = 4.5, z = 2.0},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -12.0, z = 0},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,3",
	})
	core.add_particlespawner({
		amount = 16,
		time = 0.3,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		},
		vel = {min = {x = -0.5, y = 1.2, z = -0.5}, max = {x = 0.5, y = 2.8, z = 0.5}},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -4.0, z = 0}},
		size = {min = 2.2, max = 4.0},
		exptime = {min = 0.8, max = 1.5},
		collisiondetection = true,
		texpool = NATURE_ROOT_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		minvel = {x = -0.5, y = 1.2, z = -0.5},
		maxvel = {x = 0.5, y = 2.8, z = 0.5},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -4.0, z = 0},
		minsize = 2.2,
		maxsize = 4.0,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns subtle ambient leaf rustle & dust motes around trapped player feet and knees
---@param pos Vector Trapped entity feet coordinates
function x_mobs.spawn_nature_roots_trapped(pos)
	core.add_particlespawner({
		amount = 4,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y + 0.05, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.55, z = pos.z + 0.35},
		},
		vel = {min = {x = -0.2, y = 0.1, z = -0.2}, max = {x = 0.2, y = 0.4, z = 0.2}},
		acc = {min = {x = 0, y = -0.2, z = 0}, max = {x = 0, y = -0.4, z = 0}},
		size = {min = 1.2, max = 2.0},
		exptime = {min = 0.5, max = 1.0},
		glow = 6,
		collisiondetection = false,
		texpool = NATURE_MOTE_TEXPOOL,
		minpos = {x = pos.x - 0.35, y = pos.y + 0.05, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.55, z = pos.z + 0.35},
		minvel = {x = -0.2, y = 0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.4, z = 0.2},
		minacc = {x = 0, y = -0.2, z = 0},
		maxacc = {x = 0, y = -0.4, z = 0},
		minsize = 1.2,
		maxsize = 2.0,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,5",
	})
end

--- Spawns splintering wood fragments and fading green motes when roots are broken or wither
---@param pos Vector Ground roots center coordinates
function x_mobs.spawn_nature_roots_shatter(pos)
	core.add_particlespawner({
		amount = 20,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.58, z = pos.z + 0.35},
		},
		vel = {min = {x = -1.8, y = 0.8, z = -1.8}, max = {x = 1.8, y = 2.8, z = 1.8}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -9.8, z = 0}},
		size = {min = 1.4, max = 2.8},
		exptime = {min = 0.5, max = 1.0},
		collisiondetection = true,
		texpool = NATURE_BARK_TEXPOOL,
		minpos = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.58, z = pos.z + 0.35},
		minvel = {x = -1.8, y = 0.8, z = -1.8},
		maxvel = {x = 1.8, y = 2.8, z = 1.8},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -9.8, z = 0},
		minsize = 1.4,
		maxsize = 2.8,
		minexptime = 0.5,
		maxexptime = 1.0,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,1",
	})
	core.add_particlespawner({
		amount = 14,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.58, z = pos.z + 0.35},
		},
		vel = {min = {x = -0.6, y = 0.3, z = -0.6}, max = {x = 0.6, y = 1.4, z = 0.6}},
		acc = {min = {x = 0, y = 0.4, z = 0}, max = {x = 0, y = 1.0, z = 0}},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.5, max = 1.2},
		glow = 12,
		collisiondetection = false,
		texpool = NATURE_MOTE_TEXPOOL,
		minpos = {x = pos.x - 0.35, y = pos.y + 0.1, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.58, z = pos.z + 0.35},
		minvel = {x = -0.6, y = 0.3, z = -0.6},
		maxvel = {x = 0.6, y = 1.4, z = 0.6},
		minacc = {x = 0, y = 0.4, z = 0},
		maxacc = {x = 0, y = 1.0, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.5,
		maxexptime = 1.2,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,5",
	})
end

--- Spawns drifting bark flakes and fluttering autumn foliage when Guardian takes damage
---@param pos Vector Center damage coordinates
function x_mobs.spawn_nature_guardian_hurt(pos)
	core.add_particlespawner({
		amount = 14,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 2.0, z = pos.z + 0.4},
		},
		vel = {min = {x = -1.2, y = 0.4, z = -1.2}, max = {x = 1.2, y = 2.2, z = 1.2}},
		acc = {min = {x = 0, y = -4.5, z = 0}, max = {x = 0, y = -7.0, z = 0}},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.8, max = 1.5},
		glow = 6,
		collisiondetection = true,
		texpool = NATURE_LEAF_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.5, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 2.0, z = pos.z + 0.4},
		minvel = {x = -1.2, y = 0.4, z = -1.2},
		maxvel = {x = 1.2, y = 2.2, z = 1.2},
		minacc = {x = 0, y = -4.5, z = 0},
		maxacc = {x = 0, y = -7.0, z = 0},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,0",
	})
end

--- Spawns colossal timber collapse with massive multi-colored autumn leaf shower and ancient wood debris
---@param pos Vector Center ground death coordinates
function x_mobs.spawn_nature_guardian_death(pos)
	core.add_particlespawner({
		amount = 64,
		time = 0.6,
		pos = {
			min = {x = pos.x - 1.2, y = pos.y + 0.8, z = pos.z - 1.2},
			max = {x = pos.x + 1.2, y = pos.y + 3.2, z = pos.z + 1.2},
		},
		vel = {min = {x = -2.8, y = 1.0, z = -2.8}, max = {x = 2.8, y = 4.5, z = 2.8}},
		acc = {min = {x = 0, y = -3.5, z = 0}, max = {x = 0, y = -6.0, z = 0}},
		drag = {min = {x = 0.4, y = 0.2, z = 0.4}, max = {x = 0.8, y = 0.4, z = 0.8}},
		size = {min = 2.2, max = 4.8},
		exptime = {min = 2.0, max = 3.8},
		glow = 10,
		collisiondetection = true,
		texpool = NATURE_LEAF_TEXPOOL,
		minpos = {x = pos.x - 1.2, y = pos.y + 0.8, z = pos.z - 1.2},
		maxpos = {x = pos.x + 1.2, y = pos.y + 3.2, z = pos.z + 1.2},
		minvel = {x = -2.8, y = 1.0, z = -2.8},
		maxvel = {x = 2.8, y = 4.5, z = 2.8},
		minacc = {x = 0, y = -3.5, z = 0},
		maxacc = {x = 0, y = -6.0, z = 0},
		minsize = 2.2,
		maxsize = 4.8,
		minexptime = 2.0,
		maxexptime = 3.8,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,0",
	})
	core.add_particlespawner({
		amount = 36,
		time = 0.4,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 2.0, z = pos.z + 0.8},
		},
		vel = {min = {x = -3.5, y = 1.5, z = -3.5}, max = {x = 3.5, y = 5.0, z = 3.5}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -12.0, z = 0}},
		size = {min = 2.5, max = 5.0},
		exptime = {min = 1.2, max = 2.5},
		collisiondetection = true,
		texpool = NATURE_BARK_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 2.0, z = pos.z + 0.8},
		minvel = {x = -3.5, y = 1.5, z = -3.5},
		maxvel = {x = 3.5, y = 5.0, z = 3.5},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -12.0, z = 0},
		minsize = 2.5,
		maxsize = 5.0,
		minexptime = 1.2,
		maxexptime = 2.5,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,1",
	})
	core.add_particlespawner({
		amount = 28,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 2.5, z = pos.z + 0.6},
		},
		vel = {min = {x = -0.6, y = 1.2, z = -0.6}, max = {x = 0.6, y = 3.0, z = 0.6}},
		acc = {min = {x = 0, y = 0.5, z = 0}, max = {x = 0, y = 1.5, z = 0}},
		size = {min = 2.0, max = 3.8},
		exptime = {min = 1.5, max = 2.8},
		glow = 14,
		collisiondetection = false,
		texpool = NATURE_RUNE_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 2.5, z = pos.z + 0.6},
		minvel = {x = -0.6, y = 1.2, z = -0.6},
		maxvel = {x = 0.6, y = 3.0, z = 0.6},
		minacc = {x = 0, y = 0.5, z = 0},
		maxacc = {x = 0, y = 1.5, z = 0},
		minsize = 2.0,
		maxsize = 3.8,
		minexptime = 1.5,
		maxexptime = 2.8,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,2",
	})
end



--- Returns continuous attached particle spawner definition for entangling roots immobilize
---@param scale? number Optional scale multiplier (default 1.0)
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_roots_attached_spawner(scale)
	local s = scale or 1.0
	return {
		amount = math.floor(12 * s),
		time = 0,
		minpos = {x = -0.35 * s, y = 0.05 * s, z = -0.35 * s},
		maxpos = {x = 0.35 * s, y = 0.9 * s, z = 0.35 * s},
		minvel = {x = -0.1, y = 0.0, z = -0.1},
		maxvel = {x = 0.1, y = 0.2, z = 0.1},
		minacc = {x = 0, y = -0.1, z = 0},
		maxacc = {x = 0, y = 0.1, z = 0},
		minexptime = 0.8,
		maxexptime = 1.6,
		minside = 1.2 * s,
		maxsize = 2.4 * s,
		collisiondetection = false,
		glow = 4,
		texpool = NATURE_ROOT_TEXPOOL,
		texture = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,1",
	}
end
