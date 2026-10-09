--[[
	x_mobs - Frosty Queen Boss Particle Systems
	Crystalline trail, ice spell nova, frost projectile trails & impacts, envelop shroud, freeze, shatter, hurt, and death
--]]

local texpools = x_mobs.texpools
local FROSTY_QUEEN_SNOW_TEXPOOL = texpools.FROSTY_QUEEN_SNOW_TEXPOOL
local FROSTY_QUEEN_SHARDS_TEXPOOL = texpools.FROSTY_QUEEN_SHARDS_TEXPOOL
local FROSTY_QUEEN_MIST_TEXPOOL = texpools.FROSTY_QUEEN_MIST_TEXPOOL
local FROSTY_QUEEN_SPARKLE_TEXPOOL = texpools.FROSTY_QUEEN_SPARKLE_TEXPOOL
local FROSTY_QUEEN_CHUNKS_TEXPOOL = texpools.FROSTY_QUEEN_CHUNKS_TEXPOOL
local FROSTY_QUEEN_RUNES_TEXPOOL = texpools.FROSTY_QUEEN_RUNES_TEXPOOL
local FROSTY_QUEEN_WISPS_TEXPOOL = texpools.FROSTY_QUEEN_WISPS_TEXPOOL

function x_mobs.spawn_frosty_queen_trail(pos)
	-- Gentle swirling snowflakes
	core.add_particlespawner({
		amount = 5,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.45, y = pos.y + 0.1, z = pos.z - 0.45},
			max = {x = pos.x + 0.45, y = pos.y + 1.8, z = pos.z + 0.45},
		},
		vel = {min = {x = -0.3, y = -0.4, z = -0.3}, max = {x = 0.3, y = 0.2, z = 0.3}},
		acc = {min = {x = -0.1, y = -0.2, z = -0.1}, max = {x = 0.1, y = 0.1, z = 0.1}},
		jitter = {min = {x = -0.2, y = -0.1, z = -0.2}, max = {x = 0.2, y = 0.1, z = 0.2}},
		drag = {x = 0.3, y = 0.2, z = 0.3},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 1.2, max = 2.2},
		glow = 8,
		texpool = FROSTY_QUEEN_SNOW_TEXPOOL,
		minpos = {x = pos.x - 0.45, y = pos.y + 0.1, z = pos.z - 0.45},
		maxpos = {x = pos.x + 0.45, y = pos.y + 1.8, z = pos.z + 0.45},
		minvel = {x = -0.3, y = -0.4, z = -0.3},
		maxvel = {x = 0.3, y = 0.2, z = 0.3},
		minacc = {x = -0.1, y = -0.2, z = -0.1},
		maxacc = {x = 0.1, y = 0.1, z = 0.1},
		minsize = 1.0,
		maxsize = 2.0,
		minexptime = 1.2,
		maxexptime = 2.2,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,0",
	})

	-- Faint ground cold vapor
	core.add_particlespawner({
		amount = 3,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		},
		vel = {min = {x = -0.2, y = 0.05, z = -0.2}, max = {x = 0.2, y = 0.2, z = 0.2}},
		drag = {x = 0.5, y = 0.3, z = 0.5},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 1.5, max = 2.5},
		glow = 5,
		texpool = FROSTY_QUEEN_MIST_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.4, z = pos.z + 0.4},
		minvel = {x = -0.2, y = 0.05, z = -0.2},
		maxvel = {x = 0.2, y = 0.2, z = 0.2},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.8,
		maxsize = 3.2,
		minexptime = 1.5,
		maxexptime = 2.5,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,2",
	})
end

--- Returns continuous attached particle spawner definition for Frosty Queen ambient frost aura
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_frosty_queen_ambient_spawner()
	return {
		amount = 4,
		time = 0,
		minpos = {x = -0.4, y = 0.2, z = -0.4},
		maxpos = {x = 0.4, y = 1.6, z = 0.4},
		minvel = {x = -0.2, y = -0.2, z = -0.2},
		maxvel = {x = 0.2, y = 0.2, z = 0.2},
		jitter = {min = {x = -0.15, y = -0.1, z = -0.15}, max = {x = 0.15, y = 0.1, z = 0.15}},
		drag = {x = 0.3, y = 0.2, z = 0.3},
		size = {min = 1.0, max = 2.0},
		exptime = {min = 1.2, max = 2.0},
		glow = 8,
		collisiondetection = false,
		texpool = FROSTY_QUEEN_SNOW_TEXPOOL,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,0",
	}
end

