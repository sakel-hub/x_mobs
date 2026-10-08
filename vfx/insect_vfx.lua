--[[
	x_mobs - Insect & Flying Bug Particle Systems
	Armored bug carapace shatter, ichor burst, wing shreds, dissolve, and unarmored bug VFX
--]]

local texpools = x_mobs.texpools
local CHITIN_SHATTER_TEXPOOL = texpools.CHITIN_SHATTER_TEXPOOL
local WING_SHRED_TEXPOOL = texpools.WING_SHRED_TEXPOOL
local ICHOR_BURST_TEXPOOL = texpools.ICHOR_BURST_TEXPOOL
local ICHOR_DISSOLVE_TEXPOOL = texpools.ICHOR_DISSOLVE_TEXPOOL
local BUG_CARAPACE_TEXPOOL = texpools.BUG_CARAPACE_TEXPOOL
local BUG_WING_TEXPOOL = texpools.BUG_WING_TEXPOOL
local BUG_ICHOR_TEXPOOL = texpools.BUG_ICHOR_TEXPOOL
local BUG_DISSOLVE_TEXPOOL = texpools.BUG_DISSOLVE_TEXPOOL

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

--- Spawns damage hurt effect for flying insect (amber/emerald ichor droplets)
---@param pos Vector Center impact position
---@param scale? number Scale multiplier (default 0.6)
function x_mobs.spawn_flying_insect_hurt(pos, scale)
	local s = scale or 0.6
	x_mobs.spawn_bug_ichor_burst(pos, math.floor(8 * s), s)
end

--- Spawns dissolve vapor when flying insect despawns
---@param pos Vector Center position
---@param scale? number Scale multiplier (default 1.0)
function x_mobs.spawn_flying_insect_despawn(pos, scale)
	x_mobs.spawn_bug_dissolve(pos, scale or 1.0)
end
