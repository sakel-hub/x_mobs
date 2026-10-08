--[[
	x_mobs - Spider Particle Systems & Visual Effects
	Web projectiles, venom spray, skittering, chitin shards, silk rupture, and attached debuff spawners
--]]

local texpools = x_mobs.texpools
local SPIDER_CHITIN_TEXPOOL = texpools.SPIDER_CHITIN_TEXPOOL
local SPIDER_WEB_TEXPOOL = texpools.SPIDER_WEB_TEXPOOL
local SPIDER_VENOM_TEXPOOL = texpools.SPIDER_VENOM_TEXPOOL
local SPIDER_EYE_TEXPOOL = texpools.SPIDER_EYE_TEXPOOL
local SPIDER_POISON_CLOUD_TEXPOOL = texpools.SPIDER_POISON_CLOUD_TEXPOOL

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


--- Returns continuous attached particle spawner definition for venom poison DoT
---@param scale? number Optional scale multiplier (default 1.0)
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_venom_attached_spawner(scale)
	local s = scale or 1.0
	return {
		amount = math.floor(10 * s),
		time = 0,
		minpos = {x = -0.25 * s, y = 0.2 * s, z = -0.25 * s},
		maxpos = {x = 0.25 * s, y = 1.0 * s, z = 0.25 * s},
		minvel = {x = -0.15, y = -0.1, z = -0.15},
		maxvel = {x = 0.15, y = 0.35, z = 0.15},
		minacc = {x = 0, y = -0.2, z = 0},
		maxacc = {x = 0, y = 0.2, z = 0},
		minexptime = 0.6,
		maxexptime = 1.2,
		minside = 0.8 * s,
		maxsize = 1.8 * s,
		collisiondetection = false,
		glow = 8,
		texpool = SPIDER_VENOM_TEXPOOL,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
	}
end

--- Returns continuous attached particle spawner definition for web slow debuff
---@param scale? number Optional scale multiplier (default 1.0)
---@return table spawner_def Continuous particle spawner definition table
function x_mobs.get_web_attached_spawner(scale)
	local s = scale or 1.0
	return {
		amount = math.floor(8 * s),
		time = 0,
		minpos = {x = -0.3 * s, y = 0.1 * s, z = -0.3 * s},
		maxpos = {x = 0.3 * s, y = 0.8 * s, z = 0.3 * s},
		minvel = {x = -0.1, y = -0.05, z = -0.1},
		maxvel = {x = 0.1, y = 0.15, z = 0.1},
		minacc = {x = 0, y = -0.1, z = 0},
		maxacc = {x = 0, y = 0.1, z = 0},
		minexptime = 0.8,
		maxexptime = 1.5,
		minside = 1.0 * s,
		maxsize = 2.2 * s,
		collisiondetection = false,
		glow = 4,
		texpool = SPIDER_WEB_TEXPOOL,
		texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
	}
end