--- Spawns converging frost swirls during spell / projectile charge windup
---@param pos Vector Queen position
---@param obj ObjectRef Queen entity
function x_mobs.spawn_frosty_queen_shoot_charge(pos, obj)
	local y_off = 1.3
	core.add_particlespawner({
		amount = 20,
		time = 0.4,
		attached = obj,
		pos = {
			min = {x = -0.8, y = y_off - 0.4, z = -0.8},
			max = {x = 0.8, y = y_off + 0.6, z = 0.8},
		},
		vel = {min = {x = -1.5, y = -0.5, z = -1.5}, max = {x = 1.5, y = 0.8, z = 1.5}},
		acc = {min = {x = -2.0, y = -1.0, z = -2.0}, max = {x = 2.0, y = 1.0, z = 2.0}},
		size = {min = 1.5, max = 2.6},
		exptime = {min = 0.35, max = 0.65},
		glow = 12,
		texpool = FROSTY_QUEEN_SPARKLE_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + y_off - 0.4, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + y_off + 0.6, z = pos.z + 0.8},
		minvel = {x = -1.5, y = -0.5, z = -1.5},
		maxvel = {x = 1.5, y = 0.8, z = 1.5},
		minacc = {x = -2.0, y = -1.0, z = -2.0},
		maxacc = {x = 2.0, y = 1.0, z = 2.0},
		minsize = 1.5,
		maxsize = 2.6,
		minexptime = 0.35,
		maxexptime = 0.65,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns crystalline contrail behind flying frost shard projectile
---@param pos Vector Current projectile position
---@param vel Vector Projectile velocity
function x_mobs.spawn_frosty_queen_projectile_trail(pos, vel)
	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.12, y = pos.y - 0.12, z = pos.z - 0.12},
			max = {x = pos.x + 0.12, y = pos.y + 0.12, z = pos.z + 0.12},
		},
		vel = {
			min = {x = -vel.x * 0.15 - 0.2, y = -vel.y * 0.15 - 0.1, z = -vel.z * 0.15 - 0.2},
			max = {x = -vel.x * 0.15 + 0.2, y = -vel.y * 0.15 + 0.2, z = -vel.z * 0.15 + 0.2},
		},
		drag = {x = 0.4, y = 0.4, z = 0.4},
		size = {min = 1.1, max = 2.0},
		exptime = {min = 0.3, max = 0.6},
		glow = 10,
		texpool = FROSTY_QUEEN_SHARDS_TEXPOOL,
		minpos = {x = pos.x - 0.12, y = pos.y - 0.12, z = pos.z - 0.12},
		maxpos = {x = pos.x + 0.12, y = pos.y + 0.12, z = pos.z + 0.12},
		minvel = {x = -0.2, y = -0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.2, z = 0.2},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.1,
		maxsize = 2.0,
		minexptime = 0.3,
		maxexptime = 0.6,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns ice crystal burst and cold fog on projectile impact
---@param pos Vector Impact position
function x_mobs.spawn_frosty_queen_projectile_impact(pos)
	-- High speed ice splinters
	core.add_particlespawner({
		amount = 16,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		},
		vel = {min = {x = -3.2, y = 0.5, z = -3.2}, max = {x = 3.2, y = 4.2, z = 3.2}},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		size = {min = 1.3, max = 2.4},
		exptime = {min = 0.4, max = 0.8},
		glow = 12,
		texpool = FROSTY_QUEEN_SHARDS_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.1, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.3, z = pos.z + 0.2},
		minvel = {x = -3.2, y = 0.5, z = -3.2},
		maxvel = {x = 3.2, y = 4.2, z = 3.2},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.3,
		maxsize = 2.4,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1",
	})

	-- Impact chill mist
	core.add_particlespawner({
		amount = 8,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {min = {x = -0.8, y = 0.2, z = -0.8}, max = {x = 0.8, y = 1.2, z = 0.8}},
		drag = {x = 0.6, y = 0.4, z = 0.6},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 6,
		texpool = FROSTY_QUEEN_MIST_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y - 0.1, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -0.8, y = 0.2, z = -0.8},
		maxvel = {x = 0.8, y = 1.2, z = 0.8},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.8,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns expanding frost nova ring when the Frost Envelop spell is released
---@param pos Vector Caster position
function x_mobs.spawn_frosty_queen_spell_cast(pos)
	-- Expanding frost nova ring
	core.add_particlespawner({
		amount = 24,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.6, z = pos.z + 0.5},
		},
		vel = {min = {x = -3.5, y = 0.1, z = -3.5}, max = {x = 3.5, y = 0.8, z = 3.5}},
		drag = {x = 0.4, y = 0.2, z = 0.4},
		size = {min = 2.0, max = 3.5},
		exptime = {min = 0.8, max = 1.4},
		glow = 14,
		texpool = FROSTY_QUEEN_RUNES_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.6, z = pos.z + 0.5},
		minvel = {x = -3.5, y = 0.1, z = -3.5},
		maxvel = {x = 3.5, y = 0.8, z = 3.5},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 2.0,
		maxsize = 3.5,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,5",
	})
