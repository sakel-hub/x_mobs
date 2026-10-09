--[[
	x_mobs - Undead & Shaman Particle Systems
	Death flames, resurrect channeling, interrupted bursts, fireballs, bone dust, summon runes, and regen
--]]

local texpools = x_mobs.texpools
local DEATH_FLAME_TEXPOOL = texpools.DEATH_FLAME_TEXPOOL
local DEATH_SPARK_TEXPOOL = texpools.DEATH_SPARK_TEXPOOL

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
	core.add_particlespawner({
		amount = 2,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
			max = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		},
		vel = {
			min = {x = -0.3, y = 0.1, z = -0.3},
			max = {x = 0.3, y = 0.8, z = 0.3},
		},
		acc = {
			min = {x = -0.05, y = 0.5, z = -0.05},
			max = {x = 0.05, y = 1.2, z = 0.05},
		},
		size = {min = 2, max = 4},
		exptime = {min = 0.3, max = 0.5},
		glow = 14,
		collisiondetection = false,
		animation = FIREBALL_ANIMATION,
		texture = "x_mobs_fireball.png",
		minpos = {x = pos.x - 0.15, y = pos.y - 0.15, z = pos.z - 0.15},
		maxpos = {x = pos.x + 0.15, y = pos.y + 0.15, z = pos.z + 0.15},
		minvel = {x = -0.3, y = 0.1, z = -0.3},
		maxvel = {x = 0.3, y = 0.8, z = 0.3},
		minacc = {x = -0.05, y = 0.5, z = -0.05},
		maxacc = {x = 0.05, y = 1.2, z = 0.05},
		minsize = 2,
		maxsize = 4,
		minexptime = 0.3,
		maxexptime = 0.5,
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