end

--- Spawns attached client-side particle shroud enveloping the target during freeze
--- Runs at full client FPS with zero server tick overhead
---@param target_obj ObjectRef Enveloped player or mob object
---@param duration number Spell duration in seconds
---@return number|nil spawner_id Particle spawner identifier
function x_mobs.spawn_frosty_queen_envelop_shroud(target_obj, duration)
	if not target_obj or not target_obj:is_valid() then return nil end
	return core.add_particlespawner({
		amount = math.floor(duration * 12),
		time = duration,
		attached = target_obj,
		pos = {
			min = {x = -0.4, y = 0.2, z = -0.4},
			max = {x = 0.4, y = 1.8, z = 0.4},
		},
		vel = {min = {x = -0.3, y = -0.3, z = -0.3}, max = {x = 0.3, y = 0.3, z = 0.3}},
		jitter = {min = {x = -0.4, y = -0.2, z = -0.4}, max = {x = 0.4, y = 0.2, z = 0.4}},
		drag = {x = 0.4, y = 0.3, z = 0.4},
		size = {min = 1.2, max = 2.2},
		exptime = {min = 0.8, max = 1.5},
		glow = 10,
		texpool = FROSTY_QUEEN_SNOW_TEXPOOL,
		minpos = {x = -0.4, y = 0.2, z = -0.4},
		maxpos = {x = 0.4, y = 1.8, z = 0.4},
		minvel = {x = -0.3, y = -0.3, z = -0.3},
		maxvel = {x = 0.3, y = 0.3, z = 0.3},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.2,
		maxsize = 2.2,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns flash freeze burst when envelop first forms on target
---@param pos Vector Target position
function x_mobs.spawn_frosty_queen_spell_freeze(pos)
	-- Crystallizing inward flash
	core.add_particlespawner({
		amount = 22,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 1.8, z = pos.z + 0.6},
		},
		vel = {min = {x = -1.2, y = -0.4, z = -1.2}, max = {x = 1.2, y = 1.2, z = 1.2}},
		drag = {x = 0.5, y = 0.5, z = 0.5},
		size = {min = 1.6, max = 2.8},
		exptime = {min = 0.6, max = 1.1},
		glow = 14,
		texpool = FROSTY_QUEEN_SPARKLE_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 1.8, z = pos.z + 0.6},
		minvel = {x = -1.2, y = -0.4, z = -1.2},
		maxvel = {x = 1.2, y = 1.2, z = 1.2},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.6,
		maxsize = 2.8,
		minexptime = 0.6,
		maxexptime = 1.1,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,3",
	})
end

--- Spawns shattered ice blocks & explosion when envelop breaks/thaws
---@param pos Vector Target position
function x_mobs.spawn_frosty_queen_spell_shatter(pos)
	-- Shattered glacial chunks
	core.add_particlespawner({
		amount = 26,
		time = 0.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		},
		vel = {min = {x = -3.5, y = 1.0, z = -3.5}, max = {x = 3.5, y = 4.5, z = 3.5}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -9.8, z = 0}},
		drag = {x = 0.3, y = 0.1, z = 0.3},
		bounce = 0.3,
		size = {min = 1.8, max = 3.4},
		exptime = {min = 0.8, max = 1.6},
		glow = 8,
		texpool = FROSTY_QUEEN_CHUNKS_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		minvel = {x = -3.5, y = 1.0, z = -3.5},
		maxvel = {x = 3.5, y = 4.5, z = 3.5},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -9.8, z = 0},
		minsize = 1.8,
		maxsize = 3.4,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,4",
	})

	-- Dissolving frost vapor cloud
	core.add_particlespawner({
		amount = 12,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.5, z = pos.z + 0.5},
		},
		vel = {min = {x = -1.0, y = 0.2, z = -1.0}, max = {x = 1.0, y = 1.5, z = 1.0}},
		drag = {x = 0.6, y = 0.4, z = 0.6},
		size = {min = 2.0, max = 3.8},
		exptime = {min = 0.8, max = 1.4},
		glow = 6,
		texpool = FROSTY_QUEEN_MIST_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.5, z = pos.z + 0.5},
		minvel = {x = -1.0, y = 0.2, z = -1.0},
		maxvel = {x = 1.0, y = 1.5, z = 1.0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 2.0,
		maxsize = 3.8,
		minexptime = 0.8,
		maxexptime = 1.4,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,2",
	})
end

--- Spawns ice chip sparks and frost tears on taking damage
---@param pos Vector Position
function x_mobs.spawn_frosty_queen_hurt(pos)
	core.add_particlespawner({
		amount = 14,
		time = 0.1,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		},
		vel = {min = {x = -2.2, y = 0.5, z = -2.2}, max = {x = 2.2, y = 2.8, z = 2.2}},
		acc = {min = {x = 0, y = -6.0, z = 0}, max = {x = 0, y = -6.0, z = 0}},
		drag = {x = 0.5, y = 0.3, z = 0.5},
		size = {min = 1.2, max = 2.4},
		exptime = {min = 0.35, max = 0.75},
		glow = 12,
		texpool = FROSTY_QUEEN_SHARDS_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.4, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.6, z = pos.z + 0.3},
		minvel = {x = -2.2, y = 0.5, z = -2.2},
		maxvel = {x = 2.2, y = 2.8, z = 2.2},
		minacc = {x = 0, y = -6.0, z = 0},
		maxacc = {x = 0, y = -6.0, z = 0},
		minsize = 1.2,
		maxsize = 2.4,
		minexptime = 0.35,
		maxexptime = 0.75,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns massive glacial detonation & dissolving frost vortex on death
---@param pos Vector Position
function x_mobs.spawn_frosty_queen_death(pos)
	-- Violent glacial chunk blast
	core.add_particlespawner({
		amount = 40,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.8, z = pos.z + 0.5},
		},
		vel = {min = {x = -4.5, y = 1.5, z = -4.5}, max = {x = 4.5, y = 6.0, z = 4.5}},
		acc = {min = {x = 0, y = -9.8, z = 0}, max = {x = 0, y = -9.8, z = 0}},
		drag = {x = 0.3, y = 0.1, z = 0.3},
		bounce = 0.3,
		size = {min = 2.0, max = 4.0},
		exptime = {min = 1.0, max = 2.2},
		glow = 10,
		texpool = FROSTY_QUEEN_CHUNKS_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.8, z = pos.z + 0.5},
		minvel = {x = -4.5, y = 1.5, z = -4.5},
		maxvel = {x = 4.5, y = 6.0, z = 4.5},
		minacc = {x = 0, y = -9.8, z = 0},
		maxacc = {x = 0, y = -9.8, z = 0},
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 1.0,
		maxexptime = 2.2,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,4",
	})

	-- Ascending auroral soul wisps
	core.add_particlespawner({
		amount = 25,
		time = 1.2,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		},
		vel = {min = {x = -0.5, y = 1.2, z = -0.5}, max = {x = 0.5, y = 2.8, z = 0.5}},
		jitter = {min = {x = -0.3, y = -0.2, z = -0.3}, max = {x = 0.3, y = 0.2, z = 0.3}},
		size = {min = 1.8, max = 3.2},
		exptime = {min = 1.4, max = 2.5},
		glow = 14,
		texpool = FROSTY_QUEEN_WISPS_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 1.6, z = pos.z + 0.4},
		minvel = {x = -0.5, y = 1.2, z = -0.5},
		maxvel = {x = 0.5, y = 2.8, z = 0.5},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minsize = 1.8,
		maxsize = 3.2,
		minexptime = 1.4,
		maxexptime = 2.5,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,7",
	})
end


--- Returns continuous attached particle spawner definition for frost slow
---@param scale? number Optional scale multiplier (default 1.0)
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_frost_attached_spawner(scale)
	local s = scale or 1.0
	return {
		amount = math.floor(14 * s),
		time = 0,
		minpos = {x = -0.35 * s, y = 0.1 * s, z = -0.35 * s},
		maxpos = {x = 0.35 * s, y = 1.2 * s, z = 0.35 * s},
		minvel = {x = -0.2, y = -0.1, z = -0.2},
		maxvel = {x = 0.2, y = 0.25, z = 0.2},
		minacc = {x = 0, y = -0.2, z = 0},
		maxacc = {x = 0, y = 0.1, z = 0},
		minexptime = 0.7,
		maxexptime = 1.4,
		minside = 1.0 * s,
		maxsize = 2.2 * s,
		collisiondetection = false,
		glow = 9,
		texpool = FROSTY_QUEEN_SNOW_TEXPOOL,
		texture = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,0",
	}
end
